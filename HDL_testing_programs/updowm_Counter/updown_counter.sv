
module up_down_counter(clk,reset,up,down,count);
input clk;
input reset,up,down;
output [3:0] count ;
reg [3:0] counter ;
 

initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0,up_down_counter);
    $dumplimit(1048576);
end

always @(posedge clk)
begin
    if(reset)
        counter<=0 ;
       
    if (counter<=4'b0000 || counter>=4'b1111)
       counter<=4'b0000 ;   
end
always @(posedge clk)
begin 
     if (up)
       counter<= counter+1 ;
end
always @(posedge clk)
begin   
    if (down)
       counter <= counter-1 ; 
end

assign count= counter ; 

endmodule 
