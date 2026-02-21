# Pipelined RISC Processor Design using Verilog

## Project Overview

This project implements a **32-bit Pipelined RISC Processor** using Verilog HDL.  
The processor is designed based on a pipelined architecture to improve performance by executing multiple instructions simultaneously across different pipeline stages.

The design includes the datapath, control unit, pipeline registers, and testbench for simulation and verification.

---

## Pipeline Architecture

The processor is implemented using a standard **5-stage pipeline**:

1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory Access (MEM)
5. Write Back (WB)

Pipeline registers are used between each stage to ensure correct instruction flow.

---

## Processor Features

- 32-bit architecture
- 32 general-purpose registers
- Pipelined datapath
- Separate instruction and data memory
- Control unit for instruction decoding
- ALU for arithmetic and logical operations
- Support for multiple instruction types:
  - R-type instructions (ADD, SUB, AND, OR, etc.)
  - I-type instructions (ADDI, ANDI, etc.)
  - Memory instructions (LW, SW)
  - Jump instructions (J, JR, CALL)

---

## Modules Implemented

The project includes multiple Verilog modules such as:

- Processor top module
- Datapath module
- Control Unit
- ALU
- Register File
- Instruction Memory
- Data Memory
- Pipeline Registers
- Testbench

---

## Simulation and Testing

The processor was verified using a Verilog testbench.  
Simulation was used to confirm:

- Correct pipeline execution
- Correct instruction flow through pipeline stages
- Correct ALU operations
- Correct memory access
- Correct register write-back


---

## How to Run (Simulation)

Using ModelSim or any Verilog simulator:

1. Compile all Verilog files
2. Run the testbench
3. Observe waveform results

---

## Tools Used

- Verilog HDL
- ModelSim / Vivado / Quartus (simulation)
- GitHub (version control)

---

## Authors

Heba Dababat  
Birzeit University  
Computer Engineering  

---

## Course

Computer Architecture – ENCS4370

