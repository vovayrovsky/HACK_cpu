`timescale 1ns / 1ps

//Specification on CPU see at book 
//              Noam Nisan, Shimon Schocken - 
//                      The Elements of Computing Systems.
//                      Building a Modern Computer from First Principles. 
//              The MIT Press (2005)

module HACK_CPU
    (
    input  wire clk,
    input  wire reset,
    
    input  wire [15 : 0] inM,
    input  wire [15 : 0] instruction,
    
    output wire [15 : 0] outM,
    output wire [14 : 0] addresM,
    output wire          writeM,    
    
    output wire [14 : 0] pc
    );

wire in_data_select_sig;

wire ALU_input_select_sig;

wire [15 : 0] ALU_res;      assign outM = ALU_res;
wire [15 : 0] ALU_second_op;

wire [15 : 0] A_reg_in;
wire [15 : 0] A_reg_data;   assign addresM = A_reg_data[14 : 0]; 
wire          A_reg_write;

wire [15 : 0] D_reg_data;
wire          D_reg_write;

// ALU control signals declaration
// Names are the same like in description in ALU.v.
wire z_D;    
wire n_D;

wire z_second_op;
wire n_second_op;

wire ALU_no; // This signal means inverting of output signal.
wire ALU_f;  // This one means function what output ALU signal is.

wire ALU_zr; // This signal answers on a question about equality result of ALU's actions and zero.
wire ALU_ng; // This one shows is ALU result less than zero or not.

// end of ALU control signals declaration

wire [14 : 0] PC_data;      assign pc = PC_data;
wire PC_load;
wire PC_inc;

mux in_data_select   (  in_data_select_sig, instruction,    ALU_res,      A_reg_in);
mux ALU_input_select (ALU_input_select_sig,         inM, A_reg_data, ALU_second_op);

register A (clk, A_reg_write, A_reg_in, A_reg_data);
register D (clk, D_reg_write,  ALU_res, D_reg_data);

ALU alu (D_reg_data, z_D, n_D, ALU_second_op, z_second_op, n_second_op, ALU_f, ALU_no, ALU_res, ALU_zr, ALU_ng);

counter #(15) PC_module (clk, reset, PC_load, PC_inc, A_reg_data[14 : 0], PC_data);

ControlUnit cu (instruction, ALU_res, z_D, n_D, z_second_op, n_second_op, ALU_no, ALU_f, PC_load, PC_inc,
                in_data_select_sig, ALU_input_select_sig, A_reg_write, D_reg_write, writeM);

endmodule

module ControlUnit
    (
    input  wire [15 : 0] instruction,
    input  wire [15 : 0] ALU_res,
    
    output reg  z_D,    
    output reg  n_D,

    output reg  z_second_op,
    output reg  n_second_op,

    output reg  ALU_no,
    output reg  ALU_f,
    
    output reg  PC_load,
    output reg  PC_inc,
    
    output reg  in_data_select_sig,
    output reg  ALU_input_select_sig,

    output reg  A_reg_write,
    output reg  D_reg_write,
    output reg  writeM
    );
    
localparam no_jmp = 0; //no jump
localparam    JGT = 1; //if out  > 0
localparam    JEQ = 2; //if out == 0
localparam    JGE = 3; //if out >= 0
localparam    JLT = 4; //if out  < 0
localparam    JNE = 5; //if out != 0
localparam    JLE = 6; //if out <= 0
localparam    JMP = 7; //jump... just jump   

always@(*)
    begin
    
    if (!(instruction[15]))
        begin
        
        in_data_select_sig = 0;
        A_reg_write        = 1;
        D_reg_write        = 0;
        writeM             = 0;
        ALU_input_select_sig = 0;
        z_D         = 0;
        n_D         = 0;
        z_second_op = 0;
        n_second_op = 0;
        ALU_f       = 0;
        ALU_no      = 0;
        PC_load     = 0;
        PC_inc      = 1;
        
        end
    else
        begin
        
        in_data_select_sig = 1;
        ALU_input_select_sig = instruction[12];
        
        z_D         = instruction[11];
        n_D         = instruction[10];
        z_second_op = instruction[9];
        n_second_op = instruction[8];
        ALU_f       = instruction[7];
        ALU_no      = instruction[6];
        A_reg_write = instruction[5];
        D_reg_write = instruction[4];
        writeM      = instruction[3];

`define jmp_ins(var) if (var) begin PC_load = 1; PC_inc = 0; end else begin PC_load = 0; PC_inc  = 1; end                        
        
        case (instruction[2 : 0])
        
        no_jmp:  PC_load = 0;
        JGT:    `jmp_ins (ALU_res  > 0)
        JEQ:    `jmp_ins (ALU_res == 0)
        JGE:    `jmp_ins (ALU_res >= 0)
        JLT:    `jmp_ins (ALU_res  < 0)
        JNE:    `jmp_ins (ALU_res != 0)
        JLE:    `jmp_ins (ALU_res <= 0)
        JMP:    PC_load = 1;
        
        endcase
        
`undef jmp_ins
        
        end
    
    end
    
initial
    begin
    
    ALU_input_select_sig = 0;
    in_data_select_sig   = 0;
    z_D         = 0;
    n_D         = 0;
    z_second_op = 0;
    n_second_op = 0;
    ALU_f       = 0;
    ALU_no      = 0;
    A_reg_write = 0;
    D_reg_write = 0;
    writeM      = 0;
    PC_load     = 0;
    PC_inc      = 0;
    
    end
    
endmodule
