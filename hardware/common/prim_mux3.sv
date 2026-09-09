module prim_mux3 #(
    parameter   WIDTH   = 64
)(
    input       [WIDTH-1:0]   in0,
    input       [WIDTH-1:0]   in1,
    input       [WIDTH-1:0]   in2,
    input       [1:0]         sel,
    output      [WIDTH-1:0]   out
);
  logic [WIDTH-1:0] out_d;  
  always_comb begin
    case(sel)
      0:  out_d = in0;
      1:  out_d = in1;
      2:  out_d = in2;
      default: out_d = 0;
    endcase
  end
  assign out = out_d;
endmodule