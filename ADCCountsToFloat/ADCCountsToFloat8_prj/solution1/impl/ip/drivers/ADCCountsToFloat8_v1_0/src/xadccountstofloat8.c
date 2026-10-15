// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xadccountstofloat8.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XAdccountstofloat8_CfgInitialize(XAdccountstofloat8 *InstancePtr, XAdccountstofloat8_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XAdccountstofloat8_Set_reset(XAdccountstofloat8 *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAdccountstofloat8_WriteReg(InstancePtr->Control_BaseAddress, XADCCOUNTSTOFLOAT8_CONTROL_ADDR_RESET_DATA, Data);
}

u32 XAdccountstofloat8_Get_reset(XAdccountstofloat8 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAdccountstofloat8_ReadReg(InstancePtr->Control_BaseAddress, XADCCOUNTSTOFLOAT8_CONTROL_ADDR_RESET_DATA);
    return Data;
}

void XAdccountstofloat8_Set_pointOffset(XAdccountstofloat8 *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAdccountstofloat8_WriteReg(InstancePtr->Control_BaseAddress, XADCCOUNTSTOFLOAT8_CONTROL_ADDR_POINTOFFSET_DATA, Data);
}

u32 XAdccountstofloat8_Get_pointOffset(XAdccountstofloat8 *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAdccountstofloat8_ReadReg(InstancePtr->Control_BaseAddress, XADCCOUNTSTOFLOAT8_CONTROL_ADDR_POINTOFFSET_DATA);
    return Data;
}

u32 XAdccountstofloat8_Get_iCurrentRange_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE);
}

u32 XAdccountstofloat8_Get_iCurrentRange_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH);
}

u32 XAdccountstofloat8_Get_iCurrentRange_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + 1);
}

u32 XAdccountstofloat8_Get_iCurrentRange_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_ICURRENTRANGE;
}

u32 XAdccountstofloat8_Get_iCurrentRange_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_ICURRENTRANGE;
}

u32 XAdccountstofloat8_Write_iCurrentRange_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_iCurrentRange_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_iCurrentRange_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_iCurrentRange_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_ICURRENTRANGE_BASE + offset + i);
    }
    return length;
}

u32 XAdccountstofloat8_Get_iOverloadCount_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE);
}

u32 XAdccountstofloat8_Get_iOverloadCount_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH);
}

u32 XAdccountstofloat8_Get_iOverloadCount_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + 1);
}

u32 XAdccountstofloat8_Get_iOverloadCount_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_IOVERLOADCOUNT;
}

u32 XAdccountstofloat8_Get_iOverloadCount_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_IOVERLOADCOUNT;
}

u32 XAdccountstofloat8_Write_iOverloadCount_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_iOverloadCount_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_iOverloadCount_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_iOverloadCount_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_IOVERLOADCOUNT_BASE + offset + i);
    }
    return length;
}

u32 XAdccountstofloat8_Get_OLValid_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE);
}

u32 XAdccountstofloat8_Get_OLValid_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH);
}

u32 XAdccountstofloat8_Get_OLValid_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + 1);
}

u32 XAdccountstofloat8_Get_OLValid_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_OLVALID;
}

u32 XAdccountstofloat8_Get_OLValid_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_OLVALID;
}

u32 XAdccountstofloat8_Write_OLValid_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_OLValid_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_OLValid_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_OLValid_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_OLVALID_BASE + offset + i);
    }
    return length;
}

u32 XAdccountstofloat8_Get_gainChanged_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE);
}

u32 XAdccountstofloat8_Get_gainChanged_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH);
}

u32 XAdccountstofloat8_Get_gainChanged_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + 1);
}

u32 XAdccountstofloat8_Get_gainChanged_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_GAINCHANGED;
}

u32 XAdccountstofloat8_Get_gainChanged_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_GAINCHANGED;
}

u32 XAdccountstofloat8_Write_gainChanged_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_gainChanged_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_gainChanged_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_gainChanged_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_GAINCHANGED_BASE + offset + i);
    }
    return length;
}

u32 XAdccountstofloat8_Get_status_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE);
}

u32 XAdccountstofloat8_Get_status_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH);
}

u32 XAdccountstofloat8_Get_status_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + 1);
}

u32 XAdccountstofloat8_Get_status_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_STATUS;
}

u32 XAdccountstofloat8_Get_status_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_STATUS;
}

u32 XAdccountstofloat8_Write_status_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_status_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_status_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_status_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_STATUS_BASE + offset + i);
    }
    return length;
}

u32 XAdccountstofloat8_Get_cal_step_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE);
}

u32 XAdccountstofloat8_Get_cal_step_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH);
}

u32 XAdccountstofloat8_Get_cal_step_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + 1);
}

u32 XAdccountstofloat8_Get_cal_step_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_CAL_STEP;
}

u32 XAdccountstofloat8_Get_cal_step_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_CAL_STEP;
}

u32 XAdccountstofloat8_Write_cal_step_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_cal_step_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_cal_step_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_cal_step_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_STEP_BASE + offset + i);
    }
    return length;
}

u32 XAdccountstofloat8_Get_cal_offset_BaseAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE);
}

u32 XAdccountstofloat8_Get_cal_offset_HighAddress(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH);
}

u32 XAdccountstofloat8_Get_cal_offset_TotalBytes(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + 1);
}

u32 XAdccountstofloat8_Get_cal_offset_BitWidth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_WIDTH_CAL_OFFSET;
}

u32 XAdccountstofloat8_Get_cal_offset_Depth(XAdccountstofloat8 *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XADCCOUNTSTOFLOAT8_CONTROL_DEPTH_CAL_OFFSET;
}

u32 XAdccountstofloat8_Write_cal_offset_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_cal_offset_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + (offset + i)*4);
    }
    return length;
}

u32 XAdccountstofloat8_Write_cal_offset_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XAdccountstofloat8_Read_cal_offset_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_HIGH - XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XADCCOUNTSTOFLOAT8_CONTROL_ADDR_CAL_OFFSET_BASE + offset + i);
    }
    return length;
}

