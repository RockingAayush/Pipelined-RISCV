`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2026 23:23:08
// Design Name: 
// Module Name: main_control_unit
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


module main_control_unit(
    input [6:0]opcode,
    
    output reg Branch,
    output reg MemRead,
    output reg [1:0]WriteBackSel,
    output reg [1:0]ALUOp,
    output reg MemWrite,
    output reg [1:0]ALUSrcA,
    output reg ALUSrcB,
    output reg RegWrite
    );


always@(*) begin
    Branch = 0;
    MemRead = 0;
    WriteBackSel = 2'b00;
    ALUOp = 2'b00;
    MemWrite = 0;
    ALUSrcA = 2'b00;
    ALUSrcB = 0;
    RegWrite = 0;
    case(opcode)
    7'b0110011: begin  // R-type
        ALUOp = 2'b10;
        RegWrite = 1;
    end
    7'b0010011: begin  // I-type (Arithmetic)
        ALUSrcB = 1;
        ALUOp = 2'b11;
        RegWrite = 1;
    end
    7'b0000011: begin  // I-type (Load)
        ALUSrcB = 1;
        MemRead = 1;
        RegWrite = 1;
        WriteBackSel = 2'b01;
        ALUOp = 2'b00;
    end
    7'b0100011: begin  // S-type
        ALUSrcB = 1;
        MemWrite = 1;
        ALUOp = 2'b00;
    end
    7'b1100011: begin  // B-type
        Branch = 1; 
        ALUOp = 2'b01;
    end
    7'b1101111: begin  // jal
        WriteBackSel = 2'b10;
        RegWrite = 1;
    end
    7'b1100111: begin  // jalr
        WriteBackSel = 2'b10;
        RegWrite = 1;
        ALUOp = 2'b00;
        ALUSrcB = 1'b1;
    end
    7'b0110111: begin  // lui
        RegWrite = 1;
        ALUOp = 2'b00;
        ALUSrcA = 2'b10;
        ALUSrcB = 1;
        WriteBackSel = 2'b00;
    end
    7'b0010111: begin  // auipc
        RegWrite = 1;
        ALUOp = 2'b00;
        ALUSrcA = 2'b01;
        ALUSrcB = 1;
        WriteBackSel = 2'b00;
    end
    endcase
end
  
endmodule
