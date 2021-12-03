module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

// Ports
input signed [31:0]   data1_i, data2_i;
input        [2:0]    ALUCtrl_i;
output       [31:0]   data_o;
output                Zero_o;

// Wires & Registers
reg          [31:0]   data_o;
reg                   Zero_o;

/*
and: 001
xor: 010
sll: 011
add: 100
sub: 101
mul: 110
addi: 100
srai: 111   // arithmetic右移，會將原本的 sign bit複製到最高位元。
nop: 000
*/

always@(data1_i or data2_i or ALUCtrl_i) begin
	Zero_o = 1'b0;
	case(ALUCtrl_i)
		3'b001: data_o <= data1_i & data2_i; // and
		3'b010: data_o <= data1_i ^ data2_i; // xor
		3'b011: data_o <= data1_i << data2_i; // sll
    3'b100: data_o <= data1_i + data2_i; // add, addi
		3'b101: data_o <= data1_i - data2_i; // sub
		3'b110: data_o <= data1_i * data2_i; // mul
    3'b111: data_o <= data1_i >>> data2_i[4:0]; // srai
	default: data_o <= 32'd0; // nop
	endcase
end

endmodule
