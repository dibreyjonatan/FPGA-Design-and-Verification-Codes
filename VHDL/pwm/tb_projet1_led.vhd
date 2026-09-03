library ieee;
use ieee.std_logic_1164.all;

entity tb_projet1_led is
end tb_projet1_led;

architecture sim of tb_projet1_led is

    -- Signaux du testbench
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal cs  : std_logic_vector(1 downto 0) := "00";
    signal led : std_logic;

    -- Période de l'horloge : 50 MHz
    -- T = 1 / 50 MHz = 20 ns
    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instanciation du module à tester
    DUT : entity work.projet1_led
        generic map (
            max => 5000
        )
        port map (
            clk => clk,
            rst => rst,
            cs  => cs,
            led => led
        );

    -- Génération de l'horloge 50 MHz
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;

            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;


    -- Stimuli
    stimulus_process : process
    begin

        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        rst <= '0';
        cs  <= "00";

        wait for 100 ns;

        -- Désactivation du reset
        rst <= '1';

        ----------------------------------------------------------------
        -- TEST cs = "00"
        -- comp = 272
        -- Duty cycle = 272 / 5000 = 5.44 %
        ----------------------------------------------------------------
        cs <= "00";

        wait for 1 ms;


        ----------------------------------------------------------------
        -- TEST cs = "01"
        -- comp = 160
        -- Duty cycle = 160 / 5000 = 3.2 %
        ----------------------------------------------------------------
        cs <= "01";

        wait for 1 ms;


        ----------------------------------------------------------------
        -- TEST cs = "10"
        -- comp = 132
        -- Duty cycle = 132 / 5000 = 2.64 %
        ----------------------------------------------------------------
        cs <= "10";

        wait for 1 ms;


        ----------------------------------------------------------------
        -- TEST cs = "11"
        -- comp = 100
        -- Duty cycle = 100 / 5000 = 2 %
        ----------------------------------------------------------------
        cs <= "11";

        wait for 1 ms;


        ----------------------------------------------------------------
        -- FIN DE SIMULATION
        ----------------------------------------------------------------
		std.env.stop;
        wait;

    end process;

end sim;