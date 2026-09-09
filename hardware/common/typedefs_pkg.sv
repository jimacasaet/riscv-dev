package typedefs_pkg;
  // Size Declarations
  parameter int WordSize      = 32;
  parameter   ALUOpWidth      =  5;
  parameter   OpcodeWidth     =  7;
  parameter   Funct3Width     =  3;
  parameter   Funct7Width     =  7;
  parameter   PcSrcWidth      =  2;
  parameter   RegWrSrcWidth   =  2;
  parameter   DataWidth       = 64;
  parameter   PcWidth         = 32;
  parameter   InstWidth       = 32;
  parameter   AddrWidth       = 32;
  parameter   WdataWidth      = 64;
  parameter   WmaskWidth      = 8;
  parameter   RdataWidth      = 64;

  // ALU Operations
  typedef enum logic [ALUOpWidth-1 : 0] {
     OP_ADD
    ,OP_SUB
    ,OP_SLL
    ,OP_SRL
    ,OP_SRA
    ,OP_SLT
    ,OP_SLTU
    ,OP_AND
    ,OP_OR 
    ,OP_XOR
    ,OP_ADDW
    ,OP_SUBW
    ,OP_SLLW
    ,OP_SRLW
    ,OP_SRAW
    ,OP_ISEQ // Non-standard
    ,OP_DEFAULT
  } alu_op_e;  

  //======================================
  // Instruction OPCODES
  ///======================================
  // U-type 
  parameter   opcode_lui      = 7'b0110111;
  parameter   opcode_auipc    = 7'b0010111;
  // J-type
  parameter   opcode_jal      = 7'b1101111;
  // I-type 
  parameter   opcode_jalr     = 7'b1100111;
  parameter   opcode_load     = 7'b0000011;
  parameter   opcode_op_immw  = 7'b0010011;
  parameter   opcode_op_immdw = 7'b0011011;
  // B-type
  parameter   opcode_btype    = 7'b1100011;
  // S-type
  parameter   opcode_stype    = 7'b0100011;
  // R-type
  parameter   opcode_rtype    = 7'b0110011;

  //======================================
  // FUNCT3 CODES
  ///======================================
  // I-Type
  parameter   funct3_ld       = 3'b011;
  parameter   funct3_addi     = 3'b000;
  parameter   funct3_slti     = 3'b010;
  parameter   funct3_sltiu    = 3'b011;
  parameter   funct3_xori     = 3'b100;
  parameter   funct3_ori      = 3'b110;
  parameter   funct3_andi     = 3'b111;
  // R-Type
  parameter   funct3_addsub   = 3'b000;
  parameter   funct3_sll      = 3'b001;
  parameter   funct3_slt      = 3'b010;
  parameter   funct3_sltu     = 3'b011;
  parameter   funct3_xor      = 3'b100;
  parameter   funct3_srlsra   = 3'b101;
  parameter   funct3_or       = 3'b110;
  parameter   funct3_and      = 3'b111;
  // B-Type
  parameter   funct3_beq      = 3'b000;
  parameter   funct3_bne      = 3'b001;
  // S-Type
  parameter   funct3_sb       = 3'b000;
  parameter   funct3_sh       = 3'b001;
  parameter   funct3_sw       = 3'b010;
  parameter   funct3_sd       = 3'b011;

  //======================================
  // FUNCT7 CODES
  ///======================================
  parameter   funct7_add      = 7'b0000000;
  parameter   funct7_sub      = 7'b0100000;
  parameter   funct7_srl      = 7'b0000000;
  parameter   funct7_sra      = 7'b0100000;
endpackage