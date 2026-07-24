module bist_controller(
    input  wire clk,
    input  wire rst,
    output reg  scan_en
);

reg [3:0] cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt     <= 4'd0;
        scan_en <= 1'b1; // start in scan
    end else begin
        cnt <= cnt + 1'b1;
        // simple policy: first 8 cycles scan, next 8 capture, repeat
        if (cnt < 4'd8)
            scan_en <= 1'b1;
        else
            scan_en <= 1'b0;
    end
end

endmodule