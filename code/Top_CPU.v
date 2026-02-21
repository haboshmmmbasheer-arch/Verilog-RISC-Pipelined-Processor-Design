// ========================== TOP CPU ==========================  
`timescale 1ns/1ps
module Top_CPU(
    input clk,
    input reset
);
    reg  [31:0] PC;
    wire [31:0] PC_plus1;
    wire [31:0] inst_IF;

    assign PC_plus1 = PC + 32'd1;

    Inst_MEM IMEM (.address(PC), .inst(inst_IF));

    wire stall_hz, bubble_ex_hz;

    wire [31:0] inst_ID, npc_ID;

    fetch_decode_buffer IFID (
        .clk(clk), .reset(reset),
        .stall(stall_hz),
        .bubble(Kill_ID),
        .inst_in(inst_IF),
        .npc_in(PC_plus1),
        .inst_out(inst_ID),
        .npc_out(npc_ID)
    );

    wire [4:0]  opcode_ID, Rs_ID, Rt_ID, Rd_ID, Rp_ID;
    wire [11:0] imm12_ID;

    wire        Psel_ID;
    wire [2:0]  AluSel_ID;
    wire        WB_ID, MEM_Write_ID, MEM_Read_ID, typextend_ID;
    wire        Sel_input2_ID,  Sel_Dest_ID, PCNop_ID;
    wire        J_ID, JR_ID, CALL_ID;
    wire        WR_final_ID;
    wire [31:0] BusY_ID, BusZ_ID, Busp_ID;
    wire        RpVal_ID;

    wire [31:0] imm_ext_ID;
    imm_extend IMMEXT (.imm12(imm12_ID), .typextend(typextend_ID), .imm_ext(imm_ext_ID));

    wire [4:0]  R_dest_WBbuf;
    wire [31:0] WBData_normal;
    wire        WR_normal;

    wire [4:0]  R_dest_WB_final;
    wire [31:0] WBData_WB_final;
    wire        WR_WB_final;

    decode_stage IDSTG (
        .clk(clk),
        .pc_value(PC),                 
        .inst_ID(inst_ID),
        .R_dest_WB(R_dest_WB_final),
        .WBData(WBData_WB_final),
        .WR_WB(WR_WB_final),

        .Psel(Psel_ID),
        .AluSel(AluSel_ID),
        .WB(WB_ID),
        .MEM_Write(MEM_Write_ID),
        .MEM_Read(MEM_Read_ID),
        .typextend(typextend_ID),
        .Sel_input2(Sel_input2_ID),
        .Sel_Dest(Sel_Dest_ID),
        .PCNop(PCNop_ID),
        .J(J_ID),
        .JR(JR_ID),
        .CALL(CALL_ID),
        .WR_final(WR_final_ID),
        .BusY(BusY_ID),
        .BusZ(BusZ_ID),
        .Busp(Busp_ID),
        .Rs(Rs_ID),
        .Rt(Rt_ID),
        .Rd(Rd_ID),
        .Rp(Rp_ID),
        .imm12(imm12_ID),
        .opcode(opcode_ID),
        .RpVal(RpVal_ID)
    );

    wire [1:0] pcSrc_ID;
    wire       Kill_ID;

    pc_control_unit PCCU (
        .J(J_ID),
        .JR(JR_ID),
        .CALL(CALL_ID),
        .pred_ok(RpVal_ID),
        .pcSrc(pcSrc_ID),
        .Kill(Kill_ID)
    );

    wire [21:0] off22_ID = inst_ID[21:0];
    wire [31:0] pc_ID = npc_ID - 32'd1;
    wire [31:0] jump_off_ID = {{10{off22_ID[21]}}, off22_ID};
    wire [31:0] pc_jump_target_ID = pc_ID + jump_off_ID;
    wire [31:0] pc_jr_target_ID   = BusY_ID;

    wire [31:0] PC_next =
        (pcSrc_ID == 2'b00) ? PC_plus1 :
        (pcSrc_ID == 2'b01) ? pc_jump_target_ID :
        (pcSrc_ID == 2'b10) ? pc_jr_target_ID :
                              PC_plus1;

    // ID/EX
    wire        Psel_EX;
    wire [2:0]  AluSel_EX;
    wire        WB_EX, MEM_Write_EX, MEM_Read_EX, typextend_EX;
    wire        Sel_input2_EX,  Sel_Dest_EX, PCNop_EX;
    wire        J_EX, JR_EX, CALL_EX;
    wire        RpVal_EX;
    wire [31:0] BusY_EX, BusZ_EX, Busp_EX, imm_ext_EX, npc_EX;
    wire [4:0]  Rs_EX, Rt_EX, Rd_EX, Rp_EX;

    decode_execute_buffer IDEX (
        .clk(clk),
        .stall(1'b0),
        .bubble(bubble_ex_hz),

        .Psel_in(Psel_ID),
        .AluSel_in(AluSel_ID),
        .WB_in(WB_ID & RpVal_ID),
        .MEM_Write_in(MEM_Write_ID & RpVal_ID),
        .MEM_Read_in(MEM_Read_ID & RpVal_ID),
        .typextend_in(typextend_ID),
        .Sel_input2_in(Sel_input2_ID),
        .Sel_Dest_in(Sel_Dest_ID),
        .PCNop_in(PCNop_ID),
        .J_in(J_ID),
        .JR_in(JR_ID),
        .CALL_in(CALL_ID),

        .RpVal_in(RpVal_ID),

        .BusY_in(BusY_ID),
        .BusZ_in(BusZ_ID),
        .Busp_in(Busp_ID),
        .imm_ext_in(imm_ext_ID),
        .npc_in(npc_ID),

        .Rs_in(Rs_ID),
        .Rt_in(Rt_ID),
        .Rd_in(Rd_ID),
        .Rp_in(Rp_ID),

        .Psel(Psel_EX),
        .AluSel(AluSel_EX),
        .WB(WB_EX),
        .MEM_Write(MEM_Write_EX),
        .MEM_Read(MEM_Read_EX),
        .typextend(typextend_EX),
        .Sel_input2(Sel_input2_EX),
        .Sel_Dest(Sel_Dest_EX),
        .PCNop(PCNop_EX),
        .J(J_EX),
        .JR(JR_EX),
        .CALL(CALL_EX),

        .RpVal(RpVal_EX),

        .BusY(BusY_EX),
        .BusZ(BusZ_EX),
        .Busp(Busp_EX),
        .imm_ext(imm_ext_EX),
        .npc(npc_EX),

        .Rs(Rs_EX),
        .Rt(Rt_EX),
        .Rd(Rd_EX),
        .Rp(Rp_EX)
    );

    hazard_unit HZ (
        .MEM_Read_ex(MEM_Read_EX),
        .R_dest_ex( Rd_EX ),
        .Rs_id(Rs_ID),
        .Rt_id(Rt_ID),
        .JR_id(JR_ID),
        .stall(stall_hz),
        .bubble_ex(bubble_ex_hz)
    );

    // EX stage with forwarding
    wire        WB_MEM, MEM_Read_MEM, MEM_Write_MEM, CALL_MEM;
    wire [31:0] npc_MEM;
    wire [31:0] ALU_result_MEM, Reg2_MEM;
    wire [4:0]  R_dest_MEM;

    wire        WB_WBbuf, MEM_Read_WBbuf, CALL_WBbuf;
    wire [31:0] npc_WBbuf;
    wire [31:0] MEM_Data_WBbuf, ALU_result_WBbuf;

    wire [1:0] ForwardA, ForwardB, ForwardStore;

    forward_unit FWD (
        .Rs_ex(Rs_EX),
        .Rt_ex(Rt_EX),
        .WB_mem(WB_MEM),
        .R_dest_mem(R_dest_MEM),
        .WB_wb(WR_WB_final),
        .R_dest_wb(R_dest_WB_final),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .ForwardStore(ForwardStore)
    );

    wire [31:0] MEM_Data_MEM;

    wire [31:0] fwd_from_wb = WBData_WB_final;
    wire [31:0] fwd_from_mem = (MEM_Read_MEM) ? MEM_Data_MEM : ALU_result_MEM;

    wire [31:0] BusY_EX_fwd =
        (ForwardA == 2'b10) ? fwd_from_mem :
        (ForwardA == 2'b01) ? fwd_from_wb  :
                              BusY_EX;

    wire [31:0] BusZ_EX_fwd =
        (ForwardB == 2'b10) ? fwd_from_mem :
        (ForwardB == 2'b01) ? fwd_from_wb  :
                              BusZ_EX;

    wire [31:0] Store_EX_fwd =
        (ForwardStore == 2'b10) ? fwd_from_mem :
        (ForwardStore == 2'b01) ? fwd_from_wb  :
                                  BusZ_EX;

    wire [31:0] ALU_result_EX, Reg2_EX;
    wire [4:0]  R_dest_EX;

    execute_stage EXSTG (
        .BusY(BusY_EX_fwd),
        .BusZ(BusZ_EX_fwd),
        .imm_ext(imm_ext_EX),
        .Sel_input2(Sel_input2_EX),
        .AluSel(AluSel_EX),
        .Rd(Rd_EX),
        .Rt(Rt_EX),
        .Sel_Dest(Sel_Dest_EX),
        .ALU_result(ALU_result_EX),
        .Reg2_out(Reg2_EX),
        .R_dest_exec(R_dest_EX)
    );

    execute_memory_buffer EXMEM (
        .clk(clk),
        .stall(1'b0),
        .bubble(1'b0),
        .WB_in(WB_EX),
        .MEM_Read_in(MEM_Read_EX),
        .MEM_Write_in(MEM_Write_EX),
        .CALL_in(CALL_EX & RpVal_EX),
        .npc_in(npc_EX),
        .ALU_result_in(ALU_result_EX),
        .Reg2_in(Store_EX_fwd),
        .R_dest_in(R_dest_EX),
        .WB(WB_MEM),
        .MEM_Read(MEM_Read_MEM),
        .MEM_Write(MEM_Write_MEM),
        .CALL(CALL_MEM),
        .npc(npc_MEM),
        .ALU_result(ALU_result_MEM),
        .Reg2(Reg2_MEM),
        .R_dest(R_dest_MEM)
		
    );

    memory_stage MEMSTG (
        .clk(clk),
        .MEM_Read(MEM_Read_MEM),
        .MEM_Write(MEM_Write_MEM),
        .ALU_result(ALU_result_MEM),
        .Reg2(Reg2_MEM),
        .MEM_Data(MEM_Data_MEM)
    );

    memory_writeback_buffer MEMWB (
        .clk(clk),
        .stall(1'b0),
        .bubble(1'b0),
        .WB_in(WB_MEM),
        .MEM_Read_in(MEM_Read_MEM),
        .CALL_in(CALL_MEM),
        .npc_in(npc_MEM),
        .MEM_Data_in(MEM_Data_MEM),
        .ALU_result_in(ALU_result_MEM),
        .R_dest_in(R_dest_MEM),
        .WB(WB_WBbuf),
        .MEM_Read(MEM_Read_WBbuf),
        .CALL(CALL_WBbuf),
        .npc(npc_WBbuf),
        .MEM_Data(MEM_Data_WBbuf),
        .ALU_result(ALU_result_WBbuf),
        .R_dest(R_dest_WBbuf)
    );

    write_back_stage WBSTG (
        .WBSel(MEM_Read_WBbuf),
        .WR(WB_WBbuf),
        .ALU_result(ALU_result_WBbuf),
        .MEM_Data(MEM_Data_WBbuf),
        .WBData(WBData_normal),
        .WR_out(WR_normal)
    );

    assign WBData_WB_final = (CALL_WBbuf) ? npc_WBbuf : WBData_normal;
    assign WR_WB_final     = (CALL_WBbuf) ? 1'b1     : WR_normal;
    assign R_dest_WB_final = (CALL_WBbuf) ? 5'd31    : R_dest_WBbuf;

    always @(posedge clk or posedge reset) begin
        if (reset)      PC <= 32'b0;
        else if (stall_hz) PC <= PC;
        else            PC <= PC_next;
    end
endmodule
