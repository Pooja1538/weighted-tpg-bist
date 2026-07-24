module weight_generator(
    input  wire clk,
    input  wire rst,
    input  wire enable,
    output reg  [2:0] we   // values 0..5
);

// CHANGE THIS VALUE FOR EXPERIMENT
parameter FIXED_WEIGHT = 3'd0;

always @(posedge clk or posedge rst) begin
    if (rst)
        we <= FIXED_WEIGHT;
    else if (enable)
        we <= FIXED_WEIGHT;   // always constant
end


endmodule