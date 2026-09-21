library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmps03 is
    generic (
        CLK_FREQ_HZ : natural := 50000000; -- Horloge de 50MHz
        period      : natural := 102       -- fenêtre en ms
    );
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;      -- actif bas
        in_pwm_compas : in  std_logic;
        continu       : in  std_logic;      -- non utilisé
        start_stop    : in  std_logic;      -- non utilisé
        out_oscillo   : out std_logic ;  
        data_valid    : out std_logic;      -- impulsion 1 cycle toutes les 102 ms
        data_compas   : out std_logic_vector(8 downto 0)
    );
end entity;

architecture rtl of cmps03 is
    constant MS_CYC   : natural := CLK_FREQ_HZ / 1000;   -- 1 ms  = 50000 cycles
    constant TICK_CYC : natural := CLK_FREQ_HZ / 10000;  -- 100us = 5000 cycles (1°)
    constant OFFSET   : natural := 10;                   -- offset de 1 ms = 10 ticks

    signal time_cont : integer range 0 to period := 0;
    signal angle     : integer range 0 to 511 := 0;
    signal data_out  : std_logic_vector(8 downto 0) := (others => '0');
    signal sync      : std_logic_vector(2 downto 0) := (others => '0');
    signal fin_tim   : std_logic := '0';
begin
     -- sortie Oscilloscope
	   out_oscillo <= in_pwm_compas ; 
    -- Process 1 : fenêtre de 102 ms, on recopie la dernière mesure complète
    process(clk, rst)
    begin
        if rst = '0' then
            time_cont   <= 0;
            data_compas <= (others => '0');
            data_valid  <= '0';
        elsif rising_edge(clk) then
            data_valid <= '0';
            if fin_tim = '1' then
                if time_cont = period - 1 then
                    time_cont   <= 0;
                    data_compas <= data_out;
                    data_valid  <= '1';
                else
                    time_cont <= time_cont + 1;
                end if;
            end if;
        end if;
    end process;

    -- Process 2 : mesure PWM (front montant -> comptage tous les 100us -> front descendant)
    process(clk, rst)
        variable cmpt : integer range 0 to TICK_CYC - 1 := 0;
        variable a    : integer range 0 to 511;
    begin
        if rst = '0' then
            cmpt     := 0;
            angle    <= 0;
            sync     <= (others => '0');
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            sync <= sync(1 downto 0) & in_pwm_compas;  -- synchro + détection de fronts

            if sync(2 downto 1) = "01" then            -- front montant : début de mesure
                cmpt  := 1;
                angle <= 0;

            elsif sync(2 downto 1) = "10" then         -- front descendant : fin de mesure
                if angle >= OFFSET then a := angle - OFFSET; else a := 0; end if;
                if a > 359 then a := 359; end if;
                data_out <= std_logic_vector(to_unsigned(a, 9));

            elsif sync(1) = '1' then                   -- état haut : 1 tick = 100us = 1°
                if cmpt = TICK_CYC - 1 then
                    cmpt := 0;
                    if angle < 511 then angle <= angle + 1; end if;
                else
                    cmpt := cmpt + 1;
                end if;
            end if;
        end if;
    end process;

    -- Process 3 : tick de 1 ms
    process(clk, rst)
        variable cmpt : integer range 0 to MS_CYC - 1 := 0;
    begin
        if rst = '0' then
            cmpt    := 0;
            fin_tim <= '0';
        elsif rising_edge(clk) then
            if cmpt = MS_CYC - 1 then
                cmpt    := 0;
                fin_tim <= '1';
            else
                cmpt    := cmpt + 1;
                fin_tim <= '0';
            end if;
        end if;
    end process;

end architecture;