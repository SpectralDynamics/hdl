# NOTE: single-channel ADCCountsToFloat (1.3) is SUPERSEDED

The HLS project in this directory's `solution1/` exports the ORIGINAL
single-channel `xilinx.com:hls:ADCCountsToFloat:1.3` IP — eight instances of
it were used by Panther designs up to Panther15's pre-2026-07-09 state.

As of 2026-07-09 the live design (Panther15) uses the consolidated 8-channel
core `xilinx.com:hls:ADCCountsToFloat8:1.0` instead:

- source:   `ADCCountsToFloat8.cpp` (this directory)
- build:    `vitis_hls -f build_adc8.tcl` (run from this directory)
- project:  `ADCCountsToFloat8_prj/` (exported IP in `solution1/impl/ip`)
- reg map:  `ADCCountsToFloat8_regmap.md`

The old 1.3 IP is intentionally left in place so historical project tcls
(Panther1–14, and Panther15 backups `*.prehdmi` / `*.predma`) can still
regenerate. Do NOT use it in new work.
