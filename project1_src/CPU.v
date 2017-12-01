module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire    [31:0]  inst_addr, inst;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (),//MUX_RegDst.select_i,
    .ALUSrc_o   (),//MUX_ALUSrc.select_i,
    .MemtoReg_o (),
    .RegWrite_o (),//Registers.RegWrite_i,
    .MemWrite_o (),
    .Branch_o   (),
    .Jump_o     (),
    .ALUOp_o    (),//ALU_Control.ALUOp_i,
    .MemRead_o  ()
);

Adder Add_PC(
    .data1_in   (PC.pc_o),//inst_addr
    .data2_in   (32'd4),
    .data_o     ()//Instruction_Memory.addr_i
);

Adder Add_Address(
    .data1_in   ({Sign_Extend.data_o[29:0], 2'b00}),
    .data2_in   (Add_PC.data_o),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (MUX_Jump.data_o),
    .pc_o       ()//inst_addr
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o),//inst_addr
    .instr_o    (inst)
);

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .MemWrite_i (Control.MemWrite_o),
    .MemRead_i  (Control.MemRead_o),
    .data_i     (Registers.RTdata_o),
    .addr_i     (ALU.data_o),
    .data_o     ()
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o),
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o),
    .RSdata_o   (),//ALU.data1_i
    .RTdata_o   ()//MUX_ALUSrc.data1_i
);

MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (Control.RegDst_o),
    .data_o     ()//Registers.RDaddr_i
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()//ALU.data2_i
);

MUX32 MUX_RegSrc(
    .data1_i    (Data_Memory.data_o),
    .data2_i    (ALU.data_o),
    .select_i   (Control.MemtoReg_o),
    .data_o     ()
);
    
MUX32 MUX_Branch(
    .data1_i    (Add_PC.data_o),
    .data2_i    (Add_Address.data_o),
    .select_i   (Control.Branch_o & ALU.Zero_o),
    .data_o     ()
);

MUX32 MUX_Jump(
    .data1_i    (MUX_Branch.data_o),
    .data2_i    ({Add_PC.data_o[31:28], inst[25:0], 2'b00}),
    .select_i   (Control.Jump_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     ()//MUX_ALUSrc.data2_i
);

ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),//Registers.RDdata_i
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  ()//ALU.ALUCtrl_i
);

endmodule

