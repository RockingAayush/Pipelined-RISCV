`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2026 22:40:21
// Design Name: 
// Module Name: processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processor(
    input Clk,
    input Reset,
    input [4:0]debug_reg_select,
    output [31:0]debug_reg_out,
    
    output [31:0]PC_IF_debug,
    output [31:0]instruction_IF_debug,
    
    output [31:0]PC_ID_debug,
    output [31:0]instruction_ID_debug,
    output [31:0]immediate_ID_debug,
    output [4:0]rs1_ID_debug,
    output [4:0]rs2_ID_debug,
    output [31:0]rs1_data_ID_debug,
    output [31:0]rs2_data_ID_debug ,
    
    // EX Stage Debug
    output [31:0]PC_EX_debug,
    output [1:0]forward_A_debug,
    output [1:0]forward_B_debug,
    output [31:0]ALU_in_A_debug,
    output [31:0]ALU_in_B_debug,
    output [31:0]ALU_result_EX_debug,
    output [4:0] rd_EX_debug,
    output Branch_EX_debug,
    
    // MEM Stage Debug
    output [31:0]PC_MEM_debug,
    output [31:0]ALU_result_MEM_debug,
    output [31:0]memory_data_MEM_debug,
    output [4:0] rd_MEM_debug,
    output MemRead_MEM_debug,
    output MemWrite_MEM_debug,
    
    // WB Stage Debug
    output [31:0]PC_WB_debug,
    output [31:0]ALU_result_WB_debug,
    output [31:0]memory_data_WB_debug,
    output [31:0]write_data_debug,
    output [4:0] rd_WB_debug,
    output RegWrite_WB_debug
    );

// IF Stage
wire [31:0] PC_in;
wire [31:0] PC_add4;
wire [31:0] PC_IF;
wire [31:0] instruction_IF;
wire PCWrite;
wire IF_ID_Write;
wire [31:0] branch_address_EX;
wire [31:0] jal_target;
wire [31:0] jalr_target;
wire Branch_taken;
wire [1:0] PCSel;

wire [31:0] write_data;
wire [4:0]rd_WB;
wire RegWrite_WB;


wire control_hazard;

mux4to1#(32) pcsrc(
    .a(PC_add4),
    .b(branch_address_EX),        // branch target
    .c(jal_target),               // JAL
    .d(jalr_target),              // JALR
    .sel(PCSel),                  // PCSrc 2 bits
    
    .y(PC_in)                
    );

PC pc(
    .PC_in(PC_in),
    .Clk(Clk),
    .Reset(Reset),
    .PCWrite(PCWrite),
    
    .PC_out(PC_IF)
    );    
    
PC_adder PC_plus4(
    .PC_in(PC_IF),
    
    .PC_out(PC_add4)
    );

instruction_mem inst_mem(
    .read_addr(PC_IF),
    
    .instruction(instruction_IF)
    );

wire [31:0] PC_ID;
wire [31:0] instruction_ID;

IF_ID_pipe_reg if_id_pipe_reg(
    .Clk(Clk),
    .Reset(Reset),
    .flush(control_hazard),
    .PC_IF(PC_IF),
    .IR_IF(instruction_IF), 
    .IF_ID_Write(IF_ID_Write),
    
    .PC_ID(PC_ID),
    .IR_ID(instruction_ID)
    );

// ID Stage
wire [6:0] opcode_ID;
wire [4:0] rs2_ID;
wire [4:0] rs1_ID;
wire [4:0] rd_ID;
wire [31:0] immediate_ID;
wire [31:0] rs1_data_ID;
wire [31:0] rs2_data_ID;
wire [2:0] funct3_ID;
wire [6:0] funct7_ID;

// Control wires ID 
wire Branch_ID;
wire MemRead_ID;
wire [1:0] WriteBackSel_ID;
wire [1:0] ALUOp_ID;
wire MemWrite_ID;
wire [1:0] ALUSrcA_ID;
wire ALUSrcB_ID;
wire RegWrite_ID;


assign opcode_ID = instruction_ID[6:0];
assign rs2_ID = instruction_ID[24:20];
assign rs1_ID = instruction_ID[19:15];
assign rd_ID = instruction_ID[11:7];
assign funct3_ID = instruction_ID[14:12];
assign funct7_ID = instruction_ID[31:25];

main_control_unit MCU(
    .opcode(opcode_ID),
    
    .Branch(Branch_ID),
    .MemRead(MemRead_ID),
    .WriteBackSel(WriteBackSel_ID),
    .ALUOp(ALUOp_ID),
    .MemWrite(MemWrite_ID),
    .ALUSrcA(ALUSrcA_ID),
    .ALUSrcB(ALUSrcB_ID),
    .RegWrite(RegWrite_ID)
    );
    
imm_gen immediate_generator(
    .instruction(instruction_ID),
    
    .immediate(immediate_ID)
    );

register_file registers(
    .Clk(Clk),
    .Reset(Reset),
    .read_reg1(rs1_ID),
    .read_reg2(rs2_ID),
    .write_reg(rd_WB),
    .data(write_data),
    .RegWrite(RegWrite_WB),
    
    .read_data1(rs1_data_ID),
    .read_data2(rs2_data_ID),
    
    .debug_reg_select(debug_reg_select),
    .debug_reg_out(debug_reg_out)
    );    

// EX Stage
wire [31:0] PC_EX;
wire [6:0] opcode_EX;
wire [31:0] rs1_data_EX;
wire [31:0] rs2_data_EX;
wire [31:0] immediate_EX;
wire [4:0] rs1_EX;
wire [4:0] rs2_EX;
wire [4:0] rd_EX;
wire [2:0] funct3_EX;
wire [6:0] funct7_EX;

// Control Lines EX
wire Branch_EX;
wire MemRead_EX;
wire [1:0] WriteBackSel_EX;
wire [1:0] ALUOp_EX;
wire MemWrite_EX;
wire [1:0] ALUSrcA_EX;
wire ALUSrcB_EX;
wire RegWrite_EX;

assign control_hazard = 
       Branch_taken |
       (opcode_EX == 7'b1101111) |   // JAL
       (opcode_EX == 7'b1100111);    // JALR

wire ID_EX_flush;       
ID_EX_pipe_reg id_ex_pipe_reg(
    .Clk(Clk),
    .Reset(Reset),
    .flush(control_hazard | ID_EX_flush),   // from hazard OR branch logic

    // Data
    .PC_ID(PC_ID),
    .opcode_ID(opcode_ID),
    .rs1_data_ID(rs1_data_ID),
    .rs2_data_ID(rs2_data_ID),
    .immediate_ID(immediate_ID),
    .rs1_ID(rs1_ID),
    .rs2_ID(rs2_ID),
    .rd_ID(rd_ID),
    .funct3_ID(funct3_ID),
    .funct7_ID(funct7_ID),
    
    // EX control
    .ALUOp_ID(ALUOp_ID),
    .ALUSrcA_ID(ALUSrcA_ID),
    .ALUSrcB_ID(ALUSrcB_ID),
    .Branch_ID(Branch_ID),

    // MEM control
    .MemRead_ID(MemRead_ID),
    .MemWrite_ID(MemWrite_ID),

    // WB control
    .WriteBackSel_ID(WriteBackSel_ID),
    .RegWrite_ID(RegWrite_ID),

    // Data outputs
    .PC_EX(PC_EX),
    .opcode_EX(opcode_EX),
    .rs1_data_EX(rs1_data_EX),
    .rs2_data_EX(rs2_data_EX),
    .immediate_EX(immediate_EX),
    .rs1_EX(rs1_EX),
    .rs2_EX(rs2_EX),
    .rd_EX(rd_EX),
    .funct3_EX(funct3_EX),
    .funct7_EX(funct7_EX),

    // EX control outputs
    .ALUOp_EX(ALUOp_EX),
    .ALUSrcA_EX(ALUSrcA_EX),
    .ALUSrcB_EX(ALUSrcB_EX),
    .Branch_EX(Branch_EX),

    // MEM control outputs
    .MemRead_EX(MemRead_EX),
    .MemWrite_EX(MemWrite_EX),

    // WB control outputs
    .WriteBackSel_EX(WriteBackSel_EX),
    .RegWrite_EX(RegWrite_EX)
);   

wire [31:0] ALU_A_in;
wire [31:0] ALU_B_in;
wire [1:0] forward_A;
wire [1:0] forward_B;
wire [31:0] ALU_result_MEM;
wire [4:0] rd_MEM;
wire RegWrite_MEM;

forwarding_unit forward(
    .rs1_EX(rs1_EX),
    .rs2_EX(rs2_EX),
    .rd_MEM(rd_MEM),
    .rd_WB(rd_WB),
    .RegWrite_MEM(RegWrite_MEM),
    .RegWrite_WB(RegWrite_WB),
    
    .forward_A(forward_A),
    .forward_B(forward_B)
);
mux4to1#(32) forward_value_A(
    .a(rs1_data_EX),
    .b(write_data),     // from MEM              
    .c(ALU_result_MEM), // from EX    
    .d(),               // Unconnected
    .sel(forward_A),    // forwardA
    
    .y(ALU_A_in)                
    );

mux4to1#(32) forward_value_B(
    .a(rs2_data_EX),
    .b(write_data),     // from MEM (Signal to be passed would be from WB)             
    .c(ALU_result_MEM), // from EX (Signal to be passed would be from MEM)    
    .d(),               // Unconnected
    .sel(forward_B),    // forwardA
    
    .y(ALU_B_in)                
    );

wire [31:0]ALU_A;
wire [31:0]ALU_B;

mux4to1#(32) ALU_A_select(
    .a(ALU_A_in),
    .b(PC_EX),          // PC for AUIPC             
    .c(32'd0),          // 0 for LUI    
    .d(),               // Unconnected
    .sel(ALUSrcA_EX),             
        
    .y(ALU_A)                
    );
    
mux#(32) ALU_B_select(
    .a(ALU_B_in),
    .b(immediate_EX),
    .sel(ALUSrcB_EX),
    
    .y(ALU_B)
    );

wire [3:0]ALUControl;

ALU_control_unit ALU_control(
    .ALUOp(ALUOp_EX),
    .funct3(funct3_EX),
    .funct7_5(funct7_EX[5]),   // instruction[30]
    
    .ALUControl(ALUControl)
);

wire [31:0]ALU_result_EX;
wire Zero;
wire Less;
wire LessU;

ALU alu(
    .A(ALU_A),
    .B(ALU_B),
    .ALUControl(ALUControl),
    
    .Result(ALU_result_EX),
    .Zero(Zero),
    .Less(Less),
    .LessU(LessU)
    );
                
adder branch_calc(
    .A(PC_EX),
    .B(immediate_EX),
    
    .out(branch_address_EX)
    );

assign jal_target = immediate_EX + PC_EX;
assign jalr_target = {ALU_result_EX[31:1], 1'b0};

assign Branch_taken = (Branch_EX & Zero & (funct3_EX == 3'b000)) |  // beq
                      (Branch_EX & ~Zero & (funct3_EX == 3'b001))|  // bne
                      (Branch_EX & Less & (funct3_EX == 3'b100)) |  // blt
                      (Branch_EX & ~Less & (funct3_EX == 3'b101))|  // bge  
                      (Branch_EX & LessU & (funct3_EX == 3'b110))|  // bltu  
                      (Branch_EX & ~LessU & (funct3_EX == 3'b111)); // bgeu  
                      
assign PCSel = (opcode_EX == 7'b1100111) ? 2'b11:     // jalr
               (opcode_EX == 7'b1101111) ? 2'b10:     // jal     
               (Branch_taken)         ? 2'b01:        // B-type  
                                        2'b00;
                                            
hazard_detection_unit HDU(
    .rs1_ID(rs1_ID),
    .rs2_ID(rs2_ID),
    .rd_EX(rd_EX),
    .MemRead_EX(MemRead_EX),
    
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .ID_EX_flush(ID_EX_flush)
    );


wire [31:0] rs2_data_MEM;
wire [31:0] PC_MEM;
wire MemRead_MEM;
wire MemWrite_MEM;
wire [1:0] WriteBackSel_MEM;
wire [2:0] funct3_MEM;

EX_MEM_pipe_reg ex_mem_pipe_reg(
    .Clk(Clk),
    .Reset(Reset),
    .flush(1'b0),
    
    // Data
    .funct3_EX(funct3_EX),
    .ALU_result_EX(ALU_result_EX),
    .rs2_data_EX(ALU_B_in),
    .rd_EX(rd_EX),
    .PC_EX(PC_EX),
   
    // MEM
    .MemRead_EX(MemRead_EX),
    .MemWrite_EX(MemWrite_EX),
    
    // WB
    .WriteBackSel_EX(WriteBackSel_EX),
    .RegWrite_EX(RegWrite_EX),
    
    // Data
    .funct3_MEM(funct3_MEM),
    .ALU_result_MEM(ALU_result_MEM),
    .rs2_data_MEM(rs2_data_MEM),
    .rd_MEM(rd_MEM),
    .PC_MEM(PC_MEM),
    
    // MEM
    .MemRead_MEM(MemRead_MEM),
    .MemWrite_MEM(MemWrite_MEM),
    
    // WB
    .WriteBackSel_MEM(WriteBackSel_MEM),
    .RegWrite_MEM(RegWrite_MEM)
    );

// MEM Stage
wire [31:0] memory_data_MEM;
data_memory memory(
    .Clk(Clk),
    .address(ALU_result_MEM),
    .write_data(rs2_data_MEM),
    .funct3(funct3_MEM),
    .MemWrite(MemWrite_MEM),
    .MemRead(MemRead_MEM),
    
    .ReadData(memory_data_MEM)
    );

// WB Stage 
wire [31:0]PC_WB;
wire [31:0]memory_data_WB;
wire [31:0]ALU_result_WB;
wire [1:0]WriteBackSel_WB;

MEM_WB_pipe_reg mem_wb_pipe_reg(
    .Clk(Clk),
    .Reset(Reset),
    .flush(),
    
    // Data Signals
    .PC_MEM(PC_MEM),
    .memory_data_MEM(memory_data_MEM),
    .ALU_result_MEM(ALU_result_MEM),
    .rd_MEM(rd_MEM),
    
    // Control Signals
    // WB
    .WriteBackSel_MEM(WriteBackSel_MEM),
    .RegWrite_MEM(RegWrite_MEM),
    
    // Data Signals
    .PC_WB(PC_WB),
    .memory_data_WB(memory_data_WB),
    .ALU_result_WB(ALU_result_WB),
    .rd_WB(rd_WB),
    
    // WB
    .WriteBackSel_WB(WriteBackSel_WB),
    .RegWrite_WB(RegWrite_WB)
    );

mux4to1#(32) WriteBack_Selection(
    .a(ALU_result_WB),
    .b(memory_data_WB),                      
    .c(PC_WB + 32'd4),  // PC + 4 for jal and jalr    
    .d(),               // Unconnected
    .sel(WriteBackSel_WB),             
        
    .y(write_data)                
    );
                     
// Debug Signals
assign PC_IF_debug = PC_IF;
assign instruction_IF_debug = instruction_IF;

assign PC_ID_debug = PC_ID;
assign instruction_ID_debug = instruction_ID;
assign immediate_ID_debug = immediate_ID; 
assign rs1_ID_debug = rs1_ID;  
assign rs2_ID_debug = rs2_ID; 
assign rs1_data_ID_debug = rs1_data_ID;
assign rs2_data_ID_debug = rs2_data_ID;

// EX Stage
assign PC_EX_debug          = PC_EX;
assign ALU_result_EX_debug  = ALU_result_EX;
assign rd_EX_debug          = rd_EX;
assign Branch_EX_debug      = Branch_EX;
assign ALU_in_A_debug       = ALU_A;
assign ALU_in_B_debug       = ALU_B;
assign forward_A_debug      = forward_A;
assign forward_B_debug      = forward_B;

// MEM Stage
assign PC_MEM_debug         = PC_MEM;
assign ALU_result_MEM_debug = ALU_result_MEM;
assign memory_data_MEM_debug= memory_data_MEM;
assign rd_MEM_debug         = rd_MEM;
assign MemRead_MEM_debug    = MemRead_MEM;
assign MemWrite_MEM_debug   = MemWrite_MEM;

// WB Stage
assign PC_WB_debug          = PC_WB;
assign ALU_result_WB_debug  = ALU_result_WB;
assign memory_data_WB_debug = memory_data_WB;
assign write_data_debug     = write_data;
assign rd_WB_debug          = rd_WB;
assign RegWrite_WB_debug    = RegWrite_WB;
                   
endmodule
