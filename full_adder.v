`timescale 1ns / 1ps

module full_adder(
    input  wire a,
    input  wire b,
    input  wire carry_in,
    output wire out,
    output wire carry_out
    );

`ifndef simple_logic 

assign {carry_out, out} = a + b + carry_in;

`else

assign carry_out =  a && b || a && carry_in || b && carry_in;

assign out       =  a && !b && !carry_in || !a && b && !carry_in ||
                   !a && !b &&  carry_in ||  a && b &&  carry_in; 
 
`endif

endmodule
