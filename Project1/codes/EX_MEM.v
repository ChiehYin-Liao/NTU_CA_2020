module EX_MEM(
    clk_i,
    start_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,

    ALU_rst_i,
    writeData_i,
    ALU_rst_o,
    writeData_o,

    RDaddr_i,
    RDaddr_o
);

// Ports
input clk_i, start_i;
input RegWrite_i, MemWrite_i, MemRead_i, MemtoReg_i;
output reg RegWrite_o, MemWrite_o, MemRead_o, MemtoReg_o;

input        [31:0]    ALU_rst_i, writeData_i;
input        [4:0]     RDaddr_i;

output reg   [31:0]    ALU_rst_o, writeData_o;
output reg   [4:0]     RDaddr_o;


always @(posedge clk_i) begin
  if (start_i) begin
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    ALU_rst_o <= ALU_rst_i;
    writeData_o <= writeData_i;
    RDaddr_o <= RDaddr_i;
  end
end
endmodule
