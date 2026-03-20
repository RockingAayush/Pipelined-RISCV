`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2026 16:17:18
// Design Name: 
// Module Name: ID_EX_pipe_reg
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


module ID_EX_pipe_reg(
    input Clk,
    input Reset,
    input flush,
    
    // Data
    input [31:0]PC_ID,
    input [6:0]opcode_ID,
    input [31:0]rs1_data_ID,
    input [31:0]rs2_data_ID,
    input [31:0]immediate_ID,
    input [4:0]rs1_ID,
    input [4:0]rs2_ID,
    input [4:0]rd_ID,
    input [2:0]funct3_ID,
    input [6:0]funct7_ID,
     
    // Control signals
    // EX
    input [1:0]ALUOp_ID,
    input [1:0]ALUSrcA_ID,
    input ALUSrcB_ID,
    input Branch_ID,
    
    // MEM
    input MemRead_ID,
    input MemWrite_ID,
    
    // WB
    input [1:0]WriteBackSel_ID,
    input RegWrite_ID,
    
    // Data
    output reg [31:0]PC_EX,
    output reg [6:0] opcode_EX,
    output reg [31:0]rs1_data_EX,
    output reg [31:0]rs2_data_EX,
    output reg [31:0]immediate_EX,
    output reg [4:0]rs1_EX,
    output reg [4:0]rs2_EX,
    output reg [4:0]rd_EX,
    output reg [2:0]funct3_EX,
    output reg [6:0]funct7_EX,
    
    // Control signals
    // EX
    output reg [1:0]ALUOp_EX,
    output reg [1:0]ALUSrcA_EX,
    output reg ALUSrcB_EX,
    output reg Branch_EX,
    
    // MEM
    output reg MemRead_EX,
    output reg MemWrite_EX,
    
    // WB
    output reg [1:0]WriteBackSel_EX,
    output reg RegWrite_EX
    );

always@(posedge Clk or negedge Reset) begin
    if(!Reset) begin
        PC_EX <= 32'd0;
        opcode_EX <= 7'd0;
        rs1_data_EX <= 32'd0;
        rs2_data_EX <= 32'd0;
        immediate_EX <= 32'd0;
        rs1_EX <= 5'd0;
        rs2_EX <= 5'd0;
        rd_EX <= 5'd0;
        funct3_EX <= 3'd0;
        funct7_EX <= 7'd0;
        ALUOp_EX <= 2'd0;
        ALUSrcA_EX <= 2'd0;
        ALUSrcB_EX <= 1'b0;
        Branch_EX <= 1'b0;
        MemRead_EX <= 1'b0;
        MemWrite_EX <= 1'b0;
        WriteBackSel_EX <= 2'd0;
        RegWrite_EX <= 1'b0;
    end
    
    else if(flush) begin
        opcode_EX <= 7'd0;
        ALUOp_EX <= 2'd0;
        ALUSrcA_EX <= 2'd0;
        ALUSrcB_EX <= 1'b0;
        Branch_EX <= 1'b0;    
        MemRead_EX <= 1'b0;
        MemWrite_EX <= 1'b0;
    
        WriteBackSel_EX <= 2'd0;
        RegWrite_EX <= 1'b0;
    end
    
    else begin
        PC_EX <= PC_ID;
        opcode_EX <= opcode_ID;
        rs1_data_EX <= rs1_data_ID;
        rs2_data_EX <= rs2_data_ID;
        immediate_EX <= immediate_ID;
        rs1_EX <= rs1_ID;
        rs2_EX <= rs2_ID;
        rd_EX <= rd_ID;
        funct3_EX <= funct3_ID;
        funct7_EX <= funct7_ID;
        ALUOp_EX <= ALUOp_ID;
        ALUSrcA_EX <= ALUSrcA_ID;
        ALUSrcB_EX <= ALUSrcB_ID;
        Branch_EX <= Branch_ID;
        MemRead_EX <= MemRead_ID;
        MemWrite_EX <= MemWrite_ID;
        WriteBackSel_EX <= WriteBackSel_ID;  
        RegWrite_EX <= RegWrite_ID;  
    end
end    
endmodule
