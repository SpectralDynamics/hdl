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
#include "xsynch.h"

extern XSynch_Config XSynch_ConfigTable[];

#ifdef SDT
XSynch_Config *XSynch_LookupConfig(UINTPTR BaseAddress) {
	XSynch_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XSynch_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XSynch_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XSynch_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSynch_Initialize(XSynch *InstancePtr, UINTPTR BaseAddress) {
	XSynch_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSynch_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSynch_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XSynch_Config *XSynch_LookupConfig(u16 DeviceId) {
	XSynch_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSYNCH_NUM_INSTANCES; Index++) {
		if (XSynch_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XSynch_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSynch_Initialize(XSynch *InstancePtr, u16 DeviceId) {
	XSynch_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSynch_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSynch_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

