// dac_sync_strobe: generate the DAC conversion trigger at 262144, PHASE-LOCKED
// to the ADC data-valid so the DAC output stays synchronized to the ADC
// acquisition (closed-loop DAQ requirement).
//
// adc_clk is the AD7768 FMC-card clock (clk_in port, declared 33.554432 MHz = 2^25).
// It is FIXED (crystal on the FMC daughtercard); the client sample rate is set by
// AD7768 decimation, which changes adc_valid, NOT adc_clk. 2^25 / 128 = 262144
// exactly, so a /128 counter realigned by adc_valid emits exactly
// N = 262144/client_rate evenly-spaced, ADC-locked DAC triggers per ADC sample.
//
// dac_trigger = the ungated adc_clk/128 strobe (262144), which drains the interp
// FIFO and starts each SPI conversion. It is NOT gated by fifo_valid: gating with
// fifo_valid clamped the DAC to the client rate (fifo_valid only pulses at the
// client rate, because a slow drain backs up the FIFO and backpressures the FIR).
// Draining unconditionally at 262144 keeps the FIFO fed, so it stays at 262144.
// dac_trigger_raw is the same signal, kept as a separate port for ILA visibility.
// Both are in the dst_clk (sys_cpu_clk / SPI-engine) domain.
`timescale 1ns/1ps
module dac_sync_strobe (
  input  wire adc_clk,
  input  wire adc_rstn,
  input  wire adc_valid,     // ADC data valid (client sample rate)
  input  wire dst_clk,       // sys_cpu_clk (DAC / SPI engine domain)
  input  wire dst_rstn,
  input  wire fifo_valid,    // interpolator output FIFO has data
  output wire dac_trigger,
  output wire dac_trigger_raw
);
  // ---- adc_clk domain: /128 strobe, realigned every adc_valid ----
  reg [6:0] cnt  = 7'd0;
  reg       trig = 1'b0;
  always @(posedge adc_clk) begin
    if (!adc_rstn) begin
      cnt <= 7'd0; trig <= 1'b0;
    end else if (adc_valid) begin
      cnt <= 7'd0; trig <= 1'b1;          // realign + emit on each ADC sample
    end else if (cnt == 7'd127) begin
      cnt <= 7'd0; trig <= 1'b1;          // and every 128 cycles between
    end else begin
      cnt <= cnt + 7'd1; trig <= 1'b0;
    end
  end

  // ---- toggle-based pulse CDC into dst_clk ----
  reg tog = 1'b0;
  always @(posedge adc_clk) begin
    if (!adc_rstn) tog <= 1'b0;
    else if (trig) tog <= ~tog;
  end

  reg [2:0] sync  = 3'd0;
  reg       dtrig = 1'b0;
  reg       draw  = 1'b0;
  always @(posedge dst_clk) begin
    if (!dst_rstn) begin
      sync <= 3'd0; dtrig <= 1'b0; draw <= 1'b0;
    end else begin
      sync  <= {sync[1:0], tog};
      draw  <= (sync[2] ^ sync[1]);                // ungated strobe (adc_clk/128 = 262144)
      dtrig <= (sync[2] ^ sync[1]);                // UNGATED: fifo_valid gate removed
    end
  end

  assign dac_trigger     = dtrig;
  assign dac_trigger_raw = draw;
endmodule
