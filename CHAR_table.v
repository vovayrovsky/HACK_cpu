module CharGen(
	input  wire [3 : 0] char,
    input  wire [2 : 0] X,
    input  wire [3 : 0] Y,
	
    output wire value
	);

wire [127:0] matrix [1:0];

assign matrix[0] = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
assign matrix[1] = 128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

wire [127 : 0] char_;

assign char_ = matrix[char];

wire [7 : 0] columns [15 : 0];

assign columns[0]  = char_[  7 :   0];
assign columns[1]  = char_[ 15 :   8];
assign columns[2]  = char_[ 23 :  16];
assign columns[3]  = char_[ 31 :  24];
assign columns[4]  = char_[ 39 :  32];
assign columns[5]  = char_[ 47 :  40];
assign columns[6]  = char_[ 55 :  48];
assign columns[7]  = char_[ 63 :  56];
assign columns[8]  = char_[ 71 :  64];
assign columns[9]  = char_[ 79 :  72];
assign columns[10] = char_[ 87 :  80];
assign columns[11] = char_[ 95 :  88];
assign columns[12] = char_[103 :  96];
assign columns[13] = char_[111 : 104];
assign columns[14] = char_[119 : 112];
assign columns[15] = char_[127 : 120];

wire [7 : 0] column = columns[Y];

assign value = column[X];

endmodule
