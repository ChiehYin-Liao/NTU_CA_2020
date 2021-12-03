module CPU
(
    clk_i,
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// Wires & Registers
wire  [31:0]  PC_in, PC_out;              //PC
wire  [31:0]  instruction;
wire  [31:0]  read_data_1, read_data_2;   //Registers
wire  [31:0]  ALU_src;                    //ALU
wire  [31:0]  ALU_rst;
wire          ALU_zero;
wire  [2:0]   ALUCtrl_out;                // ALU Contro
wire  [1:0]   Ctrl_ALU_op;                //Control
wire          Ctrl_ALU_src;
wire          Ctrl_Reg_write;
wire  [31:0]  Sign_Extend_out;            //Sign Extend


Control Control(
    .Op_i       (instruction[6:0]),
    .ALUOp_o    (Ctrl_ALU_op),
    .ALUSrc_o   (Ctrl_ALU_src),
    .RegWrite_o (Ctrl_Reg_write)
);


Adder Add_PC(
    .data1_in   (PC_out),
    .data2_in   (32'd4),
    .data_o     (PC_in)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (PC_in),
    .pc_o       (PC_out)
);


Instruction_Memory Instruction_Memory(
    .addr_i     (PC_out),
    .instr_o    (instruction)
);


Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (instruction[19:15]),
    .RS2addr_i   (instruction[24:20]),
    .RDaddr_i    (instruction[11:7]),
    .RDdata_i    (ALU_rst),
    .RegWrite_i  (Ctrl_Reg_write),
    .RS1data_o   (read_data_1),
    .RS2data_o   (read_data_2)
);


MUX32 MUX_ALUSrc(
    .data1_i    (read_data_2),
    .data2_i    (Sign_Extend_out),
    .select_i   (Ctrl_ALU_src),
    .data_o     (ALU_src)
);


Sign_Extend Sign_Extend(
    .data_i     (instruction[31:20]),
    .data_o     (Sign_Extend_out)
);


ALU ALU(
    .data1_i    (read_data_1),
    .data2_i    (ALU_src),
    .ALUCtrl_i  (ALUCtrl_out),
    .data_o     (ALU_rst),
    .Zero_o     (ALU_zero)
);


ALU_Control ALU_Control(
    .funct_i    ({instruction[31:25], instruction[14:12]}),
    .ALUOp_i    (Ctrl_ALU_op),
    .ALUCtrl_o  (ALUCtrl_out)
);

endmodule
