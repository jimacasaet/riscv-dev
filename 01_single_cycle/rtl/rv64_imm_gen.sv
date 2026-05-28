//------------------------------------------------------------------------------------------------------
//  Immediate Generator
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_imm_gen #(
  parameter   InstWidth   = 32,
  parameter   DataWidth   = 64,
  parameter   OpcodeWidth = 7
)(
  input       [InstWidth-1:0]    inst_i,
  output      [DataWidth-1:0]    imm_o
);
  localparam   OPCODE_LD       = 7'b0000011;
  localparam   OPCODE_ADDI     = 7'b0010011;
  localparam   OPCODE_JALR     = 7'b1100111;
  localparam   OPCODE_SD       = 7'b0100011;
  localparam   OPCODE_RTYPE    = 7'b0110011;
  localparam   OPCODE_SBTYPE   = 7'b1100011;
  localparam   OPCODE_JAL      = 7'b1101111;

  logic                   imm_d;
  logic [OpcodeWidth-1:0] opcode;

  // FIXME: Refactor always_comb block
  always_comb begin
    imm = 0;
    case(opcode)
      OPCODE_LD:      imm_d = { {52{inst[31]}} , inst[31:20]};
      OPCODE_ADDI:    imm_d = { {52{inst[31]}} , inst[31:20]};
      OPCODE_JALR:    imm_d = { {52{inst[31]}} , inst[31:20]};
      OPCODE_SD:      imm_d = { {52{inst[31]}} , inst[31:25], inst[11:7]};
      default:        imm_d = 0;
    endcase
  end

  assign opcode = inst[6:0];
  assign imm    = imm_d;

endmodule // rv64_imm_gen