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
#include "xtacho_quant.h"

extern XTacho_quant_Config XTacho_quant_ConfigTable[];

#ifdef SDT
XTacho_quant_Config *XTacho_quant_LookupConfig(UINTPTR BaseAddress) {
	XTacho_quant_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XTacho_quant_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XTacho_quant_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XTacho_quant_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTacho_quant_Initialize(XTacho_quant *InstancePtr, UINTPTR BaseAddress) {
	XTacho_quant_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTacho_quant_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTacho_quant_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XTacho_quant_Config *XTacho_quant_LookupConfig(u16 DeviceId) {
	XTacho_quant_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XTACHO_QUANT_NUM_INSTANCES; Index++) {
		if (XTacho_quant_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XTacho_quant_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTacho_quant_Initialize(XTacho_quant *InstancePtr, u16 DeviceId) {
	XTacho_quant_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTacho_quant_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTacho_quant_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

