library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
  -- fpwm = 50M/5000 = 10kHz 
entity projet1_led is 
    generic(
        max : natural := 5000
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        cs  : in  std_logic_vector(1 downto 0);
        led : out std_logic
    );     
end projet1_led;

architecture beh of projet1_led is 

    signal counter : integer range 0 to max-1 := 0;
    signal comp    : integer range 0 to max := 0;

begin

    -- Choix du rapport cyclique
   comp <= 500  when cs = "00" else  -- 10 %
        1500 when cs = "01" else     -- 30 %
        2500 when cs = "10" else     -- 50 %
        4000;                        -- 80 %  

    -- Génération PWM
    process(clk, rst)
    begin

        if rst = '0' then

            counter <= 0;
            led <= '0';

        elsif rising_edge(clk) then

            if counter = max-1 then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;

            if counter < comp then
                led <= '1';
            else
                led <= '0';
            end if;

        end if;

    end process;

end beh;