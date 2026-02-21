// Decode Stage-----------------------------------------------------------------------------------	   
`timescale 1ns/1ps
module decode_stage (
    input         clk,
    input  [31:0] pc_value,    
    input  [31:0] inst_ID,
    input  [4:0]  R_dest_WB,
    input  [31:0] WBData,
    input         WR_WB,

    output  [1:0] Psel,
    output [2:0]  AluSel,
    output  WB,
    output MEM_Write,
    output MEM_Read,
    output typextend,
    output Sel_input2,
    output Sel_Dest,
    output  PCNop,
    output J,
    output  JR,
    output  CALL,
    output WR_final,
    output [31:0] BusY,
    output [31:0] BusZ,
    output [31:0] Busp,
    output [4:0]  Rs,
    output [4:0]  Rt,
    output [4:0]  Rd,
    output [4:0]  Rp,
    output [11:0] imm12,
    output [4:0]  opcode,
    output        RpVal
);
    wire [2:0] Aluop;
    wire WR_raw;

    // extraction
    assign opcode = inst_ID[31:27];
    assign Rp     = inst_ID[26:22];
    assign Rd     = inst_ID[21:17];
    assign Rs     = inst_ID[16:12];
    assign Rt     = inst_ID[11:7];
    assign imm12  = inst_ID[11:0];

    control_unit CU (
        .opcode(opcode),
        .Psel(Psel),
        .Aluop(Aluop),
        .WB(WB),
        .MEM_Write(MEM_Write),
        .MEM_Read(MEM_Read),
        .typextend(typextend),
        .Sel_input2(Sel_input2),
        .WR(WR_raw),
        .Sel_Dest(Sel_Dest),
        .PCNop(PCNop),
        .J(J),
        .JR(JR),
        .CALL(CALL)
    );

    assign AluSel = Aluop;

    // predicate: execute if Rp==R0 OR Reg[Rp]!=0
    assign RpVal = (Rp == 5'd0) || (Busp != 32'b0);

    // control for “this instruction executes”
    assign WR_final = WB & RpVal;

    // Register file with Sel_source2 + PC mirror
    reg_file RF (
        .clk(clk),
        .pc_value(pc_value),
        .Rs(Rs),
        .Rt(Rt),
        .Rd(Rd),
        .isStore(MEM_Write),
        .Rp(Rp),
        .R_dest(R_dest_WB),
        .WBData(WBData),
        .WR(WR_WB),
        .BusY(BusY),
        .BusZ(BusZ),
        .Busp(Busp)
    );
endmodule
