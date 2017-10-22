`timescale 1ns / 1ps

module counter#(
    parameter width = 16
    )(
    input  wire clk,
    input  wire reset,
    input  wire load,
    input  wire inc,
    
    input  wire [width - 1 : 0] data,
    output wire [width - 1 : 0] out
    );
    
reg [width - 1 : 0] store = 0;

always@(posedge clk)
    begin
    
    if (reset)
        store <= 0;
    else if (load)
        store <= data;
    else if (inc)
        store <= store + 1;
    
    end
    
assign out = store;

endmodule
