`timescale 1ns / 1ps

module half_adder(
    input  wire x,
    input  wire y,
    output wire out,
    output wire carry
    );

`ifndef simple_logic

assign {carry, out} = x + y;

`else

assign carry = x && y;
assign out   = x ^^ y;

`endif

endmodule
