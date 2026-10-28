`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Spectral Dynamics
// Module Name: DacStartGate
//
// Purpose
// -------
// Give the DAC datapath the same hardware start gate the ADC datapath already
// has, so that multiple Panther boards begin playing DAC sample 0 on the same
// external sync edge.
//
// Today the ADC gets cross-board alignment from a hardware AND gate:
//
//     util_ad7768_adc_pack/packed_fifo_wr_sync -> util_vector_logic_1/Op1 --+
//     Synch_0/ap_return (bStarted latch)       -> util_vector_logic_1/Op2 --+-> ad7768_dma_2/fifo_wr_sync
//
// Software only *arms*; the sync_n edge decides t=0. The DAC path has no such
// gate -- its start is decided by when the kernel issues the DMA (the sentinel
// rendezvous in industrialio-buffer-dmaengine.c), which carries IRQ and
// scheduler jitter. One DAC sample at 262144 Sa/s is 3.8 us, far below that
// jitter, so software can never align DACs across boards. This module supplies
// the missing gate.
//
// Clock domains -- IMPORTANT
// --------------------------
// fifo_generator_1 (the DAC DMA FIFO) is a CDC:
//     wr_clk = spi_dma_clk  (PS domain; same domain as `trigger`)
//     rd_clk = axi_ad7768_adc_adc_clk
// The two things we must gate therefore live in DIFFERENT domains:
//     spi/dma_enable         sampled at posedge dma_clk  (axi_ad5766.v:292)
//     fifo_generator_1/rd_en sampled at posedge adc_clk
// so this module runs a small FSM in each domain and synchronises between them.
//
// Why gate dma_enable at all
// --------------------------
// axi_ad5766.v:292 generates dma_valid (-> axi_ad5766_dac_dma/fifo_rd_en) from
// `trigger` alone -- NOT from dac_trigger and NOT from FIFO occupancy:
//     if ((trigger) && !doDMAPulse && dma_enable && spi_enable_s) dma_valid <= 1;
// There is no back-pressure. Stalling only the read side would overflow
// fifo_generator_1 (512 deep, prog-full 493) within 512 sample periods. Holding
// dma_enable low stops the DMA being read at all, so the arm window is
// unbounded and the DMA keeps its position -- sample 0 stays sample 0.
//
// NOTE: this gates dma_enable, NOT fifo_rd_xfer_req. Gating xfer_req is what
// produced the fs/blocksize comb in the old DacGate. Different mechanism.
//
// Why prefill
// -----------
// If the read side opened with an empty FIFO, the first sample's arrival would
// depend on DMA response time plus FIFO CDC latency -- a few adc_clk of
// board-to-board variation. Instead we preload PREFILL_DEPTH samples while
// held, then open the read side on a deterministic adc_clk edge derived from
// sync_in. The prefill becomes a fixed latency offset that is IDENTICAL on
// every board, so it does not disturb alignment.
//
// Sequence
// --------
//   IDLE     : dma_en=0, rd_en=1  -- any residue from a previous run drains out
//   HOLD_RD  : rd_en=0            -- close read side first, let it cross domains
//   PREFILL  : dma_en=1 until PREFILL_DEPTH triggers counted, then dma_en=0
//   WAIT_SYNC: both closed, FIFO holding exactly PREFILL_DEPTH samples
//   RUN      : on sync_in rising edge -> rd_en=1 (adc domain, deterministic
//              edge) and dma_en=1 (dma domain). Steady state is then identical
//              to today's free-running behaviour.
//
// Deliberately NOT done here
// --------------------------
//  * No fifo_generator_1/rst. Resetting a dual-clock FIFO Generator mid-run
//    needs wr_rst_busy/rd_rst_busy handling and is risky. Draining in IDLE
//    (dma_en=0, rd_en=1) achieves an empty FIFO safely.
//  * Synch_0 is not touched. Its init-order dependency is load-bearing for the
//    ADC path and the BD wires ap_return, not bSynch.
//
// Control is via spare PS EMIO GPIO rather than a new AXI-Lite slave, matching
// how reset_n is already done (system_top.v: assign reset_n = gpio_o[32]).
// gpio_o[33] is free -- start_n is tied off to 1'b1.
//
// STATUS: NOT YET SYNTHESISED OR HARDWARE-TESTED. Written 2026-08-24.
//////////////////////////////////////////////////////////////////////////////////

module DacStartGate #(
  // Samples preloaded into fifo_generator_1 before release. Must stay well
  // under the FIFO's prog-full threshold (493 of 512). Larger = more margin
  // against underrun on release, at the cost of a fixed added latency of
  // PREFILL_DEPTH client samples (16 @ 65536 Sa/s ~= 244 us).
  parameter integer PREFILL_DEPTH = 16,
  // 0 = the sync trigger ALWAYS starts the output (project requirement). If the
  // prefill completed, the run begins with the prefilled samples; if it did not,
  // the read side opens anyway and the DAC emits whatever fifo_generator_1
  // currently holds. 1 = the original fail-closed policy, where an edge
  // arriving mid-prefill is ignored by both domains.
  //   CONSEQUENCE of 0: sample 0 of a non-prefilled start is timed by DMA
  //   response, not by the sync edge, so cross-board alignment is guaranteed
  //   only for runs reporting prefilled_o=1 together with started_o=1.
  //   Also the FIRST edge after arm now releases -- including a setup-induced
  //   edge from a sampling-frequency or filter write -- so those writes must
  //   happen BEFORE the DAC buffer is enabled.
  parameter integer REQUIRE_PREFILL = 0,
  // Cycles to wait after closing the read side before starting prefill, so
  // rd_en=0 has certainly crossed into the adc_clk domain. 64 dma_clk is far
  // more than the 2-FF synchroniser needs.
  parameter integer RD_CLOSE_WAIT = 64
)(
  // ---- asynchronous external sync -------------------------------------------
  // Drive from util_vector_logic_0/Res, i.e. the already-inverted sync_n that
  // also feeds Synch_0/spiSync. Rising edge = sync event.
  input  wire        sync_in,

  // ---- PS / DMA domain (spi_dma_clk) ----------------------------------------
  input  wire        dma_clk,
  input  wire        dma_resetn,
  // Prefill counter source. MUST be the actual FIFO write strobe
  // (axi_ad5766_dac_dma/fifo_rd_valid -> fifo_generator_1/wr_en), NOT the
  // `trigger` sample strobe. axi_ad5766.v:292 qualifies dma_valid with
  // dma_xfer_req AND spi_enable_s as well as trigger, so trigger can be pulsing
  // while no data moves at all -- counting it would declare prefill complete
  // with an EMPTY FIFO and silently reintroduce the nondeterministic start that
  // prefill exists to prevent. Counting real writes also makes the FSM
  // self-correcting: if the DMA is not streaming yet, fill_cnt simply does not
  // advance and the gate waits in PREFILL until data actually arrives, which in
  // turn makes the software arm point forgiving.
  input  wire        dma_wr_valid,
  output wire        dma_enable_o,   // -> spi/dma_enable  (was xlconstant_1)
  // Cola stream (spi1 / axi_ad5441_dma). spi1/dma_clk is the same clock as
  // dma_clk (both are spi_clk = sys_cpu_clk), so no synchroniser is needed.
  input  wire        cola_wr_valid,     // axi_ad5441_dma/fifo_rd_valid -> fifo_generator_3/wr_en
  output wire        cola_dma_enable_o, // -> spi1/dma_enable (was dma_enable_o)

  // ---- ADC clock domain -----------------------------------------------------
  input  wire        adc_clk,
  input  wire        adc_resetn,
  output wire        fifo_rd_en_o,   // -> fifo_generator_1/rd_en (was xlconstant_1)
  // -> cola_rd_or/Op2, ORed with fifo_generator_1/valid into fifo_generator_3/rd_en.
  // High while disarmed so the cola FIFO drains between runs (see the end of file).
  output wire        cola_drain_o,

  // ---- control, from PS EMIO GPIO (gpio_o) ----------------------------------
  input  wire        arm,            // 0->1 arms the gate; 0 returns to IDLE
  input  wire        bypass,         // 1 = legacy behaviour, both gates forced open

  // ---- status, to PS EMIO GPIO (gpio_i) -------------------------------------
  output wire        armed_o,
  output wire        prefilled_o,
  output wire        started_o,
  output wire [15:0] sync_count_o    // sync edges seen, for bring-up debug
);

  localparam [2:0] S_IDLE      = 3'd0,
                   S_HOLD_RD   = 3'd1,
                   S_PREFILL   = 3'd2,
                   S_WAIT_SYNC = 3'd3,
                   S_RUN       = 3'd4;

  //---------------------------------------------------------------------------
  // DMA / PS clock domain
  //---------------------------------------------------------------------------
  reg [2:0]  dstate;
  reg        dma_en_r;
  reg [15:0] fill_cnt;
  reg [15:0] wait_cnt;
  reg [15:0] sync_cnt;
  // Latched at release: 1 if the run started out of S_WAIT_SYNC (a full
  // prefill), 0 if it was released from S_HOLD_RD/S_PREFILL because
  // REQUIRE_PREFILL=0. Drives prefilled_o during S_RUN, because a live dstate
  // decode cannot tell the two apart -- S_RUN looks identical either way.
  reg        prefill_was_done_d;

  // Driven by the adc_clk domain further down, but declared here because the
  // dma_clk block below samples it through rel_sync_d. Keeping the declaration
  // ahead of first use avoids Synth 8-6901 and tools stricter than Vivado.
  reg       running_a;

  // 2-FF synchronisers into dma_clk
  reg [1:0] arm_sync_d, byp_sync_d, sync_in_d, rel_sync_d;
  reg       sync_in_q;
  wire      arm_d    = arm_sync_d[1];
  wire      bypass_d = byp_sync_d[1];
  wire      sync_rise_d = sync_in_d[1] & ~sync_in_q;

  // Prefill-done, exported to the adc_clk domain to qualify its release
  // decision. Covers S_RUN as well as S_WAIT_SYNC so it does not deassert
  // underneath the edge being qualified.
  wire      prefill_done_d = (dstate == S_WAIT_SYNC) || (dstate == S_RUN);

  // The adc_clk domain's release latch, crossed back. This domain FOLLOWS that
  // decision instead of detecting the sync edge itself, so the two domains
  // cannot disagree about whether a release happened.
  wire      released_d = rel_sync_d[1];

  always @(posedge dma_clk) begin
    if (!dma_resetn) begin
      arm_sync_d <= 2'b00;
      // FAIL-SAFE: bypass resets to 1, so the gate is transparent out of reset
      // and stays transparent through the 2-FF synchroniser delay, before the
      // PS has configured axi_gpio_dacgate at all. Combined with the gpio's
      // C_DOUT_DEFAULT=0x2, bypass is the power-on state in both places.
      byp_sync_d <= 2'b11;
      sync_in_d  <= 2'b00;
      rel_sync_d <= 2'b00;
      sync_in_q  <= 1'b0;
    end else begin
      arm_sync_d <= {arm_sync_d[0], arm};
      byp_sync_d <= {byp_sync_d[0], bypass};
      sync_in_d  <= {sync_in_d[0],  sync_in};
      rel_sync_d <= {rel_sync_d[0], running_a};
      sync_in_q  <= sync_in_d[1];
    end
  end

  always @(posedge dma_clk) begin
    if (!dma_resetn) begin
      dstate   <= S_IDLE;
      dma_en_r <= 1'b0;
      fill_cnt <= 16'd0;
      wait_cnt <= 16'd0;
      sync_cnt <= 16'd0;
      prefill_was_done_d <= 1'b0;
    end else begin
      if (sync_rise_d)
        sync_cnt <= sync_cnt + 16'd1;

      case (dstate)
        // Gate closed. Read side is open, so any residue drains to empty.
        S_IDLE: begin
          dma_en_r <= 1'b0;
          fill_cnt <= 16'd0;
          wait_cnt <= 16'd0;
          prefill_was_done_d <= 1'b0;
          if (arm_d) dstate <= S_HOLD_RD;
        end

        // Read side has been told to close; give it time to cross domains
        // before we start filling, otherwise prefill drains as fast as it fills.
        S_HOLD_RD: begin
          if (!arm_d) dstate <= S_IDLE;
          // REQUIRE_PREFILL=0 lets the adc domain release inside this window.
          // Follow it instead of carrying on closing the read side, otherwise
          // the domains disagree and the DMA is never read.
          else if (released_d) begin
            dma_en_r           <= 1'b1;
            prefill_was_done_d <= 1'b0;
            dstate             <= S_RUN;
          end
          else if (wait_cnt >= RD_CLOSE_WAIT[15:0]) begin
            wait_cnt <= 16'd0;
            dstate   <= S_PREFILL;
          end else
            wait_cnt <= wait_cnt + 16'd1;
        end

        // Count samples that ACTUALLY land in fifo_generator_1. See the
        // dma_wr_valid port comment for why counting `trigger` here was wrong.
        S_PREFILL: begin
          dma_en_r <= 1'b1;
          if (!arm_d) begin
            dma_en_r <= 1'b0;
            dstate   <= S_IDLE;
          // MUST be tested BEFORE the fill_cnt branch. With REQUIRE_PREFILL=0
          // the adc domain can release mid-prefill; letting fill_cnt then reach
          // PREFILL_DEPTH would drop dma_en and stall a DAC already running.
          end else if (released_d) begin
            prefill_was_done_d <= 1'b0;   // best-effort start, DMA-timed sample 0
            dstate             <= S_RUN;
          end else if (dma_wr_valid) begin
            if (fill_cnt >= (PREFILL_DEPTH[15:0] - 16'd1)) begin
              dma_en_r <= 1'b0;
              dstate   <= S_WAIT_SYNC;
            end else
              fill_cnt <= fill_cnt + 16'd1;
          end
        end

        // Armed and holding. This is where a board sits, for as long as it
        // takes, waiting for the master's trigger. Nothing overflows because
        // dma_enable is low, so the DMA is simply never read.
        //
        // NOTE: this does NOT detect the sync edge itself. The adc_clk domain
        // owns the release decision and this domain follows it via released_d.
        // Previously both domains detected sync independently, which let them
        // disagree -- see the released_a comment in the adc_clk section.
        //
        // Opening dma_enable a couple of clocks after the read side is exactly
        // what the prefill is there to cover.
        S_WAIT_SYNC: begin
          dma_en_r <= 1'b0;
          if (!arm_d)         dstate <= S_IDLE;
          else if (released_d) begin
            dma_en_r           <= 1'b1;
            prefill_was_done_d <= 1'b1;   // deterministic, cross-board aligned
            dstate             <= S_RUN;
          end
        end

        // Steady state: identical to the pre-gate free-running behaviour.
        S_RUN: begin
          dma_en_r <= 1'b1;
          if (!arm_d) dstate <= S_IDLE;
        end

        default: dstate <= S_IDLE;
      endcase
    end
  end

  //---------------------------------------------------------------------------
  // Cola prefill (2026-10-28), dma_clk domain.
  //
  // spi1 used to share dma_enable_o, which closes as soon as the DAC FIFO has
  // PREFILL_DEPTH words. The cola DMA delivered a few fewer in that window, so
  // at release the 16-read burst out of fifo_generator_1 found
  // fifo_generator_3 empty 1-5 times (ILA) and cola started that many samples
  // late. Cola now gets its own enable that stays open through PREFILL and
  // WAIT_SYNC until fifo_generator_3 has PREFILL_DEPTH words too.
  //
  // Follows dstate; never drives it. The DAC FSM, dma_enable_o, prefilled_o and
  // the release decision are unchanged, so DAC-only runs (no cola stream: the
  // count just never completes) behave exactly as before.
  //---------------------------------------------------------------------------
  reg        cola_en_r;
  reg [15:0] cola_cnt;

  always @(posedge dma_clk) begin
    if (!dma_resetn) begin
      cola_en_r <= 1'b0;
      cola_cnt  <= 16'd0;
    end else begin
      case (dstate)
        S_PREFILL, S_WAIT_SYNC: begin
          // Count every write, including one already in flight when the enable
          // dropped, so the count is what is really in the FIFO.
          if (cola_wr_valid) begin
            cola_cnt  <= cola_cnt + 16'd1;
            cola_en_r <= ((cola_cnt + 16'd1) < PREFILL_DEPTH[15:0]);
          end else
            cola_en_r <= (cola_cnt < PREFILL_DEPTH[15:0]);
        end
        S_RUN: cola_en_r <= 1'b1;
        // IDLE (the cola FIFO is being drained) and HOLD_RD: closed, count reset.
        default: begin
          cola_en_r <= 1'b0;
          cola_cnt  <= 16'd0;
        end
      endcase
    end
  end

  //---------------------------------------------------------------------------
  // ADC clock domain
  //
  // This is the domain that actually determines DAC output phase, and it is the
  // one locked to the shared MCLK across boards. Opening rd_en here on a
  // deterministic adc_clk edge derived from sync_in is what makes sample 0 come
  // out simultaneously on every board.
  //---------------------------------------------------------------------------
  reg       rd_en_r;   /* running_a is declared up in the dma_clk section */
  reg [1:0] arm_sync_a, byp_sync_a, sync_in_a, pfd_sync_a;
  reg       sync_in_qa;
  wire      arm_a       = arm_sync_a[1];
  wire      bypass_a    = byp_sync_a[1];
  wire      sync_rise_a = sync_in_a[1] & ~sync_in_qa;
  // Prefill-done, crossed from the dma_clk domain. Deliberately covers BOTH
  // S_WAIT_SYNC and S_RUN so it stays asserted after release -- if it only
  // tracked S_WAIT_SYNC it would deassert as the dma domain advanced, racing
  // the very edge being qualified.
  wire      prefill_done_a = pfd_sync_a[1];
  // With REQUIRE_PREFILL=0 the trigger always starts the output; the prefill
  // state then only decides WHICH data sample 0 comes from, and is reported
  // through prefilled_o so a best-effort start is visible rather than silent.
  wire      release_ok_a   = prefill_done_a || (REQUIRE_PREFILL == 0);

  always @(posedge adc_clk) begin
    if (!adc_resetn) begin
      arm_sync_a <= 2'b00;
      byp_sync_a <= 2'b11;   // FAIL-SAFE, see the dma_clk block above
      sync_in_a  <= 2'b00;
      pfd_sync_a <= 2'b00;
      sync_in_qa <= 1'b0;
    end else begin
      arm_sync_a <= {arm_sync_a[0], arm};
      byp_sync_a <= {byp_sync_a[0], bypass};
      sync_in_a  <= {sync_in_a[0],  sync_in};
      pfd_sync_a <= {pfd_sync_a[0], prefill_done_d};
      sync_in_qa <= sync_in_a[1];
    end
  end

  always @(posedge adc_clk) begin
    if (!adc_resetn) begin
      rd_en_r   <= 1'b1;   // default open == today's xlconstant_1 behaviour
      running_a <= 1'b0;
    end else begin
      if (!arm_a) begin
        // Disarmed: open, so the FIFO drains and the board behaves as before.
        rd_en_r   <= 1'b1;
        running_a <= 1'b0;
      end else if (!running_a) begin
        // Armed and not yet released: hold the read side closed so the prefill
        // accumulates instead of draining.
        rd_en_r <= 1'b0;
        /*
         * THE single release decision for the whole module. With
         * REQUIRE_PREFILL=1 it is qualified on prefill_done_a, so an edge
         * arriving while the dma domain is still in PREFILL is IGNORED by both
         * domains rather than acted on by one. With REQUIRE_PREFILL=0 (the
         * default) the edge always releases and the dma domain follows it.
         *
         * Without that qualifier (the original bug) a sync during PREFILL
         * opened the read side while the write side was still filling: prefill
         * then drained as fast as it filled, the dma domain later parked in
         * S_WAIT_SYNC waiting for an edge that had already gone by, and the DAC
         * went silent. Observed as a real possibility on hardware -- the client
         * delivers DAC data ~8 s AFTER its sync edges, so the FSM is genuinely
         * still in PREFILL when syncs arrive.
         *
         * That hazard is now handled explicitly rather than by refusing to
         * release: S_HOLD_RD and S_PREFILL both follow released_d into S_RUN,
         * so the domains still cannot disagree. Set REQUIRE_PREFILL=1 to
         * restore the original fail-closed policy.
         *
         * TRADE-OFF, accepted by project requirement: releasing with the
         * prefill incomplete opens the read side over a FIFO that may be empty,
         * so sample 0 is timed by DMA response rather than by this edge. The
         * runs that count for cross-board alignment are the ones reporting
         * prefilled_o=1 alongside started_o=1.
         */
        if (sync_rise_a && release_ok_a) begin
          rd_en_r   <= 1'b1;   // <-- the release edge
          running_a <= 1'b1;
        end
      end else begin
        rd_en_r <= 1'b1;
      end
    end
  end

  //---------------------------------------------------------------------------
  // Outputs. bypass forces both gates open so the board behaves exactly as it
  // does today -- keep this asserted until the gate is proven, and it doubles
  // as the escape hatch if anything misbehaves in the field.
  //---------------------------------------------------------------------------
  assign dma_enable_o = bypass_d ? 1'b1 : dma_en_r;
  assign cola_dma_enable_o = bypass_d ? 1'b1 : cola_en_r;
  assign fifo_rd_en_o = bypass_a ? 1'b1 : rd_en_r;
  /*
   * Cola FIFO drain (2026-10-28). fifo_generator_3 (cola) is read only when
   * fifo_generator_1 (DAC) is, so whatever cola the previous run left behind
   * was still there at the next release and played BEFORE the new cola stream:
   * an ILA showed 31-39 stale words per run stopped mid-stream, building up
   * run after run, which is the cola-late-by-0..500 the client measured.
   * Disarmed means dma_enable is low, so nothing refills it while it drains;
   * at arm, drain stops (2 adc_clk) well before PREFILL opens dma_enable
   * (RD_CLOSE_WAIT dma_clk later). Off in bypass, where dma_enable is forced
   * open and draining would eat live cola.
   */
  assign cola_drain_o = ~arm_a & ~bypass_a;

  assign armed_o      = (dstate != S_IDLE);
  // During S_RUN this reports how the run STARTED, not a live FIFO state:
  // 1 = the full prefill completed before the release edge (deterministic,
  // cross-board aligned), 0 = released with the prefill incomplete. Identical
  // to the old decode for every run that prefills normally.
  assign prefilled_o  = (dstate == S_WAIT_SYNC) ||
                        ((dstate == S_RUN) && prefill_was_done_d);
  assign started_o    = (dstate == S_RUN);
  assign sync_count_o = sync_cnt;

endmodule
