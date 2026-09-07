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
        sens_select : in std_logic ;
        sens : out std_logic ;
        rapport : in std_logic_vector(12 downto 0) ;
        pwm : out std_logic
    );     
end projet1_led;

architecture beh of projet1_led is 

    signal counter : integer range 0 to max-1 := 0;
    signal comp    : integer range 0 to max := 0;
    

begin

    -- Génération PWM
     comp <= to_integer(unsigned(rapport));
    process(clk, rst)
    begin

        if rst = '0' then

            counter <= 0;
            pwm<= '0';

        elsif rising_edge(clk) then

            if counter = max-1 then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;

            if counter < comp then
                pwm <= '1';
            else
                pwm <= '0';
            end if;

        end if;

    end process;
     -- sens de rotation moteur
     sens <= sens_select ;

end beh;

