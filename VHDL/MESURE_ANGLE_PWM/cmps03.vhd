library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmps03 is
    generic (
        CLK_FREQ_HZ : natural := 50000000;
        period      : natural := 65 
    );
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;     
        in_pwm_compas : in  std_logic;
        continu       : in  std_logic;     
        start_stop    : in  std_logic;  
          out_oscillo   : out std_logic ;            
        data_valid    : out std_logic;
        data_compas   : out std_logic_vector(8 downto 0)
    );
end entity;

architecture mealy of cmps03 is
    constant MS_CYC   : natural := CLK_FREQ_HZ / 1000;
    constant TICK_CYC : natural := CLK_FREQ_HZ / 10000; -- 100us = 1 degre
    constant OFFSET   : natural := 10;                  -- 1 ms

    type state_t is (S_WAIT_EDGE, S_COUNT, S_WAIT_WINDOW);
    signal state, next_state : state_t := S_WAIT_EDGE;

    signal sync : std_logic_vector(2 downto 0) := (others => '0');
    signal rising_pwm, falling_pwm, level_pwm : std_logic;

    signal cmpt_tick : integer range 0 to TICK_CYC - 1 := 0;
    signal angle     : integer range 0 to 511 := 0;
    signal data_out  : std_logic_vector(8 downto 0) := (others => '0');

    signal ms_cmpt     : integer range 0 to MS_CYC - 1 := 0;
    signal fin_tim     : std_logic := '0';
    signal time_cont   : integer range 0 to period := 0;
    signal window_done : std_logic;
     signal clk_pwm : std_logic :='0';
begin
    rising_pwm  <= '1' when sync(2 downto 1) = "01" else '0';
    falling_pwm <= '1' when sync(2 downto 1) = "10" else '0';
    level_pwm   <= sync(1);
    window_done <= '1' when (fin_tim = '1' and time_cont = period - 1) else '0';
     
        -- sortie Oscilloscope
       out_oscillo <= in_pwm_compas ; 

    
    -- PROCESS : sequentiel
    p_state_reg : process(clk, rst)
    begin
        if rst = '0' then
            state <= S_WAIT_EDGE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

  
    -- PROCESS : combinatoire
    
    p_next_state : process(state, rising_pwm, falling_pwm, window_done)
    begin
        next_state <= state;
        case state is
            when S_WAIT_EDGE =>
                if rising_pwm = '1' then
                    next_state <= S_COUNT;
                end if;
            when S_COUNT =>
                if falling_pwm = '1' then
                    next_state <= S_WAIT_WINDOW;
                end if;
            when S_WAIT_WINDOW =>
                if window_done = '1' then
                    next_state <= S_WAIT_EDGE;
                end if;
        end case;
    end process;

   
      -- pour valider la data 
      
    p_output : process(state, window_done)
    begin
        data_valid <= '0';
        if state = S_WAIT_WINDOW and window_done = '1' then
            data_valid <= '1';
        end if;
    end process;

    
    -- Process qui prend la donnée et les décales 
     
    p_sync : process(clk, rst)
    begin
        if rst = '0' then
            sync <= (others => '0');
        elsif rising_edge(clk) then
            sync <= sync(1 downto 0) & in_pwm_compas;
        end if;
    end process;

     -- process sortie 
     
    p_datapath : process(clk, rst)
        variable a : integer range 0 to 511;
    begin
        if rst = '0' then
            cmpt_tick   <= 0;
            angle       <= 0;
            data_out    <= (others => '0');
          
            time_cont   <= 0;
            data_compas <= (others => '0');
        elsif rising_edge(clk) then
           
            case state is
                when S_WAIT_EDGE =>
                    if rising_pwm = '1' then
                        cmpt_tick <= 1;
                        angle     <= 0;
                    end if;

                when S_COUNT =>
                    if falling_pwm = '1' then
                        if angle >= OFFSET then a := angle - OFFSET; else a := 0; end if;
                        if a > 359 then a := 359; end if;
                        data_out <= std_logic_vector(to_unsigned(a, 9));
                    elsif level_pwm = '1' then
                          
                        if cmpt_tick = TICK_CYC - 1 then
                            cmpt_tick <= 0;
                            if angle < 511 then angle <= angle + 1; end if;
                        else
                            cmpt_tick <= cmpt_tick + 1;
                        end if;
                                
                    end if;

                when S_WAIT_WINDOW =>
                    if window_done = '1' then
                        time_cont   <= 0;
                        data_compas <= data_out;
                    elsif fin_tim = '1' then
                        time_cont <= time_cont + 1;
                    end if;
            end case;
        end if;
    end process;
     
      -- compteur de 1ms 
      
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
     
     -- horloge pwm 

end architecture;