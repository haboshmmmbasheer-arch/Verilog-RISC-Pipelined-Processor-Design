
`timescale 1ns/1ps
module decode_execute_buffer (
    input clk,
    input stall,
    input bubble,

    input  [1:0]      Psel_in,
    input [2:0]  AluSel_in,
    input        WB_in,
    input        MEM_Write_in,
    input        MEM_Read_in,
    input        typextend_in,
    input        Sel_input2_in,
    input        Sel_Dest_in,
    input        PCNop_in,
    input        J_in,
    input        JR_in,
    input        CALL_in,

    input        RpVal_in,

    input [31:0] BusY_in,
    input [31:0] BusZ_in,
    input [31:0] Busp_in,
    input [31:0] imm_ext_in,

    input [31:0] npc_in,

    input [4:0]  Rs_in,
    input [4:0]  Rt_in,
    input [4:0]  Rd_in,
    input [4:0]  Rp_in,

    output reg        Psel,
    output reg [2:0]  AluSel,
    output reg        WB,
    output reg        MEM_Write,
    output reg        MEM_Read,
    output reg        typextend,
    output reg        Sel_input2,
    output reg        Sel_Dest,
    output reg        PCNop,
    output reg        J,
    output reg        JR,
    output reg        CALL,

    output reg        RpVal,

    output reg [31:0] BusY,
    output reg [31:0] BusZ,
    output reg [31:0] Busp,
    output reg [31:0] imm_ext,

    output reg [31:0] npc,

    output reg [4:0]  Rs,
    output reg [4:0]  Rt,
    output reg [4:0]  Rd,
    output reg [4:0]  Rp
);
    always @(posedge clk) begin
        if (stall) begin
            // hold
        end
        else if (bubble) begin
            Psel        <= 2'b00;
            AluSel      <= 3'b000;
            WB          <= 1'b0;
            MEM_Write   <= 1'b0;
            MEM_Read    <= 1'b0;
            typextend   <= 1'b0;
            Sel_input2  <= 1'b0;
            Sel_Dest    <= 1'b0;
            PCNop       <= 1'b0;
            J           <= 1'b0;
            JR          <= 1'b0;
            CALL        <= 1'b0;
            RpVal       <= 1'b0;

            BusY        <= 32'b0;
            BusZ        <= 32'b0;
            Busp        <= 32'b0;
            imm_ext     <= 32'b0;
            npc         <= 32'b0;

            Rs          <= 5'b0;
            Rt          <= 5'b0;
            Rd          <= 5'b0;
            Rp          <= 5'b0;
        end
        else begin
            Psel        <= Psel_in;
            AluSel      <= AluSel_in;
            WB          <= WB_in;
            MEM_Write   <= MEM_Write_in;
            MEM_Read    <= MEM_Read_in;
            typextend   <= typextend_in;
            Sel_input2  <= Sel_input2_in;
            Sel_Dest    <= Sel_Dest_in;
            PCNop       <= PCNop_in;
            J           <= J_in;
            JR          <= JR_in;
            CALL        <= CALL_in;
            RpVal       <= RpVal_in;

            BusY        <= BusY_in;
            BusZ        <= BusZ_in;
            Busp        <= Busp_in;
            imm_ext     <= imm_ext_in;
            npc         <= npc_in;

            Rs          <= Rs_in;
            Rt          <= Rt_in;
            Rd          <= Rd_in;
            Rp          <= Rp_in;
        end
    end
endmodule
