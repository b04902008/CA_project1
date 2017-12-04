module CPU
(
	clk_i, 
	rst_i,
	start_i
);

// Ports
input			clk_i;
input			rst_i;
input			start_i;

wire	[31:0]	inst_addr, inst;
wire			zero, flush;

assign zero = (Registers.RSdata_o == Registers.RTdata_o)
assign flush = Control.Jump_o | (Control.Branch_o & zero)

Control Control(
	.Op_i		(IF_ID.inst_o[31:26]),
	.RegDst_o	(),//MUX_RegDst.select_i,
	.ALUSrc_o	(),//MUX_ALUSrc.select_i,
	.MemtoReg_o	(),
	.RegWrite_o	(),//Registers.RegWrite_i,
	.MemWrite_o	(),
	.Branch_o	(),
	.Jump_o		(),
	.ALUOp_o	(),//ALU_Control.ALUOp_i,
	.MemRead_o	()
);

FW FW(
	.EX_MEM_RegWrite_i	(EX_MEM.WB_o[0]),
	.EX_MEM_RDaddr_i	(EX_MEM.RDaddr_o),
	.MEM_WB_RegWrite_i	(MEM_WB.WB_o[0]),
	.MEM_WB_RDaddr_i	(MEM_WB.RDaddr_o),
	.ID_EX_RSaddr_i		(ID_EX.RSaddr_o),
	.ID_EX_RTaddr_i		(ID_EX.RTaddr_o),
	.ForwardA_o			(),
	.ForwardB_o			()
);

Hazard_Detection HD(
	.ID_EX_MemRead_i	(ID_EX.M_o[0]),
	.ID_EX_Rt_i			(ID_EX.RTaddr_o),
	.IF_ID_Rs_i			(IF_ID.inst_o[25:21]),
	.IF_ID_Rt_i			(IF_ID.inst_o[20:16]),
	.stall_o			()
);

IF_ID IF_ID(
	.clk_i			(clk_i),
	.IFIDwrite_i	(HD.stall_o),
	.flush_i		(flush),
	.pc_i			(Add_PC.data_o),
	.inst_i			(inst),
	.pc_o			(),
	.inst_o			()
);

ID_EX ID_EX(
	.clk_i			(clk_i),
	.WB_i			(MUX_Control.data_o[1:0]),//control signal
	.M_i			(MUX_Control.data_o[3:2]),//control signal
	.EX_i			(MUX_Control.data_o[7:4]),//control signal
	.RSdata_i		(Registers.RSdata_o),
	.RTdata_i		(Registers.RTdata_o),
	.SignExtend_i	(Sign_Extend.data_o),
	.RSaddr_i		(IF_ID.inst_o[25:21]),
	.RTaddr_i		(IF_ID.inst_o[20:16]),
	.RDaddr_i		(IF_ID.inst_o[15:11]),
	.WB_o			(),//control signal
	.M_o			(),//control signal
	.EX_o			(),//control signal
	.RSdata_o		(),
	.RTdata_o		(),
	.SignExtend_o	(),
	.RSaddr_o		(),
	.RTaddr_o		(),
	.RDaddr_o		()
);

EX_MEM EX_MEM(
	.clk_i		(clk_i),
	.WB_i		(ID_EX.WB_o),//control signal
	.M_i		(ID_EX.M_o),//control signal
	.DMaddr_i	(ALU.data_o),
	.DMdata_i	(MUX_RT.data_o),
	.RDaddr_i	(MUX_RegDst.data_o),
	.WB_o		(),//control signal
	.M_o		(),//control signal
	.DMaddr_o	(),
	.DMdata_o	(),
	.RDaddr_o	()
);

MEM_WB MEM_WB(
	.clk_i		(clk_i),
	.WB_i		(EX_MEM.WB_o),//control signal
	.data1_i	(EX_MEM.DMaddr_o),
	.data2_i	(Data_Memory.data_o),
	.RDaddr_i	(EX_MEM.RDaddr_o),
	.WB_o		(),//control signal
	.data1_o	(),
	.data2_o	(),
	.RDaddr_o	()
);

