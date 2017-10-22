`timescale 1ns / 1ps

module seven_seg_disp(
    input  wire LED_clk,
    input  wire [15 : 0] symbol,

    output reg  [7 : 0] symbol_pins,//pgfedcba
    output reg  [3 : 0] position_pins
    );
    
wire [3 : 0] numbs [3 : 0];
assign numbs[0] = symbol[ 3 : 0];
assign numbs[1] = symbol[ 7 : 4];
assign numbs[2] = symbol[11 : 8];
assign numbs[3] = symbol[15 : 12];      
    
initial
    begin
    symbol_pins = 0;
    position_pins = 0;
    end
    
reg [1 : 0] position = 0;

always@(*)
    begin
    
    position_pins           = 4'b1111;
    position_pins[position] = 0;
    
    case (numbs[position])
    
     0: symbol_pins = ~8'b00111111; 
     1: symbol_pins = ~8'b00000110;
     2: symbol_pins = ~8'b01011011;
     3: symbol_pins = ~8'b01001111;
     4: symbol_pins = ~8'b01100110;
     5: symbol_pins = ~8'b01101101;
     6: symbol_pins = ~8'b01111101;
     7: symbol_pins = ~8'b00000111;
     8: symbol_pins = ~8'b01111111;
     9: symbol_pins = ~8'b01101111;
    10: symbol_pins = ~8'b01110111; 
    11: symbol_pins = ~8'b01111010;
    12: symbol_pins = ~8'b00111001;
    13: symbol_pins = ~8'b01011110;
    14: symbol_pins = ~8'b01111001;
    15: symbol_pins = ~8'b01110001;
    
    endcase
    
    end

always@(posedge LED_clk)
    begin 
    
    position <= position + 1;
    
    end

endmodule
