//------------------------------------------------------------------------------------------------------
//  ALU - Arithmetic Logic Unit
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_alu #(
  parameter OpWidth    = 5,
  parameter DataWidth  = 64
)(
  input     [OpWidth-1  :0]       alu_op_i,
  input     [DataWidth-1:0]       op_a_i,
  input     [DataWidth-1:0]       op_b_i,
  output                          zero_o,
  output                          result_o
);

  // ALU Opcodes
  localparam OP_AND       = 0;
  localparam OP_OR        = 1;
  localparam OP_ADD       = 2;
  localparam OP_XOR       = 3;
  localparam OP_SUB       = 6;
  localparam OP_SLT       = 7;
  localparam OP_ISEQ      = 10;

  logic result_d;
  logic zero_d;
  
  always_comb begin
    case(alu_op_i)
      OP_AND:   result_d = op_a_i & op_b_i;
      OP_OR :   result_d = op_a_i | op_b_i;
      OP_ADD:   result_d = op_a_i + op_b_i;
      OP_XOR:   result_d = op_a_i ^ op_b_i;
      OP_SUB:   result_d = $signed(op_a_i) - $signed(op_b_i);
      OP_SLT:   result_d = $signed(op_a_i) <  $signed(op_b_i) ? 1 : 0;
      OP_ISEQ:  result_d = $signed(op_a_i) == $signed(op_b_i) ? 1 : 0;
      default:  result_d = 0;
    endcase
  end

  assign result_o = result_d;

  always_comb begin
    if(result_d == 0)
      zero_d = 1'b1;
    else
      zero_d = 1'b0;
  end

  assign zero_o = result_d;

endmodule : alu