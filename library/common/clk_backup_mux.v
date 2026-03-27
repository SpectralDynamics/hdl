// clk_backup_mux.v
//
// Automatic clock backup mux for ad7768evb_zed design.
//
// When clk_in (FMC card clock, 33.554432 MHz) is present, it is passed through
// to clk_out via a glitch-free BUFGMUX_CTRL.  When the FMC card is removed and
// clk_in stops toggling, the mux automatically falls back to clk_backup
// (FCLK_CLK2, 33.3333 MHz) so the FPGA continues to boot and operate.
//
// Inputs
//   clk_in     - primary clock from FMC J3 connector (may be absent)
//   clk_backup - backup clock, connect to sys_ps7/FCLK_CLK2 (33.333 MHz)
//   ref_clk    - reference clock for presence detection; connect to
//                sys_ps7/FCLK_CLK0 (100 MHz)
// Output
//   clk_out    - muxed clock output
//
// Detection logic
//   A toggle flip-flop in the clk_in domain is sampled by ref_clk through
//   a 2-stage synchroniser.  A 16-bit watchdog counter resets whenever a
//   transition is observed.  If no transition occurs within 2^16 = 65 536
//   ref_clk cycles (~655 µs @ 100 MHz, well below any reasonable timeout),
//   clk_present is de-asserted and the mux switches to clk_backup.
//   BUFGMUX_CTRL performs a glitch-free clock switch on a safe edge.
//
// X_INTERFACE attributes teach Vivado BD the clock types and frequencies
// so that FREQ_HZ propagates correctly through module references into
// downstream IPs (HLS ap_clk, AXI interconnect couplers, etc.)

`timescale 1ns / 1ps

module clk_backup_mux (
    // Primary clock input from FMC card (33.554432 MHz, may be absent)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_in CLK" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 33554432, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN clk_in" *)
    input  wire clk_in,

    // Backup clock - always present, connect to FCLK_CLK2 (33.333 MHz)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_backup CLK" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 33333333, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN clk_backup" *)
    input  wire clk_backup,

    // Reference clock for presence detection - connect to FCLK_CLK0 (100 MHz)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ref_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN ref_clk" *)
    input  wire ref_clk,

    // Muxed clock output - 33.554432 MHz when clk_in present, 33.333 MHz otherwise
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_out CLK" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 33554432, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN clk_out" *)
    output wire clk_out
);

    // -----------------------------------------------------------------------
    // 1.  Toggle flip-flop clocked by clk_in
    //     Registers with no reset are used deliberately: a floating clk_in
    //     may cause spurious toggles, but the watchdog window is long enough
    //     that sustained, coherent toggling (i.e. a real clock) is the only
    //     way to keep clk_present asserted.
    // -----------------------------------------------------------------------
    (* KEEP = "TRUE" *) reg toggle_clkin = 1'b0;
    always @(posedge clk_in) toggle_clkin <= ~toggle_clkin;

    // -----------------------------------------------------------------------
    // 2.  Two-stage synchroniser into ref_clk domain
    // -----------------------------------------------------------------------
    (* ASYNC_REG = "TRUE" *) reg sync0 = 1'b0;
    (* ASYNC_REG = "TRUE" *) reg sync1 = 1'b0;
    always @(posedge ref_clk) begin
        sync0 <= toggle_clkin;
        sync1 <= sync0;
    end

    // -----------------------------------------------------------------------
    // 3.  Watchdog presence detector (ref_clk domain)
    // -----------------------------------------------------------------------
    reg        last_sync   = 1'b0;
    reg [15:0] watchdog    = 16'd0;
    reg        clk_present = 1'b0;   // 1 ? clk_in running; 0 ? use backup

    always @(posedge ref_clk) begin
        last_sync <= sync1;
        if (sync1 != last_sync) begin
            // Edge detected - clock is alive
            watchdog    <= 16'd0;
            clk_present <= 1'b1;
        end else if (watchdog == 16'hFFFF) begin
            // Timeout - clock has stopped
            clk_present <= 1'b0;
        end else begin
            watchdog <= watchdog + 1'b1;
        end
    end

    // -----------------------------------------------------------------------
    // 4.  Glitch-free clock mux
    //     I0=clk_backup (FCLK_CLK2), I1=clk_in (FMC)
    //     S=1 ? I1 (clk_in) when present
    //     S=0 ? I0 (clk_backup) when absent
    //     I0 is on the cascade path from BUFGCTRL_X0Y20 ? X0Y19
    // -----------------------------------------------------------------------
    BUFGMUX_CTRL clk_mux_i (
        .O  (clk_out),
        .I0 (clk_backup),   // FCLK_CLK2 on I0 - uses cascade routing
        .I1 (clk_in),       // FMC clk on I1  - uses CCIO routing
        .S  (clk_present)   // 1=clk_in, 0=backup
    );

endmodule
