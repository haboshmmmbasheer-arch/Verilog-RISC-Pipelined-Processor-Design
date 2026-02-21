// IF/ID Buffer------------------------------------------------------------------------	 
	`timescale 1ns/1ps
module fetch_decode_buffer (
    input clk,
    input reset,
    input stall,     // from hazard unit
    input bubble,    // from PC control unit (Kill)
    input [31:0] inst_in,
    input [31:0] npc_in,      // PC + 1

    output reg [31:0] inst_out,
    output reg [31:0] npc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            inst_out <= 32'b0;   // NOP
            npc_out  <= 32'b0;
        end
        else if (stall) begin
            inst_out <= inst_out;
            npc_out  <= npc_out;
        end
        else if (bubble) begin
            inst_out <= 32'b0;   // insert NOP
            npc_out  <= npc_in;  
        end
        else begin
            inst_out <= inst_in;
            npc_out  <= npc_in;
        end
    end
endmodule
