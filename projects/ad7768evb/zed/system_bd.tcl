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

# Close the empty BD that create_bd_design just created, copy ours in, reopen
close_bd_design [current_bd_design]
file mkdir $bd_dir
file copy -force $src_bd $bd_file
open_bd_design $bd_file
