############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project tacho4
set_top tacho_control
add_files tacho4/tacho_4.cpp
add_files tacho4/tacho_4.h
add_files -tb tacho4/tacho_4_tb.cpp -cflags "-Wno-unknown-pragmas"
open_solution "solution1" -flow_target vivado
set_part {xc7z020-clg484-1}
create_clock -period 10 -name default
config_export -description tacho_control -display_name tacho_control_1.1.5 -format ip_catalog -rtl verilog -version 1.1.5
source "./tacho4/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -rtl verilog -format ip_catalog
