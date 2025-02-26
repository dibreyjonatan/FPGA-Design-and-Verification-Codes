module sync_2dff (
  input logic clk ,
  input logic rst_n ,
  
  input logic d_i,
  output logic q_o ) ;
  
  reg  ff1;
  reg ff2 ;
  
  assign q_o=ff2 ;
  
  always @(posedge clk , negedge rst_n ) begin
  
  if(~rst_n) begin
   ff1 <= '0 ;
   ff2 <= '0 ;
   end else begin 
    ff1<=d_i ;
    ff2 <=ff1  ;
    end
    end
    
    endmodule
  
