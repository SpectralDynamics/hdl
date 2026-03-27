###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Load the pre-built Panther block design instead of recreating from TCL.
# system.bd was exported from the working project and contains all custom
# IP instances (ADCCountsToFloat, ColaCounts, DriveScale, tacho, etc.)

set script_dir [file normalize [file dirname [info script]]]
set src_bd [file join $script_dir "system.bd"]

# Build the destination path from project properties
set project_name [get_property NAME [current_project]]
set project_dir  [get_property DIRECTORY [current_project]]
set bd_dir  [file normalize "$project_dir/${project_name}.srcs/sources_1/bd/system"]
set bd_file "$bd_dir/system.bd"

# The FIR compiler IPs reference .coe files at ../DAC FIR Filters/ relative
# to their XCI location inside bd/system/ip/. Copy them into place now so
# Vivado can resolve them when the BD is opened and targets are generated.
set coe_src [file join $script_dir "coe" "DAC FIR Filters"]
set coe_dst [file normalize "$project_dir/${project_name}.srcs/sources_1/bd/system/ip/DAC FIR Filters"]
file mkdir $coe_dst
foreach coe_file [glob -nocomplain [file join $coe_src "*.coe"]] {
  file copy -force $coe_file $coe_dst
}

# Close the empty BD that create_bd_design just created, copy ours in, reopen
close_bd_design [current_bd_design]
file mkdir $bd_dir
file copy -force $src_bd $bd_file
open_bd_design $bd_file
