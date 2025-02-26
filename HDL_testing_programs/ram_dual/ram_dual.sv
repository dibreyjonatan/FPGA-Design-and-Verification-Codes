
module ram_dual (
 input[7:0] data,
 input [5:0] read_addr,write_addr,
 input we, read_clock,write_clock ,
 output reg[7:0] q );
 
 reg[7:0] ram[63:0] ;
 always @(posedge write_clock)
 begin
 if(we)
    ram[write_addr]<=data ;
end
always @(posedge read_clock)
begin
q<=ram[read_addr] ;
end
endmodule     
