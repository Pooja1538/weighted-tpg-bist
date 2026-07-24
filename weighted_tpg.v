module weighted_tpg #(
    parameter WIDTH = 8
)(
    input  wire                 clk,
    
    input  wire                 rst,
    input  wire [WIDTH-1:0]     seed,

    output wire [WIDTH-1:0]     y_w,

    // DEBUG OUTPUTS
    output wire [WIDTH-1:0]     lfsr_out_dbg,
    output wire [2:0]           we_dbg,
    output wire                 wa_dbg,
    output wire                 we_en_dbg   // NEW
);

// -----------------------------
// INTERNAL SIGNALS
// -----------------------------
wire [WIDTH-1:0] lfsr_state;
wire             we_en;
wire [2:0]       we;
wire             wa;

// -----------------------------
// LFSR
// -----------------------------
galois_lfsr #(WIDTH) lfsr_i (
    .clk(clk),
    .rst(rst),
    .enable(1'b1),
    .seed(seed),
    .state(lfsr_state)
);

// -----------------------------
// WE ENABLE
// -----------------------------
weight_enable_ctrl wec_i (
    .clk(clk),
    .rst(rst),
    .we_en(we_en)
);

// -----------------------------
// WE GENERATOR
// -----------------------------
weight_generator wg_i (
    .clk(clk),
    .rst(rst),
    .enable(we_en),
    .we(we)
);

// -----------------------------
// ACTUAL WEIGHT (optional logic)
// -----------------------------
actual_weight #(WIDTH) aw_i (
    .data(lfsr_state),
    .wa(wa)
);

// -----------------------------
// WEIGHTED MUX (IMPORTANT FIX)
// -----------------------------
weighted_mux #(WIDTH) wm_i (
    .clk(clk),
    .rst(rst), 
    .lfsr_out(lfsr_state),
    .we(we),                // ADD THIS
    .we_en(we_en),          // ADD THIS
    .y_w(y_w)
);

// -----------------------------
// DEBUG SIGNALS
// -----------------------------
assign lfsr_out_dbg = lfsr_state;
assign we_dbg       = we;
assign wa_dbg       = wa;
assign we_en_dbg    = we_en;   // VERY IMPORTANT

endmodule