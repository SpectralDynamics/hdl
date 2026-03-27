############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
############################################################
open_project ADCCountsToFloat
set_top ADCCountsToFloat
add_files ADCCountsToFloat/ADCCountsToFloat.cpp
open_solution "solution1" -flow_target vivado
set_part {xc7z020-clg484-1}
::common::set_param hls.enable_float_acc_inference false
::common::set_param hls.enable_float_mul_acc_inference false
create_clock -period 30 -name default
config_export -format ip_catalog -output C:/github/hdl/ADCCountsToFloat/ADCCountsToFloat.zip -rtl verilog -version 1.1 -vivado_optimization_level 0 -vivado_phys_opt none -vivado_report_level 0
source "./ADCCountsToFloat/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -rtl verilog -format ip_catalog -version "1.1" -output C:/github/hdl/ADCCountsToFloat/ADCCountsToFloat.zip
