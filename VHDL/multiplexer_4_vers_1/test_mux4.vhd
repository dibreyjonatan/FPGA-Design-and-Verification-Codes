library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity test_mux4 is 
 end test_mux4 ;
 
 architecture beh of test_mux4 is 
 -- declaration d'un component mux4
 Component mux4 
 port(
   signal ent : in std_logic_vector(3 downto 0 ) ;
   signal cs : in std_logic_vector(1 downto 0 ) ;
   signal sortie : out std_logic 
    ) ;
 end Component ;
 -- declaration des signaux 
 -- les signaux qui seront utilisé pour la simulation
 signal ent_t : std_logic_vector(3 downto 0 ) ;
 signal cs_t : std_logic_vector(1 downto 0 ) ;
 signal s : std_logic ;
 
 begin 
 -- Instantation du UUT
 -- on voit que c'est les ports de l'entité qui map le signale
 uut: mux4 PORT MAP ( ent => ent_t , cs=> cs_t, sortie => s ) ; 
 

 -- un process pour faire varier les entrer
 -- un process pour faire varier cs 
  process 
   begin 
   ent_t <= "0100" ;
    wait for 10 ns ;
	ent_t <= "0101" ;
	 wait for 20 ns ;
	ent_t <= "0001" ;
	 wait for 20 ns ;
	ent_t <= "1100" ;
     wait for 20 ns ;
	ent_t <= "0100" ;
	  -- wait for 20 ns ;
	
	wait ; 
  end process ; 
  
  process
  begin
  	cs_t <= "11" ;
  wait for 10 ns ; 
  cs_t <= "00" ;
  wait for 20 ns ;
	cs_t <= "01" ;
  wait for 20 ns ;
	cs_t <= "10" ;
  wait for 20 ns ;
	cs_t <= "11" ;
	-- wait for 20 ns ;

  wait ; 
  end process ; 
 
 
 
 end beh ; 