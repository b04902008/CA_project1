module Control
(
	Op_i,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o
);

input	[5:0]	Op_i;
output			RegDst_o, ALUSrc_o, RegWrite_o;
output	[1:0]	ALUOp_o;

wire [4:0] temp;

assign temp = (Op_i == 6'b000000) ? {5'b11101} :	//R-Type
			  (Op_i == 6'b001000) ? {5'b00011} :	//addi
			  5'bxxxxx;

assign RegDst_o		= temp[4];
assign ALUOp_o		= temp[3:2];
assign ALUSrc_o		= temp[1];
assign RegWrite_o	= temp[0];

endmodule