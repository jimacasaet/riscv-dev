//------------------------------------------------------------------------------------------------------
//  RV64 Core Single Cycle Testbench (Legacy)
//
//  Import Date : 2026-06-25 (Created 2022)
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_single_cycle_tb_legacy();

    parameter PC_WIDTH = 32;
    parameter DATA_WID = 64;
    parameter ADDR_WID = 32;
    parameter DM_ADD_W = 29;    // Data Memory Addr Width
    parameter PM_ADD_W = 30;    // Program Memory Addr Width

    logic                clk, nrst;
    logic [PC_WIDTH-1:0] inst;
    logic [ADDR_WID-1:0] pc;
    logic [DATA_WID-1:0] wdata, rdata;
    logic [ADDR_WID-1:0] addr;
    logic                wr_en;
    logic [7:0]          wmask;

    rv64_core_single_cycle i_rv64_core_single(
        .clk_i  (clk    ), 
        .rst_ni (nrst   ),
        .pc     (pc     ), 
        .inst   (inst   ),
        .addr   (addr   ), 
        .wr_en  (wr_en  ), 
        .wdata  (wdata  ),
        .wmask  (wmask  ), 
        .rdata  (rdata  )
    );
    
    legacy_data_mem i_data_mem(
        .clk  (clk                                ),
        .addr (addr[ADDR_WID-1:ADDR_WID-DM_ADD_W] ), 
        .wr_en(wr_en                              ),
        .wdata(wdata                              ), 
        .wmask(wmask                              ),
        .rdata(rdata                              )
    );
    
    legacy_program_mem i_program_mem(
        .addr (pc[ADDR_WID-1:ADDR_WID-PM_ADD_W]), 
        .rdata(inst                            )
    );
    
    // Clock generation
    initial clk=0;
    always begin #10; clk = !clk; end
    
    // Stimulus
    initial begin
        nrst    = 1'b0;
        @(negedge clk);
        nrst    = 1'b1;
        @(posedge clk);
        repeat(180) @(posedge clk);

        $finish;
    end

    // Dump
    initial begin
      `ifdef VCS
        // $vcdplusfile("dump.vpd");
        // $vcdpluson();
        // $vcdplusmemon();
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0, "+mda"); 
      `elsif XCELIUM begin
        $recordfile("dump.trn");
        $recordvars();
      end
      `else begin
        $dumpfile("dump.vcd");
        $dumpvars();
      end
      `endif

    end

endmodule : rv64_single_cycle_tb_legacy
