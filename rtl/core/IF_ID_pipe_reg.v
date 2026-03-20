`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2026 15:53:55
// Design Name: 
// Module Name: IF_ID_pipe_reg
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


module IF_ID_pipe_reg(
    input Clk,
    input Reset,
    input flush,
    input [31:0]PC_IF,
    input [31:0]IR_IF, 
    input IF_ID_Write,
    
    output reg [31:0]PC_ID,
    output reg [31:0]IR_ID
    );

always@(posedge Clk or negedge Reset) begin
    if(!Reset) begin
        PC_ID <= 32'd0;
        IR_ID <= 32'd0;
    end
    
    else if(flush) begin          // Insert NOPs
        PC_ID <= 32'd0;     
        IR_ID <= 32'd0;
    end
     
    else if(IF_ID_Write) begin
        PC_ID <= PC_IF;
        IR_ID <= IR_IF;
    end 
    
end    
endmodule
