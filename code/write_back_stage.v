// Write Back stage ---------------------------------------------------------------------------------------- 
`timescale 1ns/1ps
module write_back_stage (																	   
    input        WBSel,        // 0: ALU_result , 1: MEM_Data
    input        WR,
    input [31:0] ALU_result,
    input [31:0] MEM_Data,

    output [31:0] WBData,
    output        WR_out
);
    assign WBData = (WBSel) ? MEM_Data : ALU_result;
    assign WR_out = WR;
endmodule

