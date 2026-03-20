`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2026 22:15:56
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0]instruction,
    
    output reg [31:0]immediate
    );
    
always@(*) begin
    case(instruction[6:0])
    // R-Type
    7'b0110011: begin
        immediate = 32'd0;
    end
    
    // I-type
    7'b0010011, // arithmetic
    7'b0000011, // load
    7'b1100111  // jalr
    : begin
        immediate = {{20{instruction[31]}}, instruction[31:20]} ;
    end
    
    // S-type
    7'b0100011: begin
        immediate = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    end
    
    // B-type
    7'b1100011: begin
        immediate = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
    end
    
    // U-type
    7'b0110111,
    7'b0010111: begin
        immediate = {instruction[31:12],12'b0};
    end
    
    // J-type
    7'b1101111: begin
        immediate = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
    end
    
    default:
        immediate = 32'd0;
    endcase
end    
endmodule
