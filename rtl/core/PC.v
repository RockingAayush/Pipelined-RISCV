`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 23:28:06
// Design Name: 
// Module Name: PC
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


module PC(
    input [31:0]PC_in,
    input Clk,
    input Reset,
    input PCWrite,
    
    output reg [31:0]PC_out
    );

always@(posedge Clk or negedge Reset) begin
    if(!Reset) begin
        PC_out <= 32'h00000000;
    end else if(PCWrite) begin
        PC_out <= PC_in;
    end
end
    
endmodule
