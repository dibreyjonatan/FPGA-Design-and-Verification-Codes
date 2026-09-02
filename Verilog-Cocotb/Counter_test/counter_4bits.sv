`timescale  1ns/1ns
module countup(reset,count);
input reset ;
output [3:0] count ;
reg [3:0] counter ;
bit clk ;
initial clk=0 ;
always #2 clk=~clk ;

always @(posedge clk)
begin
    if(reset)
        counter<=0 ;
    else
       counter<= counter+1 ;
    //if (counter==4'b1111 )
        //counter<=0 ;
end

 assign count= counter ;        
          
initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0,countup);
end   
endmodule 