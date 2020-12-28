module IF_ID(
    clk_i,
    start_i,
    rst_i,
    pc_i,
    instr_i,
    stall_i,
    mem_stall_i,
    flush_i,
    pc_o,
    instr_o

);


// Ports
input                   mem_stall_i;
input 		          		clk_i, start_i, stall_i, flush_i, rst_i;
input       [31:0]      pc_i;
input	      [31:0] 	  	instr_i;

output reg  [31:0]      pc_o;
output reg	[31:0] 	  	instr_o;
reg         [31:0]      inst;


always @(posedge clk_i) begin
  if (rst_i) begin
    instr_o <= 32'b0;
    pc_o <= 32'b0;
  end
  if (start_i) begin
      if (flush_i == 1'b1) begin
          instr_o <= 32'b0;
          pc_o <= 32'b0;
      end
      else if (~stall_i | ~mem_stall_i) begin
      	  pc_o <= pc_i;
          instr_o <= instr_i;
      end
  end
end

endmodule
