`timescale 1ns / 1ps

module seven_sig_up(
    input  clk,
    
    /*output wire [7 : 0] symbol_pins,//pgfedcba
    output wire [3 : 0] position_pins,
    output wire [5 : 0] LED,
    */
    
    input  wire Keyb_clk,
    input  wire Keyboard_data,
    
    output wire Hsync,
    output wire Vsync,
    
    output wire [2 : 0] R,
    output wire [2 : 0] G,
    output wire [1 : 0] B
    );

wire [15 : 0] key;

//reg LED_clk = 0;

//seven_seg_disp  drv  (LED_clk, key, symbol_pins, position_pins);
keyboard_driver keyb (Keyb_clk, key, Keyboard_data);

/*reg [17 : 0] dividerLED  = 0;

always@ (posedge clk)
    begin
    
    if (dividerLED == 200000)
        begin
        
        dividerLED <= 0;
        LED_clk <= ~LED_clk;
        
        end
    else
        begin
        
        dividerLED <= dividerLED + 1;
        
        end
        
    end*/

wire VGAclk;    

Screen  (VGAclk, key, Hsync, Vsync, R, G, B);
VGA_clk (.CLK_IN(clk), .CLK_OUT(VGAclk));

endmodule
