# Instruction Compliance

## RV64I Instructions Implemented

## ALU Operations Implemented

| Operation Category | ALU Operation | Description | Status |
| :--- | :--- | :--- | :--- |
| **64-bit Arithmetic** | **ADD** / **ADDI** | Performs full 64-bit addition for register-register or register-immediate operands. | ✔ **Implemented** |
| | **SUB** | Performs full 64-bit subtraction. | ✔ **Implemented** |
| **Logical** | **AND** / **ANDI** | Performs a bitwise AND across all 64 bits. | ✔ **Implemented** |
| | **OR** / **ORI** | Performs a bitwise OR across all 64 bits. | ✔ **Implemented** |
| | **XOR** / **XORI** | Performs a bitwise XOR across all 64 bits. | ✔ **Implemented** |
| **Comparisons / Sets** | **SLT** / **SLTI** | Set Less Than (Signed): Outputs `1` if Op1 < Op2 (signed), else `0`. | ✔ **Implemented** |
| | **SLTU** / **SLTIU** | Set Less Than Unsigned: Outputs `1` if Op1 < Op2 (unsigned), else `0`. | ✖ **Missing** |
| **64-bit Shifts** | **SLL** / **SLLI** | Shift Left Logical: Shifts 64-bit value left by a 6-bit shift amount (`shamt`), filling with zeros. | ✖ **Missing** |
| | **SRL** / **SRLI** | Shift Right Logical: Shifts 64-bit value right by a 6-bit shift amount, filling with zeros. | ✖ **Missing** |
| | **SRA** / **SRAI** | Shift Right Arithmetic: Shifts 64-bit value right by a 6-bit shift amount, preserving the sign bit. | ✖ **Missing** |
| **32-bit Word Arithmetic** | **ADDW** / **ADDIW** | Truncates/operates on lower 32 bits for addition, then **sign-extends** the result to 64 bits. | ✖ **Missing** |
| | **SUBW** | Subtracts lower 32 bits of two registers, then **sign-extends** the result to 64 bits. | ✖ **Missing** |
| **32-bit Word Shifts** | **SLLW** / **SLLIW** | Performs a logical left shift on the lower 32 bits using a 5-bit shift amount, then **sign-extends** to 64 bits. | ✖ **Missing** |
| | **SRLW** / **SRLIW** | Performs a logical right shift on the lower 32 bits using a 5-bit shift amount, then **sign-extends** to 64 bits. | ✖ **Missing** |
| | **SRAW** / **SRAIW** | Performs an arithmetic right shift on the lower 32 bits using a 5-bit shift amount, then **sign-extends** to 64 bits. | ✖ **Missing** |
| *Custom Extension* | *ISEQ* | Non-standard university-level subset custom equality check. | ✔ **Implemented** *(Non-standard)* |