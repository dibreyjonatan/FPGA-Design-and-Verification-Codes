library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end tb_top;

architecture sim of tb_top is

    --------------------------------------------------------------------
    -- Signaux du testbench
    --------------------------------------------------------------------
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal cs            : std_logic_vector(1 downto 0) := "00";

    signal sens_choix    : std_logic := '0';
    signal sens_rotation : std_logic;
    signal pwm_sortie    : std_logic;

    --------------------------------------------------------------------
    -- Horloge 50 MHz
    -- T = 20 ns
    --------------------------------------------------------------------
    constant CLK_PERIOD : time := 20 ns;

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : entity work.top
        generic map (
            max => 5000
        )
        port map (
            clk           => clk,
            rst           => rst,
            cs            => cs,
            sens_choix    => sens_choix,
            sens_rotation => sens_rotation,
            pwm_sortie    => pwm_sortie
        );

    --------------------------------------------------------------------
    -- Génération horloge 50 MHz
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop

            clk <= '0';
            wait for CLK_PERIOD / 2;

            clk <= '1';
            wait for CLK_PERIOD / 2;

        end loop;
    end process;


    --------------------------------------------------------------------
    -- STIMULI
    --------------------------------------------------------------------
    stimulus_process : process
    begin

        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        rst <= '0';
        cs  <= "00";
        sens_choix <= '0';
         sens_rotation <= '0' ;		
        wait for 100 ns;

        -- Désactivation du reset
        rst <= '1';
		
        ----------------------------------------------------------------
        report "CS = 00 -> 500 -> 10 %";

        cs <= "00";
         sens_choix <= '0';
         sens_rotation <= '0' ;		 
        wait for 1 ms;


        
        ----------------------------------------------------------------
        report "CS = 01 -> 1500 -> 30 %";

        cs <= "01";
		  sens_choix <= '1';
         sens_rotation <= '1' ;	

        wait for 1 ms;

        ----------------------------------------------------------------
        report "CS = 10 -> 2500 -> 50%";

        cs <= "10";
		  sens_choix <= '0';
         sens_rotation <= '0' ;	

        wait for 1 ms;

        report "CS = 11 -> 4000 -> 80%";

        cs <= "11";
		  sens_choix <= '1';
         sens_rotation <= '1' ;	

        wait for 1 ms;


        ----------------------------------------------------------------
        -- FIN
        ----------------------------------------------------------------
        report "FIN DE SIMULATION";

        std.env.stop;
        wait;

    end process;
	

end sim;
