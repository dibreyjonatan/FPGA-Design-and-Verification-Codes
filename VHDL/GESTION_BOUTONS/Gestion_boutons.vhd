-- codeFonction:
-- =0000: pas d'action, le pilote est en veille
-- =0001: mode manuel action vérin babord
-- =0010: mode manuel action vérin tribord
-- =0011: mode pilote automatique/cap
-- =0100: incrément de 1° consigne de cap
-- =0101: incrément de 10° consigne de cap
-- =0111: décrément de 1° consigne de cap
-- =0110: décrément de 10° consigne de cap

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Gestion_boutons is		
port (BP_Babord : in std_logic := '0';
		BP_Tribord : in std_logic := '0';
		BP_STBY : in std_logic:= '0';
		clk_50M : in std_logic;
		raz_n : in std_logic := '0';
		--t_3s : in std_logic := '0';
		codeFonction : out std_logic_vector(3 downto 0):="0000";
		ledBabord : out std_logic_vector(1 downto 0):=(others=>'0');
		ledTribord : out std_logic_vector(1 downto 0):=(others=>'0');
		ledSTBY : out std_logic_vector(1 downto 0):=(others=>'0');
		out_bip : out std_logic_vector(1 downto 0):=(others=>'0')
		--a_tempo : out std_logic:= '0'
		);
end entity Gestion_boutons;


architecture exmpl of Gestion_boutons is

	-- seuil d'appui long : 250_000_000 coups à 50 MHz = 5 s (150_000_000 pour 3 s)
	constant T_LONG : integer := 250_000_000 ;

	signal start_tim, start_t : std_logic :='0' ;
	signal  second_temp : integer range 9 to 15 := 9 ; 
	signal  first_temp : integer range 0 to 9 := 0 ; 
	
	-- niveaux des boutons après anti-rebond : '1' tant que le bouton est maintenu
	signal Babord_Btn : std_logic ; 
	signal Tribord_Btn:  std_logic ; 
	signal STBY_Btn :  std_logic ;
	
	begin
	
	
	GESTION_REBOND : entity work.gestion_rebond_bouton port map(
	    
		clk => clk_50M ,
		rst => raz_n ,
		BP_Baboard  => BP_Babord ,
		BP_Triboard => BP_Tribord, 
		BP_STBY => BP_STBY,
		-- les sorties des boutons après temporisation 
		Baboard_Btn => Babord_Btn, 
		Triboard_Btn => Tribord_Btn , 
		STBY_Btn => STBY_Btn 
	   ) ; 
	   
	process(clk_50M,raz_n, first_temp, second_temp)
	variable state: integer range 0 to 11 ;
	
	
	begin
---reset asynchrone 	
		if(raz_n='0') then			
			state:=0;
			codeFonction<="0000";
			ledBabord<="00";
			ledTribord<="00";
			ledSTBY<="00";
			out_bip<="00";
			start_t <='0' ;
			start_tim <='0' ;
	--BP_Babord  BP_Tribord   BP_STBY
	--ledBabord  ledTribord   ledSTBY
	 
		elsif(rising_edge(clk_50M))then
			case state is
			--état 0 MODE manuele 
			when 0 =>
				if(Babord_Btn='1' and  Tribord_Btn='0' and STBY_Btn='0' )then
					state:=1;
				end if;
				if(Babord_Btn='0' and  Tribord_Btn='1' and STBY_Btn='0')then
					state:=2;
				end if;
				if(Babord_Btn='0' and  Tribord_Btn='0' and STBY_Btn='1')then
					state:=3;
				end if;
				
			codeFonction<="0000";
			ledSTBY<="11";
			ledBabord<="01";
			ledTribord<="01";
			out_bip<="00";	

			
		   --état 1
			when 1 =>
				if(Babord_Btn='0')then
					state:=0;
				end if;
				
			codeFonction<="0001";
			ledSTBY<="00";
			ledBabord<="10";
			ledTribord<="00";
			out_bip<="01";
			--1 bip
				
		   --état 2		
			when 2 =>
				if(Tribord_Btn='0')then
					state:=0;
				end if;
			
			codeFonction<="0010";
			ledSTBY<="00";
			ledBabord<="00";
			ledTribord<="10";
			out_bip<="01";
			--1 bip	
			
			--état 3
			when 3 =>
				if(STBY_Btn='0')then
					state:=4;
				end if;
			codeFonction<="0011";
			ledSTBY<="11";
			ledBabord<="01";
			ledTribord<="01";
			out_bip<="01";	
			--1 bip

