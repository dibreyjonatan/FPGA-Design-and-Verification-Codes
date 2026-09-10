library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
  
entity top is 
    generic(
        max : natural := 14
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic ;
		data_adc : in std_logic ;
		clk_adc : out std_logic ;
		data_output : inout std_logic_vector( max-2 downto 0 ) ; 
		cs : out std_logic ); -- pas de conversion     
end top;

architecture beh of top is 
	  signal clk_conversion : std_logic ; 
	 Component clk_1MHz
  port(
        clk : in  std_logic;
        rst : in  std_logic;
        clk_adc : out std_logic 
    );    
 end Component ;

begin

      --- j'importe le bloc  d'horloge de 1MHz
	 Horloge_1MHz : clk_1MHz PORT MAP (
       clk => clk,
	   rst => rst,
	   clk_adc => clk_conversion
	 ) ;
	 -- affectation du signal d'horloge 
	 clk_adc <=clk_conversion ; 

end beh;