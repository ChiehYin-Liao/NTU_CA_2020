module CPU
(
  clk_i,
  rst_i,
  start_i,

  mem_data_i,
  mem_ack_i,
  mem_data_o,
  mem_addr_o,
  mem_enable_o,
  mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// To data memory interface.
input   [255:0]    mem_data_i;
input              mem_ack_i;
output  [255:0]    mem_data_o;
output  [31:0]     mem_addr_o;
output             mem_enable_o;
output             mem_write_o;

// Wires & Registers
wire  [31:0]   PC_in, PC_out, Branch_Target, MUX_PCSrc_out;              //PC
wire  [31:0]   ID_PC_out;
wire  [31:0]   IF_instruction, ID_instruction;
wire  [31:0]   ALU_src;                    //ALU
wire  [31:0]   EX_ALU_rst, MEM_ALU_rst, WB_ALU_rst;
wire           ALU_zero;
wire  [2:0]    ALUCtrl_out;                // ALU Contro
wire  [1:0]    Ctrl_ALU_op, EX_Ctrl_ALU_op;                //Control
wire           Ctrl_ALU_src, EX_Ctrl_ALU_src;
wire           Ctrl_Reg_write, EX_Ctrl_Reg_write, MEM_Ctrl_Reg_write, WB_Ctrl_Reg_write;
wire           Ctrl_Mem_to_Reg, EX_Ctrl_Mem_to_Reg, MEM_Ctrl_Mem_to_Reg, WB_Ctrl_Mem_to_Reg;
wire           Ctrl_Mem_read, EX_Ctrl_Mem_read, MEM_Ctrl_Mem_read;
wire           Ctrl_Mem_write, EX_Ctrl_Mem_write, MEM_Ctrl_Mem_write;
wire           Ctrl_Branch;
wire           Ctrl_PCWrite;
wire           Ctrl_PCSrc;

wire  [31:0]   MEM_Data_Mem_out, WB_Data_Mem_out;               //Data Memory

wire  [31:0]   WB_write_data;
wire  [31:0]   ID_read_data_1, ID_read_data_2, MEM_read_data_2;   //Registers
wire  [31:0]   EX_read_data_1, EX_read_data_2;
wire  [4:0]    EX_RDaddr, MEM_RDaddr, WB_RDaddr;

wire  [31:0]   ID_Sign_Extend_out, EX_Sign_Extend_out;            //Sign Extend
wire  [9:0]    EX_funct;
wire  [4:0]    ID_RS1addr;
wire  [4:0]    ID_RS2addr;
wire  [1:0]    ForwardA, ForwardB;

wire  [31:0]   MUX_Forwarding1_out, MUX_Forwarding2_out;

wire           Hazard_Detection_Stall, Hazard_Detection_Flush, ID_NoOp;
wire           MEM_dcache_stall;

// IF-stage
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (Ctrl_PCWrite),
    .pc_i       (MUX_PCSrc_out),
    .pc_o       (PC_out),
    .stall_i    (MEM_dcache_stall)
);

Adder Add_PC(
    .data1_in   (PC_out),
    .data2_in   (32'd4),
    .data_o     (PC_in)
);

MUX32 MUX_PCSrc(
    .data1_i    (PC_in),
    .data2_i    (Branch_Target),
    .select_i   (Hazard_Detection_Flush),
    .data_o     (MUX_PCSrc_out)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_out),
    .instr_o    (IF_instruction)
);

IF_ID IF_ID(
    .clk_i         (clk_i),
    .start_i       (start_i),
    .rst_i         (rst_i),
    .pc_i          (PC_out),
    .instr_i       (IF_instruction),
    .stall_i       (Hazard_Detection_Stall),
    .mem_stall_i   (MEM_dcache_stall),
    .flush_i       (Hazard_Detection_Flush),
    .pc_o 	       (ID_PC_out),
    .instr_o       (ID_instruction)
);

// ID-stage
Control Control(
    .Op_i       (ID_instruction[6:0]),
    .NoOp_i     (ID_NoOp),
    .ALUOp_o    (Ctrl_ALU_op),
    .ALUSrc_o   (Ctrl_ALU_src),
    .RegWrite_o (Ctrl_Reg_write),
    .MemtoReg_o (Ctrl_Mem_to_Reg),
    .MemRead_o  (Ctrl_Mem_read),
    .MemWrite_o (Ctrl_Mem_write),
    .Branch_o   (Ctrl_Branch)
);

