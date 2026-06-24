module prim_add #(
    parameter   WIDTH   = 32
)(
    input   [WIDTH-1:0] A,
    input   [WIDTH-1:0] B,
    output  [WIDTH-1:0] Sum,
    output              Cout
);
    assign {Cout,Sum} = A + B;
    
endmodule