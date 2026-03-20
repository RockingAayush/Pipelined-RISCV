`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 00:58:36
// Design Name: 
// Module Name: ALU_control_unit
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


module ALU_control_unit(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7_5,   // instruction[30]
    
    output reg [3:0]ALUControl
);

always @(*) begin
    case (ALUOp)

        // Load / Store → ADD
        2'b00: ALUControl = 4'b0010;

        // Branch → SUB (for BEQ/BNE)
        2'b01: begin
            case (funct3)
                3'b000: ALUControl = 4'b0110; // BEQ
                3'b001: ALUControl = 4'b0110; // BNE
                3'b100: ALUControl = 4'b0111; // BLT
                3'b101: ALUControl = 4'b0111; // BGE
                3'b110: ALUControl = 4'b1000; // BLTU
                3'b111: ALUControl = 4'b1000; // BGEU
                default: ALUControl = 4'b0010;
            endcase
        end

        // R-type
        2'b10: begin
            case (funct3)
                3'b000: ALUControl = (funct7_5) ? 4'b0110 : 4'b0010; // SUB : ADD
                3'b111: ALUControl = 4'b0000; // AND
                3'b110: ALUControl = 4'b0001; // OR
                3'b100: ALUControl = 4'b0011; // XOR
                3'b001: ALUControl = 4'b0100; // SLL
                3'b101: ALUControl = (funct7_5) ? 4'b1101 : 4'b0101; // SRA : SRL
                3'b010: ALUControl = 4'b0111; // SLT
                3'b011: ALUControl = 4'b1000; // SLTU
                default: ALUControl = 4'b0010;
            endcase
        end

        // I-type arithmetic
        2'b11: begin
            case (funct3)
                3'b000: ALUControl = 4'b0010; // ADDI
                3'b111: ALUControl = 4'b0000; // ANDI
                3'b110: ALUControl = 4'b0001; // ORI
                3'b100: ALUControl = 4'b0011; // XORI
                3'b010: ALUControl = 4'b0111; // SLTI
                3'b011: ALUControl = 4'b1000; // SLTIU
                3'b001: ALUControl = 4'b0100; // SLLI
                3'b101: ALUControl = (funct7_5) ? 4'b1101 : 4'b0101; // SRAI : SRLI
                default: ALUControl = 4'b0010;
            endcase
        end

        default: ALUControl = 4'b0010;
    endcase
end

endmodule
