`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2026 19:16:50
// Design Name: 
// Module Name: top
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


module top(
    input clk_100MHz,
    input btn_reset,
    input [4:0] sw,      // 5 switches for register select
    
    output [7:0] led     // lower 8 bits of register
);

wire [31:0] debug_reg_out;

wire [31:0] PC_IF, instruction_IF;
wire [31:0] PC_ID, instruction_ID, immediate_ID;
wire [4:0] rs1_ID, rs2_ID;
wire [31:0] rs1_data_ID, rs2_data_ID;

wire [31:0] PC_EX;
wire [1:0] forward_A, forward_B;
wire [31:0] ALU_in_A, ALU_in_B, ALU_result_EX;
wire [4:0] rd_EX;
wire Branch_EX;

wire [31:0] PC_MEM, ALU_result_MEM, memory_data_MEM;
wire [4:0] rd_MEM;
wire MemRead_MEM, MemWrite_MEM;

wire [31:0] PC_WB, ALU_result_WB, memory_data_WB;
wire [31:0] write_data;
wire [4:0] rd_WB;
wire RegWrite_WB;

reg [1:0] reset_sync;

always @(posedge clk_100MHz) begin
    reset_sync[0] <= ~btn_reset;   // invert here (active low internal)
    reset_sync[1] <= reset_sync[0];
end

wire Reset_sync = reset_sync[1];

processor cpu (
    .Clk(clk_100MHz),
    .Reset(reset_sync),

    .debug_reg_select(sw),
    .debug_reg_out(debug_reg_out),

    // IF
    .PC_IF_debug(PC_IF),
    .instruction_IF_debug(instruction_IF),

    // ID
    .PC_ID_debug(PC_ID),
    .instruction_ID_debug(instruction_ID),
    .immediate_ID_debug(immediate_ID),
    .rs1_ID_debug(rs1_ID),
    .rs2_ID_debug(rs2_ID),
    .rs1_data_ID_debug(rs1_data_ID),
    .rs2_data_ID_debug(rs2_data_ID),

    // EX
    .PC_EX_debug(PC_EX),
    .forward_A_debug(forward_A),
    .forward_B_debug(forward_B),
    .ALU_in_A_debug(ALU_in_A),
    .ALU_in_B_debug(ALU_in_B),
    .ALU_result_EX_debug(ALU_result_EX),
    .rd_EX_debug(rd_EX),
    .Branch_EX_debug(Branch_EX),

    // MEM
    .PC_MEM_debug(PC_MEM),
    .ALU_result_MEM_debug(ALU_result_MEM),
    .memory_data_MEM_debug(memory_data_MEM),
    .rd_MEM_debug(rd_MEM),
    .MemRead_MEM_debug(MemRead_MEM),
    .MemWrite_MEM_debug(MemWrite_MEM),

    // WB
    .PC_WB_debug(PC_WB),
    .ALU_result_WB_debug(ALU_result_WB),
    .memory_data_WB_debug(memory_data_WB),
    .write_data_debug(write_data),
    .rd_WB_debug(rd_WB),
    .RegWrite_WB_debug(RegWrite_WB)
);

assign led = debug_reg_out[7:0];

endmodule
