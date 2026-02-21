// FORWARD UNIT-------------------------------------------------------------------------------------   
`timescale 1ns/1ps
module forward_unit (
    input  [4:0] Rs_ex,
    input  [4:0] Rt_ex,

    input        WB_mem,
    input  [4:0] R_dest_mem,

    input        WB_wb,
    input  [4:0] R_dest_wb,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,
    output reg [1:0] ForwardStore
);
    always @(*) begin
        ForwardA     = 2'b00;
        ForwardB     = 2'b00;
        ForwardStore = 2'b00;

        if (WB_mem && (R_dest_mem != 5'd0) && (R_dest_mem == Rs_ex))
            ForwardA = 2'b10;

        if (WB_mem && (R_dest_mem != 5'd0) && (R_dest_mem == Rt_ex))
            ForwardB = 2'b10;

        if (WB_wb && (R_dest_wb != 5'd0) &&
            !(WB_mem && (R_dest_mem != 5'd0) && (R_dest_mem == Rs_ex)) &&
            (R_dest_wb == Rs_ex))
            ForwardA = 2'b01;

        if (WB_wb && (R_dest_wb != 5'd0) &&
            !(WB_mem && (R_dest_mem != 5'd0) && (R_dest_mem == Rt_ex)) &&
            (R_dest_wb == Rt_ex))
            ForwardB = 2'b01;

        if (WB_mem && (R_dest_mem != 5'd0) && (R_dest_mem == Rt_ex))
            ForwardStore = 2'b10;
        else if (WB_wb && (R_dest_wb != 5'd0) && (R_dest_wb == Rt_ex))
            ForwardStore = 2'b01;
    end
endmodule
