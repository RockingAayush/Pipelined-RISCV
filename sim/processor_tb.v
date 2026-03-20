`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2026 19:52:18
// Design Name: 
// Module Name: processor_tb
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


`timescale 1ns / 1ps

module processor_tb;

// Clock and Reset
reg Clk;
reg Reset;

// IF
wire [31:0] PC_IF_debug;
wire [31:0] instruction_IF_debug;

// ID
wire [31:0] PC_ID_debug;
wire [31:0] instruction_ID_debug;
wire [31:0] immediate_ID_debug;
wire [4:0] rs1_ID_debug;
wire [4:0] rs2_ID_debug;
wire [31:0] rs1_data_ID_debug;
wire [31:0] rs2_data_ID_debug;

// EX
wire [31:0] PC_EX_debug;
wire [31:0] ALU_result_EX_debug;
wire [4:0] rd_EX_debug;
wire Branch_EX_debug;
wire [31:0] ALU_in_A_debug;
wire [31:0] ALU_in_B_debug;
wire [1:0] forward_A_debug;
wire [1:0] forward_B_debug;

// MEM
wire [31:0] PC_MEM_debug;
wire [31:0] ALU_result_MEM_debug;
wire [31:0] memory_data_MEM_debug;
wire [4:0] rd_MEM_debug;
wire MemRead_MEM_debug;
wire MemWrite_MEM_debug;

// WB
wire [31:0] PC_WB_debug;
wire [31:0] ALU_result_WB_debug;
wire [31:0] memory_data_WB_debug;
wire [31:0] write_data_debug;
wire [4:0] rd_WB_debug;
wire RegWrite_WB_debug;

processor uut (
    .Clk(Clk),
    .Reset(Reset),

    .PC_IF_debug(PC_IF_debug),
    .instruction_IF_debug(instruction_IF_debug),

    .PC_ID_debug(PC_ID_debug),
    .instruction_ID_debug(instruction_ID_debug),
    .immediate_ID_debug(immediate_ID_debug),
    .rs1_ID_debug(rs1_ID_debug),
    .rs2_ID_debug(rs2_ID_debug),
    .rs1_data_ID_debug(rs1_data_ID_debug),
    .rs2_data_ID_debug(rs2_data_ID_debug),

    .PC_EX_debug(PC_EX_debug),
    .forward_A_debug(forward_A_debug),
    .forward_B_debug(forward_B_debug),
    .ALU_result_EX_debug(ALU_result_EX_debug),
    .rd_EX_debug(rd_EX_debug),
    .Branch_EX_debug(Branch_EX_debug),
    .ALU_in_A_debug(ALU_in_A_debug),
    .ALU_in_B_debug(ALU_in_B_debug),

    .PC_MEM_debug(PC_MEM_debug),
    .ALU_result_MEM_debug(ALU_result_MEM_debug),
    .memory_data_MEM_debug(memory_data_MEM_debug),
    .rd_MEM_debug(rd_MEM_debug),
    .MemRead_MEM_debug(MemRead_MEM_debug),
    .MemWrite_MEM_debug(MemWrite_MEM_debug),

    .PC_WB_debug(PC_WB_debug),
    .ALU_result_WB_debug(ALU_result_WB_debug),
    .memory_data_WB_debug(memory_data_WB_debug),
    .write_data_debug(write_data_debug),
    .rd_WB_debug(rd_WB_debug),
    .RegWrite_WB_debug(RegWrite_WB_debug)
);


initial begin
    Clk = 0;
    forever #5 Clk = ~Clk; 
end


initial begin
    Reset = 0;
    #20;
    Reset = 1;
end
endmodule
