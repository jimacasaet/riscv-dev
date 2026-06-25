//------------------------------------------------------------------------------------------------------
//  Program Memory Model (Legacy)
//
//  Import Date : 2026-06-25 (Created 2022)
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------
module legacy_program_mem#(
  parameter DATA_DEP = 20, 
  parameter ADDR_WID = 30   
)(
  input   [ADDR_WID-1:0]  addr,
  output  [31:0]          rdata
);
  string     memprog_file;
  reg [31:0] memdata [0:DATA_DEP-1];
  
  assign rdata = memdata[addr];
  
  initial begin
    if($value$plusargs("MEMPROG=%s", memprog_file))
      $readmemh(memprog_file, memdata);
    else
      $fatal("Program memory data file not specified. Use +MEMPROG=<path_to_file>");
  end
      
endmodule : legacy_program_mem
