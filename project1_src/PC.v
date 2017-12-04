module PC
(
    clk_i,
    rst_i,
    start_i,
    pc_i,
    stall_i,   //
    pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input   [31:0]      pc_i;
input               stall_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;

//reg                 stall;


always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin
        if(start_i & ((stall_i === 1'bx) | (stall_i === 0)))
            pc_o <= pc_i;
        else
            pc_o <= pc_o;
    end
    // ((stall_i === 1'bx) | (stall_i === 0))
end

endmodule
