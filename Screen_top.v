`timescale 1ns / 1ps

module Screen_top(
    input wire clk,
    
    input  wire Keyb_clk,
    input  wire Keyboard_data,
    
    output wire Hsync,
    output wire Vsync,
    
    output wire [2 : 0] R,
    output wire [2 : 0] G,
    output wire [1 : 0] B
    );
    
wire [15 : 0] key;
keyboard_driver keyb (Keyb_clk, key, Keyboard_data);
    
wire VGAclk;    
Screen  scr (VGAclk, key, Hsync, Vsync, R, G, B, x, y);
VGA_clk vga_clk (.CLK_IN (clk), .CLK_OUT (VGAclk));

endmodule
