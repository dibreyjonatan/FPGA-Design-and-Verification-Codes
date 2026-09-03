library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity projet1_led is 
generic(max:natural:=50000000) ;
port(
clk : in std_logic ;
rst : in std_logic ;
clk_1s : inout std_logic ;
led : out std_logic_vector(3 downto 0) );     
end projet1_led;

architecture beh of projet1_led is 

begin 

  process(clk, rst)
  variable temp: integer range 0 to max ; 
  begin 
  if (rst='0') then 
   temp:=0 ;
	clk_1s <= '0' ;
	elsif ( rising_edge(clk)) then 
	 temp := temp+1 ;
	 if (temp = max ) then 
	    clk_1s <= '1' ;
		 temp:=0 ; 
		 else 
		 clk_1s<='0' ; 
		 end if ;
		 end if ; 
  end process;
  
  
  
  
  process(clk, rst)
  variable tout : std_logic_vector(3 downto 0) ;
  begin 
  if (rst='0') then 
  led<="0000";
  tout:="0000";
  elsif (rising_edge(clk)) then  
  if (clk_1s='1') then 
  tout:= tout+1;
  end if ;
  led<=tout ;
	end if ;
  end process ;
  
  
end beh;
