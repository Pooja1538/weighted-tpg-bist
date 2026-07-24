module galois_lfsr #(
    parameter WIDTH = 8,
    // Example primitive poly taps for WIDTH=8: x^8 + x^6 + x^5 + x^4 + 1
    parameter [WIDTH-1:0] TAPS = 8'b01110000
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 enable,
    input  wire [WIDTH-1:0]     seed,
    output reg  [WIDTH-1:0]     state
);

integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= seed;
    end else if (enable) begin
        // Galois style shift
        state[0] <= state[WIDTH-1];
        for (i = 1; i < WIDTH; i = i + 1) begin
            if (TAPS[i])
                state[i] <= state[i-1] ^ state[WIDTH-1];
            else
                state[i] <= state[i-1];
        end
    end
end

endmodule