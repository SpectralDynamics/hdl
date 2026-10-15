// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XSTREAMTODATA_H
#define XSTREAMTODATA_H

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
#include "xstreamtodata_hw.h"

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
} XStreamtodata_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XStreamtodata;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XStreamtodata_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XStreamtodata_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XStreamtodata_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XStreamtodata_ReadReg(BaseAddress, RegOffset) \
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
int XStreamtodata_Initialize(XStreamtodata *InstancePtr, UINTPTR BaseAddress);
XStreamtodata_Config* XStreamtodata_LookupConfig(UINTPTR BaseAddress);
#else
int XStreamtodata_Initialize(XStreamtodata *InstancePtr, u16 DeviceId);
XStreamtodata_Config* XStreamtodata_LookupConfig(u16 DeviceId);
#endif
int XStreamtodata_CfgInitialize(XStreamtodata *InstancePtr, XStreamtodata_Config *ConfigPtr);
#else
int XStreamtodata_Initialize(XStreamtodata *InstancePtr, const char* InstanceName);
int XStreamtodata_Release(XStreamtodata *InstancePtr);
#endif


void XStreamtodata_Set_interp(XStreamtodata *InstancePtr, u32 Data);
u32 XStreamtodata_Get_interp(XStreamtodata *InstancePtr);
u32 XStreamtodata_Get_DacCountsOut(XStreamtodata *InstancePtr);
u32 XStreamtodata_Get_DacCountsOut_vld(XStreamtodata *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
