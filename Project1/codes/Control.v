module Control
(
    Op_i,
    NoOp_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o

);


// Ports
input    [6:0]      Op_i;
input               NoOp_i;
output   [1:0]      ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output              Branch_o;


// Wires & Registers
reg      [1:0]      ALUOp_o;
reg                 ALUSrc_o;

assign RegWrite_o = (~NoOp_i) && ((Op_i == 7'b0010_011) || (Op_i == 7'b0000_011) || (Op_i == 7'b0110_011));
assign Branch_o = (Op_i == 7'b1100_011);
assign MemWrite_o = (Op_i == 7'b0100_011);
assign MemRead_o = (Op_i == 7'b0000_011);
assign MemtoReg_o = (Op_i == 7'b0000_011);

// set controls
always@(Op_i) begin
  if (NoOp_i == 1'b1) begin
    ALUOp_o <= 2'b00;
    ALUSrc_o <= 1'b0;
  end
  else begin
  case(Op_i)
    7'b0010_011:            //I-type
      begin
        ALUOp_o <= 2'b11;
        ALUSrc_o <= 1'b1;
      end
    7'b0110_011:            //R-type
      begin
        ALUOp_o <= 2'b10;
        ALUSrc_o <= 1'b0;
      end
    7'b0000_011:            //lw
      begin
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 1'b1;
      end
    7'b0100_011:            //sw
      begin
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 1'b1;
      end
    7'b1100_011:            //beq
      begin
        ALUOp_o <= 2'b01;
        ALUSrc_o <= 1'b0;
      end
  endcase
  end

end


endmodule
