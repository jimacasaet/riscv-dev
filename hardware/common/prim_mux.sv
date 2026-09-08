module prim_mux #(
  parameter   WIDTH   = 64
)(
  input   [WIDTH-1:0]   in0,
  input   [WIDTH-1:0]   in1,
  input                 sel,
  output  [WIDTH-1:0]   out
);
  logic out_d;

  always_comb begin 
    out_d = (sel) ? in1 : in0;
  end
  
  assign out = out_d;
endmodule