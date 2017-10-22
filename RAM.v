`timescale 1ns / 1ps

module RAM(
    input  wire clk,
    
    input  wire writeM,
    
    input  wire [14 : 0] address,
    input  wire [15 : 0] inM,
    
    input  wire [14 : 0] addressV,
    output wire [15 : 0] outV,
    
    output wire [15 : 0] outM,
    output reg  out_of_mem
    );

localparam mem_depth = 24575;

reg [15 : 0] storage [mem_depth - 1 : 0];

assign outM = storage[address];

always@(posedge clk)
    begin
    
    if (address >= mem_depth)
        out_of_mem <= 1;
        
    if (writeM)
        storage[address] <= inM;
    
    end

endmodule