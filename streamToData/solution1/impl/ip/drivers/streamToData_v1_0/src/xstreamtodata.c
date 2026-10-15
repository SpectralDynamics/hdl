// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xstreamtodata.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XStreamtodata_CfgInitialize(XStreamtodata *InstancePtr, XStreamtodata_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XStreamtodata_Set_interp(XStreamtodata *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStreamtodata_WriteReg(InstancePtr->Control_BaseAddress, XSTREAMTODATA_CONTROL_ADDR_INTERP_DATA, Data);
}

u32 XStreamtodata_Get_interp(XStreamtodata *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStreamtodata_ReadReg(InstancePtr->Control_BaseAddress, XSTREAMTODATA_CONTROL_ADDR_INTERP_DATA);
    return Data;
}

u32 XStreamtodata_Get_DacCountsOut(XStreamtodata *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStreamtodata_ReadReg(InstancePtr->Control_BaseAddress, XSTREAMTODATA_CONTROL_ADDR_DACCOUNTSOUT_DATA);
    return Data;
}

u32 XStreamtodata_Get_DacCountsOut_vld(XStreamtodata *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStreamtodata_ReadReg(InstancePtr->Control_BaseAddress, XSTREAMTODATA_CONTROL_ADDR_DACCOUNTSOUT_CTRL);
    return Data & 0x1;
}

