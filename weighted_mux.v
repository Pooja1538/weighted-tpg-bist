module weighted_mux #(
    parameter WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rst,        // IMPORTANT for reset
    input  wire [WIDTH-1:0]     lfsr_out,
    input  wire [2:0]           we,
    input  wire                 we_en,
    output reg  [WIDTH-1:0]     y_w
);

reg [WIDTH-1:0] prev;

// ---------------------------------
// OUTPUT LOGIC (COMBINATIONAL)
// ---------------------------------
always @(*) begin
    if (we_en) begin
        case (we)
            3'd0: y_w = lfsr_out;

            // gradually reuse previous bits
            3'd1: y_w = (lfsr_out & 8'hFE) | (prev & 8'h01);
            3'd2: y_w = (lfsr_out & 8'hFC) | (prev & 8'h03);
            3'd3: y_w = (lfsr_out & 8'hF8) | (prev & 8'h07);
            3'd4: y_w = (lfsr_out & 8'hF0) | (prev & 8'h0F);

            // maximum weighting ? fully previous
            3'd5: y_w = prev;

            default: y_w = lfsr_out;
        endcase
    end else begin
        y_w = lfsr_out;
    end
end

// ---------------------------------
// PREVIOUS VALUE STORAGE (SEQUENTIAL)
// ---------------------------------
always @(posedge clk or posedge rst) begin
    if (rst)
        prev <= {WIDTH{1'b0}};   // ? FIX: initialize to avoid X
    else
        prev <= y_w;
end

endmodule