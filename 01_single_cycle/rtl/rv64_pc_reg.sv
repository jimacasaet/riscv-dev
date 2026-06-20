//------------------------------------------------------------------------------------------------------
//  Program Counter
//
//  Create Date : 2026-05-29
//  Author      : John Rufino Macasaet
//  E-Mail      : macasaetjohn@gmail.com
//------------------------------------------------------------------------------------------------------

module rv64_pc_reg #(
    parameter   PcWidth = 32
)(
    input                       clk_i,
    input                       rst_ni,
    input      [PcWidth-1:0]    next_i,
    output     [PcWidth-1:0]    current_o
);

  logic current_d;

  always@(posedge clk_i) begin
    if(!rst_ni) current_d <= 0;
    else        current_d <= next_i;
  end

  assign current_o = current_d;

endmodule // rv64_pc_reg