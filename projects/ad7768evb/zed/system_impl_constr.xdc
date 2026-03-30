# Implementation-only constraints.
# clk_fpga_0 is defined in the PS7 IP XDC and is only visible after IP
# synthesis, so this constraint must not be evaluated during top-level synthesis.
# system_project.tcl adds this file with set_property used_in_synthesis false.
set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks clk_fpga_0]

# The audio MMCM (sys_audio_clkgen) runs from a free-running reference and is
# asynchronous to clk_fpga_0.  ADI audio IP uses FIFOs for the crossing.
set_clock_groups -asynchronous \
  -group [get_clocks clk_fpga_0] \
  -group [get_clocks clk_out1_system_sys_audio_clkgen_0]
