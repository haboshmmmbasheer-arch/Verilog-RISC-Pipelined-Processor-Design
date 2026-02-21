`timescale 1ns/1ps
module CPU_TB;

  reg clk, reset;
  Top_CPU cpu(.clk(clk), .reset(reset));

  integer i;
  integer cycle;

  // -----------------------------
  // Clock (10 ns period)
  // -----------------------------
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // -----------------------------
  // Init regs to avoid X
  // -----------------------------
    
  initial begin	 
			 
    for (i = 1; i < 32; i = i + 1)
      cpu.IDSTG.RF.R[i] = 32'd0;
	  cpu.IDSTG.RF.R[1] = 32'd10;	
	  cpu.IDSTG.RF.R[2] = 32'd1;  
	  cpu.IDSTG.RF.R[3] = 32'd5;	
	  cpu.IDSTG.RF.R[4] = 32'd10; 
	  cpu.IDSTG.RF.R[7] = 32'd3; 
	   cpu.IDSTG.RF.R[31] = 32'd5; 
	   cpu.MEMSTG.DATA_MEM[3]=32'd15; 
	   cpu.MEMSTG.DATA_MEM[1]= 32'd4;
    cycle = 0;
  end

  // -----------------------------
 
  // -----------------------------
  task print_mem_window;
    integer a;
    begin
      $write("MEM: ");
      // print a small window (0..7)
      for (a = 0; a < 8; a = a + 1) begin
        $write("[%0d]=%h ", a, cpu.MEMSTG.DATA_MEM[a]);
      end
      $write("\n");
   
      $display("MEM: [16]=%h  [20]=%h",
               cpu.MEMSTG.DATA_MEM[16],
               cpu.MEMSTG.DATA_MEM[20]);
    end
  endtask

  // -----------------------------
  // Pretty trace each cycle
  // -----------------------------
  always @(posedge clk) begin
    cycle = cycle + 1;

    // Small delay so signals settle after pipeline regs update
    #1;

    $display("==============================================================");
    $display("CYCLE %0d   TIME=%0t ns", cycle, $time);
    $display("--------------------------------------------------------------");
    $display("IF : PC=%0d   instIF=%h", cpu.PC, cpu.inst_IF);
    $display("ID : instID=%h", cpu.inst_ID);

    // If these signals exist in your Top_CPU, keep them; if not, delete the line(s)
    $display("HZ : stall=%b   Kill=%b", cpu.stall_hz, cpu.Kill_ID);

    $display("--------------------------------------------------------------");
    $display("CTRL(ID): WB=%b MR=%b MW=%b Aluop=%b SelImm=%b typext=%b WR_final=%b",
             cpu.WB_ID, cpu.MEM_Read_ID, cpu.MEM_Write_ID,
             cpu.AluSel_ID, cpu.Sel_input2_ID, cpu.typextend_ID, cpu.WR_final_ID);

    $display("--------------------------------------------------------------");
    $display("EX : ALU=%h   Rdest=%0d   WB=%b MR=%b MW=%b",
             cpu.ALU_result_EX, cpu.R_dest_EX, cpu.WB_EX, cpu.MEM_Read_EX, cpu.MEM_Write_EX);

    $display("MEM: ALU=%h   MEMD=%h   Rdest=%0d   WB=%b MR=%b MW=%b",
             cpu.ALU_result_MEM, cpu.MEM_Data_MEM, cpu.R_dest_MEM,
             cpu.WB_MEM, cpu.MEM_Read_MEM, cpu.MEM_Write_MEM);

    $display("WB : WR=%b   Rdest=%0d   WBData=%h",
             cpu.WR_WB_final, cpu.R_dest_WB_final, cpu.WBData_WB_final);

    $display("--------------------------------------------------------------");
    $display("REGS: R0=%h R1=%h R2=%h R3=%h R4=%h R5=%h R6=%h R7=%h R31=%h",
             cpu.IDSTG.RF.R[0], cpu.IDSTG.RF.R[1], cpu.IDSTG.RF.R[2],
             cpu.IDSTG.RF.R[3], cpu.IDSTG.RF.R[4], cpu.IDSTG.RF.R[5],
             cpu.IDSTG.RF.R[6], cpu.IDSTG.RF.R[7], cpu.IDSTG.RF.R[31]);

    $display("--------------------------------------------------------------");
    print_mem_window();

    $display("==============================================================");
    $display("");
  end

  // -----------------------------
  // Reset + run
  // -----------------------------
  initial begin
    reset = 1'b1;
    #20;
    reset = 1'b0;

    // Run long enough to see multiple instructions through pipeline
    // With 10ns/clock: 300ns = 30 cycles
    #600;  // 60 cycles 
    $finish;
  end

endmodule
