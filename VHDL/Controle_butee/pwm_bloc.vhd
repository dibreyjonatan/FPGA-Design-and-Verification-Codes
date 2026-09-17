library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
  -- fpwm = 50M/5000 = 10kHz 
entity pwm_bloc is 
    generic(
        max : natural := 1000;
		  pres_scaler : natural :=5
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        sens_select : in std_logic ;
        sens : out std_logic ;
        rapport : in std_logic_vector(9 downto 0) ;
        pwm : out std_logic
    );     
end pwm_bloc;

architecture beh of pwm_bloc is 

    signal counter : integer range 0 to max-1 := 0;
    signal comp    : integer range 0 to max := 0;
    signal div_clk : std_logic; 

begin

    -- Génération PWM
     comp <= to_integer(unsigned(rapport));
    process(div_clk, rst)
	 variable tick_div : integer range 0 to pres_scaler-1:=0; 
    begin

        if rst = '0' then
            tick_div := 0;
            counter <= 0;
            pwm<= '0';
        elsif  rising_edge(div_clk) then 
		         if counter=max-1 then 
					counter <= 0 ;
					else
					counter <= counter + 1 ;
					end if ; 
			 if counter < comp then
              pwm <= '1';
          else
              pwm <= '0';
         end if;
	   end if ; 		
      

    end process;
	 
process(clk, rst)
    variable tick : integer range 0 to pres_scaler-1 := 0;
begin
    if rst = '0' then
        div_clk <= '0';
        tick := 0;
    elsif rising_edge(clk) then
        if tick = pres_scaler-1 then
            div_clk <='1';
            tick := 0;
        else
            tick := tick + 1;
				  div_clk <= '0';
        end if;
    end if;
end process;

-- sens de rotation moteur
sens <= sens_select;

end beh;

