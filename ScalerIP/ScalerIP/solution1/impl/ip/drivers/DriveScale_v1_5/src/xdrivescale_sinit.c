// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xdrivescale.h"

extern XDrivescale_Config XDrivescale_ConfigTable[];

#ifdef SDT
XDrivescale_Config *XDrivescale_LookupConfig(UINTPTR BaseAddress) {
	XDrivescale_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XDrivescale_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XDrivescale_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XDrivescale_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XDrivescale_Initialize(XDrivescale *InstancePtr, UINTPTR BaseAddress) {
	XDrivescale_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XDrivescale_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XDrivescale_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XDrivescale_Config *XDrivescale_LookupConfig(u16 DeviceId) {
	XDrivescale_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XDRIVESCALE_NUM_INSTANCES; Index++) {
		if (XDrivescale_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XDrivescale_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XDrivescale_Initialize(XDrivescale *InstancePtr, u16 DeviceId) {
	XDrivescale_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XDrivescale_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XDrivescale_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

