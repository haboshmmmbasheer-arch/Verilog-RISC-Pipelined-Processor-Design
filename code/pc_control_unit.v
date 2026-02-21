 // PC Control Unit  --------------------------------------------------------------------		
 `timescale 1ns/1ps
module pc_control_unit (
    input  J,
    input  JR,
    input  CALL,
    input  pred_ok,
    output reg [1:0] pcSrc,  // 00: PC+1, 01: PC+offset, 10: JR
    output reg  Kill
);
    always @(*) begin
        pcSrc = 2'b00; // PC + 1
        Kill  = 1'b0;
        if (pred_ok) begin
            if (JR) begin
                pcSrc = 2'b10; // JR
                Kill  = 1'b1;
            end
            else if (J || CALL) begin
                pcSrc = 2'b01; // Jump / Call
                Kill  = 1'b1;
            end
        end
    end
endmodule