module ALU_Control
(
  funct_i,
  ALUOp_i,
  ALUCtrl_o
);

// Ports
input  [1:0]   ALUOp_i;
input  [9:0]   funct_i;
output [2:0]   ALUCtrl_o;

// Wires & Registers
reg    [2:0]   ALUCtrl_o;

// set ALU controls
always@(ALUOp_i or funct_i) begin
	case(ALUOp_i)
		2'b11:
      case(funct_i[2:0])
        3'b101: ALUCtrl_o <= 3'b111; // srai
        3'b000: ALUCtrl_o <= 3'b100; // addi
      default: ALUCtrl_o <= 3'b000; // nop
      endcase
		2'b10:
			case(funct_i)
				10'b0000000_111: ALUCtrl_o <= 3'b001; // and
				10'b0000000_100: ALUCtrl_o <= 3'b010; // xor
        10'b0000000_001: ALUCtrl_o <= 3'b011; // sll
				10'b0000000_000: ALUCtrl_o <= 3'b100; // add
				10'b0100000_000: ALUCtrl_o <= 3'b101; // sub
				10'b0000001_000: ALUCtrl_o <= 3'b110; // mul
			default: ALUCtrl_o <= 3'b000; // nop
			endcase
    2'b00:
			ALUCtrl_o <= 3'b100; // add

	endcase
end

endmodule
