// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xadccountstofloat.h"

extern XAdccountstofloat_Config XAdccountstofloat_ConfigTable[];

XAdccountstofloat_Config *XAdccountstofloat_LookupConfig(u16 DeviceId) {
	XAdccountstofloat_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XADCCOUNTSTOFLOAT_NUM_INSTANCES; Index++) {
		if (XAdccountstofloat_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XAdccountstofloat_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XAdccountstofloat_Initialize(XAdccountstofloat *InstancePtr, u16 DeviceId) {
	XAdccountstofloat_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XAdccountstofloat_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XAdccountstofloat_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

