//------------------------------------------------------------------------------------------------------
//  RV64 Core Single Cycle
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------
module rv64_core_single_cycle
import typedefs_pkg::*;
(
  //==============================
  //  Clocks and resets
  //==============================
  input                       clk_i,
  input                       rst_ni,
  //==============================
  //  Program Memory
  //==============================
  output  [PcWidth-1:0]      pc,
  input   [InstWidth-1:0]    inst,
  //==============================
  //  Data Memory
  //==============================
  output reg [AddrWidth-1:0] addr,
  output                     wr_en,
  output  [WdataWidth-1:0]   wdata,
  output  [WmaskWidth-1:0]   wmask,
  input   [RdataWidth-1:0]   rdata
);
  // Data Mem Address register
  logic [AddrWidth-1:0] addr_d;
  
  //  RegFile to ALU/MUX Wires
  wire    [RdataWidth-1:0]   rd1_o;     // read data 1 to ALU IN A
  wire    [RdataWidth-1:0]   rd2_o  ;        // read data 2 to ALU MUX OR DataMemory
  wire    [RdataWidth-1:0]   mux_to_inB;     // ALU MUX out to ALU IN B 
  wire    [RdataWidth-1:0]   imm;            // Immediate
    
  // MUX (ALURes/Rdata/PC+4) to RegFile
  wire    [RdataWidth-1:0]   mux3_to_RegFile; // ALU/DataMem MUX to RegFile
  
  // ALU
  wire    [DataWidth-1:0]     ALURes;
  wire                        branch_taken_w;
  
  // Control Input Wires
  wire    [OpcodeWidth-1:0]  opcode_w;
  wire    [Funct3Width-1:0]  funct3_w;
  wire    [Funct7Width-1:0]  funct7_w;
  
  // Control Output Wires
  wire                        Branch, MemRead, MemToReg;
  alu_op_e                    ALUOp;
  wire                        ALUSrcA, ALUSrcB, RegWrite;
  wire    [1:0]               RegWrSrc, PCSrc;
  
  // PC Adder/MUX Wires
  wire    [PcWidth-1:0]      pc_plus_4_res;  // Adder 0 Result (PC + 4)
  wire    [PcWidth-1:0]      pc_plus_imm_res;// Adder 1 Result (PC + Branch Immediate)
  wire    [PcWidth-1:0]      pc_plus_jal_res;// Adder 2 Result (PC + JAL Immediate)
  wire    [PcWidth-1:0]      branch_res;     // PC+4 or Branch MUX Result
  wire    [PcWidth-1:0]      branch_imm;     // Sign-extended immediate for branch addr compute
  wire    [PcWidth-1:0]      mux_to_PC;      // MUX output to PC
  wire    [PcWidth-1:0]      const_four;     // Constant 4
  wire    [PcWidth-1:0]      JAL_imm;        // Immediate for JAL to PCSrc
  wire    [PcWidth-1:0]      pc_out;
  
  wire                        branch_sel;     // Select wire for MUX (branch or PC+4)

  
  //==============================
  //  Register File
  //==============================
  rv64_register_file u_rv64_register_file(
    .clk_i            (clk_i          ), 
    .rst_ni           (rst_ni         ),
    .reg_wr_en_i      (RegWrite       ), 
    .reg_wr_data_i    (mux3_to_RegFile),
    .reg_wr_dest_i    (inst[11:7]     ),
    .reg_read_addr1_i (inst[19:15]    ), 
    .reg_read_addr2_i (inst[24:20]    ),
    .reg_read_data1_o (rd1_o          ), 
    .reg_read_data2_o (rd2_o          )
  );
  
  //==============================
  // Immediate Generator
  //==============================
  rv64_imm_gen u_rv64_imm_gen(
    .inst_i (inst ),
    .imm_o  (imm  )
  );
  
  //==============================
  // MUX (RegFile/Immediate to ALU)
  //==============================
  prim_mux I_MUX_REG_TO_ALU(
    .in0(rd2_o  ), 
    .in1(imm    ), 
    .sel(ALUSrcB), 
    .out(mux_to_inB)
  );
  
  //==============================
  //  ALU
  //==============================
  rv64_alu u_rv64_alu(
    .alu_op_i (ALUOp      ), 
    .op_a_i   (rd1_o      ), 
    .op_b_i   (mux_to_inB ),
    .result_o (ALURes     )
  );

  //==============================
  //  Comparator Unit
  //==============================
  rv64_comparator u_comparator(
    .rd1_i         (rd1_o   ),
    .rd2_i         (rd2_o   ),
    .funct3_i      (funct3_w),
    .branch_taken_o(branch_taken_w)
  );
  
  //==============================
  //  MUX3 (ALURes/Rdata/PC+4 To RegFile)
  //==============================
  prim_mux3 u_mux3_regwr(
    .in0(ALURes),
    .in1(rdata),
    .in2({ {PcWidth{pc_plus_4_res[PcWidth-1]}}, pc_plus_4_res}), // sign extend to 64 bits
    .sel(RegWrSrc),
    .out(mux3_to_RegFile)
  );
  
  //==============================
  // ADDER 0
  //==============================
  
  // Set constant to 4
  assign const_four = 32'd4;
  
  prim_add I_ADD_ADDER0(
    .A    (pc_out         ),
    .B    (const_four     ),
    .Sum  (pc_plus_4_res  )
  );
  
  //==============================
  // ADDER 1
  //==============================
  
  // Sign-extended immediate for branch address computation
  // (Must be 32 bits)
  assign branch_imm = { {19{inst[31]}} ,inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
  
  prim_add I_ADD_ADDER1(
    .A  (pc_out         ),
    .B  (branch_imm     ),
    .Sum(pc_plus_imm_res)
  );
  
  //==============================
  // MUX (PC+4 or Branch)
  //==============================
  assign branch_sel = Branch & branch_taken_w;
  
  prim_mux #(PcWidth) u_mux_pc4_branch(
    .in0(pc_plus_4_res      ), 
    .in1(pc_plus_imm_res    ), 
    .sel(branch_sel         ), 
    .out(branch_res         )
  );
    
  //==============================
  // ADDER 2
  //==============================
  
  // JAL Immediate field
  // sign-extended, 32 bits
  assign JAL_imm = { {11{inst[31]}} ,inst[31],inst[19:12],inst[20],inst[30:21],1'b0} ;
  
  prim_add I_ADD_ADDER2(
    .A  (pc_out         ),
    .B  (JAL_imm        ),
    .Sum(pc_plus_jal_res)
  );     
  
  //==============================
  // MUX3 (To PC)
  //==============================
  prim_mux3 #(PcWidth) u_mux3_to_pc (
    .in0(branch_res),
    .in1(pc_plus_jal_res),
    .in2(ALURes[PcWidth-1:0]),
    .sel(PCSrc),
    .out(mux_to_PC)
  );
  //==============================
  //  ProgramCounter
  //==============================
  rv64_pc_reg u_rv64_pc_reg(
    .clk_i    (clk_i      ), 
    .rst_ni   (rst_ni     ),
    .next_i   (mux_to_PC  ), 
    .current_o(pc_out     )
  );
  
  //==============================
  //  Control Input Wires
  //==============================
  assign  opcode_w = inst[6:0];
  assign  funct3_w = inst[14:12];
  assign  funct7_w = inst[31:25];
  
  //==============================
  //  Control
  //==============================
  rv64_controller_single_cycle u_rv64_controller(
    .opcode(opcode_w), 
    .funct3(funct3_w), 
    .funct7(funct7_w),
    .Branch(Branch), 
    .MemRead(MemRead),
    .PCSrc(PCSrc), 
    .RegWrSrc(RegWrSrc),
    .ALUOp(ALUOp), 
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB), 
    .RegWrite(RegWrite),
    .wr_en(wr_en), 
    .wmask(wmask)
  );

  //==============================
  //  Data Mem Address
  //==============================
  always@(*) begin
    if(!rst_ni) 
      addr_d = 0;
    else
      addr_d = ALURes[AddrWidth-1:0];
  end
  
  //==============================
  // Processor Outputs
  //==============================
  assign pc = pc_out[PcWidth-1:0];
  assign addr  = addr_d;
  assign wdata = rd2_o  ;
  
  

endmodule // rv64_core_single_cycle