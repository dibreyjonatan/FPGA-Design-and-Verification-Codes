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
sel : in std_logic ; 
led : out std_logic_vector(7 downto 0) );     
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
  variable tout : std_logic_vector(7 downto 0) ;
  variable gauche, droite, change : integer := 0 ; 
  begin 
  if (rst='0') then 
  led<="00000000";
  tout:="00000000";
  gauche:=0 ; 
  droite :=0 ;
  change:=0 ;
  
  elsif (rising_edge(clk)) then  
  if (clk_1s='1') then 
  
   if (sel = '1' and gauche=0) then
	if change=0 then  --si on commence par gauche c'est elle qui va mettre la valeur du système
	tout(7):=clk_1s ;
	change:=1 ;
	end if ;
	gauche:=1 ; 
	droite:=0 ;
	elsif (sel = '1' and gauche=1) then 
	
	tout := tout(6 downto 0 ) & tout(7) ;  -- décalage à gauche
   end if ; 
	
	if (sel = '0' and droite=0) then 
	if change=0 then  --si on commence par droite c'est elle qui va mettre la valeur du système
		tout(0):=clk_1s ;
	   change:=1 ;
	end if ;
	droite:=1 ;
	gauche:=0 ;
	elsif (sel = '0' and droite=1) then 
	tout := tout(0) & tout(7 downto 1 ) ; -- décalage à droite 
   end if ;
	
  led<=tout ;
	end if ;
	end if ;
  end process ;
  
  
end beh;
