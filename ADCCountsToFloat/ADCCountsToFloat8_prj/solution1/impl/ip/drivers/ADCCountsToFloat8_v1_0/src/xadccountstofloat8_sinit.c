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
#include "xadccountstofloat8.h"

extern XAdccountstofloat8_Config XAdccountstofloat8_ConfigTable[];

#ifdef SDT
XAdccountstofloat8_Config *XAdccountstofloat8_LookupConfig(UINTPTR BaseAddress) {
	XAdccountstofloat8_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XAdccountstofloat8_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XAdccountstofloat8_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XAdccountstofloat8_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XAdccountstofloat8_Initialize(XAdccountstofloat8 *InstancePtr, UINTPTR BaseAddress) {
	XAdccountstofloat8_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XAdccountstofloat8_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XAdccountstofloat8_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XAdccountstofloat8_Config *XAdccountstofloat8_LookupConfig(u16 DeviceId) {
	XAdccountstofloat8_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XADCCOUNTSTOFLOAT8_NUM_INSTANCES; Index++) {
		if (XAdccountstofloat8_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XAdccountstofloat8_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XAdccountstofloat8_Initialize(XAdccountstofloat8 *InstancePtr, u16 DeviceId) {
	XAdccountstofloat8_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XAdccountstofloat8_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XAdccountstofloat8_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

