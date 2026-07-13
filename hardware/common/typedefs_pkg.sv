package typedefs_pkg;
  parameter int ALUOpWidth = 5;

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
    ,OP_ISEQ // Non-standard
    ,OP_DEFAULT
  } alu_op_e;
endpackage