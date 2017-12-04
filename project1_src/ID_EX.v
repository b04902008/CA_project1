module ID_EX
(
	clk_i,
	WB_i,//control signal
	M_i,//control signal
	EX_i,//control signal
	RSdata_i,
	RTdata_i,
	SignExtend_i,
	RSaddr_i,
	RTaddr_i,
	RDaddr_i,
	WB_o,//control signal
	M_o,//control signal
	EX_o,//control signal
	RSdata_o,
	RTdata_o,
	SignExtend_o,
	RSaddr_o,
	RTaddr_o,
	RDaddr_o
);

// Ports
input				clk_i;
input	[1:0]		WB_i;//control signal
input	[1:0]		M_i;//control signal
input	[3:0]		EX_i;//control signal
input	[31:0]		RSdata_i;
input	[31:0]		RTdata_i;
input	[31:0]		SignExtend_i;
input	[4:0]		RSaddr_i;
input	[4:0]		RTaddr_i;
input	[4:0]		RDaddr_i;
output	[1:0]		WB_o;//control signal
output	[1:0]		M_o;//control signal
output	[3:0]		EX_o;//control signal
output	[31:0]		RSdata_o;
output	[31:0]		RTdata_o;
output	[31:0]		SignExtend_o;
output	[4:0]		RSaddr_o;
output	[4:0]		RTaddr_o;
output	[4:0]		RDaddr_o;

// Wires & Registers
reg		[1:0]		WB_o;//control signal
reg		[1:0]		M_o;//control signal
reg		[3:0]		EX_o;//control signal
reg		[31:0]		RSdata_o;
reg		[31:0]		RTdata_o;
reg		[31:0]		SignExtend_o;
reg		[4:0]		RSaddr_o;
reg		[4:0]		RTaddr_o;
reg		[4:0]		RDaddr_o;

initial begin
	WB_o = 2'd0
	M_o = 2'd0
	EX_o = 4'd0
	RSdata_o = 32'd0
	RTdata_o = 32'd0
	SignExtend_o = 32'd0
	RSaddr_o = 5'd0
	RTdata_o = 5'd0
	RDaddr_o = 5'd0
end

always@(posedge clk_i) begin
	WB_o <= WB_i;//control signal
	M_o <= M_i;//control signal
	EX_o <= EX_i;//control signal
	RSdata_o <= RSdata_i;
	RTdata_o <= RTdata_i;
	SignExtend_o <= SignExtend_i;
	RSaddr_o <= RSaddr_i;
	RTaddr_o <= RTaddr_i;
	RDaddr_o <= RDaddr_i;
end
   
endmodule