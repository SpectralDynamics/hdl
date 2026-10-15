############################################################
## Build script for the consolidated 8-channel ADCCountsToFloat8 core.
## Run from C:/github/hdl-master/ADCCountsToFloat:
##   vitis_hls -f build_adc8.tcl
## Packaged IP lands in ADCCountsToFloat8_prj/solution1/impl/ip
## (picked up by the project's existing ip_repo_paths entry for this dir).
############################################################
open_project -reset ADCCountsToFloat8_prj
set_top ADCCountsToFloat8
add_files ADCCountsToFloat8.cpp
open_solution "solution1" -flow_target vivado
set_part {xc7z020-clg484-1}
create_clock -period 33.554432MHz -name default
config_export -format ip_catalog -rtl verilog -version 1.0
csynth_design
export_design -rtl verilog -format ip_catalog
exit
