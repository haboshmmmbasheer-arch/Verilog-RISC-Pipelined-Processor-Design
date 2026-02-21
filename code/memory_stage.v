// Memory stage -------------------------------------------------------------------------------------	   
`timescale 1ns/1ps
module memory_stage (
    input clk,

    input  MEM_Read,
    input  MEM_Write,
    input [31:0] ALU_result,   // address (word index)
    input [31:0] Reg2,         // store data

    output reg [31:0] MEM_Data
);
    reg [31:0] DATA_MEM [0:255];

    always @(posedge clk) begin
        if (MEM_Write) begin
            DATA_MEM[ALU_result[7:0]] <= Reg2;
        end
    end

    always @(*) begin
        if (MEM_Read)
            MEM_Data = DATA_MEM[ALU_result[7:0]];
        else
            MEM_Data = 32'b0;
    end
endmodule
