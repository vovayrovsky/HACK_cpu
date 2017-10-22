`timescale 1ns / 1ps

module pull#(
    parameter to    = 1'b1,
    parameter width = 16
    )(
    input  wire [width - 1 : 0] in_sig,
    output wire [width - 1 : 0] out_sig
    );

integer i = 0;

always@(*)
    begin
    
    for (i = 0; i < width; i = i + 1)
        begin
        
        
        
        end
        
    end

endmodule
