`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 20:37:20
// Design Name: 
// Module Name: instruction_mem
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


module instruction_mem(
    input  [31:0] read_addr,
    output [31:0] instruction
);

reg [31:0] instruction_reg [0:255];

initial begin
    $readmemh("program.mem", instruction_reg);
end

assign instruction = instruction_reg[read_addr[31:2]];

endmodule
