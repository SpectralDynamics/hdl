// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xtacho_quant.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XTacho_quant_CfgInitialize(XTacho_quant *InstancePtr, XTacho_quant_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

u32 XTacho_quant_Get_out_data(XTacho_quant *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTacho_quant_ReadReg(InstancePtr->Control_BaseAddress, XTACHO_QUANT_CONTROL_ADDR_OUT_DATA_DATA);
    return Data;
}

u32 XTacho_quant_Get_out_data_vld(XTacho_quant *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTacho_quant_ReadReg(InstancePtr->Control_BaseAddress, XTACHO_QUANT_CONTROL_ADDR_OUT_DATA_CTRL);
    return Data & 0x1;
}

