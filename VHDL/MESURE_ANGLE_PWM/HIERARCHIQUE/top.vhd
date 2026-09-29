
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
  
entity top is 
   
    port(
        clk : in  std_logic;
        
          continu : in std_logic ;
          start_stop : in std_logic ; 
          rst_command : in std_logic ; 
          in_pwm : in std_logic ; 
          data_out : out std_logic_vector(9 downto 0 ) ;
        out_oscillo : out std_logic ;
          out_1s : out std_logic 
    );     
end top;

architecture beh of top is 
   

component cmps03 is
    
    port (
        clk_50M : in std_logic ;
          
          in_pwm_compas : in std_logic ;
          config : in std_logic_vector(2 downto 0);
          compas : out std_logic_vector(9 downto 0 ) ;   
        out_1s : out std_logic ; 
        out_oscillo   : out std_logic 
    );
end component;

begin
  
 cmps03_map : cmps03 PORT MAP (
       clk_50M => clk,
        in_pwm_compas => in_pwm , 
       config =>start_stop & continu & rst_command ,
       compas =>data_out  ,
       out_1s => out_1s,
       out_oscillo =>  out_oscillo 
     ) ;


end beh;
