############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project ColaFloatsToCounts
set_top ColaCounts
add_files ColaFloatsToCounts/ColaCounts.cpp
open_solution "ColaCounts" -flow_target vivado
set_part {xc7z020-clg484-1}
create_clock -period 10 -name default
config_export -format ip_catalog -output C:/github/ColaFloatsToCounts/ColaCounts.zip -rtl verilog -vendor SpectralDynamics -version 1.0 -vivado_optimization_level 0 -vivado_phys_opt none -vivado_report_level 0
config_rtl -kernel_profile=0 -module_auto_prefix -mult_keep_attribute=0 -register_reset_num 0 -reset control -reset_async=0 -reset_level low
source "./ColaFloatsToCounts/ColaCounts/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -rtl verilog -format ip_catalog -output C:/github/ColaFloatsToCounts/ColaCounts.zip
