// MEM/WB buffer--------------------------------------------------------------------------------------			  
`timescale 1ns/1ps
module memory_writeback_buffer (
    input clk,
    input stall,
    input bubble,

    input        WB_in,
    input        MEM_Read_in,
    input        CALL_in,
    input [31:0] npc_in,

    input [31:0] MEM_Data_in,
    input [31:0] ALU_result_in,
    input [4:0]  R_dest_in,

    output reg        WB,
    output reg        MEM_Read,
    output reg        CALL,
    output reg [31:0] npc,

    output reg [31:0] MEM_Data,
    output reg [31:0] ALU_result,
    output reg [4:0]  R_dest
);
    always @(posedge clk) begin
        if (stall) begin
            // hold
        end
        else if (bubble) begin
            WB         <= 1'b0;
            MEM_Read   <= 1'b0;
            CALL       <= 1'b0;
            npc        <= 32'b0;
            MEM_Data   <= 32'b0;
            ALU_result <= 32'b0;
            R_dest     <= 5'b0;
        end
        else begin
            WB         <= WB_in;
            MEM_Read   <= MEM_Read_in;
            CALL       <= CALL_in;
            npc        <= npc_in;
            MEM_Data   <= MEM_Data_in;
            ALU_result <= ALU_result_in;
            R_dest     <= R_dest_in;
        end
    end
endmodule
