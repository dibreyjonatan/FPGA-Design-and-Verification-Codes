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
		data_output : out std_logic_vector( max-2 downto 0 ) ; 
		cs : out std_logic ); -- pas de conversion     
end top;

architecture beh of top is 
      type etats is (START,READY, CONVERT, ATTENTE) ;
      signal ep, es : etats ; 
	  signal clk_conversion : std_logic ; 
	  signal fin_tim : std_logic :='0' ;
	  signal cmpt_fm : integer range 0 to 2 :=0 ;
	  signal cmpt_fd : integer range 0 to max :=0 ;
	  signal data_collect : std_logic_vector(max-2 downto 0 ); 
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
	 
	 -- affectation de la sortie 
	 data_output <= data_collect ; 
	 
	 -- process sequentielle 
	 sequentiel :process(rst,clk)
      begin 
  
      if rst='0' then ep <= START ;
      elsif rising_edge(clk) then ep <=es ; 
      end if ;
      end process ; 
	  
	  -- process combinant entrées et sorties
	  process(clk,clk_conversion)
	  
	  begin 
	  case ep is 
	   when START =>
	   if rising_edge(clk) then 
	        cs<='0' ;
			es <=READY ; 
			cmpt_fm <= 0 ; 
		end if ; 	
	  when READY =>
	        if cmpt_fm = 2 then 
			    es <= CONVERT ;
				cmpt_fm <=0 ; 
				cmpt_fd <=0 ;
        	elsif rising_edge(clk_conversion) then  
			cmpt_fm <= cmpt_fm +1  ; 
		    end if ; 
      when CONVERT =>
           if cmpt_fd = max-1 then  --on compte 13 bits i.e 13 coups d'horloge 
		       es <= ATTENTE ; 
               cmpt_fd <= 0 ; 
		   elsif rising_edge(clk_conversion) then 
                 data_collect <= data_collect(max-3 downto 0) & data_adc;    --les premiers bits sont les MSB donc il faut faire un
																			 -- décalage vers la gauche,	
				 cmpt_fd <= cmpt_fd+1 ; 
		   end if ;  		 
     when ATTENTE =>
          if (fin_tim='1') then 
           es<=START ;
		   fin_tim <='0' ;
          else 
		  cs<='1' ;
          es<=ATTENTE;	
          end if ;		  
           			   
	  end case ; 
	  end process ; 
      
	  -- compteur d'attente de 100ms 
	  process(clk,rst) 
	  variable cmpt : integer range 0 to 5000000 ; 
	  begin 
	  if (rst='0') then 
	   cmpt:=0 ;
		fin_tim<='0';
		
	  elsif (rising_edge(clk)) then 
		  cmpt:=cmpt+1 ;
		 if ep /= ATTENTE then  --ajouter car lui il sera executer tout le temps 
		  fin_tim <= '0';        -- donc forcer tim à 0 
		  cmpt := 0;
			 
	     elsif ( cmpt= 5000000 ) then 
		 cmpt:=0 ;
		 fin_tim<='1' ;
		 end if ;
		end if ;
		 
	  end process ; 

end beh;