module Control
(
	Op_i,
	RegDst_o,
	ALUSrc_o,
	MemtoReg_o,
	RegWrite_o,
	MemWrite_o,
	Branch_o,
	Jump_o,
	ALUOp_o,
	MemRead_o
);

input	[5:0]	Op_i;
output			RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, Branch_o, Jump_o, MemRead_o;
output	[1:0]	ALUOp_o;

wire [9:0] temp;

assign temp = (Op_i == 6'b000000) ? {10'b1001000110} :	//R-Type
			  (Op_i == 6'b001000) ? {10'b0101000000} :	//addi
			  (Op_i == 6'b100011) ? {10'b0111000001} :	//lw
			  (Op_i == 6'b101011) ? {10'bx1x0100000} :	//sw
			  (Op_i == 6'b000100) ? {10'bx0x0010010} :	//beq
			  (Op_i == 6'b000010) ? {10'bxxx0001xx0} :	//j
			  10'bxxxxxxxxxx;

assign RegDst_o		= temp[9];
assign ALUSrc_o 	= temp[8];
assign MemtoReg_o 	= temp[7];
assign RegWrite_o 	= temp[6];
assign MemWrite_o 	= temp[5];
assign Branch_o 	= temp[4];
assign Jump_o 		= temp[3];
assign ALUOp_o		= temp[2:1];
assign MemRead_o 	= temp[0];

endmodule