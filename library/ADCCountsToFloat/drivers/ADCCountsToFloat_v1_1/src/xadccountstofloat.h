// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XADCCOUNTSTOFLOAT_H
#define XADCCOUNTSTOFLOAT_H

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
#include "xadccountstofloat_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_BaseAddress;
} XAdccountstofloat_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XAdccountstofloat;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XAdccountstofloat_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XAdccountstofloat_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XAdccountstofloat_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XAdccountstofloat_ReadReg(BaseAddress, RegOffset) \
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
int XAdccountstofloat_Initialize(XAdccountstofloat *InstancePtr, u16 DeviceId);
XAdccountstofloat_Config* XAdccountstofloat_LookupConfig(u16 DeviceId);
int XAdccountstofloat_CfgInitialize(XAdccountstofloat *InstancePtr, XAdccountstofloat_Config *ConfigPtr);
#else
int XAdccountstofloat_Initialize(XAdccountstofloat *InstancePtr, const char* InstanceName);
int XAdccountstofloat_Release(XAdccountstofloat *InstancePtr);
#endif


void XAdccountstofloat_Set_iCurrentRange(XAdccountstofloat *InstancePtr, u32 Data);
u32 XAdccountstofloat_Get_iCurrentRange(XAdccountstofloat *InstancePtr);
void XAdccountstofloat_Set_reset(XAdccountstofloat *InstancePtr, u32 Data);
u32 XAdccountstofloat_Get_reset(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_iOverloadCount(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_iOverloadCount_vld(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_OLValid(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_OLValid_vld(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_step_BaseAddress(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_step_HighAddress(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_step_TotalBytes(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_step_BitWidth(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_step_Depth(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Write_cal_step_Words(XAdccountstofloat *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat_Read_cal_step_Words(XAdccountstofloat *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat_Write_cal_step_Bytes(XAdccountstofloat *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat_Read_cal_step_Bytes(XAdccountstofloat *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat_Get_cal_offset_BaseAddress(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_offset_HighAddress(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_offset_TotalBytes(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_offset_BitWidth(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Get_cal_offset_Depth(XAdccountstofloat *InstancePtr);
u32 XAdccountstofloat_Write_cal_offset_Words(XAdccountstofloat *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat_Read_cal_offset_Words(XAdccountstofloat *InstancePtr, int offset, word_type *data, int length);
u32 XAdccountstofloat_Write_cal_offset_Bytes(XAdccountstofloat *InstancePtr, int offset, char *data, int length);
u32 XAdccountstofloat_Read_cal_offset_Bytes(XAdccountstofloat *InstancePtr, int offset, char *data, int length);

#ifdef __cplusplus
}
#endif

#endif
