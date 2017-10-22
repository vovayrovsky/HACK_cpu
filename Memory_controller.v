`timescale 1ns / 1ps

module Memory_controller(
    input wire [14 : 0] addr,
    
    output reg main_memory,
    output reg video_memory,
    output reg keyboard_memory
    );

always@(*)
    begin
    
    main_memory = 0;
    video_memory = 0;
    keyboard_memory = 0;
    
    if (0 <= addr && addr <= 16383)
        main_memory = 1;
    else if (16384 <= addr && addr <= 24575)
        video_memory = 1;
    else if (addr == 24576)
        keyboard_memory = 1;
    end

endmodule
