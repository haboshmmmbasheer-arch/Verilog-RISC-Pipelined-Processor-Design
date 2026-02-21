// This module generates all control signals based on the instruction opcode.
// A ROM-based control approach is used, where each opcode maps to a fixed
// set of control signals loaded from an external file.
// -----------------------------------------------------------------------------		   
`timescale 1ns/1ps
module control_unit (
    input  [4:0] opcode,   // inst[31:27]

    output reg   [1:0]     Psel,
    output reg [2:0]  Aluop,
    output reg        WB,
    output reg        MEM_Write,
    output reg        MEM_Read,
    output reg        typextend,
    output reg        Sel_input2,
    output reg        WR,            // Reg_Write (raw)
    output reg        Sel_Dest,
    output reg        PCNop,
    output reg        J,
    output reg        JR,
    output reg        CALL
);
    reg [15:0] ROM [0:31];

 initial begin
  $readmemh("SignalsFile.txt", ROM);

end

// Decode control signals from ROM based on opcode
    always @(*) begin
        WB          = ROM[opcode][0];
        MEM_Write   = ROM[opcode][1];
        MEM_Read    = ROM[opcode][2];
        typextend   = ROM[opcode][3];
        WR          = ROM[opcode][4];
        Sel_input2 = ROM[opcode][5];
        Sel_Dest    = ROM[opcode][6];
        PCNop       = ROM[opcode][7];
        J           = ROM[opcode][8];
        JR          = ROM[opcode][9];
        CALL        = ROM[opcode][10];
        Aluop       = ROM[opcode][13:11];
        Psel        = ROM[opcode][15:14];
    end
endmodule
