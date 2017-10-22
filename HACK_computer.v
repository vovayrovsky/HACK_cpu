`timescale 1ns / 1ps

//TODO: add reset into keyboard_driver and Screen
//TODO: ADD FUCKING SCREEEN. IT SHOULD BE WITHOU ANY CHARS. ONLY PIXELS. FUCKKKKKKKKKKKKKKKK!!!!!!!!!

module HACK_computer(
    input  wire clk,
    input  wire reset,

    input  wire Keyb_clk,
    input  wire Keyboard_data,
    
    output wire Hsync,
    output wire Vsync,
    
    output wire [2 : 0] R,
    output wire [2 : 0] G,
    output wire [1 : 0] B,
    
    output wire out_of_mem 
    );
//clk part

wire VGAclk; 

VGA_clk vga_clk (.CLK_IN (clk), .CLK_OUT (VGAclk));

//wires declaration 

wire writeM;
wire main_memory;
wire video_memory;
wire keyboard_memory;

wire [15 : 0] inM_main;
wire [15 : 0] inM_keyboard;
reg  [15 : 0] inM;

wire [15 : 0] outM;
wire [15 : 0] outV;

wire [15 : 0] instruction;
wire [15 : 0] key;

wire [14 : 0] pc;

wire [14 : 0] addressV;

wire [14 : 0] addressM;

//main part

always@(*)
    begin
    
    if (main_memory)
        inM = inM_main;
    else if (video_memory)
        inM = inM_main;
    else if (keyboard_memory)
        inM = inM_keyboard;
    else
        inM = inM_main;
    end

HACK_CPU main_cpu (VGAclk, reset, inM, instruction, outM, addressM, writeM, pc);

tstROM Program_memory (.a(pc), .spo(instruction));

Memory_controller main_controll (addressM, main_memory, video_memory, keyboard_memory);

RAM    Data_memory  (VGAclk, writeM && main_memory, addressM, addressV, outV, outM, inM_main, out_of_mem);

//keyboard part
keyboard_driver keyb (Keyb_clk, inM_keyboard, Keyboard_data);    

//screen part
localparam video_mem_start = 16384;

reg  [14 : 0] scr_addr = 0;

assign addressV = scr_addr;
reg  scr_valid = 1;

wire [10 : 0] x;
wire [10 : 0] y;

always@ (*)
    begin
    
    if (x < 512 && y < 256)
        begin
        scr_addr = y*32 + x[10 : 4] + video_mem_start;
        scr_valid = 1;
        end
    else
        begin
        scr_addr = video_mem_start;
        scr_valid = 0;
        end
    end

Screen  scr (VGAclk, scr_valid? outV[x[3:0]] : 0, Hsync, Vsync, R, G, B, x, y);

endmodule
