// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x000 : reserved
// 0x004 : reserved
// 0x008 : reserved
// 0x00c : reserved
// 0x010 : Data signal of reset
//         bit 31~0 - reset[31:0] (Read/Write)
// 0x014 : reserved
// 0x018 : Data signal of pointOffset
//         bit 31~0 - pointOffset[31:0] (Read/Write)
// 0x01c : reserved
// 0x020 ~
// 0x03f : Memory 'iCurrentRange' (8 * 32b)
//         Word n : bit [31:0] - iCurrentRange[n]
// 0x040 ~
// 0x05f : Memory 'iOverloadCount' (8 * 32b)
//         Word n : bit [31:0] - iOverloadCount[n]
// 0x060 ~
// 0x07f : Memory 'OLValid' (8 * 32b)
//         Word n : bit [31:0] - OLValid[n]
// 0x080 ~
// 0x09f : Memory 'gainChanged' (8 * 32b)
//         Word n : bit [31:0] - gainChanged[n]
// 0x0a0 ~
// 0x0bf : Memory 'status' (8 * 32b)
//         Word n : bit [31:0] - status[n]
// 0x100 ~
// 0x1ff : Memory 'cal_step' (64 * 32b)
//         Word n : bit [31:0] - cal_step[n]
// 0x200 ~
// 0x2ff : Memory 'cal_offset' (64 * 32b)
//         Word n : bit [31:0] - cal_offset[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_RESET_DATA          0x010
#define XADCCOUNTSTOFLOAT8_CONTROL_BITS_RESET_DATA          32
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_POINTOFFSET_DATA    0x018
#define XADCCOUNTSTOFLOAT8_CONTROL_BITS_POINTOFFSET_DATA    32
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE  0x020
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH  0x03f
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_ICURRENTRANGE      32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_ICURRENTRANGE      8
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE 0x040
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH 0x05f
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_IOVERLOADCOUNT     32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_IOVERLOADCOUNT     8
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE        0x060
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH        0x07f
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_OLVALID            32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_OLVALID            8
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE    0x080
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH    0x09f
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_GAINCHANGED        32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_GAINCHANGED        8
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE         0x0a0
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH         0x0bf
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_STATUS             32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_STATUS             8
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE       0x100
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH       0x1ff
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_CAL_STEP           32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_CAL_STEP           64
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE     0x200
#define XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH     0x2ff
#define XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_CAL_OFFSET         32
#define XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_CAL_OFFSET         64

