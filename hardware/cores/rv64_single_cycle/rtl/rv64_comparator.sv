module rv64_comparator
import typedefs_pkg::*;
(
  input   [DataWidth-1:0]     rd1_i,
  input   [DataWidth-1:0]     rd2_i,
  input   [Funct3Width-1:0]   funct3_i,
  output  logic               branch_taken_o
);
  logic eq, lt, ltu;

  assign eq   = (rd1_i == rd2_i);
  assign lt   = ($signed(rd1_i) <  $signed(rd2_i));
  assign ltu  = (rd1_i < rd2_i);

  // Branch taken computation
  always_comb begin
    case(funct3_i)
      funct3_beq:  branch_taken_o = eq;
      funct3_bne:  branch_taken_o = ~eq;
      funct3_blt:  branch_taken_o = lt;
      funct3_bge:  branch_taken_o = ~lt;
      funct3_bltu: branch_taken_o = ltu;
      funct3_bgeu: branch_taken_o = ~ltu;
      default:     branch_taken_o = 1'b0;
    endcase
  end // always_comb begin


endmodule : rv64_comparator