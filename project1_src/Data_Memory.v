module Data_Memory
(
    clk_i,
    MemWrite_i,
    MemRead_i,
    data_i,
    addr_i,
    data_o
);

// Ports
input               clk_i ;
input               MemWrite_i ;
input               MemRead_i ;
input   [31:0]      data_i ;
input   [31:0]      addr_i ;
output reg [31:0]   data_o ;

// Data Memory
reg     [7:0]     memory  [0:31];

// Write Data   
always@(posedge clk_i) begin
    if (MemWrite_i)
        memory[addr_i] <= data_i;
end
   
// Read Data  
always begin
    if (MemRead_i)
        data_o <= memory[addr_i] ;
end

endmodule 
