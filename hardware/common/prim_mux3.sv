module prim_mux3 #(
    parameter   WIDTH   = 64
)(
    input       [WIDTH-1:0]   in0,
    input       [WIDTH-1:0]   in1,
    input       [WIDTH-1:0]   in2,
    input       [1:0]         sel,
    output reg  [WIDTH-1:0]   out
);
    
    always@(*) begin
        case(sel)
            0:  out = in0;
            1:  out = in1;
            2:  out = in2;
            default: out = 0;
        endcase
    end
endmodule