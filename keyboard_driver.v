`timescale 1ns / 1ps

module keyboard_driver
    (
    input  wire keyboardclk,
    
    output wire [15 : 0] pres_key,
    
    input  wire keyboard_data
    );

reg [15 : 0] present_key = 0;

assign pres_key = present_key;

reg [8 : 0] cmd = 0;

localparam INIT  = 0;
localparam IDLE  = 1;
localparam RECV  = 2;
localparam DECOD = 3;

reg [1 : 0] state   = IDLE;
reg [3 : 0] counter = 0;

reg ignore_next = 0;

always@(negedge keyboardclk)
    begin
    
    if (state == INIT)
        begin
        
        state <= IDLE;
        
        end
        
    if (state == IDLE)
        begin
        
        if (keyboard_data == 0)
            begin
            state   <= RECV;
            cmd     <= 0;
            counter <= 0;
            end
        else
            state <= IDLE;
        end
        
    
    if (state == RECV)
        begin
        
        if (counter == 8)
            state <= DECOD;
            
        cmd[counter] <= keyboard_data;
        counter <= counter + 1;
        
        end
        
`define SCAN_TO_KEY(SYMBOL_, SCAN_, KEY_) else if (cmd[7 : 0] == SCAN_) present_key <= KEY_;
         
    if (state == DECOD)
        begin
        
        if (cmd[8] ^^ cmd[7] ^^ cmd[6] ^^ cmd[5] ^^ cmd[4] ^^
            cmd[3] ^^ cmd[2] ^^ cmd[1] ^^ cmd[0] && keyboard_data == 1)
            begin
            
            if (ignore_next)
                ignore_next <= 0;
            else if (cmd[7 : 0] == 8'hF0)
                begin
                
                ignore_next <= 1;
                present_key <= 0;
                
                end
            `include <scancodes_table>        
            
            counter     <= 0;             
            
            end
            
        state <= IDLE;
        
        end
        
    end

endmodule
