# Instruction Compliance

## Instructions Implemented
### RV32I
| Category | Instruction | Description | Status | What needs to be added / modified |
| :--- | :--- | :--- | :---: | :--- |
| **Upper Immediate** | `LUI` | Load Upper Immediate | ✖ Missing | Add decoding logic to shift a 20-bit immediate left by 12 bits. |
| | `AUIPC` | Add Upper Immediate to PC | ✖ Missing | Essential for PC-relative addressing / function calls. |
| **Unconditional Jump**| `JAL` | Jump and Link | ✔ Implemented | Ensure it sign-extends the offset correctly to 64-bit boundaries. |
| | `JALR` | Jump and Link Register | ✔ Implemented | Ensure it sets the least-significant bit of the target to 0. |
| **Conditional Branch**| `BEQ` | Branch if Equal | ✔ Implemented | Performs standard equality check. |
| | `BNE` | Branch if Not Equal | ✔ Implemented | Performs standard inequality check. |
| | `BLT` | Branch if Less Than (Signed) | ✖ Missing | Needs signed arithmetic comparison logic. |
| | `BGE` | Branch if Greater/Equal (Signed) | ✖ Missing | Needs signed arithmetic comparison logic. |
| | `BLTU` | Branch if Less Than (Unsigned) | ✖ Missing | Needs unsigned arithmetic comparison logic. |
| | `BGEU` | Branch if Greater/Equal (Unsigned)| ✖ Missing | Needs unsigned arithmetic comparison logic. |
| **Loads** | `LB` | Load Byte (Signed) | ✖ Missing | Needs byte mask extraction + sign-extension to 64 bits. |
| | `LH` | Load Halfword (Signed) | ✖ Missing | Halfword mask extraction + sign-extension to 64 bits. |
| | `LW` | Load Word (Signed) | ✖ Missing | Word mask extraction + sign-extension to 64 bits. |
| | `LBU` | Load Byte Unsigned | ✖ Missing | Zero-extends a byte to 64 bits. |
| | `LHU` | Load Halfword Unsigned | ✖ Missing | Zero-extends a halfword to 64 bits. |
| **Stores** | `SB` | Store Byte | ✖ Missing | Lower 8-bit routing logic to memory. |
| | `SH` | Store Halfword | ✖ Missing | Lower 16-bit routing logic to memory. |
| | `SW` | Store Word | ✖ Missing | Lower 32-bit routing logic to memory. |
| **Arithmetic (Imm)** | `ADDI` | Add Immediate | ✔ Implemented | Ensure the 12-bit immediate expands natively to 64 bits. |
| | `SLTI` | Set Less Than Immediate (Signed)| ✖ Missing | Immediate comparison against register. |
| | `SLTIU`| Set Less Than Immediate (Unsigned)| ✖ Missing | Immediate comparison against register. |
| | `ANDI` | AND Immediate | ✖ Missing | Bitwise immediate logic. |
| | `ORI`  | OR Immediate | ✖ Missing | Bitwise immediate logic. |
| | `XORI` | XOR Immediate | ✖ Missing | Bitwise immediate logic. |
| **Shifts (Imm)** | `SLLI` | Shift Left Logical Immediate | ✖ Missing | Operates on 64 bits (needs a 6-bit shift amount decoding). |
| | `SRLI` | Shift Right Logical Immediate | ✖ Missing | Operates on 64 bits (needs a 6-bit shift amount decoding). |
| | `SRAI` | Shift Right Arithmetic Immediate| ✖ Missing | Shift right preserving the sign bit across 64 bits. |
| **Arithmetic (Reg)** | `ADD`  | Add Registers | ✔ Implemented | 64-bit addition. |
| | `SUB`  | Subtract Registers | ✔ Implemented | 64-bit subtraction. |
| | `SLT`  | Set Less Than (Signed) | ✔ Implemented | Register comparison. |
| | `SLTU` | Set Less Than (Unsigned) | ✖ Missing | Unsigned register comparison. |
| | `AND`  | Bitwise AND | ✔ Implemented | 64-bit bitwise logic. |
| | `OR`   | Bitwise OR | ✔ Implemented | 64-bit bitwise logic. |
| | `XOR`  | Bitwise XOR | ✔ Implemented | 64-bit bitwise logic. |
| **Shifts (Reg)** | `SLL`  | Shift Left Logical | ✖ Missing | Shift register values dynamically. |
| | `SRL`  | Shift Right Logical | ✖ Missing | Shift register values dynamically. |
| | `SRA`  | Shift Right Arithmetic | ✖ Missing | Shift right preserving the sign bit. |
| **System/Environment**| `FENCE`| Fence Memory / Ordering | ✖ Missing | Can be treated as a NOP if you have a simple in-order core. |
| | `ECALL`| Environment Call | ✖ Missing | Crucial for triggering system traps or passing compliance tests. |
| | `EBREAK`| Environment Breakpoint | ✖ Missing | Used by debuggers. |

### RV64I
| Category | Instruction | Description | Status | Notes / Implementation Strategy |
| :--- | :--- | :--- | :---: | :--- |
| **64-bit Memory** | `LD` | Load Doubleword | ✔ Implemented | Fetches a full 64-bit value from memory into a register. |
| | `SD` | Store Doubleword | ✔ Implemented | Commits a full 64-bit register value into memory. |
| | `LWU` | Load Word Unsigned | ✖ Missing | Fetches 32 bits from memory and zero-extends it into 64 bits. |
| **32-bit Word Computational (Imm)** | `ADDIW` | Add Immediate Word | ✖ Missing | Adds sign-extended 12-bit immediate to the lower 32 bits, then sign-extends result to 64 bits. |
| | `SLLIW` | Shift Left Log. Imm Word | ✖ Missing | 5-bit shift amount on the lower 32 bits, followed by sign-extension to 64 bits. |
| | `SRLIW` | Shift Right Log. Imm Word | ✖ Missing | 5-bit shift amount on the lower 32 bits, followed by sign-extension to 64 bits. |
| | `SRAIW` | Shift Right Arith. Imm Word | ✖ Missing | 5-bit arithmetic shift on the lower 32 bits, followed by sign-extension to 64 bits. |
| **32-bit Word Computational (Reg)** | `ADDW` | Add Word | ✖ Missing | Adds lower 32 bits of two registers, then sign-extends the result to 64 bits. |
| | `SUBW` | Subtract Word | ✖ Missing | Subtracts lower 32 bits of two registers, then sign-extends the result to 64 bits. |
| | `SLLW` | Shift Left Logical Word | ✖ Missing | Performs shift on lower 32 bits, then sign-extends the result to 64 bits. |
| | `SRLW` | Shift Right Logical Word | ✖ Missing | Performs shift on lower 32 bits, then sign-extends the result to 64 bits. |
| | `SRAW` | Shift Right Arithmetic Word| ✖ Missing | Performs arithmetic shift on lower 32 bits, then sign-extends the result to 64 bits. |

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