module Sign_Extend
(
    data_i,
    data_o
);

// Ports
input  [11:0]  data_i;
output [31:0]  data_o;

// Wires & Registers
reg    [31:0]  data_o;

// Sign extend
always@(data_i) begin
  data_o[31:0] <= { {20{data_i[11]}}, data_i[11:0] };
end

endmodule
