module MEM_WB(
    clk_i,
    start_i,
    RegWrite_i,
    MemtoReg_i,
    RegWrite_o,
    MemtoReg_o,

    ALU_rst_i,
    ReadData_i,
    ALU_rst_o,
    ReadData_o,

    RDaddr_i,
	  RDaddr_o
);

// Ports
input         clk_i, start_i;
input         RegWrite_i, MemtoReg_i;
output  reg    RegWrite_o, MemtoReg_o;

input        [31:0]    ReadData_i, ALU_rst_i;
output  reg   [31:0]    ReadData_o, ALU_rst_o;
input        [4:0]     RDaddr_i;
output  reg   [4:0]     RDaddr_o;


always @(posedge clk_i) begin
  if (start_i) begin
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    ReadData_o <= ReadData_i;
    ALU_rst_o <= ALU_rst_i;
	  RDaddr_o <= RDaddr_i;
  end
end
endmodule
