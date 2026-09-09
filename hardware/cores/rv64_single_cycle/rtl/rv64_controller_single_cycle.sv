//------------------------------------------------------------------------------------------------------
//  RV64 Controller (for Single Cycle Core)
//
//  Create Date : 2026-05-30
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------


module rv64_controller_single_cycle
import typedefs_pkg::*;
(
  //==============================
  //  Control Inputs
  //==============================
  input   [OpcodeWidth-1:0]      opcode,
  input   [Funct3Width-1:0]      funct3,
  input   [Funct7Width-1:0]      funct7,
  //==============================
  //  Control Outputs
  //==============================
  output                         Branch,
  output                         MemRead,
  output [PcSrcWidth-1:0]        PCSrc,
  output [RegWrSrcWidth-1:0]     RegWrSrc,
  output alu_op_e                ALUOp,
  output                         ALUSrc,
  output                         RegWrite,
  //==============================
  //  Processor Outputs
  //==============================
  output                         wr_en,
  output [WmaskWidth-1:0]        wmask
);

  alu_op_e  alu_op_d;

  // Registers
  logic                      branch_d;
  logic                      memread_d;
  logic [PcSrcWidth-1:0]     pcsrc_d;
  logic [RegWrSrcWidth-1:0]  regwrsrc_d;
  alu_op_e                   aluop_d;
  logic                      alusrc_d;
  logic                      regwrite_d;
  logic                      wr_en_d;
  logic [WmaskWidth-1:0]     wmask_d;

  always_comb begin
    branch_d      = 0;
    memread_d     = 0;
    pcsrc_d       = 0;
    regwrsrc_d    = 0;
    alu_op_d      = OP_DEFAULT;
    alusrc_d      = 0;
    regwrite_d    = 0;
    wr_en_d       = 0;
    wmask_d       = 8'hFF;
      
    case(opcode)
      //===============================================================================
      // I-TYPE
      //===============================================================================
      opcode_load: begin
        if(funct3==funct3_ld) begin
          regwrite_d    = 1'b1;     // Write to Register File
          regwrsrc_d    = 2'd1;     // Choose rdata input to write to Register File
          alu_op_d      = OP_ADD;   // Add op
          alusrc_d      = 1'b1;     // Choose i-type immediate as ALU inB
        end
      end
      
      opcode_op_immw: begin
        regwrite_d    = 1'b1;     // Write to Register File
        regwrsrc_d    = 2'd0;     // Choose ALURes to write to Register File
        alusrc_d      = 1'b1;     // Choose Immediate as ALU inB
        case(funct3)
          funct3_addi:  alu_op_d    = OP_ADD;
          funct3_slti:  alu_op_d    = OP_SLT;
          funct3_sltiu: alu_op_d    = OP_SLTU;
          funct3_xori:  alu_op_d    = OP_XOR;
          funct3_ori:   alu_op_d    = OP_OR;
          funct3_andi:  alu_op_d    = OP_AND;
          default:      alu_op_d    = OP_ADD;  
        endcase
      end
      
      opcode_jalr: begin
        if(funct3==0) begin
          regwrite_d    = 1'b1;     // Write to Register File
          regwrsrc_d    = 2'd2;     // Choose PC+4 to write to Register File
          alu_op_d    = OP_ADD;   // Add ALU OP
          alusrc_d      = 1'b1;     // Choose Immediate as ALU inB
          pcsrc_d       = 2'd2;     // Choose ALURes to write to PC
        end
      end
      
      //===============================================================================
      // S-TYPE
      //===============================================================================
      
      opcode_stype: begin
        case(funct3) 
          funct3_sd: begin
            alusrc_d      = 1'b1;     // Choose Immediate as ALU inB
            alu_op_d    = OP_ADD;   // Add ALU OP
            wr_en_d       = 1'b1;     // Enable write to Data Memory
          end

          // funct3_sb: begin
          //   alusrc_d      = 
          // end
        endcase
      end
      
      //===============================================================================
      // R-TYPE
      //===============================================================================
      opcode_rtype: begin  
        regwrite_d    = 1'b1;         // Write to Register File         
        case(funct3) 
          funct3_addsub:
            case(funct7) 
              funct7_add: alu_op_d = OP_ADD;
              funct7_sub: alu_op_d = OP_SUB;
              default:    alu_op_d = OP_DEFAULT;
            endcase
          funct3_sll:     alu_op_d = OP_SLL;
          funct3_slt:     alu_op_d = OP_SLT; 
          funct3_sltu:    alu_op_d = OP_SLTU;
          funct3_xor:     alu_op_d = OP_XOR; 
          funct3_srlsra: 
            case(funct7)
              funct7_srl: alu_op_d = OP_SRL;
              funct7_sra: alu_op_d = OP_SRA;
              default:    alu_op_d = OP_DEFAULT;
            endcase
          funct3_or:      alu_op_d = OP_OR; 
          funct3_and:     alu_op_d = OP_AND; 
          default:        alu_op_d = OP_DEFAULT;
        endcase
      end
      
      //===============================================================================
      // B-TYPE
      //===============================================================================
      opcode_btype: begin
        branch_d = 1'b1;
        if(funct3==funct3_beq) begin
          alu_op_d = OP_XOR;
        end
        else if(funct3==funct3_bne) begin
          alu_op_d = OP_ISEQ;
        end
      end
      
      //===============================================================================
      // J-TYPE
      //===============================================================================
      opcode_jal: begin
        regwrsrc_d = 2'd2;
        regwrite_d = 1'b1;
        pcsrc_d    = 1'b1;
      end
      
      default: begin
        branch_d      = 0;
        memread_d     = 0;
        pcsrc_d       = 0;
        regwrsrc_d    = 0;
        alu_op_d      = OP_DEFAULT;
        alusrc_d      = 0;
        regwrite_d    = 0;
        wr_en_d       = 0;
        wmask_d       = 0;
      end
    endcase
  end

  assign Branch   = branch_d;
  assign MemRead  = memread_d;
  assign PCSrc    = pcsrc_d;
  assign RegWrSrc = regwrsrc_d;
  assign ALUOp    = alu_op_d;
  assign ALUSrc   = alusrc_d;
  assign RegWrite = regwrite_d;
  assign wr_en    = wr_en_d;
  assign wmask    = wmask_d;

endmodule // rv64_controller_single_cycle