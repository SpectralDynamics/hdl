###############################################################################
# Packer-reset gate -- incremental block-design edit (Panther, v30.20 candidate)
#
# PROBLEM. sync_n (pin M21, FMC H10 LA04_P, the AD7768 SYNC_IN/ net) is
# inverted by util_vector_logic_0 and ORed with adc_reset by
# util_vector_logic_3 to drive util_ad7768_adc_pack/reset. Every low pulse on
# the line therefore resets the packer, including spurious pulses in the
# middle of a run. The driver (sync_buf, g_acquiring), Synch_0 (ACTIVE mode
# leaves bStarted alone) and DacStartGate_0 (S_RUN leaves only on disarm) all
# ignore those pulses; the packer reset was the one path that did not.
#
# CHANGE. Gate the sync term with Synch_0/bRunningAcqOut:
#
#   before:  pack_reset = adc_reset | ~sync_n
#   after:   pack_reset = adc_reset | (~sync_n & ~bRunningAcqOut)
#
#   sync_n -> util_vector_logic_0 (not) --+--> Synch_0/spiSync           (unchanged)
#                                         +--> DacStartGate_0/sync_in    (unchanged)
#                                         +--> packreset_sync_and/Op1    (NEW)
#   Synch_0/bRunningAcqOut -> packreset_run_not (NEW) -> packreset_sync_and/Op2
#   packreset_sync_and/Res -> util_vector_logic_3/Op2   (was util_vector_logic_0/Res)
#
# WHY THE START PULSE STILL RESETS THE PACKER. bRunningAcq is 0 from RX buffer
# enable (dmaengine enable wrapper) until sync_buf() writes 1, and sync_buf is
# IRQF_TRIGGER_RISING on sync_n -- it runs after the low pulse has ended, so
# the whole start pulse reaches the packer exactly as today. Synch_0 itself
# only latches bStarted on an edge seen with bRunningAcq=0, so any run that
# captures data at all had bRunningAcq=0 at its start edge.
# Pulses between runs (rate / filter changes, resync) still reset the packer.
#
# Clocks: Synch_0 and util_ad7768_adc_pack are both on axi_ad7768_adc_adc_clk,
# and bRunningAcqOut is a registered output. sync_n was already asynchronous
# into this reset; that is unchanged. Two LUTs, no BRAM (BRAM is at 92%).
#
# Usage (Panther15 project, NOT the stale outer zed/ad7768evb_zed project):
#     vivado -mode batch -source packreset_gate_bd_edit_run.tcl
#
# STATUS: applied to Panther15 2026-10-27 and bench-verified: a mid-run sync no
# longer rotates the channels (was 0.17 s of rotated data until the next block).
###############################################################################

set n_sync    util_vector_logic_0_Res   ;# ~sync_n
set n_running Synch_0_bRunningAcqOut    ;# also feeds ColaGate_0/bRunningAcq
set or_pin    util_vector_logic_3/Op2   ;# Op1 = axi_ad7768_adc/adc_reset

puts "--- packer-reset gate BD edit starting ---"
open_bd_design [get_files system.bd]

# Refuse to run twice or against an unexpected design.
if {[llength [get_bd_cells -quiet packreset_sync_and]]} {
    error "packreset_sync_and already exists -- edit already applied"
}
set cur [get_bd_nets -of_objects [get_bd_pins $or_pin]]
if {$cur ne "/$n_sync"} {
    error "$or_pin is on '$cur', expected /$n_sync -- design differs from the one this was written for"
}
if {![llength [get_bd_pins -quiet Synch_0/bRunningAcqOut]]} {
    error "Synch_0 has no bRunningAcqOut pin"
}

create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 packreset_run_not
set_property -dict [list CONFIG.C_OPERATION {not} CONFIG.C_SIZE {1}] [get_bd_cells packreset_run_not]
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 packreset_sync_and
set_property -dict [list CONFIG.C_OPERATION {and} CONFIG.C_SIZE {1}] [get_bd_cells packreset_sync_and]

disconnect_bd_net /$n_sync [get_bd_pins $or_pin]
# Joining an existing net needs -net (plain form fails with BD 41-701).
connect_bd_net -net [get_bd_nets $n_sync]    [get_bd_pins packreset_sync_and/Op1]
connect_bd_net -net [get_bd_nets $n_running] [get_bd_pins packreset_run_not/Op1]
connect_bd_net [get_bd_pins packreset_run_not/Res]  [get_bd_pins packreset_sync_and/Op2]
connect_bd_net [get_bd_pins packreset_sync_and/Res] [get_bd_pins $or_pin]

validate_bd_design
save_bd_design
puts "--- packer-reset gate BD edit done ---"
