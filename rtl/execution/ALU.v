`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 00:35:37
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    
    output reg [31:0] Result,
    output Zero,
    output Less,
    output LessU
    );

always @(*) begin
    case (ALUControl)
        4'b0000: Result = A & B;
        4'b0001: Result = A | B;
        4'b0010: Result = A + B;
        4'b0110: Result = A - B;
        4'b0011: Result = A ^ B;
        4'b0100: Result = A << B[4:0];
        4'b0101: Result = A >> B[4:0];
        4'b1101: Result = $signed(A) >>> B[4:0];
        4'b0111: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
        4'b1000: Result = (A < B) ? 32'd1 : 32'd0;
        default: Result = 32'd0;
    endcase
end
assign Zero = (Result == 32'd0);
assign Less = ($signed(A) < $signed(B));
assign LessU = (A < B);   
endmodule