---état 4 Mode automatique
			when 4 =>
				if(Babord_Btn='0' and  Tribord_Btn='0' and STBY_Btn='1')then
					state:=5;
				end if;
				if(Babord_Btn='1' and  Tribord_Btn='0' and STBY_Btn='0')then
					state:=6;
					start_t <='1' ; 
				end if;
				if(Babord_Btn='0' and  Tribord_Btn='1' and STBY_Btn='0')then
					state:=9;
					start_tim <='1' ; 	
				end if;
				
			codeFonction<="0011";
			ledSTBY<="10";
			ledBabord<="00";
			ledTribord<="00";
			out_bip<="00";	
			
			--état 5
			when 5 =>
				if(STBY_Btn='0')then
					state:=0;
				end if;
				
			codeFonction<="0000";
			ledSTBY<="10";
			ledBabord<="00";
			ledTribord<="00";
			out_bip<="01";		
			--1 bip	
		
		   --état 6
			when 6 =>
			
				if( first_temp=7) then
					state:=7;
				
				elsif (first_temp=8) then
					state:=8;
			    else 
                    state:=6 ;  				
				end if;
				
			ledSTBY<="00";
			ledBabord<="10";
			ledTribord<="00";        
			out_bip<="01";		
			--1 bip
			
         --état 7
			when 7 =>
			
			start_t <='0' ; 			
			codeFonction<="0111";
			state:=4 ;

         --état 8
			when 8 =>
			
				if(Babord_Btn='0')then
					state:=4;
				end if;
			start_t<='0' ; 	
			codeFonction<="0110";
			ledSTBY<="00";
			ledBabord<="11";
			ledTribord<="00";
			out_bip<="11";		
			--2 bip
		
         --état 9			
			when 9 =>
			
				if(second_temp=10)then
					state:=10;
				elsif (second_temp=11)then
					state:=11;
				else 
                    state := 9 ; 				
				end if;
				
			ledSTBY<="00";
			ledBabord<="00";
			ledTribord<="10";        
			out_bip<="01";		
			--1 bip
			
			--état 10
			when 10 =>
			
			start_tim <='0' ; 
			codeFonction<="0100";	        
			state:=4;

			--état 11
			when 11 =>
			
				if(Tribord_Btn='0')then
					state:=4;
				end if;
			start_tim <='0' ; 		
			codeFonction<="0101";
			ledSTBY<="00";
			ledBabord<="00";
			ledTribord<="11";
			out_bip<="11";			
			
			end case;
		end if ;		
	end process;
	
	-- Appui sur Babord : mesure de la durée d'appui, à partir de l'état 6
	-- first_temp = 0 : on attend ; 7 : bouton relâché (appui court) ; 8 : toujours appuyé après T_LONG (appui long)
	compteur_t : process (raz_n, clk_50M ) 
		variable cmpt : integer range 0 to T_LONG ; 
	begin 
		if (raz_n='0') then 
			cmpt:=0 ;
			first_temp<=0 ; 
		elsif (rising_edge(clk_50M)) then
			if start_t='1' then
				cmpt := cmpt +1  ; 
				first_temp <=0 ; 
				if Babord_Btn='0' then  -- bouton relâché (niveau anti-rebond) : appui court
					first_temp <=7;
				elsif cmpt = T_LONG then  -- toujours appuyé après T_LONG : appui long
					cmpt:=0 ;
					first_temp <= 8 ; 
				end if ; 
			else
				-- compteur arrêté : on remet tout à zéro pour ne pas garder l'ancien résultat
				cmpt:=0 ;
				first_temp <=0 ;
			end if ;
		end if;
	end process ; 		 
		
	-- Appui sur Tribord : même principe, à partir de l'état 9
	-- second_temp = 9 : on attend ; 10 : appui court ; 11 : appui long
	compteur : process (raz_n, clk_50M ) 
		variable cmpt : integer range 0 to T_LONG ; 
	begin 
		if (raz_n='0') then 
			cmpt:=0 ;
			second_temp<=9 ; 
		elsif (rising_edge(clk_50M)) then
			if start_tim='1' then
				cmpt := cmpt +1  ; 
				second_temp <=9 ; -- valeur d'attente : on reste dans l'état actuel tant qu'il n'y a pas de résultat
				if Tribord_Btn='0' then  -- bouton relâché : appui court
					second_temp <=10 ;
				elsif cmpt = T_LONG then  -- toujours appuyé après T_LONG : appui long
					cmpt:=0 ;
					second_temp <= 11 ; 
				end if ; 
			else
				cmpt:=0 ;
				second_temp <=9 ;
			end if ;
		end if;
	end process ; 		 

end architecture exmpl ;
