library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is

    constant CLK_PERIOD : time := 20 ns;  -- 50 MHz -> adc_clk_i = 1 MHz (25 cycles/demi-periode)

    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal sens_choix    : std_logic := '0';
    signal adc_dout      : std_logic := '0';
    signal adc_cs_n      : std_logic;
    signal adc_clk       : std_logic;
    signal data_out      : std_logic_vector(11 downto 0);
    signal RxIF          : std_logic;
    signal sens_rotation : std_logic;
    signal pwm_sortie    : std_logic;

    -- valeur que le modele d'ADC renverra a la PROCHAINE acquisition
    signal tb_adc_value  : std_logic_vector(11 downto 0) := std_logic_vector(to_unsigned(2048, 12));

    signal sim_done      : boolean := false;

    ------------------------------------------------------------------
    -- Mesure du rapport cyclique du PWM sur une periode complete
    -- (max=1000, pres_scaler=5 : valeurs par defaut de pwm_bloc,
    --  non redefinies dans le PORT MAP de top -> donc telles quelles)
    ------------------------------------------------------------------
    procedure measure_duty (
        expected_high : integer;
        tol           : integer;
        label_txt     : string
    ) is
        variable high_count : integer := 0;
    begin
        high_count := 0;
        for i in 0 to (1000*5)-1 loop
            wait until rising_edge(clk);
            if pwm_sortie = '1' then
                high_count := high_count + 1;
            end if;
        end loop;
        report label_txt & " : cycles PWM haut = " & integer'image(high_count)
               & " (attendu " & integer'image(expected_high) & " +/- " & integer'image(tol) & ")";
        assert (high_count >= expected_high - tol) and (high_count <= expected_high + tol)
            report "ERREUR " & label_txt & " : duty cycle incorrect"
            severity error;
    end procedure measure_duty;

begin

    ------------------------------------------------------------------
    DUT : entity work.top(beh)
        generic map (max => 1000)
        port map (
            clk           => clk,
            rst           => rst,
            sens_choix    => sens_choix,
            adc_dout      => adc_dout,
            adc_cs_n      => adc_cs_n,
            adc_clk       => adc_clk,
            data_out      => data_out,
            RxIF          => RxIF,
            sens_rotation => sens_rotation,
            pwm_sortie    => pwm_sortie
        );

    ------------------------------------------------------------------
    clk_gen : process
    begin
        while not sim_done loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process clk_gen;

    ------------------------------------------------------------------
    -- Modele MCP3201 : envoie tb_adc_value en serie MSB en premier,
    -- avec 3 bits de tete + 1 bit de fin (calque sur bit_cnt 3..14
    -- utilise dans mcp3201_driver.registre_flag)
    ------------------------------------------------------------------
    adc_model : process
        variable frame : std_logic_vector(15 downto 0);
    begin
        adc_dout <= '0';
        loop
            wait until falling_edge(adc_cs_n);
            frame := "000" & tb_adc_value & "0";
            for idx in 0 to 15 loop
                wait until falling_edge(adc_clk);
                adc_dout <= frame(15 - idx);
            end loop;
        end loop;
    end process adc_model;

    ------------------------------------------------------------------
    stim : process
        procedure wait_clk(n : integer) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
        end procedure;
    begin
        tb_adc_value <= std_logic_vector(to_unsigned(2048, 12)); -- en zone (1022 < x < 2919)
        sens_choix   <= '0';

        rst <= '0';
        wait_clk(5);
        rst <= '1';

        ----------------------------------------------------------------
        -- Acquisition 1 : valeur en zone valide
        ----------------------------------------------------------------
        wait until RxIF = '1';
        report "Acquisition 1 : data_out = " & integer'image(to_integer(unsigned(data_out)));
        assert data_out = std_logic_vector(to_unsigned(2048, 12))
            report "ERREUR : data_out different de la valeur envoyee (2048)"
            severity error;

        wait_clk(3);

        -- en zone : sens_decision suit mem_sens (pas sens_choix), moteur roule
        assert sens_rotation = '0'
            report "ERREUR scenario1 : sens_rotation attendu a '0'" severity error;
        measure_duty(2500, 10, "Scenario1 (en zone)");

        ----------------------------------------------------------------
        -- Scenario 2 : toujours en zone, on change sens_choix
        -- -> ne doit RIEN changer (in-zone ignore sens_choix)
        ----------------------------------------------------------------
        sens_choix <= '1';
        wait_clk(3);
        assert sens_rotation = '0'
            report "ERREUR scenario2 : sens_rotation ne devrait pas bouger en zone" severity error;
        measure_duty(2500, 10, "Scenario2 (en zone, sens_choix change)");

        ----------------------------------------------------------------
        -- Acquisition 2 : valeur hors zone (butee basse, < 1022)
        -- ATTENTION : attente ~100 ms simulees (WAIT_CYCLES=99999 par defaut)
        ----------------------------------------------------------------
        tb_adc_value <= std_logic_vector(to_unsigned(500, 12));
        wait until RxIF = '1';
        report "Acquisition 2 : data_out = " & integer'image(to_integer(unsigned(data_out)));
        assert data_out = std_logic_vector(to_unsigned(500, 12))
            report "ERREUR : data_out different de la valeur envoyee (500)"
            severity error;

        wait_clk(3);

        -- hors zone + sens_choix('1') /= mem_sens('0') -> doit sortir (mem_sens=0 -> force '1')
        assert sens_rotation = '1'
            report "ERREUR scenario3 : sens_rotation attendu a '1' (sortie de butee)" severity error;
        measure_duty(2500, 10, "Scenario3 (hors zone, changement de decision)");

        ----------------------------------------------------------------
        -- Scenario 4 : sens_choix = mem_sens desormais -> coupure attendue
        ----------------------------------------------------------------
        wait_clk(3);
        assert sens_rotation = '1'
            report "ERREUR scenario4 : sens_rotation devrait rester a '1'" severity error;
        measure_duty(0, 0, "Scenario4 (hors zone, sens stable -> coupure)");

        ----------------------------------------------------------------
        -- Scenario 5 : on rechange sens_choix -> doit de nouveau autoriser un mouvement
        ----------------------------------------------------------------
        sens_choix <= '0';
        wait_clk(3);
        assert sens_rotation = '0'
            report "ERREUR scenario5 : sens_rotation attendu a '0' (entree de butee)" severity error;
        measure_duty(2500, 10, "Scenario5 (hors zone, decision inversee)");

        report "=== FIN DES TESTS === (verifier qu'aucune ligne ERROR n'apparait ci-dessus)";
        sim_done <= true;
        wait;
    end process stim;

end architecture sim;