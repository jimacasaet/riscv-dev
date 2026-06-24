//------------------------------------------------------------------------------------------------------
//  Register File
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_register_file #(
  parameter     DataWidth    = 64,              
  parameter     NumReg       = 32,              
  localparam    AddressWidth = $clog2(NumReg)
)(
  input                       clk_i,
  input                       rst_ni,
  input                       reg_wr_en_i,
  input   [   DataWidth-1:0]  reg_wr_data_i,   
  input   [AddressWidth-1:0]  reg_wr_dest_i,    
  input   [AddressWidth-1:0]  reg_read_addr1_i, 
  input   [AddressWidth-1:0]  reg_read_addr2_i,
  output  [DataWidth-1:0]     reg_read_data1_o, 
  output  [DataWidth-1:0]     reg_read_data2_o
);
  integer i;
  reg [DataWidth-1:0] register_file [0:NumReg-1];
    
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni)
      for (i=0; i < NumReg; i = i+1) begin
        register_file[i] <= 0;
      end
    else
      if(reg_wr_en_i && reg_wr_dest_i > 0)
        register_file[reg_wr_dest_i] <= reg_wr_data_i;
  end

  assign    reg_read_data1_o = register_file[reg_read_addr1_i];
  assign    reg_read_data2_o = register_file[reg_read_addr2_i];

endmodule