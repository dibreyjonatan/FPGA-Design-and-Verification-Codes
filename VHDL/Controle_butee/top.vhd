library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
    generic(
        max : natural := 1000;
		  ADC_droite : natural := 2500;
		  ADC_gauche : natural := 1000;
		  ADC_milieu : natural := 2000
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        sens_choix : in std_logic;
        adc_dout : in STD_LOGIC;
        
        adc_cs_n : out STD_LOGIC;
        adc_clk : out STD_LOGIC;    
   
        data_out : out STD_LOGIC_VECTOR(11 downto 0);
        RxIF : out STD_LOGIC;
        sens_rotation : out std_logic;
        pwm_sortie : out std_logic ;
		  fin_course_d : out std_logic:='0' ; 
		  fin_course_g : out std_logic:='0'
    );    
end top;

architecture beh of top is 
    signal compteur_comp : std_logic_vector(9 downto 0) := (others => '0');
    signal sens_decision : std_logic := '0';    
    signal data_conversion : STD_LOGIC_VECTOR(11 downto 0);
    signal centering : std_logic := '0';

    component pwm_bloc
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            sens_select : in std_logic;
            sens : out std_logic;
            rapport : in std_logic_vector(9 downto 0);
            pwm : out std_logic
        );    
    end component;
 
    component mcp3201_driver is
        generic (
            WAIT_CYCLES : integer := 99999  
        );
        Port (
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            adc_cs_n : out STD_LOGIC;
            adc_clk : out STD_LOGIC;  
            adc_dout : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(11 downto 0);
            RxIF : out STD_LOGIC
        );
    end component;
begin
    
    pwm_map : pwm_bloc PORT MAP (
        clk => clk,
        rst => rst,
        sens_select => sens_decision,
        sens => sens_rotation,
        rapport => compteur_comp,
        pwm => pwm_sortie
    );
     
    data_out <= data_conversion;
     
    ADC_ANGLE : mcp3201_driver PORT MAP (
        clk => clk,
        rst => rst,
        adc_cs_n => adc_cs_n,
        adc_clk => adc_clk,
        adc_dout => adc_dout,
        data_out => data_conversion,
        RxIF => RxIF  
    );

    controle_butee : process(clk, rst)
        constant C_MIN : unsigned(11 downto 0) := to_unsigned(ADC_gauche, 12);
        constant C_MAX : unsigned(11 downto 0) := to_unsigned(ADC_droite, 12);
        constant C_MID : unsigned(11 downto 0) := to_unsigned(ADC_milieu, 12); -- Milieu de conversion exact
        variable v_data : unsigned(11 downto 0);
    begin
        v_data := unsigned(data_conversion);

        if rst = '0' then
            compteur_comp <= (others => '0');
            sens_decision <= '0';
            centering     <= '1';
				fin_course_d <='0' ; 
		      fin_course_g <='0' ;
				
        elsif rising_edge(clk) then
            sens_decision <= sens_choix;

            if centering = '1' then
                -- Phase de recentrage initial vers le milieu de conversion (2000)
                if v_data < (C_MID - 15) then
                    sens_decision <= '1';
                    compteur_comp <= std_logic_vector(to_unsigned(600, 10));
                elsif v_data > (C_MID + 15) then
                    sens_decision <= '0';
                    compteur_comp <= std_logic_vector(to_unsigned(600, 10));
                else
                    compteur_comp <= (others => '0'); -- Atteint le centre
                    centering     <= '0';             -- Bascule en mode normal
                end if;
            else
                -- Mode normal : gestion des butées et inversion selon sens_choix
                if (v_data <= C_MIN) and (sens_choix = '0') then
                    -- En butée min et on veut aller vers le min -> Arrêt
						  		
		               fin_course_g <='1' ;
                    compteur_comp <= (others => '0');
                elsif (v_data >= C_MAX) and (sens_choix = '1') then
                    -- En butée max et on veut aller vers le max -> Arrêt
                    compteur_comp <= (others => '0');
						  fin_course_d <='1' ; 
                else
                    -- Mouvement autorisé (permet l'inversion min->max et max->min via sens_choix)
                    compteur_comp <= std_logic_vector(to_unsigned(600, 10));
						  		fin_course_d <='0' ; 
		                  fin_course_g <='0' ;
                end if;
            end if;
        end if;
    end process;

end beh;

 