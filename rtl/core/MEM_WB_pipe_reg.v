`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2026 20:37:02
// Design Name: 
// Module Name: MEM_WB_pipe_reg
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


module MEM_WB_pipe_reg(
    input Clk,
    input Reset,
    input flush,
    
    // Data Signals
    input [31:0]PC_MEM,
    input [31:0]memory_data_MEM,
    input [31:0]ALU_result_MEM,
    input [4:0]rd_MEM,
    
    // Control Signals
    // WB
    input [1:0]WriteBackSel_MEM,
    input RegWrite_MEM,
    
    // Data Signals
    output reg [31:0]PC_WB,
    output reg [31:0]memory_data_WB,
    output reg [31:0]ALU_result_WB,
    output reg [4:0]rd_WB,
    
    // WB
    output reg [1:0]WriteBackSel_WB,
    output reg RegWrite_WB
    );

always@(posedge Clk or negedge Reset) begin
    if(!Reset) begin
        PC_WB <= 32'd0;
        memory_data_WB <= 32'd0;
        ALU_result_WB <= 32'd0;
        rd_WB <= 5'd0;
        WriteBackSel_WB <= 2'd0;
        RegWrite_WB <= 1'b0; 
    end
    else if(flush) begin
        PC_WB <= 32'd0;
        memory_data_WB <= 32'd0;
        ALU_result_WB <= 32'd0;
        rd_WB <= 5'd0;
        WriteBackSel_WB <= 2'd0;
        RegWrite_WB <= 1'b0; 
    end
    else begin
        PC_WB <= PC_MEM;
        memory_data_WB <= memory_data_MEM;
        ALU_result_WB <= ALU_result_MEM;
        rd_WB <= rd_MEM;
        WriteBackSel_WB <= WriteBackSel_MEM;
        RegWrite_WB <= RegWrite_MEM; 
    end
end
endmodule
