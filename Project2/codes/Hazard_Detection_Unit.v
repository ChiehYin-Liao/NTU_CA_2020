module Hazard_Detection_Unit
(
	ID_EX_MemRead_i,
	ID_EX_RegisterRd_i,
	IF_ID_RS1_i,
	IF_ID_RS2_i,
  Registers_RS1data_i,
  Registers_RS2data_i,
  branch_i,
  PCWrite_o,
  stall_o
);


// Ports
input         	    ID_EX_MemRead_i, branch_i;
input	   [4:0]   	  ID_EX_RegisterRd_i;
input	   [4:0]	    IF_ID_RS1_i;
input	   [4:0]	    IF_ID_RS2_i;
input	   [31:0]	    Registers_RS1data_i, Registers_RS2data_i;

output reg 	PCWrite_o, stall_o;



always @(ID_EX_MemRead_i or ID_EX_RegisterRd_i or IF_ID_RS1_i or IF_ID_RS2_i or Registers_RS1data_i or Registers_RS2data_i) begin
	//load use
	if (ID_EX_MemRead_i && ((ID_EX_RegisterRd_i == IF_ID_RS1_i) || (ID_EX_RegisterRd_i == IF_ID_RS2_i))) begin
    PCWrite_o <= 1'b0;
    stall_o <= 1'b1;
	end
	else begin
    PCWrite_o <= 1'b1;
    stall_o <= 1'b0;
	end

end

endmodule
