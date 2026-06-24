//------------------------------------------------------------------------------------------------------
//  RV64 Controller (for Single Cycle Core)
//
//  Create Date : 2026-05-30
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_controller_single_cycle#(  
  parameter   ALUOP_WIDTH     =  5,
  parameter   OPCODE_WIDTH    =  7,
  parameter   FUNCT3_WIDTH    =  3,
  parameter   FUNCT7_WIDTH    =  7,
  parameter   WMASK_WIDTH     =  8,
  parameter   PCSRC_WIDTH     =  2,
  parameter   REGWRSRC_WIDTH  =  2
)(
    //==============================
    //  Control Inputs
    //==============================
    input   [OPCODE_WIDTH-1:0]      opcode,
    input   [FUNCT3_WIDTH-1:0]      funct3,
    input   [FUNCT7_WIDTH-1:0]      funct7,
    //==============================
    //  Control Outputs
    //==============================
    output reg                     Branch,
    output reg                     MemRead,
    output reg [PCSRC_WIDTH-1:0]   PCSrc,
    output reg [REGWRSRC_WIDTH-1:0]RegWrSrc,
    output reg [ALUOP_WIDTH-1:0]   ALUOp,
    output reg                     ALUSrc,
    output reg                     RegWrite,
    //==============================
    //  Processor Outputs
    //==============================
    output reg                     wr_en,
    output reg [WMASK_WIDTH-1:0]   wmask
);

  //==============================
  //  OPCODES
  //==============================
  localparam   opcode_ld       = 7'b0000011;
  localparam   opcode_addi     = 7'b0010011;
  localparam   opcode_jalr     = 7'b1100111;
  localparam   opcode_sd       = 7'b0100011;
  localparam   opcode_rtype    = 7'b0110011;
  localparam   opcode_sbtype   = 7'b1100011;
  localparam   opcode_jal      = 7'b1101111;
  //==============================
  //  FUNCT3
  //==============================
  localparam   funct3_ld       = 3'b011;
  localparam   funct3_sd       = 3'b011;
  localparam   funct3_addsub   = 3'b000;
  localparam   funct3_and      = 3'b111;
  localparam   funct3_or       = 3'b110;
  localparam   funct3_xor      = 3'b100;
  localparam   funct3_slt      = 3'b010;
  localparam   funct3_beq      = 3'b000;
  localparam   funct3_bne      = 3'b001;
  //==============================
  //  FUNCT7
  //==============================
  localparam   funct7_add      = 7'd0;
  localparam   funct7_sub      = 7'b0100000;
  //===============================
  //  ALU Opcodes
  //===============================
  localparam   OP_AND        =   0;
  localparam   OP_OR         =   1;
  localparam   OP_ADD        =   2;
  localparam   OP_XOR        =   3;
  localparam   OP_SUB        =   6;
  localparam   OP_SLT        =   7;
  localparam   OP_ISEQ       =   10;

  always_comb begin
    Branch      = 0;
    MemRead     = 0;
    PCSrc       = 0;
    RegWrSrc    = 0;
    ALUOp       = 64;
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
          ALUOp       = OP_ADD;   // Add op
          ALUSrc      = 1'b1;     // Choose i-type immediate as ALU inB
        end
      end
      
      opcode_addi: begin
        if(funct3==0) begin
          RegWrite    = 1'b1;     // Write to Register File
          RegWrSrc    = 2'd0;     // Choose ALURes to write to Register File
          ALUOp       = OP_ADD;   // Add ALU OP
          ALUSrc      = 1'b1;     // Choose Immediate as ALU inB
        end
      end
      
      opcode_jalr: begin
        if(funct3==0) begin
          RegWrite    = 1'b1;     // Write to Register File
          RegWrSrc    = 2'd2;     // Choose PC+4 to write to Register File
          ALUOp       = OP_ADD;   // Add ALU OP
          ALUSrc      = 1'b1;     // Choose Immediate as ALU inB
          PCSrc       = 2'd2;     // Choose ALURes to write to PC
        end
      end
      
      //===============================================================================
      // S-TYPE
      //===============================================================================
      
      opcode_sd: begin
        if(funct3==funct3_sd) begin
          ALUSrc      = 1'b1;     // Choose Immediate as ALU inB
          ALUOp       = OP_ADD;   // Add ALU OP
          wr_en       = 1'b1;     // Enable write to Data Memory
        end
      end
      
      //===============================================================================
      // R-TYPE
      //===============================================================================
      opcode_rtype: begin  
          RegWrite    = 1'b1;         // Write to Register File         
          case(funct3) 
              funct3_addsub: begin 
                  if(funct7==funct7_add)    
                      ALUOp = OP_ADD;
                  else if(funct7==funct7_sub)
                      ALUOp = OP_SUB;
              end
              
              funct3_and: begin
                      ALUOp = OP_AND; 
              end
              
              funct3_or: begin 
                      ALUOp = OP_OR; 
              end
              
              funct3_xor: begin 
                      ALUOp = OP_XOR; 
              end
              
              funct3_slt: begin 
                      ALUOp = OP_SLT; 
              end
          endcase
      end
      
      //===============================================================================
      // SB-TYPE
      //===============================================================================
      opcode_sbtype: begin
          Branch = 1'b1;
          if(funct3==funct3_beq) begin
              ALUOp = OP_XOR;
          end
          else if(funct3==funct3_bne) begin
              ALUOp = OP_ISEQ;
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
          ALUOp       = 64;
          ALUSrc      = 0;
          RegWrite    = 0;
          wr_en       = 0;
          wmask       = 0;
      end
    endcase
  end

endmodule // rv64_controller_single_cycle