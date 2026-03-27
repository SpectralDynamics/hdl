module sync_filter #(
    parameter FILTER_LEN = 16  // must be stable for 16 cycles
)(
    input  clk,
    input  rst_n,
    input  sig_in,
    output reg sig_out
);
    reg [FILTER_LEN-1:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg <= {FILTER_LEN{1'b1}};  // sync_n is active low
            sig_out   <= 1'b1;
        end else begin
            shift_reg <= {shift_reg[FILTER_LEN-2:0], sig_in};
            if (&shift_reg)        // all 1s — stable high
                sig_out <= 1'b1;
            else if (~|shift_reg)  // all 0s — stable low
                sig_out <= 1'b0;
            // otherwise hold current value — glitch rejected
        end
    end
endmodule