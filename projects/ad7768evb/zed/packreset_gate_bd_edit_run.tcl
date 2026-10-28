###############################################################################
# Batch wrapper: open Panther15 and apply packreset_gate_bd_edit.tcl.
#
#   vivado -mode batch -source packreset_gate_bd_edit_run.tcl
#
# BACK UP system.bd FIRST -- it is hand-edited and cannot be regenerated.
###############################################################################

set proj "C:/github/hdl-master/projects/ad7768evb/zed/Panther15/ad7768evb_zed/ad7768evb_zed.xpr"
set editdir "C:/github/hdl-master/projects/ad7768evb/zed"

puts "opening $proj"
open_project $proj
cd $editdir
source $editdir/packreset_gate_bd_edit.tcl

puts "=== post-edit sanity ==="
foreach n {util_vector_logic_0_Res Synch_0_bRunningAcqOut} {
    puts "$n loads:"
    foreach p [get_bd_pins -of_objects [get_bd_nets $n]] { puts "   $p" }
}
puts "util_ad7768_adc_pack/reset <- [get_bd_nets -of_objects [get_bd_pins util_ad7768_adc_pack/reset]]"
puts "util_vector_logic_3/Op2    <- [get_bd_nets -of_objects [get_bd_pins util_vector_logic_3/Op2]]"

close_project
puts "=== wrapper done ==="
