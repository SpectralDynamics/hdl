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
// 0x10 : Data signal of interp
//        bit 3~0 - interp[3:0] (Read/Write)
//        others  - reserved
// 0x14 : reserved
// 0x18 : Data signal of DacCountsOut
//        bit 19~0 - DacCountsOut[19:0] (Read)
//        others   - reserved
// 0x1c : Control signal of DacCountsOut
//        bit 0  - DacCountsOut_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XSTREAMTODATA_CONTROL_ADDR_INTERP_DATA       0x10
#define XSTREAMTODATA_CONTROL_BITS_INTERP_DATA       4
#define XSTREAMTODATA_CONTROL_ADDR_DACCOUNTSOUT_DATA 0x18
#define XSTREAMTODATA_CONTROL_BITS_DACCOUNTSOUT_DATA 20
#define XSTREAMTODATA_CONTROL_ADDR_DACCOUNTSOUT_CTRL 0x1c

