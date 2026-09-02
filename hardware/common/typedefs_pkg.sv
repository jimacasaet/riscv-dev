package typedefs_pkg;
  parameter int ALUOpWidth = 5;
  parameter int WordSize   = 32;

  parameter   ALUOP_WIDTH     =  5;
  parameter   OPCODE_WIDTH    =  7;
  parameter   FUNCT3_WIDTH    =  3;
  parameter   FUNCT7_WIDTH    =  7;
  parameter   WMASK_WIDTH     =  8;
  parameter   PCSRC_WIDTH     =  2;
  parameter   REGWRSRC_WIDTH  =  2;
  parameter   DATA_WIDTH      = 64;
  parameter   PcWidth         = 32;
  parameter   InstWidth       = 32;
  parameter   AddrWidth       = 32;
  parameter   WdataWidth      = 64;
  parameter   WmaskWidth      = 8;
  parameter   RdataWidth      = 64;

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
endpackage