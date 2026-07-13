//------------------------------------------------------------------------------------------------------
//  ALU - Arithmetic Logic Unit
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------
import typedefs_pkg::*;

module rv64_alu #(
  parameter OpWidth    = ALUOpWidth,
  parameter DataWidth  = 64
)(
  input     alu_op_e              alu_op_i,
  input     [DataWidth-1:0]       op_a_i,
  input     [DataWidth-1:0]       op_b_i,
  output                          zero_o,
  output    [DataWidth-1:0]       result_o
);


  logic [DataWidth-1:0] result_d;
  logic                 zero_d;
  
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

endmodule : rv64_alu