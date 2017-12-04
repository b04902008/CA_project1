module FW
(
	EX_MEM_RegWrite_i,
	EX_MEM_RDaddr_i,
	MEM_WB_RegWrite_i,
	MEM_WB_RDaddr_i,
	ID_EX_RSaddr_i,
	ID_EX_RTaddr_i,
	ForwardA_o,
	ForwardB_o
);

input 			EX_MEM_RegWrite_i, MEM_WB_RegWrite_i;
input	[4:0]	EX_MEM_RDaddr_i, MEM_WB_RDaddr_i, ID_EX_RSaddr_i, ID_EX_RTaddr_i;
output	[1:0]	ForwardA_o, ForwardB_o;

assign ForwardA_o = (EX_MEM_RegWrite_i && EX_MEM_RDaddr_i != 5'b00000 && EX_MEM_RDaddr_i == ID_EX_RSaddr_i) ? 2'b10 :
					(MEM_WB_RegWrite_i && MEM_WB_RDaddr_i != 5'b00000 && EX_MEM_RDaddr_i != ID_EX_RSaddr_i && MEM_WB_RDaddr_i == ID_EX_RSaddr_i) ? 2'b01 :
					2'b00;
assign ForwardB_o = (EX_MEM_RegWrite_i && EX_MEM_RDaddr_i != 5'b00000 && EX_MEM_RDaddr_i == ID_EX_RTaddr_i) ? 2'b10 :
					(MEM_WB_RegWrite_i && MEM_WB_RDaddr_i != 5'b00000 && EX_MEM_RDaddr_i != ID_EX_RTaddr_i && MEM_WB_RDaddr_i == ID_EX_RTaddr_i) ? 2'b01 :
					2'b00;

endmodule