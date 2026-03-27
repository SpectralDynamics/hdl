###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad7768evb_zed

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

adi_project_files ad7768evb_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "StartGen.v" \
  "demux1to4.v" \
  "trigger_sel.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

adi_project_run ad7768evb_zed
