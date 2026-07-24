module actual_weight #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] data,
    output wire             wa
);
    assign wa = ^data; // XOR reduction (odd=1, even=0)
endmodule