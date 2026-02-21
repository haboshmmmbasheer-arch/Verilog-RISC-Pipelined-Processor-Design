// ALU (Arithmetic Logic Unit)
// -----------------------------------------------------------------------------
// This module performs arithmetic and logical operations based on the ALU
// control signal (op).
// -----------------------------------------------------------------------------
`timescale 1ns/1ps
module ALU_module (
    input  [31:0] a, // First operand
    input  [31:0] b, // Second operand
    input  [2:0]  op, // ALU operation select
    output reg [31:0] out // ALU result
);
 // Combinational ALU logic
    always @(*) begin
        case (op)
            3'b000: out = ~(a | b);   // NOR / NORI
            3'b001: out =  a & b;     // AND / ANDI
            3'b010: out =  a | b;     // OR  / ORI
            3'b011: out =  a - b;     // SUB
            3'b100: out =  a + b;     // ADD / ADDI
            default: out = 32'b0;
        endcase
    end
endmodule