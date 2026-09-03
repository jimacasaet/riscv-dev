//------------------------------------------------------------------------------------------------------
//  Immediate Generator
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_imm_gen
import typedefs_pkg::*;
(
  input       [InstWidth-1:0]    inst_i,
  output      [DataWidth-1:0]    imm_o
);

  logic                   imm_d;
  logic [OpcodeWidth-1:0] opcode;

  // FIXME: Refactor always_comb block
  always_comb begin
    imm_d = 0;
    case(opcode)
      opcode_ld:      imm_d = { {52{inst_i[31]}} , inst_i[31:20]};
      opcode_addi:    imm_d = { {52{inst_i[31]}} , inst_i[31:20]};
      opcode_jalr:    imm_d = { {52{inst_i[31]}} , inst_i[31:20]};
      opcode_sd:      imm_d = { {52{inst_i[31]}} , inst_i[31:25], inst_i[11:7]};
      default:        imm_d = 0;
    endcase
  end

  assign opcode = inst_i[6:0];
  assign imm_o  = imm_d;

endmodule // rv64_imm_gen