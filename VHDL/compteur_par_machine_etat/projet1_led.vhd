library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity projet1_led is 
generic(max:natural:=50000000) ;
port(
clk : in std_logic ;
rst : in std_logic ;
go : in std_logic ; 
clk_1s : inout std_logic ;
led : out std_logic_vector(3 downto 0) );     
end projet1_led;

architecture beh of projet1_led is 
type etats is (idle, compter, attendre) ;
signal ep, es : etats ;
begin 
  
  sequentiel :process(rst,clk)
  begin 
  
  if rst='0' then ep <= idle  ;
  elsif rising_edge(clk) then ep <=es ; 
  end if ;
  end process ; 
  
  sorties : process (ep, go) 
  begin 
  case ep is 
  when idle => clk_1s <='0' ;
  when compter => clk_1s <= '1' ;
  when attendre => clk_1s <='0' ; 
  end case ;
  end process ; 
  
  combinatoire :process(ep,go)
  begin
  case ep is 
  when idle => 
  if (go='1') then 
      es<=idle ;
  else 
     es<=compter ;
	  end if ;
  when compter => es<=attendre ;
  when attendre =>
  if (go='1') then 
      es<=idle ;
  else 
     es<=attendre ;
	  end if ;
	  end case ;  
	  end process ; 
    
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
