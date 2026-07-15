//------------------------------------------------------------------------------------------------------
//  ALU - Arithmetic Logic Unit
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_alu 
import typedefs_pkg::*;
#(
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
      OP_ADD:   result_d = op_a_i + op_b_i;
      OP_SUB:   result_d = $signed(op_a_i) - $signed(op_b_i);
      OP_SLL:   result_d = op_a_i << op_b_i[5:0];
      OP_SRL:   result_d = op_a_i >> op_b_i[5:0];
      OP_SRA:   result_d = $signed(op_a_i) >>> op_b_i[5:0];
      OP_SLT:   result_d = $signed(op_a_i) <  $signed(op_b_i) ? DataWidth'(1) : DataWidth'(0);
      OP_SLTU:  result_d = op_a_i < op_b_i ?  DataWidth'(1) : DataWidth'(0);
      OP_AND:   result_d = op_a_i & op_b_i;
      OP_OR :   result_d = op_a_i | op_b_i;  
      OP_XOR:   result_d = op_a_i ^ op_b_i;
      OP_ADDW:  result_d = DataWidth'($signed(op_a_i[WordSize-1 : 0] + op_b_i[WordSize-1 : 0]));
      OP_SUBW:  result_d = DataWidth'($signed(op_a_i[WordSize-1 : 0] - op_b_i[WordSize-1 : 0]));
      OP_SLLW:  result_d = DataWidth'($signed(op_a_i[WordSize-1 : 0] << op_b_i[$clog2(WordSize)-1 : 0]));
      OP_SRLW:  result_d = DataWidth'($signed(op_a_i[WordSize-1 : 0] >> op_b_i[$clog2(WordSize)-1 : 0]));
      OP_SRAW:  result_d = DataWidth'($signed($signed(op_a_i[WordSize-1 : 0]) >>> op_b_i[$clog2(WordSize)-1 : 0]));
      OP_ISEQ:  result_d = $signed(op_a_i) == $signed(op_b_i) ?  DataWidth'(1) : DataWidth'(0);
      default:  result_d = DataWidth'(0);
    endcase
  end

  assign result_o = result_d;

  always_comb begin
    if(result_d == 0) begin
      zero_d = 1'b1;
    end else begin
      zero_d = 1'b0;
    end
  end

  assign zero_o = zero_d;

endmodule : rv64_alu