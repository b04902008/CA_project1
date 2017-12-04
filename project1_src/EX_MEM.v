module EX_MEM
(
	clk_i,
	WB_i,//control signal
	M_i,//control signal
	DMaddr_i,
	DMdata_i,
	RDaddr_i,
	WB_o,//control signal
	M_o,//control signal
	DMaddr_o,
	DMdata_o,
	RDaddr_o
);

// Ports
input				clk_i;
input	[1:0]		WB_i;//control signal
input	[1:0]		M_i;//control signal
input	[31:0]		DMaddr_i;
input	[31:0]		DMdata_i;
input	[4:0]		RDaddr_i;
output	[1:0]		WB_o;//control signal
output	[1:0]		M_o;//control signal
output	[31:0]		DMaddr_o;
output	[31:0]		DMdata_o;
output	[4:0]		RDaddr_o;

// Wires & Registers
reg		[1:0]		WB_o;//control signal
reg		[1:0]		M_o;//control signal
reg		[31:0]		DMaddr_o;
reg		[31:0]		DMdata_o;
reg		[4:0]		RDaddr_o;

initial begin
	WB_o = 2'd0
	M_o = 2'd0
	DMaddr_o = 32'd0
	DMdata_o = 32'd0
	RDaddr_o = 5'd0
end
 
always@(posedge clk_i) begin
	WB_o <= WB_i;//control signal
	M_o <= M_i;//control signal
	DMaddr_o <= DMaddr_i;
	DMdata_o <= DMdata_i;
	RDaddr_o <= RDaddr_i;
end
   
endmodule