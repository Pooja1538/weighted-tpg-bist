module weight_enable_ctrl(
    input  wire clk,
    input  wire rst,
    output reg  we_en
);

reg [2:0] div;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        div   <= 3'd0;
        we_en <= 1'b0;
    end else begin
        div <= div + 1'b1;
        we_en <= div[2];   // stable enable window
    end
end

endmodule