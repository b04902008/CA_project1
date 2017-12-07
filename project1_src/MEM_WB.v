module MEM_WB
(
	clk_i,
	WB_i,//control signal
	data1_i,
	data2_i,
	RDaddr_i,
	WB_o,//control signal
	data1_o,
	data2_o,
	RDaddr_o
);

// Ports
input				clk_i;
input	[1:0]		WB_i;//control signal
input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[4:0]		RDaddr_i;
output	[1:0]		WB_o;//control signal
output	[31:0]		data1_o;
output	[31:0]		data2_o;
output	[4:0]		RDaddr_o;

// Wires & Registers
reg		[1:0]		WB_o;//control signal
reg		[31:0]		data1_o;
reg		[31:0]		data2_o;
reg		[4:0]		RDaddr_o;

initial begin
	WB_o = 2'b0;
	data1_o = 32'b0;
	data2_o = 32'b0;
	RDaddr_o = 5'b0;
end

always@(posedge clk_i) begin
	WB_o <= WB_i;//control signal
	data1_o <= data1_i;
	data2_o <= data2_i;
	RDaddr_o <= RDaddr_i;
end
   
endmodule