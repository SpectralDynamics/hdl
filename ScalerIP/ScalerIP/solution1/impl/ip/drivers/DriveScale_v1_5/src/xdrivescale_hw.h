// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : Data signal of ScaleValue
//        bit 31~0 - ScaleValue[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of ZeroCross
//        bit 31~0 - ZeroCross[31:0] (Read/Write)
// 0x1c : reserved
// 0x50 : Data signal of samp_index
//        bit 31~0 - samp_index[31:0] (Read/Write)
// 0x54 : reserved
// 0x58 : Data signal of iCurrentFilter
//        bit 31~0 - iCurrentFilter[31:0] (Read/Write)
// 0x5c : reserved
// 0x60 : Data signal of fClipValue
//        bit 31~0 - fClipValue[31:0] (Read/Write)
// 0x64 : reserved
// 0x68 : Data signal of sync_reset
//        bit 31~0 - sync_reset[31:0] (Read/Write)
// 0x6c : reserved
// 0x70 : Data signal of alignOffset
//        bit 31~0 - alignOffset[31:0] (Read)
// 0x74 : Control signal of alignOffset
//        bit 0  - alignOffset_ap_vld (Read/COR)
//        others - reserved
// 0x80 : Data signal of colaEnable
//        bit 31~0 - colaEnable[31:0] (Read/Write)
// 0x84 : reserved
// 0x88 : Data signal of group_delay
//        bit 31~0 - group_delay[31:0] (Read/Write)
// 0x8c : reserved
// 0xa0 : Data signal of loop_delay
//        bit 31~0 - loop_delay[31:0] (Read/Write)
// 0xa4 : reserved
// 0xa8 : Data signal of dbg_ready
//        bit 31~0 - dbg_ready[31:0] (Read)
// 0xac : Control signal of dbg_ready
//        bit 0  - dbg_ready_ap_vld (Read/COR)
//        others - reserved
// 0x20 ~
// 0x2f : Memory 'calibratedStep' (4 * 32b)
//        Word n : bit [31:0] - calibratedStep[n]
// 0x30 ~
// 0x3f : Memory 'calibratedOffset' (4 * 32b)
//        Word n : bit [31:0] - calibratedOffset[n]
// 0x40 ~
// 0x4f : Memory 'OffsetCounts' (4 * 32b)
//        Word n : bit [31:0] - OffsetCounts[n]
// 0x90 ~
// 0x9f : Memory 'calibratedStepRecip' (4 * 32b)
//        Word n : bit [31:0] - calibratedStepRecip[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XDRIVESCALE_CONTROL_ADDR_SCALEVALUE_DATA          0x10
#define XDRIVESCALE_CONTROL_BITS_SCALEVALUE_DATA          32
#define XDRIVESCALE_CONTROL_ADDR_ZEROCROSS_DATA           0x18
#define XDRIVESCALE_CONTROL_BITS_ZEROCROSS_DATA           32
#define XDRIVESCALE_CONTROL_ADDR_SAMP_INDEX_DATA          0x50
#define XDRIVESCALE_CONTROL_BITS_SAMP_INDEX_DATA          32
#define XDRIVESCALE_CONTROL_ADDR_ICURRENTFILTER_DATA      0x58
#define XDRIVESCALE_CONTROL_BITS_ICURRENTFILTER_DATA      32
#define XDRIVESCALE_CONTROL_ADDR_FCLIPVALUE_DATA          0x60
#define XDRIVESCALE_CONTROL_BITS_FCLIPVALUE_DATA          32
#define XDRIVESCALE_CONTROL_ADDR_SYNC_RESET_DATA          0x68
#define XDRIVESCALE_CONTROL_BITS_SYNC_RESET_DATA          32
#define XDRIVESCALE_CONTROL_ADDR_ALIGNOFFSET_DATA         0x70
#define XDRIVESCALE_CONTROL_BITS_ALIGNOFFSET_DATA         32
#define XDRIVESCALE_CONTROL_ADDR_ALIGNOFFSET_CTRL         0x74
#define XDRIVESCALE_CONTROL_ADDR_COLAENABLE_DATA          0x80
#define XDRIVESCALE_CONTROL_BITS_COLAENABLE_DATA          32
#define XDRIVESCALE_CONTROL_ADDR_GROUP_DELAY_DATA         0x88
#define XDRIVESCALE_CONTROL_BITS_GROUP_DELAY_DATA         32
#define XDRIVESCALE_CONTROL_ADDR_LOOP_DELAY_DATA          0xa0
#define XDRIVESCALE_CONTROL_BITS_LOOP_DELAY_DATA          32
#define XDRIVESCALE_CONTROL_ADDR_DBG_READY_DATA           0xa8
#define XDRIVESCALE_CONTROL_BITS_DBG_READY_DATA           32
#define XDRIVESCALE_CONTROL_ADDR_DBG_READY_CTRL           0xac
#define XDRIVESCALE_CONTROL_ADDR_CALIBRATEDSTEP_BASE      0x20
#define XDRIVESCALE_CONTROL_ADDR_CALIBRATEDSTEP_HIGH      0x2f
#define XDRIVESCALE_CONTROL_WIDTH_CALIBRATEDSTEP          32
#define XDRIVESCALE_CONTROL_DEPTH_CALIBRATEDSTEP          4
#define XDRIVESCALE_CONTROL_ADDR_CALIBRATEDOFFSET_BASE    0x30
#define XDRIVESCALE_CONTROL_ADDR_CALIBRATEDOFFSET_HIGH    0x3f
#define XDRIVESCALE_CONTROL_WIDTH_CALIBRATEDOFFSET        32
#define XDRIVESCALE_CONTROL_DEPTH_CALIBRATEDOFFSET        4
#define XDRIVESCALE_CONTROL_ADDR_OFFSETCOUNTS_BASE        0x40
#define XDRIVESCALE_CONTROL_ADDR_OFFSETCOUNTS_HIGH        0x4f
#define XDRIVESCALE_CONTROL_WIDTH_OFFSETCOUNTS            32
#define XDRIVESCALE_CONTROL_DEPTH_OFFSETCOUNTS            4
#define XDRIVESCALE_CONTROL_ADDR_CALIBRATEDSTEPRECIP_BASE 0x90
#define XDRIVESCALE_CONTROL_ADDR_CALIBRATEDSTEPRECIP_HIGH 0x9f
#define XDRIVESCALE_CONTROL_WIDTH_CALIBRATEDSTEPRECIP     32
#define XDRIVESCALE_CONTROL_DEPTH_CALIBRATEDSTEPRECIP     4

