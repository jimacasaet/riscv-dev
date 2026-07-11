# RV64I RISC-V Core & SoC Development

## 1. Overview
This repository contains the ongoing design, verification, and system integration of a 64-bit RISC-V SoC implemented in modern **SystemVerilog**. 

Rather than a single static design, this project focuses on hardware scaling and architectural evolution, maintaining independent, fully functional core implementations within the same ecosystem.

### Current Architectural Targets:
* **ISA Compliance:** RV64I Base Integer Instruction Set.
* **Core 1: Single-Cycle Base (`hardware/cores/rv64_single_cycle`):** A lean, instruction-isolated model focused on strict decode-to-execution mapping and initial compliance loops. Ongoing implementation of the full RV64I instruction set.
* **Core 2: 5-Stage Pipelined Core (Planned):** An in-order performance core incorporating hazard detection, interlocks, and a comprehensive data forwarding/bypassing network.
* **SoC Integration (Planned):** A complete system topology utilizing memory-mapped I/O (MMIO), a standard bus interconnect (AXI4-Lite), and critical system peripherals (UART, CLINT).

## Verification Stack
Leveraging an industry-standard design verification (DV) methodology to ensure mathematical correctness:
* **Unit Testing:** Direct and constrained-random SystemVerilog verification for standalone components (ALU, LSU).
* **System-Level DV:** A robust, scalable **UVM (Universal Verification Methodology)** environment built to handle core-level instruction stream checking and SoC-level interconnect traffic.
* **Simulation & Tools:** Synopsys VCS and AMD Vivado for synthesis, simulation, and Gate-Level Simulation (GLS) workflows.

## 3. Directory Layout
```text
.
├── docs/             # Specifications, architectural charts, and testplans
├── hardware/         # Hardware design files (Single-cycle, Pipelined, Peripherals)
├── scripts/          # Simulation automation, compilation scripts, and Makefiles
├── sim/              # Directory for simulation runs
├── sw/               # Software toolchains, firmware, and test programs
└── verification/     # Testbenches and UVM environment components