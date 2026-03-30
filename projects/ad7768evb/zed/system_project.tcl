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

# RTL sources for module_ref instances must be in the fileset before
# open_bd_design runs. adi_project_xilinx.tcl adds these via ::ad_extra_sources
# before create_bd_design so Vivado can resolve their port lists.
set ::ad_extra_sources [list \
  [file normalize "[file dirname [info script]]/StartGen.v"] \
  [file normalize "[file dirname [info script]]/system_StartGen_0_0.v"] \
  [file normalize "[file dirname [info script]]/demux1to4.v"] \
  [file normalize "[file dirname [info script]]/trigger_sel.v"] \
  [file normalize "$ad_hdl_dir/library/util_cdc/sync_bits.v"] \
]

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

# Add implementation-only constraints (clock groups referencing PS7 clocks
# that are not visible during top-level synthesis).
add_files -norecurse -fileset constrs_1 "system_impl_constr.xdc"
set_property used_in_synthesis false [get_files system_impl_constr.xdc]

# Use a timing-closure-focused implementation strategy.  The 7z020 is
# congested with 31 AXI master connections at 100 MHz; the default placer
# leaves zero-logic-level routing paths that exceed the 10 ns budget.
# Performance_ExplorePostRoutePhysOpt tries multiple placer directives and
# runs post-route physical optimisation to recover routing-dominated slack.
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]

adi_project_run ad7768evb_zed
