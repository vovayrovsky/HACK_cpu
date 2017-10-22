`timescale 1ns / 1ps

module register#(
    parameter width = 16
    )(
    input  wire clk,
    input  wire write,
    
    input  wire [width - 1 : 0] sig,
    
    output wire [width - 1 : 0] data
    );

reg [width - 1 : 0] storage = 0;

assign data = storage;

always@(posedge clk)
    begin
    
    storage <= write? sig : storage;
    
    end

endmodule
