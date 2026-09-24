library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cmps03 is
end entity;

architecture sim of tb_cmps03 is
    constant CLK_FREQ_HZ : natural := 1_000_000;   -- 50_000_000 pour le cas réel (lent)
    constant CLK_PERIOD  : time    := 1 sec / CLK_FREQ_HZ;

    type int_vec is array (natural range <>) of natural;
    constant ANGLES : int_vec := (0, 1, 90, 180, 270, 359);

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal pwm         : std_logic := '0';
    signal data_valid  : std_logic;
    signal data_compas : std_logic_vector(8 downto 0);
    signal done        : boolean := false;
begin

    clk <= not clk after CLK_PERIOD / 2 when not done else clk;

    dut : entity work.cmps03
        generic map (CLK_FREQ_HZ => CLK_FREQ_HZ)
        port map (
            clk           => clk,
            rst           => rst,
            in_pwm_compas => pwm,
            continu       => '1',
            start_stop    => '0',
            data_valid    => data_valid,
            data_compas   => data_compas,
			cmd => '0' 
        );

    stim : process
        variable errors : natural := 0;

        procedure pulse(a : natural) is
        begin
            pwm <= '1';
            wait for 1 ms + a * 100 us;   -- 1 ms d'offset + 100 us/degré
            pwm <= '0';
            wait for 65 ms;               -- état bas
        end procedure;
    begin
        rst <= '0';
        wait for 5 * CLK_PERIOD;
        rst <= '1';
        wait for 10 * CLK_PERIOD;

        for i in ANGLES'range loop
            wait for (i * 137 + 53) * 1 ns;     -- phase asynchrone vis-à-vis de clk

            for k in 1 to 3 loop
                pulse(ANGLES(i));
            end loop;

            wait until rising_edge(data_valid) for 110 ms;
            wait for CLK_PERIOD / 2;

            if data_valid /= '1' then
                report "TIMEOUT : pas de data_valid pour angle = " & integer'image(ANGLES(i))
                    severity error;
                errors := errors + 1;
            elsif to_integer(unsigned(data_compas)) /= ANGLES(i) then
                report "ERREUR : attendu " & integer'image(ANGLES(i)) &
                       ", lu " & integer'image(to_integer(unsigned(data_compas)))
                    severity error;
                errors := errors + 1;
            else
                report "OK : angle " & integer'image(ANGLES(i)) & " correctement mesuré";
            end if;
        end loop;

        if errors = 0 then
            report "=== TEST PASSED ===";
        else
            report "=== TEST FAILED : " & integer'image(errors) & " erreur(s) ===" severity error;
        end if;

        done <= true;
        wait;
    end process;

end architecture;