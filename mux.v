`timescale 1ns / 1ps

module mux#(
    parameter width = 16
    )(
    input  wire select,
    
    input  wire [width - 1 : 0] a,
    input  wire [width - 1 : 0] b,
    
    output wire [width - 1 : 0] out    
    );

assign out = select? b : a;

endmodule
