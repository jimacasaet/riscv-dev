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
  
  reg [31:0] memdata [0:DATA_DEP-1];
  
  assign rdata = memdata[addr];
  
  initial begin
      `ifdef LDTEST
      $readmemh("ldtest_prog.mem",memdata);
      `elsif ATEST
      $readmemh("arithtest_prog.mem",memdata);
      `elsif BTEST
      $readmemh("brtest_prog.mem",memdata);
      `elsif LTEST
      $readmemh("looptest_prog.mem",memdata);
      `elsif JTEST
      $readmemh("jtest_prog.mem",memdata);
      `elsif PLDTEST
      $readmemh("pldtest_prog.mem",memdata);
      `elsif PATEST
      $readmemh("parithtest_prog.mem",memdata);
      `elsif PBTEST
      $readmemh("pbrtest_prog.mem",memdata);
      `else
      $readmemh("progmem.mem",memdata);
      `endif
  end
      
endmodule : legacy_program_mem
