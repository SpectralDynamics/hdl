############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project tacho3
set_top tacho
add_files tacho3/tacho_3.cpp
add_files tacho3/tacho_3.h
add_files -tb tacho3/tacho_3_tb.cpp -cflags "-Wno-unknown-pragmas"
open_solution "solution1" -flow_target vivado
set_part {xc7z020-clg484-1}
create_clock -period 10 -name default
config_export -display_name tacho_1.0 -flow syn -format ip_catalog -rtl verilog -version 1.0 -vivado_clock 10
config_cosim -tool xsim
set_clock_uncertainty 0
source "./tacho3/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -flow syn -rtl verilog -format ip_catalog
