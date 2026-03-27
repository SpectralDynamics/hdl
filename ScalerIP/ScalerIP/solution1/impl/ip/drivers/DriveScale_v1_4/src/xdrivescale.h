// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XDRIVESCALE_H
#define XDRIVESCALE_H

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
#include "xdrivescale_hw.h"

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
} XDrivescale_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XDrivescale;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XDrivescale_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XDrivescale_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XDrivescale_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XDrivescale_ReadReg(BaseAddress, RegOffset) \
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
int XDrivescale_Initialize(XDrivescale *InstancePtr, UINTPTR BaseAddress);
XDrivescale_Config* XDrivescale_LookupConfig(UINTPTR BaseAddress);
#else
int XDrivescale_Initialize(XDrivescale *InstancePtr, u16 DeviceId);
XDrivescale_Config* XDrivescale_LookupConfig(u16 DeviceId);
#endif
int XDrivescale_CfgInitialize(XDrivescale *InstancePtr, XDrivescale_Config *ConfigPtr);
#else
int XDrivescale_Initialize(XDrivescale *InstancePtr, const char* InstanceName);
int XDrivescale_Release(XDrivescale *InstancePtr);
#endif


void XDrivescale_Set_ScaleValue(XDrivescale *InstancePtr, u32 Data);
u32 XDrivescale_Get_ScaleValue(XDrivescale *InstancePtr);
void XDrivescale_Set_ZeroCross(XDrivescale *InstancePtr, u32 Data);
u32 XDrivescale_Get_ZeroCross(XDrivescale *InstancePtr);
void XDrivescale_Set_samp_index(XDrivescale *InstancePtr, u32 Data);
u32 XDrivescale_Get_samp_index(XDrivescale *InstancePtr);
void XDrivescale_Set_iCurrentFilter(XDrivescale *InstancePtr, u32 Data);
u32 XDrivescale_Get_iCurrentFilter(XDrivescale *InstancePtr);
void XDrivescale_Set_fClipValue(XDrivescale *InstancePtr, u32 Data);
u32 XDrivescale_Get_fClipValue(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedStep_BaseAddress(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedStep_HighAddress(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedStep_TotalBytes(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedStep_BitWidth(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedStep_Depth(XDrivescale *InstancePtr);
u32 XDrivescale_Write_calibratedStep_Words(XDrivescale *InstancePtr, int offset, word_type *data, int length);
u32 XDrivescale_Read_calibratedStep_Words(XDrivescale *InstancePtr, int offset, word_type *data, int length);
u32 XDrivescale_Write_calibratedStep_Bytes(XDrivescale *InstancePtr, int offset, char *data, int length);
u32 XDrivescale_Read_calibratedStep_Bytes(XDrivescale *InstancePtr, int offset, char *data, int length);
u32 XDrivescale_Get_calibratedOffset_BaseAddress(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedOffset_HighAddress(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedOffset_TotalBytes(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedOffset_BitWidth(XDrivescale *InstancePtr);
u32 XDrivescale_Get_calibratedOffset_Depth(XDrivescale *InstancePtr);
u32 XDrivescale_Write_calibratedOffset_Words(XDrivescale *InstancePtr, int offset, word_type *data, int length);
u32 XDrivescale_Read_calibratedOffset_Words(XDrivescale *InstancePtr, int offset, word_type *data, int length);
u32 XDrivescale_Write_calibratedOffset_Bytes(XDrivescale *InstancePtr, int offset, char *data, int length);
u32 XDrivescale_Read_calibratedOffset_Bytes(XDrivescale *InstancePtr, int offset, char *data, int length);
u32 XDrivescale_Get_OffsetCounts_BaseAddress(XDrivescale *InstancePtr);
u32 XDrivescale_Get_OffsetCounts_HighAddress(XDrivescale *InstancePtr);
u32 XDrivescale_Get_OffsetCounts_TotalBytes(XDrivescale *InstancePtr);
u32 XDrivescale_Get_OffsetCounts_BitWidth(XDrivescale *InstancePtr);
u32 XDrivescale_Get_OffsetCounts_Depth(XDrivescale *InstancePtr);
u32 XDrivescale_Write_OffsetCounts_Words(XDrivescale *InstancePtr, int offset, word_type *data, int length);
u32 XDrivescale_Read_OffsetCounts_Words(XDrivescale *InstancePtr, int offset, word_type *data, int length);
u32 XDrivescale_Write_OffsetCounts_Bytes(XDrivescale *InstancePtr, int offset, char *data, int length);
u32 XDrivescale_Read_OffsetCounts_Bytes(XDrivescale *InstancePtr, int offset, char *data, int length);

#ifdef __cplusplus
}
#endif

#endif
