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
#include "xstreamtodata.h"

extern XStreamtodata_Config XStreamtodata_ConfigTable[];

#ifdef SDT
XStreamtodata_Config *XStreamtodata_LookupConfig(UINTPTR BaseAddress) {
	XStreamtodata_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XStreamtodata_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XStreamtodata_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XStreamtodata_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XStreamtodata_Initialize(XStreamtodata *InstancePtr, UINTPTR BaseAddress) {
	XStreamtodata_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XStreamtodata_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XStreamtodata_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XStreamtodata_Config *XStreamtodata_LookupConfig(u16 DeviceId) {
	XStreamtodata_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSTREAMTODATA_NUM_INSTANCES; Index++) {
		if (XStreamtodata_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XStreamtodata_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XStreamtodata_Initialize(XStreamtodata *InstancePtr, u16 DeviceId) {
	XStreamtodata_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XStreamtodata_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XStreamtodata_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

