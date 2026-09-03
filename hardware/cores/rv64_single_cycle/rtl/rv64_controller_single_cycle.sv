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
    output reg                     Branch,
    output reg                     MemRead,
    output reg [PcSrcWidth-1:0]    PCSrc,
    output reg [RegWrSrcWidth-1:0] RegWrSrc,
    output alu_op_e                ALUOp,
    output reg                     ALUSrc,
    output reg                     RegWrite,
    //==============================
    //  Processor Outputs
    //==============================
    output reg                     wr_en,
    output reg [WmaskWidth-1:0]   wmask
);

  alu_op_e  alu_op_d;

  // Registers
  // logic                      Branch;
  // logic                      MemRead;
  // logic [PcSrcWidth-1:0]     PCSrc;
  // logic [RegWrSrcWidth-1:0]  RegWrSrc;
  // alu_op_e                   ALUOp;
  // logic                      ALUSrc;
  // logic                      RegWrite;

  always_comb begin
    Branch      = 0;
    MemRead     = 0;
    PCSrc       = 0;
    RegWrSrc    = 0;
    alu_op_d    = OP_DEFAULT;
    ALUSrc      = 0;
    RegWrite    = 0;
    wr_en       = 0;
    wmask       = 8'hFF;
      
    case(opcode)
      //===============================================================================
      // I-TYPE
      //===============================================================================
      opcode_ld: begin
        if(funct3==funct3_ld) begin
          RegWrite    = 1'b1;     // Write to Register File
          RegWrSrc    = 2'd1;     // Choose rdata input to write to Register File
          alu_op_d    = OP_ADD;   // Add op
          ALUSrc      = 1'b1;     // Choose i-type immediate as ALU inB
        end
      end
      
      opcode_addi: begin
        if(funct3==0) begin
          RegWrite    = 1'b1;     // Write to Register File
          RegWrSrc    = 2'd0;     // Choose ALURes to write to Register File
          alu_op_d    = OP_ADD;   // Add ALU OP
          ALUSrc      = 1'b1;     // Choose Immediate as ALU inB
        end
      end
      
      opcode_jalr: begin
        if(funct3==0) begin
          RegWrite    = 1'b1;     // Write to Register File
          RegWrSrc    = 2'd2;     // Choose PC+4 to write to Register File
          alu_op_d    = OP_ADD;   // Add ALU OP
          ALUSrc      = 1'b1;     // Choose Immediate as ALU inB
          PCSrc       = 2'd2;     // Choose ALURes to write to PC
        end
      end
      
      //===============================================================================
      // S-TYPE
      //===============================================================================
      
      opcode_stype: begin
        case(funct3) 
          funct3_sd: begin
            ALUSrc      = 1'b1;     // Choose Immediate as ALU inB
            alu_op_d    = OP_ADD;   // Add ALU OP
            wr_en       = 1'b1;     // Enable write to Data Memory
          end

          // funct3_sb: begin
          //   ALUSrc      = 
          // end
        endcase
      end
      
      //===============================================================================
      // R-TYPE
      //===============================================================================
      opcode_rtype: begin  
          RegWrite    = 1'b1;         // Write to Register File         
          case(funct3) 
              funct3_addsub: begin 
                  if(funct7==funct7_add)    
                      alu_op_d = OP_ADD;
                  else if(funct7==funct7_sub)
                      alu_op_d = OP_SUB;
              end
              
              funct3_and: begin
                      alu_op_d = OP_AND; 
              end
              
              funct3_or: begin 
                      alu_op_d = OP_OR; 
              end
              
              funct3_xor: begin 
                      alu_op_d = OP_XOR; 
              end
              
              funct3_slt: begin 
                      alu_op_d = OP_SLT; 
              end
          endcase
      end
      
      //===============================================================================
      // B-TYPE
      //===============================================================================
      opcode_sbtype: begin
          Branch = 1'b1;
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
          RegWrSrc = 2'd2;
          RegWrite = 1'b1;
          PCSrc    = 1'b1;
      end
      
      default: begin
          Branch      = 0;
          MemRead     = 0;
          PCSrc       = 0;
          RegWrSrc    = 0;
          alu_op_d    = OP_DEFAULT;
          ALUSrc      = 0;
          RegWrite    = 0;
          wr_en       = 0;
          wmask       = 0;
      end
    endcase
  end

  assign ALUOp = alu_op_d;

endmodule // rv64_controller_single_cycle