Adder Add_PC(
	.data1_in	(PC.pc_o),//inst_addr
	.data2_in	(32'd4),
	.data_o		()//Instruction_Memory.addr_i
);

Adder Add_Address(
	.data1_in	({Sign_Extend.data_o[29:0], 2'b00}),
	.data2_in	(IF_ID.pc_o),
	.data_o		()
);

PC PC(
	.clk_i		(clk_i),
	.rst_i		(rst_i),
	.start_i	(start_i),
	.pc_i		(MUX_Jump.data_o),
	.stall_i	(HD.stall_o),
	.pc_o		()//inst_addr
);

Instruction_Memory Instruction_Memory(
	.addr_i		(PC.pc_o),//inst_addr
	.instr_o	(inst)
);

Data_Memory Data_Memory(
	.clk_i		(clk_i),
	.MemWrite_i	(EX_MEM.M_o[1]),
	.MemRead_i	(EX_MEM.M_o[0]),
	.data_i		(EX_MEM.DMdata_o),
	.addr_i		(EX_MEM.DMaddr_o),
	.data_o		()
);

Registers Registers(
	.clk_i		(clk_i),
	.RSaddr_i	(IF_ID.inst_o[25:21]),
	.RTaddr_i	(IF_ID.inst_o[20:16]),
	.RDaddr_i	(MEM_WB.RDaddr_o),
	.RDdata_i	(MUX_RegSrc.data_o),
	.RegWrite_i	(MEM_WB.WB_o[0]),
	.RSdata_o	(),//ALU.data1_i
	.RTdata_o	()//MUX_ALUSrc.data1_i
);

MUX5 MUX_RegDst(
	.data1_i	(ID_EX.RTaddr_o),
	.data2_i	(ID_EX.RDaddr_o),
	.select_i	(ID_EX.EX_o[3]),
	.data_o		()//Registers.RDaddr_i
);

MUX8 MUX_Control(
	.data1_i	({Control.RegDst_o, Control.ALUOp_o, Control.ALUSrc_o, Control.MemWrite_o, Control.MemRead_o, Control.MemtoReg_o, Control.RegWrite_o}),
	.data2_i	(8'b00000000),
	.select_i	(HD.stall_o),
	.data_o		()
);

MUX32_2 MUX_RS(
	.data1_i	(ID_EX.RSdata_o),
	.data2_i	(MUX_RegSrc.data_o),
	.data3_i	(EX_MEM.DMaddr_o),
	.select_i	(FW.ForwardA_o),
	.data_o		()
);

MUX32_2 MUX_RT(
	.data1_i	(ID_EX.RTdata_o),
	.data2_i	(MUX_RegSrc.data_o),
	.data3_i	(EX_MEM.DMaddr_o),
	.select_i	(FW.ForwardB_o),
	.data_o		()
);

MUX32 MUX_ALUSrc(
	.data1_i	(MUX_RT.data_o),
	.data2_i	(ID_EX.SignExtend_o),
	.select_i	(ID_EX.EX_o[0]),
	.data_o		()//ALU.data2_i
);

MUX32 MUX_RegSrc(
	.data1_i	(MEM_WB.data1_o),
	.data2_i	(MEM_WB.data2_o),
	.select_i	(MEM_WB.WB_o[1]),
	.data_o		()
);
	
MUX32 MUX_Branch(
	.data1_i	(Add_PC.data_o),
	.data2_i	(Add_Address.data_o),
	.select_i	(Control.Branch_o & zero),
	.data_o		()
);

MUX32 MUX_Jump(
	.data1_i	(MUX_Branch.data_o),
	.data2_i	({MUX_Branch.data_o[31:28], IF_ID.inst_o[25:0], 2'b00}),
	.select_i	(Control.Jump_o),
	.data_o		()
);

Sign_Extend Sign_Extend(
	.data_i		(IF_ID.inst_o[15:0]),
	.data_o		()//MUX_ALUSrc.data2_i
);

ALU ALU(
	.data1_i	(MUX_RS.data_o),
	.data2_i	(MUX_ALUSrc.data_o),
	.ALUCtrl_i	(ALU_Control.ALUCtrl_o),
	.data_o		(),//Registers.RDdata_i
	.Zero_o		()
);

ALU_Control ALU_Control(
	.funct_i	(ID_EX.SignExtend_o[5:0]),
	.ALUOp_i	(ID_EX.EX_o[2:1]),
	.ALUCtrl_o	()//ALU.ALUCtrl_i
);

endmodule

