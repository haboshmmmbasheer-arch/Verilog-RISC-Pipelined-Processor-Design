// HAZARD UNIT ---------------------------------------------------------------------------------------		   
`timescale 1ns/1ps
module hazard_unit (
    input        MEM_Read_ex,
    input  [4:0] R_dest_ex,
    input  [4:0] Rs_id,
    input  [4:0] Rt_id,
    input        JR_id,

    output reg   stall,
    output reg   bubble_ex
);
    always @(*) begin
        stall     = 1'b0;
        bubble_ex = 1'b0;

        if (MEM_Read_ex && (R_dest_ex != 5'd0) &&
            ((R_dest_ex == Rs_id) || (R_dest_ex == Rt_id))) begin
            stall     = 1'b1;
            bubble_ex = 1'b1;
        end

        if (JR_id && MEM_Read_ex && (R_dest_ex != 5'd0) &&
            (R_dest_ex == Rs_id)) begin
            stall     = 1'b1;
            bubble_ex = 1'b1;
        end
    end
endmodule