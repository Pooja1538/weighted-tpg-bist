module misr #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] signature
);

integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        signature <= {WIDTH{1'b0}};
    end else begin
        signature[0] <= data_in[0] ^ signature[WIDTH-1];
        for (i = 1; i < WIDTH; i = i + 1) begin
            signature[i] <= data_in[i] ^ signature[i-1];
        end
    end
end

endmodule