###############################################################################
# Cola FIFO drain -- incremental block-design edit (Panther, v30.20 candidate)
#
# PROBLEM. fifo_generator_3 (cola, 512 deep) has rd_en = fifo_generator_1/valid:
# it is read only when a DAC word is read. DacStartGate drains the DAC FIFO
# between runs, but nothing drains the cola FIFO, so cola words left by the
# previous run were read first at the next release. ILA 2026-10-28: 31-39
# stale words per run stopped mid-stream, building up run after run; cola then
# lagged the DAC by that many samples for the whole run, and the stale samples
# played on the cola output.
#
# CHANGE.
#   before:  fifo_generator_3/rd_en = fifo_generator_1/valid
#   after:   fifo_generator_3/rd_en = fifo_generator_1/valid | DacStartGate_0/cola_drain_o
#   cola_drain_o = ~arm & ~bypass (adc_clk domain, new port in DacStartGate.v)
# fifo_generator_1/valid still drives DriveScale_0/ap_start unchanged.
#
# Usage: sourced by C:/panther_work/build_coladrain.tcl (Panther15 project).
###############################################################################

set n_valid fifo_generator_1_valid
set rd_pin  fifo_generator_3/rd_en

puts "--- cola drain BD edit starting ---"
open_bd_design [get_files system.bd]

if {[llength [get_bd_cells -quiet cola_rd_or]]} {
    error "cola_rd_or already exists -- edit already applied"
}
set cur [get_bd_nets -of_objects [get_bd_pins $rd_pin]]
if {$cur ne "/$n_valid"} {
    error "$rd_pin is on '$cur', expected /$n_valid -- design differs from the one this was written for"
}

# Pick up the new cola_drain_o port from DacStartGate.v.
update_module_reference [get_ips -filter {NAME =~ *DacStartGate*}]
if {![llength [get_bd_pins -quiet DacStartGate_0/cola_drain_o]]} {
    error "DacStartGate_0 has no cola_drain_o after update_module_reference"
}

create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cola_rd_or
set_property -dict [list CONFIG.C_OPERATION {or} CONFIG.C_SIZE {1}] [get_bd_cells cola_rd_or]

disconnect_bd_net /$n_valid [get_bd_pins $rd_pin]
# Joining an existing net needs -net (plain form fails with BD 41-701).
connect_bd_net -net [get_bd_nets $n_valid] [get_bd_pins cola_rd_or/Op1]
connect_bd_net [get_bd_pins DacStartGate_0/cola_drain_o] [get_bd_pins cola_rd_or/Op2]
connect_bd_net [get_bd_pins cola_rd_or/Res] [get_bd_pins $rd_pin]

validate_bd_design
save_bd_design
puts "--- cola drain BD edit done ---"
