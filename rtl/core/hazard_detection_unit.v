`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2026 21:35:18
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    input [4:0]rs1_ID,
    input [4:0]rs2_ID,
    input [4:0]rd_EX,
    input MemRead_EX,
    
    output PCWrite,
    output IF_ID_Write,
    output ID_EX_flush
    );

wire load_use_hazard;
assign load_use_hazard = (MemRead_EX) &&
                         (rd_EX != 5'd0) &&   
                         ((rd_EX == rs1_ID) || (rd_EX == rs2_ID));
         
assign PCWrite = ~load_use_hazard;
assign IF_ID_Write = ~load_use_hazard;  
assign ID_EX_flush = load_use_hazard;

endmodule
