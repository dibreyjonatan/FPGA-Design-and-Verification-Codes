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
		sens_choix : in std_logic ;
		adc_dout   : in  STD_LOGIC;
		
        adc_cs_n   : out STD_LOGIC;
        adc_clk    : out STD_LOGIC;   
     
        data_out   : out STD_LOGIC_VECTOR(11 downto 0);
        RxIF       : out STD_LOGIC ;
		sens_rotation : out std_logic ; 
        pwm_sortie : out std_logic 
    );     
end top;

architecture beh of top is 
    signal comp    : integer range 0 to max := 500;
	signal compteur_comp : std_logic_vector(9 downto 0) ;
	signal sens_decision, mem_sens : std_logic :='0' ; 
	signal data_conversion   : STD_LOGIC_VECTOR(11 downto 0);
	 Component pwm_bloc
  port(
        clk : in  std_logic;
        rst : in  std_logic;
        sens_select : in std_logic ;
        sens : out std_logic ;
        rapport : in std_logic_vector(9 downto 0) ;
        pwm : out std_logic
    );    
 end Component ;
 
 
component mcp3201_driver is
    generic (
        
        WAIT_CYCLES : integer := 99999  
    );
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        adc_cs_n   : out STD_LOGIC;
        adc_clk    : out STD_LOGIC;  
        adc_dout   : in  STD_LOGIC;
        data_out   : out STD_LOGIC_VECTOR(11 downto 0);
        RxIF       : out STD_LOGIC
    );
end Component;

begin

	
	 
	 pwm_map : pwm_bloc PORT MAP (
       clk => clk,
	   rst => rst,
	   sens_select => sens_decision,
	   sens => sens_rotation,
	   rapport => compteur_comp ,
	   pwm => pwm_sortie
	 ) ;
	 
	 -- conversion ADC 
	 
	 data_out <= data_conversion ; 
	 
	 ADC_ANGLE : mcp3201_driver PORT MAP (
	     clk => clk ,
		 rst => rst , 
		 adc_cs_n => adc_cs_n , 
		 adc_clk => adc_clk,
		 adc_dout => adc_dout,
		 data_out => data_conversion,
	     RxIF => RxIF  
	  ) ;
	 
controle_butee : process(clk, rst)
begin
    if rst = '0' then
        compteur_comp <= (others => '0');
        sens_decision <= '0';
        mem_sens      <= '0';

    elsif rising_edge(clk) then

        -- 0 pour entrer
        -- 1 pour sortir

        if data_conversion > std_logic_vector(to_unsigned(1022, 12)) and  data_conversion < std_logic_vector(to_unsigned(2919, 12)) then
            compteur_comp <= std_logic_vector(to_unsigned(500, 10));
            sens_decision <= mem_sens;

        else
		     -- ce n'est que en dehors du min et max que je modifie le sens de rotation 
			 
            if sens_choix = mem_sens then     -- si on ne change pas le sens on coupe le pwm en mettant une comparaison de 0 
                compteur_comp <= std_logic_vector(to_unsigned(0, 10));
            else
                if mem_sens = '0' then
                    -- si sens_choix != mem_sens i.e 1 != 0 alors le controle buté doit sortir
                    mem_sens      <= sens_choix; -- <= 1 
                    sens_decision <= '1';
                    compteur_comp <= std_logic_vector(to_unsigned(500, 10));
                else
                    -- si sens_choix != mem_sens i.e 0 != 1 alors le controle buté doit entrer
                    mem_sens      <= sens_choix;  -- <= 0
                    sens_decision <= '0';
                    compteur_comp <= std_logic_vector(to_unsigned(500, 10));
                end if;
            end if;
        end if;

    end if;
end process;

end beh;