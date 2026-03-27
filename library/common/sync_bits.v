module sync_bits #(
  parameter NUM_OF_BITS = 1,
  parameter ASYNC_CLK = 1
) (
  input  [NUM_OF_BITS-1:0] in_bits,
  input                    out_resetn,
  input                    out_clk,
  output [NUM_OF_BITS-1:0] out_bits
);

  (* ASYNC_REG = "TRUE" *) reg [NUM_OF_BITS-1:0] cdc_sync_stage1;
  (* ASYNC_REG = "TRUE" *) reg [NUM_OF_BITS-1:0] cdc_sync_stage2;

  always @(posedge out_clk) begin
    if (out_resetn == 1'b0) begin
      cdc_sync_stage1 <= {NUM_OF_BITS{1'b0}};
      cdc_sync_stage2 <= {NUM_OF_BITS{1'b0}};
    end else begin
      cdc_sync_stage1 <= in_bits;
      cdc_sync_stage2 <= cdc_sync_stage1;
    end
  end

  assign out_bits = cdc_sync_stage2;

endmodule