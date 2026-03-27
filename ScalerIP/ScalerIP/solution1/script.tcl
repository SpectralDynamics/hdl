############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project ScalerIP
set_top DriveScale
add_files Scaler.cpp
open_solution "solution1" -flow_target vivado
set_part {xc7z020-clg484-1}
create_clock -period 33.554432MHz -name default
config_export -format ip_catalog -rtl verilog -vendor SpectralDynamics -version 1.4 -vivado_clock 33.554432MHz
set_clock_uncertainty 0
source "./ScalerIP/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -rtl verilog -format ip_catalog
