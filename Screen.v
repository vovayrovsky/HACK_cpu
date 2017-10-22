`timescale 1ns / 1ps

module Screen(
    input  wire VGA_clk,
    input  wire color,
    
    output wire Hsync,
    output wire Vsync,
    
    output wire [2 : 0] R,
    output wire [2 : 0] G,
    output wire [1 : 0] B,
    
    output wire [10 : 0] X_screen,
    output wire [10 : 0] Y_screen 
    );
    
wire VisibleHorisontal;
wire VisibleVertical;

wire NextLine;

VGAcounter #(640, 16, 48, 96, 800, 10) HorisontalSync (VGA_clk,     1'b1, Hsync, VisibleHorisontal, X_screen, NextLine);
VGAcounter #(480, 10,  2, 33, 525, 10)   VerticalSync (VGA_clk, NextLine, Vsync, VisibleVertical, Y_screen);

assign R = (VisibleHorisontal && VisibleVertical && color)? 3'b111 : 3'b0;
assign G = (VisibleHorisontal && VisibleVertical && color)? 3'b111 : 3'b0;
assign B = (VisibleHorisontal && VisibleVertical && color)? 2'b11 : 2'b0;


endmodule

module VGAcounter#(
    parameter Visible_Area  = 800,
    parameter  Front_Porch  = 40,
    parameter   Back_Porch  = 40,
    parameter   Sync_Pulse  = 128,
    parameter   Whole_Line  = 1056,
    parameter Counter_width = 11    //log2(Whole_line)
    )(
    input  wire VGA_clk,
    input  wire CE,
    
    output reg  Sync,
    output reg  VisibleArea,
    output wire [Counter_width - 1 : 0] coordinate,
    
    output reg NextLine 
    );

initial 
    begin
    
    Sync = 1;
    VisibleArea = 1;
    NextLine = 0;
    
    end

reg [Counter_width - 1 : 0] counter = 0;

assign coordinate = counter;

always@(posedge VGA_clk)
    begin
    
    if (CE)
        begin
        
        if (counter == 0)
            begin
            VisibleArea <= 1;
            NextLine <= 0;
            end
            
        if (counter == Visible_Area - 1)
            begin
            VisibleArea <= 0;
            end
                    
        if (counter == Visible_Area + Front_Porch - 2)
            begin
            Sync        <= 0;
            end
            
        if (counter == Whole_Line - Back_Porch)
            begin
            Sync        <= 1;
            end
                    
        if (counter == Whole_Line - 1)
            begin
            counter <= 0;
            NextLine <= 1;
            end
        else            
            counter <= counter + 1;
        
        end
    
    end


endmodule
