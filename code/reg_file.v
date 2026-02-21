//  Register File ---------------------------------------------------------------	
	`timescale 1ns/1ps
module reg_file (
    input         clk,
    input  [31:0] pc_value,      
    input  [4:0]  Rs,
    input  [4:0]  Rt,
    input  [4:0]  Rd,             
    input         isStore,   

    input  [4:0]  Rp,
    input  [4:0]  R_dest,
    input  [31:0] WBData,
    input         WR,

    output [31:0] BusY,
    output [31:0] BusZ,
    output [31:0] Busp
);
    reg [31:0] R [0:31];

    wire [4:0] read2 = (isStore) ? Rd : Rt;

    always @(posedge clk) begin
        // hardwire R0=0
        R[0]  <= 32'b0;

        // hardwire R30 = PC
        R[30] <= pc_value;

        // normal write (but not to R0 or R30)
        if (WR && (R_dest != 5'd0) && (R_dest != 5'd30))
            R[R_dest] <= WBData;
    end

    // combinational reads
    assign BusY = (Rs == 5'd0) ? 32'b0 : R[Rs];
    assign BusZ = (read2 == 5'd0) ? 32'b0 : R[read2];
    assign Busp = (Rp == 5'd0) ? 32'b0 : R[Rp];
endmodule