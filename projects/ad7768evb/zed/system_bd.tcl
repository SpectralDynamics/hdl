###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Load the pre-built Panther block design instead of recreating from TCL.
# system.bd was exported from the working project and contains all custom
# IP instances (ADCCountsToFloat, ColaCounts, DriveScale, tacho, etc.)

set script_dir [file normalize [file dirname [info script]]]
set src_bd [file join $script_dir "system.bd"]

# Build destination paths from project properties
set project_name [get_property NAME [current_project]]
set project_dir  [get_property DIRECTORY [current_project]]
set bd_dir  [file normalize "$project_dir/${project_name}.srcs/sources_1/bd/system"]
set bd_file "$bd_dir/system.bd"

# Set all IP repo paths here (inside adi_project_create context, after project
# exists) so the catalog is up to date before the block design is opened.
set_property ip_repo_paths [list \
  [file normalize "$ad_hdl_dir/library"] \
  [file normalize "$ad_hdl_dir/ADCCountsToFloat"] \
  [file normalize "$ad_hdl_dir/ScalerIP"] \
  [file normalize "$ad_hdl_dir/streamToData"] \
  [file normalize "$ad_hdl_dir/Synch"] \
  [file normalize "$ad_hdl_dir/ColaFloatsToCounts"] \
  [file normalize "$ad_hdl_dir/tacho3"] \
  [file normalize "$ad_hdl_dir/tacho4"] \
  [file normalize "$ad_hdl_dir/tacho5"] \
  [file normalize "$ad_hdl_dir/spi_cont"] \
  ] [current_project]
update_ip_catalog

# The FIR compiler IPs reference .coe files at ../DAC FIR Filters/ relative
# to their XCI location inside bd/system/ip/. Copy them into place now.
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
