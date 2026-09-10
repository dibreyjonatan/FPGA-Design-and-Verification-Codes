library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
  -- generer un signal de 1MHz 
entity clk_1Mhz is 
    generic(
        PSC: natural := 25
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        clk_adc : out std_logic 
    );     
end clk_1Mhz;
 
architecture beh of clk_1Mhz is 
 signal clk_count : std_logic :='0' ;
 
begin
 
    process(clk, rst)
variable counter : integer range 0 to PSC-1 ;
 
 
    begin
 
        if rst = '0' then
 
            counter := 0;
            clk_adc<= '0';
clk_count <='0' ;
 
        elsif rising_edge(clk) then
            clk_adc <= clk_count ;
 
            if counter = PSC then 
              counter := 0 ;
				 clk_count<=not(clk_count) ;
				else 
						counter := counter +1 ;
				 end if ; 
				 end if ;
			 
				 end process;
 
end beh;