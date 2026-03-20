`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2026 20:08:59
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input Clk,
    input [31:0] address,
    input [31:0] write_data,
    input [2:0] funct3,
    input MemWrite,
    input MemRead,
    
    output reg [31:0]ReadData
    );

reg [31:0] memory [1023:0];
initial begin
    $readmemh("data.mem",memory);
end

// Read
wire [31:0] word;
wire [1:0] byte_offset;

assign word = memory[address[11:2]];
assign byte_offset = address[1:0];

always@(*) begin
    if(MemRead) begin
        case(funct3) 
            3'b000: begin   // LB
                case(byte_offset)
                    2'b00: ReadData = {{24{word[7]}},word[7:0]};
                    2'b01: ReadData = {{24{word[15]}},word[15:8]};
                    2'b10: ReadData = {{24{word[23]}},word[23:16]};
                    2'b11: ReadData = {{24{word[31]}},word[31:24]};
                endcase
            end
            3'b001: begin   // LH
                if(byte_offset[1] == 0) begin
                    ReadData = {{16{word[15]}},word[15:0]};
                end else begin
                    ReadData = {{16{word[31]}},word[31:16]};
                end
            end
            3'b010: begin   // LW
                ReadData = word;
            end
            3'b100: begin   // LBU
                case(byte_offset)
                    2'b00: ReadData = {24'b0,word[7:0]};
                    2'b01: ReadData = {24'b0,word[15:8]};
                    2'b10: ReadData = {24'b0,word[23:16]};
                    2'b11: ReadData = {24'b0,word[31:24]};
                endcase
            end
            3'b101: begin  // LHU
                if(byte_offset[1] == 0) begin
                    ReadData = {16'b0,word[15:0]};
                end else begin
                    ReadData = {16'b0,word[31:16]};
                end
            end
            default: ReadData = 32'd0;
        endcase
    end else begin
        ReadData = 32'd0;
    end        
end

// Write 
always@(posedge Clk) begin
    if(MemWrite) begin
        case(funct3)
            3'b000: begin  // SB
                case(byte_offset)
                    2'b00: memory[address[11:2]] <= {word[31:8],write_data[7:0]};
                    2'b01: memory[address[11:2]] <= {word[31:16],write_data[7:0],word[7:0]};
                    2'b10: memory[address[11:2]] <= {word[31:24],write_data[7:0],word[15:0]};
                    2'b11: memory[address[11:2]] <= {write_data[7:0],word[23:0]};
                endcase 
            end
            3'b001: begin  // SH
                if(byte_offset[1] == 0) begin
                    memory[address[11:2]] <= {word[31:16],write_data[15:0]};
                end else begin
                    memory[address[11:2]] <= {write_data[15:0],word[15:0]};
                end
            end
            3'b010: begin  // SW
                memory[address[11:2]] <= write_data; 
            end
            default:;
        endcase 
    end
end 
endmodule
