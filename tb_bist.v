`timescale 1ns/1ps

module tb_bist;

parameter WIDTH = 8;

reg clk;
reg rst;
reg [WIDTH-1:0] seed;

wire [WIDTH-1:0] signature;
wire [WIDTH-1:0] tpg_out_dbg;
wire [WIDTH-1:0] scan_data_dbg;
wire scan_en_dbg;

// DEBUG SIGNALS (must be exposed from bist_top)
wire we_en_dbg;
wire [2:0] we_dbg;
wire [WIDTH-1:0] lfsr_dbg;

// -----------------------------
// RESULT VARIABLES (DECLARE HERE)
// -----------------------------
integer ones_norm, ones_weight;
integer trans_norm, trans_weight;
integer cycles_norm, cycles_weight;

reg [7:0] prev_norm, prev_weight;

// REAL values (MUST be outside initial)
real avg_ones_norm, avg_ones_weight;
real avg_trans_norm, avg_trans_weight;
real reduction;

// -----------------------------
// DUT
// -----------------------------
bist_top #(WIDTH) dut (
    .clk(clk),
    .rst(rst),
    .seed(seed),
    .signature(signature),
    .tpg_out_dbg(tpg_out_dbg),
    .scan_data_dbg(scan_data_dbg),
    .scan_en_dbg(scan_en_dbg),

    // debug connections
    .we_en_dbg(we_en_dbg),
    .we_dbg(we_dbg),
    .lfsr_dbg(lfsr_dbg)
);

// -----------------------------
// CLOCK
// -----------------------------
always #5 clk = ~clk;

// -----------------------------
// COUNT ONES FUNCTION
// -----------------------------
function integer count_ones;
    input [7:0] value;
    integer i;
    begin
        count_ones = 0;
        for (i = 0; i < 8; i = i + 1)
            if (value[i]) count_ones = count_ones + 1;
    end
endfunction

// -----------------------------
// INIT
// -----------------------------
initial begin
    clk  = 0;
    rst  = 1;
    seed = 8'b10101101;

    ones_norm = 0; ones_weight = 0;
    trans_norm = 0; trans_weight = 0;
    cycles_norm = 0; cycles_weight = 0;

    prev_norm = 0;
    prev_weight = 0;

    // reset
    #15 rst = 0;

    // run
    // change seed
    #200;
    rst = 1;
    seed = 8'b11001010;
    #10;
    rst = 0;
    #200
    // -----------------------------
    // CALCULATIONS
    // -----------------------------
    avg_ones_norm  = ones_norm  * 1.0 / cycles_norm;
    avg_trans_norm = trans_norm * 1.0 / cycles_norm;

    avg_ones_weight  = ones_weight  * 1.0 / cycles_weight;
    avg_trans_weight = trans_weight * 1.0 / cycles_weight;

    reduction = ((avg_trans_norm - avg_trans_weight) / avg_trans_norm) * 100.0;

    // -----------------------------
    // PRINT RESULTS
    // -----------------------------
    $display("\n===============================");
    $display("   WEIGHTED TPG ANALYSIS");
    $display("===============================");

    $display("\nNORMAL MODE:");
    $display("  Avg Ones        = %f", avg_ones_norm);
    $display("  Avg Transitions = %f", avg_trans_norm);

    $display("\nWEIGHTED MODE:");
    $display("  Avg Ones        = %f", avg_ones_weight);
    $display("  Avg Transitions = %f", avg_trans_weight);

    $display("\nSWITCHING ACTIVITY REDUCTION:");
    $display("  Reduction = %f %%", reduction);

    $display("\n===============================");
    $display("COMPARISON TABLE");
    $display("===============================");
    $display("Metric          Normal      Weighted");
    $display("Ones           %f     %f", avg_ones_norm, avg_ones_weight);
    $display("Transitions    %f     %f", avg_trans_norm, avg_trans_weight);
    $display("===============================\n");
    



    $finish;
end



// -----------------------------
// MEASUREMENT LOGIC
// -----------------------------
always @(posedge clk) begin
    if (we_en_dbg) begin
        ones_weight  = ones_weight + count_ones(tpg_out_dbg);
        trans_weight = trans_weight + count_ones(tpg_out_dbg ^ prev_weight);
        cycles_weight = cycles_weight + 1;
        prev_weight = tpg_out_dbg;
    end else begin
        ones_norm  = ones_norm + count_ones(tpg_out_dbg);
        trans_norm = trans_norm + count_ones(tpg_out_dbg ^ prev_norm);
        cycles_norm = cycles_norm + 1;
        prev_norm = tpg_out_dbg;
    end
end

// -----------------------------
// MONITOR (for waveform understanding)
// -----------------------------
initial begin
    $monitor("t=%0t | WE_EN=%b | WE=%d | LFSR=%h | TPG=%h | SIG=%h",
             $time, we_en_dbg, we_dbg, lfsr_dbg, tpg_out_dbg, signature);
end

endmodule