Adder Add_Branch(
    .data1_in   (ID_Sign_Extend_out),
    .data2_in   (ID_PC_out),
    .data_o     (Branch_Target)
);

Hazard_Detection_Unit Hazard_Detection(
	.ID_EX_MemRead_i      (EX_Ctrl_Mem_read),
	.ID_EX_RegisterRd_i   (EX_RDaddr),
	.IF_ID_RS1_i          (ID_instruction[19:15]),
	.IF_ID_RS2_i          (ID_instruction[24:20]),
  .Registers_RS1data_i  (ID_read_data_1),
  .Registers_RS2data_i  (ID_read_data_2),
  .branch_i             (Ctrl_Branch),
  .PCWrite_o            (Ctrl_PCWrite),
  .stall_o              (Hazard_Detection_Stall)
);

assign ID_NoOp = (Hazard_Detection_Stall || (ID_instruction == 32'b0));
assign Hazard_Detection_Flush = Ctrl_Branch && ( ID_read_data_1 == ID_read_data_2);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (ID_instruction[19:15]),
    .RS2addr_i   (ID_instruction[24:20]),
    .RDaddr_i    (WB_RDaddr),
    .RDdata_i    (WB_write_data),
    .RegWrite_i  (WB_Ctrl_Reg_write),
    .RS1data_o   (ID_read_data_1),
    .RS2data_o   (ID_read_data_2)
);

Sign_Extend Sign_Extend(
    .instruction_i     (ID_instruction),
    .data_o            (ID_Sign_Extend_out)
);

ID_EX ID_EX(
    .clk_i         (clk_i),
    .start_i       (start_i),
    .rst_i         (rst_i),
    .ALUOp_i       (Ctrl_ALU_op),
    .ALUSrc_i      (Ctrl_ALU_src),
    .RegWrite_i    (Ctrl_Reg_write),
    .MemWrite_i    (Ctrl_Mem_write),
    .MemRead_i     (Ctrl_Mem_read),
    .MemtoReg_i    (Ctrl_Mem_to_Reg),
    .ALUOp_o       (EX_Ctrl_ALU_op),
	  .ALUSrc_o      (EX_Ctrl_ALU_src),
    .RegWrite_o    (EX_Ctrl_Reg_write),
    .MemWrite_o    (EX_Ctrl_Mem_write),
    .MemRead_o     (EX_Ctrl_Mem_read),
    .MemtoReg_o    (EX_Ctrl_Mem_to_Reg),

    .RS1data_i     (ID_read_data_1),
    .RS2data_i     (ID_read_data_2),
    .imm_i         (ID_Sign_Extend_out),
    .funct_i       ({ID_instruction[31:25], ID_instruction[14:12]}),
    .RS1data_o     (EX_read_data_1),
    .RS2data_o     (EX_read_data_2),
    .imm_o         (EX_Sign_Extend_out),
    .funct_o       (EX_funct),

    .RS1addr_i     (ID_instruction[19:15]),
    .RS2addr_i     (ID_instruction[24:20]),
    .RS1addr_o     (ID_RS1addr),
    .RS2addr_o     (ID_RS2addr),

    .RDaddr_i      (ID_instruction[11:7]),
    .RDaddr_o      (EX_RDaddr),
    .mem_stall_i   (MEM_dcache_stall)
);

// EX-stage
MUX32 MUX_ALUSrc(
    .data1_i    (MUX_Forwarding2_out),
    .data2_i    (EX_Sign_Extend_out),
    .select_i   (EX_Ctrl_ALU_src),
    .data_o     (ALU_src)
);

Forwarding_Unit Forwarding_Unit
(
    .EX_MEM_RegisterRd_i (MEM_RDaddr),
    .EX_MEM_RegWrite_i   (MEM_Ctrl_Reg_write),
    .MEM_WB_RegisterRd_i (WB_RDaddr),
    .MEM_WB_RegWrite_i   (WB_Ctrl_Reg_write),
    .ID_EX_RS1_i         (ID_RS1addr),
    .ID_EX_RS2_i         (ID_RS2addr),
    .ForwardA_o          (ForwardA),
    .ForwardB_o          (ForwardB)
);

MUX_Forwarding MUX_Forwarding_1
(
    .data1_i   (EX_read_data_1),
    .data2_i   (WB_write_data),
    .data3_i   (MEM_ALU_rst),
    .select_i  (ForwardA),
    .data_o    (MUX_Forwarding1_out)
);

MUX_Forwarding MUX_Forwarding_2
(
    .data1_i   (EX_read_data_2),
    .data2_i   (WB_write_data),
    .data3_i   (MEM_ALU_rst),
    .select_i  (ForwardB),
    .data_o    (MUX_Forwarding2_out)
);

ALU ALU(
    .data1_i    (MUX_Forwarding1_out),
    .data2_i    (ALU_src),
    .ALUCtrl_i  (ALUCtrl_out),
    .data_o     (EX_ALU_rst),
    .Zero_o     (ALU_zero)
);

ALU_Control ALU_Control(
    .funct_i    (EX_funct),
    .ALUOp_i    (EX_Ctrl_ALU_op),
    .ALUCtrl_o  (ALUCtrl_out)
);

EX_MEM EX_MEM(
    .clk_i         (clk_i),
    .start_i       (start_i),
    .rst_i         (rst_i),
    .RegWrite_i    (EX_Ctrl_Reg_write),
    .MemtoReg_i    (EX_Ctrl_Mem_to_Reg),
    .MemRead_i     (EX_Ctrl_Mem_read),
    .MemWrite_i    (EX_Ctrl_Mem_write),
    .RegWrite_o    (MEM_Ctrl_Reg_write),
    .MemtoReg_o    (MEM_Ctrl_Mem_to_Reg),
    .MemRead_o     (MEM_Ctrl_Mem_read),
    .MemWrite_o    (MEM_Ctrl_Mem_write),

    .ALU_rst_i     (EX_ALU_rst),
    .writeData_i   (MUX_Forwarding2_out),
    .ALU_rst_o     (MEM_ALU_rst),
    .writeData_o   (MEM_read_data_2),

    .RDaddr_i      (EX_RDaddr),
    .RDaddr_o      (MEM_RDaddr),
    .mem_stall_i   (MEM_dcache_stall)
);

//MEM-stage
// Data_Memory Data_Memory(
//     .clk_i       (clk_i),
//     .addr_i      (MEM_ALU_rst),
//     .MemRead_i   (MEM_Ctrl_Mem_read),
//     .MemWrite_i  (MEM_Ctrl_Mem_write),
//     .data_i      (MEM_read_data_2),
//     .data_o      (MEM_Data_Mem_out)
// );

dcache_controller dcache(
    // System clock, reset and stall
    .clk_i           (clk_i),
    .rst_i           (rst_i),

    // to Data Memory interface
    .mem_data_i      (mem_data_i),
    .mem_ack_i       (mem_ack_i),
    .mem_data_o      (mem_data_o),
    .mem_addr_o      (mem_addr_o),
    .mem_enable_o    (mem_enable_o),
    .mem_write_o     (mem_write_o),

    // to CPU interface
    .cpu_data_i      (MEM_read_data_2),       // data_i
    .cpu_addr_i      (MEM_ALU_rst),           // addr_i
    .cpu_MemRead_i   (MEM_Ctrl_Mem_read),     // MemRead_i
    .cpu_MemWrite_i  (MEM_Ctrl_Mem_write),    // MemWrite_i
    .cpu_data_o      (MEM_Data_Mem_out),      // data_o
    .cpu_stall_o     (MEM_dcache_stall)
);

MEM_WB MEM_WB(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .rst_i          (rst_i),
    .RegWrite_i     (MEM_Ctrl_Reg_write),
    .MemtoReg_i     (MEM_Ctrl_Mem_to_Reg),
    .RegWrite_o     (WB_Ctrl_Reg_write),
    .MemtoReg_o     (WB_Ctrl_Mem_to_Reg),

    .ALU_rst_i      (MEM_ALU_rst),
    .ReadData_i     (MEM_Data_Mem_out),
    .ALU_rst_o      (WB_ALU_rst),
    .ReadData_o     (WB_Data_Mem_out),

    .RDaddr_i       (MEM_RDaddr),
	  .RDaddr_o       (WB_RDaddr),
    .mem_stall_i    (MEM_dcache_stall)
);

//WB-stage
MUX32 MUX_MemtoReg(
    .data1_i    (WB_ALU_rst),
    .data2_i    (WB_Data_Mem_out),
    .select_i   (WB_Ctrl_Mem_to_Reg),
    .data_o     (WB_write_data)
);
endmodule
