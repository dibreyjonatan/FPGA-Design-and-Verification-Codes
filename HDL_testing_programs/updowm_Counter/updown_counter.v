
module up_down_counter(clk,reset,up,down,count);
input clk;
input reg reset,up,down;
output [3:0] count ;
reg [3:0] counter ;


always @(posedge clk)
begin
    if(reset)
        counter<=0 ;
        
    if (up)
       counter<= counter+1 ;
       
    if (down)
       counter <= counter-1 ;
       
end

 assign count= counter ;  

 initial
 begin
    $dumpfile("dump.vcd");
    $dumpvars(1,up_down_counter);
 end

endmodule 