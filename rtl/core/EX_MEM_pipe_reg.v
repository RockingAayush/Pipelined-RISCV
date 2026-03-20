`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2026 17:13:42
// Design Name: 
// Module Name: EX_MEM_pipe_reg
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


module EX_MEM_pipe_reg(
    input Clk,
    input Reset,
    input flush,
    
    // Data
    input [2:0]funct3_EX,
    input [31:0]ALU_result_EX,
    input [31:0]rs2_data_EX,
    input [4:0]rd_EX,
    input [31:0] PC_EX,
    
    //Control
    // MEM
    input MemRead_EX,
    input MemWrite_EX,
    
    // WB
    input [1:0]WriteBackSel_EX,
    input RegWrite_EX,
    
    // Data
    output reg [2:0]funct3_MEM,
    output reg [31:0]ALU_result_MEM,
    output reg [31:0]rs2_data_MEM,
    output reg [4:0]rd_MEM,
    output reg [31:0] PC_MEM,
    
    //Control
    // MEM
    output reg MemRead_MEM,
    output reg MemWrite_MEM,
    
    // WB
    output reg [1:0]WriteBackSel_MEM,
    output reg RegWrite_MEM
    );


always@(posedge Clk or negedge Reset) begin
    if(!Reset) begin
        PC_MEM <= 32'd0;
        funct3_MEM <= 3'd0;
        ALU_result_MEM <= 32'd0;
        rs2_data_MEM <= 32'd0;
        rd_MEM <= 5'd0;
        MemRead_MEM <= 1'b0;
        MemWrite_MEM <= 1'b0;
        WriteBackSel_MEM <= 2'd0;
        RegWrite_MEM <= 1'b0; 
    end
    
    else if(flush) begin
        PC_MEM <= 32'd0;
        funct3_MEM <= 3'd0;
        ALU_result_MEM <= 32'd0;
        rs2_data_MEM <= 32'd0;
        rd_MEM <= 5'd0;
        MemRead_MEM <= 1'b0;
        MemWrite_MEM <= 1'b0;
        WriteBackSel_MEM <= 2'd0;
        RegWrite_MEM <= 1'b0;
    end
    
    else begin
        PC_MEM <= PC_EX;
        funct3_MEM <= funct3_EX;
        ALU_result_MEM <= ALU_result_EX;
        rs2_data_MEM <= rs2_data_EX;
        rd_MEM <= rd_EX;
        MemRead_MEM <= MemRead_EX;
        MemWrite_MEM <= MemWrite_EX;
        WriteBackSel_MEM <= WriteBackSel_EX;
        RegWrite_MEM <= RegWrite_EX; 
    end
end        
endmodule
