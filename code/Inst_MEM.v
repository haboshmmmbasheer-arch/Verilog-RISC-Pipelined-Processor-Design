// Instruction Memory -----------------------------------------------------------------		   
`timescale 1ns/1ps
module Inst_MEM (
    input  [31:0] address,
    output [31:0] inst
);
    reg [31:0] ROM [0:255];

    initial begin
        $readmemh("InstFile.txt", ROM);
    end

    assign inst = ROM[address[7:0]];
endmodule