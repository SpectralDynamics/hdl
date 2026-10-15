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
#include "xbufferstart.h"

extern XBufferstart_Config XBufferstart_ConfigTable[];

XBufferstart_Config *XBufferstart_LookupConfig(u16 DeviceId) {
	XBufferstart_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XBUFFERSTART_NUM_INSTANCES; Index++) {
		if (XBufferstart_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XBufferstart_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XBufferstart_Initialize(XBufferstart *InstancePtr, u16 DeviceId) {
	XBufferstart_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XBufferstart_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XBufferstart_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

