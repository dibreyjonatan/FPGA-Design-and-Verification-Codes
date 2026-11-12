library ieee ;
use ieee.std_logic_1164.all ; 



entity gestion_rebond_bouton is 
   port (
     
	   clk : in std_logic ;
	   rst : in std_logic ; 
	   BP_Baboard : in std_logic ; 
	   BP_Triboard: in std_logic ; 
	   BP_STBY : in std_logic ; 
	   -- les sorties des boutons après temporisation 
	   
	   Baboard_Btn : out std_logic ; 
	   Triboard_Btn: out std_logic ; 
	   STBY_Btn : out std_logic 
	 
	  ) ; 
	  
	  end gestion_rebond_bouton ;
	  
	  
	  Architecture description of gestion_rebond_bouton is 
	  
	  type etats is (idle,wait_50ms, sortie) ;
	  signal ep, es : etats ;
	  signal start_tim, fin_tim : std_logic :='0' ; 
      
	  begin 
	    
		sequentiel :process(rst,clk)
			begin 
  
			if rst='0' then ep <= idle  ;
			elsif rising_edge(clk) then ep <=es ; 
			end if ;
		end process ; 
		
		sorties : process (ep,rst)
		  
		  begin 
		     if rst='0' then  
			  Baboard_Btn<='0' ; 
			  Triboard_Btn<='0'; 
	          STBY_Btn<='0' ; 
	        end if  ; 
			    
		     if ep = sortie then 
			 
			    if BP_Baboard = '1' then 
				  Baboard_Btn <= '1' ; 
				end if ; 
				
				if BP_Triboard = '1' then 
				  Triboard_Btn <= '1' ; 
				end if ;
				
				if BP_STBY = '1' then 
				  STBY_Btn <= '1' ; 
				end if ;
				
			else 
			
              Baboard_Btn<='0' ; 
			  Triboard_Btn<='0'; 
	          STBY_Btn<='0' ; 	
			  
		     end if ; 	
		  end process ; 
		  
		combinatoire : process( ep,fin_tim, BP_Baboard, BP_Triboard, BP_STBY ) 
			begin 
			case ep is 
			when idle =>
			  if BP_Baboard='1' or BP_Triboard='1' or BP_STBY='1' then 
			     es <= wait_50ms ; 
			  else 
                 es <= idle ; 
              end if ; 
            when wait_50ms =>
               	  start_tim<='1' ; 
                  if fin_tim = '1' then 
                     es <= sortie ; 
                  else 
				     es <= wait_50ms ; 
				  end if ; 
				  
		    when sortie =>
                 start_tim <= '0' ; 
                  es<=idle ; 
            				 
			end case  ; 
			
			end process ; 
	  
	  compteur : process (clk, rst, start_tim ) 
	     
		   variable cmpt : integer range 0 to 2500000 ; 
		   
		    begin 
			 if (rst='0') then 
			cmpt:=0 ;
			fin_tim<='0';
			elsif (rising_edge(clk) and start_tim='1' ) then
                  cmpt := cmpt +1  ; 
                  fin_tim <='0' ;
				  
                  if cmpt = 2500000 then 
					 cmpt:=0 ;
                     fin_tim<='1' ;
		          end if ; 
				  
		   end if;
        end process ; 		   
	  
	  
	  end ;  
