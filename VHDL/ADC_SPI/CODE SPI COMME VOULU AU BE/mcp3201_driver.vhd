library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mcp3201_driver is
    generic (
        
        WAIT_CYCLES : integer := 99999  
    );
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        adc_cs_n   : out STD_LOGIC;
        adc_clk    : out STD_LOGIC;   -- redevient une simple sortie
        adc_dout   : in  STD_LOGIC;
        data_out   : out STD_LOGIC_VECTOR(11 downto 0);
        RxIF       : out STD_LOGIC
    );
end mcp3201_driver;

architecture Behavioral of mcp3201_driver is

    type etats is (IDLE, SAMPLING_CONV, HOLD_CS, WAIT_100MS);
    signal ep, es : etats := IDLE;

    signal clk_cnt   : integer range 0 to 24:= 0;
    signal adc_clk_i : std_logic := '0';   -- horloge interne 1 MHz, libre

    signal bit_cnt   : integer range 0 to 15 := 0;
    signal shift_reg : std_logic_vector(11 downto 0) := (others => '0');

    signal cmpt    : integer range 0 to WAIT_CYCLES := 0;
    signal fin_tim : std_logic := '0';

begin

    adc_clk <= adc_clk_i;

   
    horloge_spi : process(clk, rst)
    begin
        if rst = '0' then
            clk_cnt   <= 0;
            adc_clk_i <= '0';
        elsif rising_edge(clk) then
            if clk_cnt = 24 then
                clk_cnt   <= 0;
                adc_clk_i <= not adc_clk_i;
            else
                clk_cnt <= clk_cnt + 1;
            end if;
        end if;
    end process horloge_spi;

    registre_flag : process(adc_clk_i, rst)
    begin
        if rst = '0' then
         
            bit_cnt   <= 0;
            shift_reg <= (others => '0');
            data_out  <= (others => '0');
            RxIF      <= '0';
                
        elsif rising_edge(adc_clk_i) then
           
          

                if (ep=SAMPLING_CONV) then
                    if bit_cnt >= 3 and bit_cnt <= 14 then
                        shift_reg <= shift_reg(10 downto 0) & adc_dout;
                    end if;
                    if bit_cnt = 15 then
                        data_out <= shift_reg;
                        RxIF     <= '1';
                        bit_cnt  <= 0;
                    else
                        bit_cnt <= bit_cnt + 1;
                    end if;
                          
                    else
                        bit_cnt <= 0;
                        RxIF <= '0';
                    end if;

        end if;
    end process ;

    
    sequentiel : process(adc_clk_i, rst)
    begin
      if rst = '0' then
            ep <= IDLE;
           
       elsif  rising_edge(adc_clk_i) then 
        ep <= es;
          end if ; 
    end process ;
     
     
     
    combinatoire : process(ep, bit_cnt, fin_tim)
    begin
          --es <= ep ; 
        case ep is
          
            when IDLE =>
                es <= SAMPLING_CONV;     
                     
            when SAMPLING_CONV =>
                if bit_cnt = 15 then
                    es <= HOLD_CS;
                        else
                            es<=SAMPLING_CONV;
                end if;
                     
            when HOLD_CS =>
                es <= WAIT_100MS;
                     
            when WAIT_100MS =>
                if fin_tim = '1' then
                    es <= IDLE;
                      else
                            es <= WAIT_100MS;
                end if;
                     
                when others =>
                      es <= SAMPLING_CONV;
                     
        end case;
          
    end process combinatoire;

    sortie : process(ep)
    begin
        case ep is
            
                when IDLE          => adc_cs_n <= '1';
            when SAMPLING_CONV => adc_cs_n <= '0';
            when HOLD_CS       => adc_cs_n <= '1';
            when WAIT_100MS    => adc_cs_n <= '1';
                when others        => adc_cs_n <= '1';
                
        end case;
    end process sortie;

    timer_100ms : process(adc_clk_i, rst)
    begin
        if rst = '0' then
            cmpt    <= 0;
            fin_tim <= '0';
        elsif rising_edge(adc_clk_i) then
            fin_tim <= '0';
            if ep /= WAIT_100MS then
                cmpt <= 0;
            elsif cmpt = WAIT_CYCLES then
                cmpt    <= 0;
                fin_tim <= '1';
            else
                cmpt <= cmpt + 1;
            end if;
        end if;
    end process timer_100ms;

end Behavioral;