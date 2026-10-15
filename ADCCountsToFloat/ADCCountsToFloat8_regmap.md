# ADCCountsToFloat8 register map (driver migration)

One `ADCCountsToFloat8` core replaces the eight `ADCCountsToFloat` instances.
Base address: **0x40010000** (unchanged from old instance 0). The old per-channel
bases 0x40020000–0x40080000 no longer exist. All other peripherals in the design
keep their old addresses (DriveScale 0x40000000, Synch 0x400A0000, etc.).

## Old layout (per instance, base 0x40010000 + ch*0x10000)

| offset | register |
|--------|----------|
| 0x10 | iCurrentRange |
| 0x18 | reset |
| 0x20–0x3f | cal_step[8] (float) |
| 0x40–0x5f | cal_offset[8] (float) |
| 0x60 | iOverloadCount (RO) |
| 0x70 | OLValid (RO) |
| 0x80 | pointOffset |
| 0x88 | gainChanged (RO) |
| 0x98 | status (RO) |

## New layout (single core, base 0x40010000, ch = 0..7, range = 0..7)

| offset | register |
|--------|----------|
| 0x010 | reset (shared, kept for compatibility — unused in HW, as before) |
| 0x018 | pointOffset (shared across all channels — was per-instance) |
| 0x020 + 4*ch | iCurrentRange[ch] |
| 0x040 + 4*ch | iOverloadCount[ch] (RO) |
| 0x060 + 4*ch | OLValid[ch] (RO) |
| 0x080 + 4*ch | gainChanged[ch] (RO) |
| 0x0a0 + 4*ch | status[ch] (RO) |
| 0x100 + 32*ch + 4*range | cal_step[ch][range] (float) |
| 0x200 + 32*ch + 4*range | cal_offset[ch][range] (float) |

## Behavioral notes

- `pointOffset` is now one value for all channels (software wrote the same value
  to all eight instances anyway).
- Latency: 26 clks after the common `adc_valid` (old core: 10 clks after the
  per-channel valid). Both are far inside the 128-clk sample period, and the
  cpack capture semantics (previous conversion latched at each strobe) are
  unchanged.
- Disabled channels are now computed too (their `adc_data` is stale); their
  overload counters may move if stale data has bit 27 set. Only read counters
  for enabled channels, same as before.
- Generated driver headers: `ADCCountsToFloat8_prj/solution1/impl/ip/drivers/`
