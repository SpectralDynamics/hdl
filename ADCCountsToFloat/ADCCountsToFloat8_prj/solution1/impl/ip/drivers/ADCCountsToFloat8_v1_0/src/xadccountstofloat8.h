// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XADCCOUNTSTOFLOAT8_H
#define XADCCOUNTSTOFLOAT8_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xadccountstofloat8_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XAdccountstofloat8_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XAdccountstofloat8;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XAdccountstofloat8_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XAdccountstofloat8_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XAdccountstofloat8_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XAdccountstofloat8_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XAdccountstofloat8_Initialize(XAdccountstofloat8 *InstancePtr, UINTPTR BaseAddress);
XAdccountstofloat8_Config* XAdccountstofloat8_LookupConfig(UINTPTR BaseAddress);
#else
int XAdccountstofloat8_Initialize(XAdccountstofloat8 *InstancePtr, u16 DeviceId);
XAdccountstofloat8_Config* XAdccountstofloat8_LookupConfig(u16 DeviceId);
#endif
int XAdccountstofloat8_CfgInitialize(XAdccountstofloat8 *InstancePtr, XAdccountstofloat8_Config *ConfigPtr);
#else
int XAdccountstofloat8_Initialize(XAdccountstofloat8 *InstancePtr, const char* InstanceName);
int XAdccountstofloat8_Release(XAdccountstofloat8 *InstancePtr);
#endif


void XAdccountstofloat8_Set_reset(XAdccountstofloat8 *InstancePtr, u32 Data);
u32 XAdccountstofloat8_Get_reset(XAdccountstofloat8 *InstancePtr);
void XAdccountstofloat8_Set_pointOffset(XAdccountstofloat8 *InstancePtr, u32 Data);
u32 XAdccountstofloat8_Get_pointOffset(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iCurrentRange_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iCurrentRange_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iCurrentRange_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iCurrentRange_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iCurrentRange_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_iCurrentRange_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_iCurrentRange_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_iCurrentRange_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_iCurrentRange_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Get_iOverloadCount_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iOverloadCount_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iOverloadCount_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iOverloadCount_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_iOverloadCount_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_iOverloadCount_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_iOverloadCount_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_iOverloadCount_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_iOverloadCount_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Get_OLValid_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_OLValid_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_OLValid_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_OLValid_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_OLValid_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_OLValid_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_OLValid_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_OLValid_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_OLValid_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Get_gainChanged_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_gainChanged_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_gainChanged_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_gainChanged_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_gainChanged_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_gainChanged_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_gainChanged_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_gainChanged_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_gainChanged_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Get_status_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_status_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_status_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_status_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_status_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_status_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_status_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_status_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_status_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Get_cal_step_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_step_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_step_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_step_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_step_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_cal_step_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_cal_step_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_cal_step_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_cal_step_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Get_cal_offset_BaseAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_offset_HighAddress(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_offset_TotalBytes(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_offset_BitWidth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Get_cal_offset_Depth(XAdccountstofloat8 *InstancePtr);
u32 XAdccountstofloat8_Write_cal_offset_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Read_cal_offset_Words(XAdccountstofloat8 *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat8_Write_cal_offset_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat8_Read_cal_offset_Bytes(XAdccountstofloat8 *InstancePtr, int offset, char *data, int length);

#ifdef __cplusplus
}
#endif

#endif
