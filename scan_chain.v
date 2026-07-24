module scan_chain #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             scan_en,
    input  wire             scan_in,
    output reg              scan_out,
    output reg [WIDTH-1:0]  data
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data     <= {WIDTH{1'b0}};
        scan_out <= 1'b0;
    end else if (scan_en) begin
        data     <= {data[WIDTH-2:0], scan_in};
        scan_out <= data[WIDTH-1];
    end
end

endmodule