`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2026 00:55:42
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input [4:0] rs1_EX,
    input [4:0] rs2_EX,
    input [4:0] rd_MEM,
    input [4:0] rd_WB,
    input RegWrite_MEM,
    input RegWrite_WB,
    
    output [1:0] forward_A,
    output [1:0] forward_B
);

assign forward_A =
    (RegWrite_MEM && (rd_MEM != 0) && (rd_MEM == rs1_EX)) ? 2'b10 :
    (RegWrite_WB && (rd_WB != 0) &&
     !(RegWrite_MEM && (rd_MEM != 0) && (rd_MEM == rs1_EX)) &&
     (rd_WB == rs1_EX)) ? 2'b01 :
    2'b00;

assign forward_B =
    (RegWrite_MEM && (rd_MEM != 0) && (rd_MEM == rs2_EX)) ? 2'b10 :
    (RegWrite_WB && (rd_WB != 0) &&
     !(RegWrite_MEM && (rd_MEM != 0) && (rd_MEM == rs2_EX)) &&
     (rd_WB == rs2_EX)) ? 2'b01 :
    2'b00;

endmodule
