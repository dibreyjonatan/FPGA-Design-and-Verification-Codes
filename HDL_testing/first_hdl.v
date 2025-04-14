module andgate(
 a,b,out
);
input a,b ;
output out ;


assign out =  a & b ;

initial 
    $dumpfile("dump.vcd");
    //$dumpvars(1,andgate);

// end
endmodule 
