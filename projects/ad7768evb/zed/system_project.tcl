###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Disable OOC synthesis so module_ref sources (StartGen, demux1to4,
# trigger_sel, sync_bits) are compiled in the top-level synthesis run
# where project sources are visible, rather than in isolated OOC runs.
set ::ADI_USE_OOC_SYNTHESIS 0

adi_project ad7768evb_zed

adi_project_files ad7768evb_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "StartGen.v" \
  "system_StartGen_0_0.v" \
  "demux1to4.v" \
  "trigger_sel.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" ]

adi_project_run ad7768evb_zed
