module Sign_Extend
(
    instruction_i,
    data_o
);

// Ports
input  [31:0] instruction_i;
output [31:0]  data_o;

// Wires & Registers
reg    [31:0]  data_o;

// Sign extend
always@(instruction_i) begin
  if (instruction_i[6:0] == 7'b0100011) begin //sw
		data_o <= {{20{instruction_i[31]}}, instruction_i[31:25], instruction_i[11:7]};
	end
	else if (instruction_i[6:0] == 7'b1100011) begin //beq
		data_o <= {{20{instruction_i[31]}},instruction_i[7],instruction_i[30:25],instruction_i[11:8], 1'b0};
	end
	else begin // I-type, lw
		data_o <= { {20{instruction_i[31]}}, instruction_i[31:20] };
	end
end


endmodule
