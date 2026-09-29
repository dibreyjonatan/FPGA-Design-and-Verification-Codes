library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

-- Scenario :
--   Phase A : reset
--   Phase B : 3 monocoups (continu='0', start_stop='1')
--   Phase C : 2 conversions en continu, start_stop='0'
--   Phase D : 2 conversions en continu, start_stop='1'
-- Horloge reelle 50 MHz (periode 20 ns), comme le generic par defaut de cmps03 :
-- MS_CYC (65 ms) et CYCLE_S (935 ms) sont des constantes figees, la simulation
-- tourne donc en "temps reel" (quelques secondes de temps simule).

entity tb_top_scenario is
end entity;

architecture sim of tb_top_scenario is
    constant T_CLK : time := 20 ns;   -- 50 MHz

    signal clk          : std_logic := '0';
    signal continu      : std_logic := '0';
    signal start_stop   : std_logic := '0';
    signal rst_command  : std_logic := '0';
    signal in_pwm       : std_logic := '0';
    signal data_out     : std_logic_vector(9 downto 0);
    signal out_oscillo  : std_logic;
    signal out_1s       : std_logic;

    signal angle_target : natural range 0 to 359 := 0;
    signal data_valid   : std_logic;
begin

    clk <= not clk after T_CLK / 2;
    data_valid <= data_out(9);

    dut : entity work.top
        port map (
            clk => clk, continu => continu, start_stop => start_stop,
            rst_command => rst_command, in_pwm => in_pwm,
            data_out => data_out, out_oscillo => out_oscillo, out_1s => out_1s);

    -- Faux CMPS03 : impulsion haute = 1 ms + angle x 100 us, periode 65 ms.
    -- angle_target est relu a chaque debut de boucle (donc pendant la phase
    -- basse), ce qui fixe la largeur de la PROCHAINE impulsion haute.
    p_pwm : process
        variable t_high : time;
    begin
        loop
            t_high := 1 ms + angle_target * 100 us;
            in_pwm <= '1';  wait for t_high;
            in_pwm <= '0';  wait for 65 ms - t_high;
        end loop;
    end process;

    -- Trace chaque transition de data_valid avec son horodatage : seul moyen
    -- fiable de voir une impulsion qui ne dure qu'un cycle d'horloge (20 ns).
    p_monitor : process(data_valid)
    begin
        report "   [data_valid -> " & std_logic'image(data_valid) & " @ " & time'image(now) & "]";
    end process;

    p_stim : process
        variable errors : natural := 0;

        procedure check(cond : boolean; msg : string) is
        begin
            if not cond then
                errors := errors + 1;
                report "ERREUR : " & msg severity error;
            end if;
        end procedure;

        procedure check_angle(expected : natural; msg : string) is
            variable m : integer;
        begin
            m := to_integer(unsigned(data_out(8 downto 0)));
            check(abs(m - integer(expected)) <= 1,
                  msg & " : attendu " & integer'image(expected) & ", lu " & integer'image(m));
        end procedure;

        -- Regle l'angle pour la PROCHAINE impulsion PWM, attend cette impulsion
        -- en entier (front montant puis descendant), laisse LOAD s'evaluer.
        procedure measure(angle : natural; timeout : time; msg : string) is
        begin
            if in_pwm = '1' then
                wait until in_pwm = '0' for timeout;
                check(in_pwm = '0', "timeout fin d'impulsion avant mesure : " & msg);
            end if;
            angle_target <= angle;
            wait until in_pwm = '1' for timeout;
            check(in_pwm = '1', "timeout debut d'impulsion : " & msg);
            wait until in_pwm = '0' for timeout;
            check(in_pwm = '0', "timeout fin d'impulsion : " & msg);
            wait for 60 ns;  -- 3 cycles : laisse LOAD puis WAIT_WINDOW s'evaluer
            check_angle(angle, msg);
        end procedure;

    begin
        report "=== Phase A : reset ===";
        rst_command <= '0';  wait for 100 ns;
        rst_command <= '1';  wait for 200 ns;
        check(unsigned(data_out) = 0, "data_out non nul apres reset");

        ------------------------------------------------------------------
        report "=== Phase B : 3 monocoups, continu = 0, start_stop = 1 ===";
        ------------------------------------------------------------------
        continu <= '0';
        start_stop <= '1';

        report ">>> monocoup 0 (angle=40)";
        measure(40, 200 ms, "monocoup 0");
        wait for 68 ms;  -- laisse la fenetre WAIT_WINDOW se refermer (retour DECISION/WAIT_CMD)

        report ">>> monocoup 1 (angle=150)";
        measure(150, 200 ms, "monocoup 1");
        wait for 68 ms;

        report ">>> monocoup 2 (angle=300)";
        measure(300, 200 ms, "monocoup 2");
        wait for 68 ms;

        ------------------------------------------------------------------
        report "=== Phase C : 2 conversions en continu, start_stop = 0 ===";
        ------------------------------------------------------------------
        continu <= '1';
        start_stop <= '0';

        report ">>> continu SS=0, cycle 0 (angle=70)";
        measure(70, 200 ms, "continu SS=0 cycle 0");
        check(data_valid = '0', "data_valid a 1 alors que start_stop = 0 (cycle 0)");
        wait for 1000 ms;  -- laisse le cycle complet (65ms + 935ms) se terminer

        report ">>> continu SS=0, cycle 1 (angle=250)";
        measure(250, 200 ms, "continu SS=0 cycle 1");
        check(data_valid = '0', "data_valid a 1 alors que start_stop = 0 (cycle 1)");
        wait for 1000 ms;

        ------------------------------------------------------------------
        report "=== Phase D : 2 conversions en continu, start_stop = 1 ===";
        ------------------------------------------------------------------
        start_stop <= '1';

        report ">>> continu SS=1, cycle 0 (angle=110)";
        measure(110, 200 ms, "continu SS=1 cycle 0");
        wait for 1000 ms;

        report ">>> continu SS=1, cycle 1 (angle=200)";
        measure(200, 200 ms, "continu SS=1 cycle 1");
        wait for 1000 ms;

        if errors = 0 then
            report "=== TEST TERMINE : 0 erreur (voir les horodatages de data_valid ci-dessus) ===";
        else
            report "=== TEST TERMINE : " & integer'image(errors) & " erreur(s) ===" severity error;
        end if;
        finish;
    end process;

end architecture;