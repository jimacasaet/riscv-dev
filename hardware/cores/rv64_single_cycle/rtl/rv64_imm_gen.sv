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

  logic [DataWidth-1:0]   imm_d;
  logic [OpcodeWidth-1:0] opcode;

  always_comb begin
    imm_d = '0;
    case(opcode)
      // U-type
      opcode_lui, opcode_auipc: 
        imm_d = { {32{inst_i[31]}} , inst_i[31:12], 12'b0};
      // J-type
      opcode_jal:     
        imm_d = { {43{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
      // I-type
      opcode_jalr, opcode_load, opcode_op_immw, opcode_op_immdw:    
        imm_d = { {52{inst_i[31]}} , inst_i[31:20]};
      // B-type
      opcode_btype:   
        imm_d = { {51{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
      // S-Type
      opcode_stype:      
        imm_d = { {52{inst_i[31]}} , inst_i[31:25], inst_i[11:7]};
      default:
        imm_d = '0;
    endcase
  end

  assign opcode = inst_i[6:0];
  assign imm_o  = imm_d;

endmodule // rv64_imm_gen