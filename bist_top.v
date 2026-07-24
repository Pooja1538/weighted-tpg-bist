module bist_top #(
    parameter WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire [WIDTH-1:0]     seed,

    output wire [WIDTH-1:0]     signature,

    // DEBUG OUTPUTS (for waveform)
    output wire                we_en_dbg,
    output wire [2:0]          we_dbg,
    output wire [WIDTH-1:0]    lfsr_dbg,

    output wire [WIDTH-1:0]    tpg_out_dbg,
    output wire [WIDTH-1:0]    scan_data_dbg,
    output wire                scan_en_dbg
);

// -----------------------------
// INTERNAL SIGNALS
// -----------------------------
wire [WIDTH-1:0] tpg_out;
wire             we_en;
wire             wa_dbg;

wire scan_en;
wire scan_out;
wire [WIDTH-1:0] scan_data;

// -----------------------------
// TPG
// -----------------------------
weighted_tpg #(WIDTH) tpg_i (
    .clk(clk),
    .rst(rst),
    .seed(seed),

    .y_w(tpg_out),

    // DEBUG FROM TPG
    .lfsr_out_dbg(lfsr_dbg),
    .we_dbg(we_dbg),
    .we_en_dbg(we_en),   // IMPORTANT
    .wa_dbg(wa_dbg)
);

// -----------------------------
// CONTROLLER
// -----------------------------
bist_controller ctrl_i (
    .clk(clk),
    .rst(rst),
    .scan_en(scan_en)
);

// -----------------------------
// SCAN CHAIN (CUT)
// -----------------------------
scan_chain #(WIDTH) sc_i (
    .clk(clk),
    .rst(rst),
    .scan_en(scan_en),
    .scan_in(tpg_out[0]),
    .scan_out(scan_out),
    .data(scan_data)
);

// -----------------------------
// MISR
// -----------------------------
misr #(WIDTH) misr_i (
    .clk(clk),
    .rst(rst),
    .data_in(scan_data),
    .signature(signature)
);

// -----------------------------
// DEBUG ASSIGNMENTS
// -----------------------------
assign tpg_out_dbg   = tpg_out;
assign scan_data_dbg = scan_data;
assign scan_en_dbg   = scan_en;

// expose weight enable
assign we_en_dbg = we_en;

endmodule