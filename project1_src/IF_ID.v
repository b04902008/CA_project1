module IF_ID
(
	clk_i,
	IFIDwrite_i,
	flush_i,
	pc_i,
	inst_i,
	pc_o,
	inst_o
);

// Ports
input				clk_i;
input 				IFIDwrite_i;
input 				flush_i;
input	[31:0]		pc_i;
input	[31:0]		inst_i;
output	[31:0]		pc_o;
output	[31:0]		inst_o;

// Wires & Registers
reg		[31:0]		pc_o;
reg		[31:0]		inst_o;

initial begin
	pc_o = 32'b0;
	inst_o = 32'b0;
end

always@(posedge clk_i) begin
	if (flush_i) begin
		pc_o <= 0;
		inst_o <= 0;
	end
	else if (IFIDwrite_i) begin
		pc_o <= pc_o;
		inst_o <= inst_o;
	end
	else begin
		pc_o <= pc_i;
		inst_o <= inst_i;
	end
end
   
endmodule