// Immediate Extend ------------------------------------------------------------------	  
`timescale 1ns/1ps
module imm_extend (
    input  [11:0] imm12,
    input         typextend,
    output [31:0] imm_ext
);
    assign imm_ext = (typextend) ? {{20{imm12[11]}}, imm12} : {20'b0, imm12};
endmodule