`timescale 1ns / 1ps

module ALU#(
    parameter width = 16
    )(
    input  wire [width - 1 : 0] x,
    input  wire                 zx,
    input  wire                 nx,
    
    input  wire [width - 1 : 0] y,
    input  wire                 zy,
    input  wire                 ny,
    
    input  wire                 f,
    input  wire                 no,
    
    output wire [width - 1 : 0] out,
    output wire                 zr,
    output wire                 ng
    );

wire [width - 1 : 0] directed_x;
wire [width - 1 : 0] directed_y;
wire [width - 1 : 0] out_buf;

input_direct #(width) dir_x (x, zx, nx, directed_x);
input_direct #(width) dir_y (y, zy, ny, directed_y);

assign out_buf = f? directed_x + directed_y : directed_x & directed_y;
assign out     = no? ~out_buf : out_buf;
assign zr      = out == 0;
assign ng      = out < 0;

endmodule

module input_direct#(
    parameter width = 16
    )(
    input  wire [width - 1 : 0] sig,
    input  wire                 zsig,
    input  wire                 nsig,   
    output reg  [width - 1 : 0] out
    );

always@(*)
    begin
    
    case ({nsig, zsig})
    
    2'b00: out = sig;
    2'b01: out = 0;
    2'b10: out = ~sig;
    2'b11: out = ~0;
    
    endcase
    
    end
    
endmodule
