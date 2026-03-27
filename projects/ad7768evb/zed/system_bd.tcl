###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Load the pre-built Panther block design instead of recreating from TCL.
# system.bd was exported from the working project and contains all custom
# IP instances (ADCCountsToFloat, ColaCounts, DriveScale, tacho, etc.)

set bd_file [get_property FILE_NAME [current_bd_design]]
close_bd_design [current_bd_design]

set script_dir [file normalize [file dirname [info script]]]
file copy -force [file join $script_dir "system.bd"] $bd_file

open_bd_design $bd_file
