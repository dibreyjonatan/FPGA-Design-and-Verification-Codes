library ieee ;
use ieee.std_logic_1164.all ; 
use ieee.numeric_std.all ; 

entity mux4 is 
port(
   signal ent : in std_logic_vector(3 downto 0 ) ;
   signal cs : in std_logic_vector(1 downto 0 ) ;
   signal sortie : out std_logic 
    ) ;
end mux4 ;

Architecture beh of mux4 is 
begin 

 sortie <= ent(3) when cs="11" else
           ent(2) when cs="10" else
		   ent(1) when cs="01" else
		   ent(0) ; 

end ;  