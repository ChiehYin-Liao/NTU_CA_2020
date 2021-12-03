module Control
(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);


// Ports
input    [6:0]      Op_i;
output   [1:0]      ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;

// Wires & Registers
reg      [1:0]      ALUOp_o;
reg                 ALUSrc_o;
reg                 RegWrite_o;

// set controls
always@(Op_i) begin
	RegWrite_o <= 1'b1;
	case(Op_i)
		7'b0010_011:            //I-type
      begin
  			ALUOp_o <= 2'b00;
  			ALUSrc_o <= 1'b1;
      end
		7'b0110_011:            //R-type
      begin
  			ALUOp_o <= 2'b01;
  			ALUSrc_o <= 1'b0;
      end
	endcase
end


endmodule
