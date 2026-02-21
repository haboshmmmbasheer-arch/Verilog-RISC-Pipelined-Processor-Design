// Execute stage ---------------------------------------------------------------------------------------- 
`timescale 1ns/1ps
module execute_stage (
    input [31:0] BusY,
    input [31:0] BusZ,
    input [31:0] imm_ext,

    input        Sel_input2,
    input [2:0]  AluSel,

    input [4:0]  Rd,
    input [4:0]  Rt,
    input        Sel_Dest,

    output [31:0] ALU_result,
    output [31:0] Reg2_out,
    output [4:0]  R_dest_exec
);
    wire [31:0] ALU_in2 = (Sel_input2) ? imm_ext : BusZ;

    ALU_module ALU (
        .a(BusY),
        .b(ALU_in2),
        .op(AluSel),
        .out(ALU_result)
    );

    assign Reg2_out = BusZ;
    assign R_dest_exec = (Sel_Dest) ? Rt : Rd;
endmodule