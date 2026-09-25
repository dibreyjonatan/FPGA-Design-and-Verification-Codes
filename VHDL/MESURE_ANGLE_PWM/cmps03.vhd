library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmps03 is
    generic (
        CLK_FREQ_HZ : natural := 50000000;
        period      : natural := 65 
    );
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;     
        in_pwm_compas : in  std_logic;
        continu       : in  std_logic;     
        start_stop    : in  std_logic;  
          out_oscillo   : out std_logic ;            
        data_valid    : out std_logic;
        data_compas   : out std_logic_vector(8 downto 0) ;
		cmd : in std_logic  -- bouton pour 
    );
end entity;

architecture behavior of cmps03 is
    constant MS_CYC   : natural := CLK_FREQ_HZ / 1000;
    constant TICK_CYC : natural := CLK_FREQ_HZ / 10000; -- 100us = 1 degre
    constant OFFSET   : natural := 10;                  -- 1 ms

    type state_t is (DECISION, WAIT_CMD, IDLE, ATTENTE, COUNT, WAIT_WINDOW);
    signal state, next_state : state_t := DECISION;
	
    signal cmpt_tick : integer range 0 to TICK_CYC - 1 := 0;
    signal angle     : integer range 0 to 511 := 0;
   
    signal ms_cmpt     : integer range 0 to MS_CYC - 1 := 0;
    signal fin_tim     : std_logic := '0';
    signal time_cont   : integer range 0 to period := 0;
    signal window_done : std_logic;	 
begin
     
     	-- sortie Oscilloscope
       out_oscillo <= in_pwm_compas ; 

    
    -- PROCESS : sequentiel
    p_state_reg : process(clk, rst)
    begin
        if rst = '0' then
            state <= DECISION;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

  
    -- PROCESS : combinatoire
    p_next_state : process(state, window_done, in_pwm_compas)
    begin
        next_state <= state;
        case state is
		   When DECISION =>
		        if continu='1' then  
				   next_state <= IDLE ;
				elsif continu='0' then 
                   next_state <= WAIT_CMD ; 
                end if ; 				   
		
		   when WAIT_CMD =>
				if cmd = '1' then
					next_state <= IDLE;
			    else 
             		next_state <= WAIT_CMD; 		
				end if;	
                if continu='1' then 
				    next_state <= DECISION;
				end if ; 
				
				
            when IDLE =>
			
                if  in_pwm_compas= '1' then
                    next_state <=IDLE ;
			    else 
				    next_state <=ATTENTE ;
                end if;
				
		     when ATTENTE =>
			 
                if  in_pwm_compas= '0' then
                    next_state <=ATTENTE ;
			    else 
				    next_state <=COUNT ;
                end if;		
				
            when COUNT =>
			
                if in_pwm_compas = '1' then
                    next_state <= COUNT;
				else 
				    next_state <=WAIT_WINDOW;	
                end if;
				
            when WAIT_WINDOW =>
			
                if window_done = '1' then
                   if continu = '1' then
                      next_state <= IDLE;      
                  else
                      next_state <= DECISION; 
                  end if;
                end if;	
        end case;
    end process;


    p_datapath : process(clk, rst)
        variable a : integer range 0 to 511;
    begin
        if rst = '0' then
            cmpt_tick   <= 0;
            angle       <= 0;
             data_valid <= '0';
            time_cont   <= 0;
			 window_done <= '0' ; 
            data_compas <= (others => '0');
        elsif rising_edge(clk) then
           
            case state is
                when IDLE =>
				        -- window_done <= '0' ; 
						cmpt_tick   <= 0;
				when ATTENTE =>
				
                    if  in_pwm_compas= '1' then
					   data_valid <= '0';
                        cmpt_tick <= 1;
                        angle     <= 0;
                    end if;
					
                when COUNT =>
				
                    if in_pwm_compas = '0' then
                        if angle >= OFFSET then a := angle - OFFSET; else a := 0; end if;
                        if a > 359 then a := 359; end if;
                          data_compas <= std_logic_vector(to_unsigned(a, 9));
						   data_valid <= '1';
                    elsif in_pwm_compas = '1' then
                          
                        if cmpt_tick = TICK_CYC - 1 then
                            cmpt_tick <= 0;
                            if angle < 511 then angle <= angle + 1; end if;
                        else
                            cmpt_tick <= cmpt_tick + 1;
                        end if;
                                
                    end if;

                when WAIT_WINDOW =>
				
                    if time_cont=period-1 then
                        time_cont   <= 0;
						 window_done <= '1' ; 
                    elsif fin_tim = '1' then
					     window_done <= '0' ; 
                        time_cont <= time_cont + 1;
                    end if;
					
			    when others => null ; 		
            end case;
        end if;
    end process;
     
      -- compteur de 1ms 
      
      process(clk, rst)
        variable cmpt : integer range 0 to MS_CYC - 1 := 0;
    begin
        if rst = '0' then
            cmpt    := 0;
            fin_tim <= '0';
        elsif rising_edge(clk) then
            if cmpt = MS_CYC - 1 then
                cmpt    := 0;
                fin_tim <= '1';
            else
                cmpt    := cmpt + 1;
                fin_tim <= '0';
            end if;
        end if;
    end process;
     

end architecture;