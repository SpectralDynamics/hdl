###############################################################################
# Cola prefill -- incremental block-design edit (Panther, v30.20 candidate)
# Applies ON TOP of coladrain_bd_edit.tcl.
#
# PROBLEM. spi1 (cola) shared DacStartGate_0/dma_enable_o with the DAC. That
# enable closes when the DAC FIFO holds PREFILL_DEPTH words, and the cola DMA
# had delivered 11-15 by then (ILA 2026-10-28), so the release burst found the
# cola FIFO empty 1-5 times and cola started that many samples late.
#
# CHANGE.
#   spi1/dma_enable           <- DacStartGate_0/cola_dma_enable_o   (was dma_enable_o)
#   DacStartGate_0/cola_wr_valid <- axi_ad5441_dma/fifo_rd_valid      (cola FIFO writes)
# spi/dma_enable stays on dma_enable_o.
###############################################################################

set n_en    DacStartGate_0_dma_enable_o
set n_cwv   axi_ad5441_dma_fifo_rd_valid

puts "--- cola prefill BD edit starting ---"
open_bd_design [get_files system.bd]

if {![llength [get_bd_cells -quiet cola_rd_or]]} {
    error "cola_rd_or missing -- apply coladrain_bd_edit.tcl first"
}
set cur [get_bd_nets -of_objects [get_bd_pins spi1/dma_enable]]
if {$cur ne "/$n_en"} {
    error "spi1/dma_enable is on '$cur', expected /$n_en -- already applied or design differs"
}
if {[get_bd_nets -quiet -of_objects [get_bd_pins fifo_generator_3/wr_en]] ne "/$n_cwv"} {
    error "fifo_generator_3/wr_en is not on /$n_cwv"
}

update_module_reference [get_ips -filter {NAME =~ *DacStartGate*}]
foreach p {cola_dma_enable_o cola_wr_valid cola_drain_o} {
    if {![llength [get_bd_pins -quiet DacStartGate_0/$p]]} {
        error "DacStartGate_0 has no $p after update_module_reference"
    }
}
# update_module_reference keeps existing connections; re-check the drain.
if {[get_bd_nets -quiet -of_objects [get_bd_pins DacStartGate_0/cola_drain_o]] eq ""} {
    error "cola_drain_o lost its connection during the module update"
}

disconnect_bd_net /$n_en [get_bd_pins spi1/dma_enable]
connect_bd_net [get_bd_pins DacStartGate_0/cola_dma_enable_o] [get_bd_pins spi1/dma_enable]
# Joining an existing net needs -net (plain form fails with BD 41-701).
connect_bd_net -net [get_bd_nets $n_cwv] [get_bd_pins DacStartGate_0/cola_wr_valid]

validate_bd_design
save_bd_design
puts "--- cola prefill BD edit done ---"
