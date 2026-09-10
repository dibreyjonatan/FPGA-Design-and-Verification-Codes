library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
  
entity top is 
    generic(
        max : natural := 1000
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        cs  : in  std_logic_vector(1 downto 0);
		
		 sens_choix : in std_logic ;
		 sens_rotation : out std_logic ; 
       pwm_sortie : out std_logic 
    );     
end top;

architecture beh of top is 
    signal comp    : integer range 0 to max := 0;
	  signal compteur_comp : std_logic_vector(9 downto 0) ;
	 Component projet1_led 
  port(
        clk : in  std_logic;
        rst : in  std_logic;
        sens_select : in std_logic ;
        sens : out std_logic ;
        rapport : in std_logic_vector(9 downto 0) ;
        pwm : out std_logic
    );    
 end Component ;

begin

    -- Choix du rapport cyclique
	-- le multiplexeur 4 vers 1 ici permet de decider du rapport cyclique qui va sur le pwm 
       comp <= 200  when cs = "00" else  -- 20 %
       300 when cs = "01" else     -- 30 %
       500 when cs = "10" else     -- 50 %
       800;                        -- 80 %  

    -- Generation PWM
	 compteur_comp <= std_logic_vector(to_unsigned(comp, 10)); 
	 pwm_map : projet1_led PORT MAP (
       clk => clk,
	   rst => rst,
	   sens_select => sens_choix,
	   sens => sens_rotation,
	   rapport => compteur_comp ,
	   pwm => pwm_sortie
	 ) ;

end beh;