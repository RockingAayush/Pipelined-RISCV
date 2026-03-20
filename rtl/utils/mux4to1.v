`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 18:52:01
// Design Name: 
// Module Name: mux4to1
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


module mux4to1 #(
    parameter WIDTH = 32
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [WIDTH-1:0] c,
    input  [WIDTH-1:0] d,
    input  [1:0]sel,
    
    output [WIDTH-1:0] y
);

assign y = (sel == 2'b00) ? a :
           (sel == 2'b01) ? b :
           (sel == 2'b10) ? c :
                            d;
                            
endmodule
