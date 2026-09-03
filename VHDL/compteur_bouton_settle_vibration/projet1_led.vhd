library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
 
 
entity projet1_led is 
generic(max:natural:=50000000) ;
port(
clk : in std_logic ;
rst : in std_logic ;
go : in std_logic ; 
clk_1s : inout std_logic:='0';
led : out std_logic_vector(3 downto 0) );     
end projet1_led;
 
architecture beh of projet1_led is 
type etats is (idle,timer, compter, attendre) ;
signal ep, es : etats ;
signal fin_tim : std_logic :='0' ;
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
  when timer => clk_1s <='0' ;
                --fin_tim<='0' ;
                --start_tim <= '1'; 
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
     es<=timer;
  end if ;
  when timer => 
  if (fin_tim='1') then 
      es<=compter ;
		--fin_tim<='0' ;
  else 
     es<=timer;
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
  
  process(clk,rst,go) 
  variable cmpt : integer range 0 to 2500000 ; 
  begin 
  if (rst='0') then 
   cmpt:=0 ;
	fin_tim<='0';
	
  elsif (rising_edge(clk) and go='0' ) then 
	  cmpt:=cmpt+1 ;
	 if ep /= timer then
      fin_tim <= '0';
      cmpt := 0;
		 
  elsif ( cmpt= 2500000 ) then 
     cmpt:=0 ;
     fin_tim<='1' ;
     end if ;
    end if ;
	 
  end process ; 
end beh;
 

 