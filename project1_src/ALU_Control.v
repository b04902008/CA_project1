module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input	[5:0]	funct_i;
input	[1:0]	ALUOp_i;
output	[2:0]	ALUCtrl_o;

assign ALUCtrl_o = (ALUOp_i == 2'b11) ?					//R-tpye->
					(funct_i == 6'b100000) ? 3'b010 :	//ADD
					(funct_i == 6'b100010) ? 3'b110 :	//SUB
					(funct_i == 6'b100100) ? 3'b000 :	//AND
					(funct_i == 6'b100101) ? 3'b001 :	//OR
					(funct_i == 6'b011000) ? 3'b011 :	//MUL
					3'bxxx :							//unknown
				   (ALUOp_i == 2'b01) ? 3'b110 :	//beq->SUB
				   (ALUOp_i == 2'b00) ? 3'b010 :	//lw,sw->ADD
				   3'bxxx;							//unknown

endmodule