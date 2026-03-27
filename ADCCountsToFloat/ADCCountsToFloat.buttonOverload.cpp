#include<iostream>
#include "ap_int.h"
int counter=0;
int iCurrentFrameSize=4096;
//int rampVal=0;
volatile float fADCStepVal;
volatile float fADCOffset;
volatile int iCurrentGain;
volatile int iCurrentOverloads=0;
float ADCCountsToFloat(int input, /*float *output, */float cal_step[16], float cal_offset[16], int *iCurrentRange,ap_uint<3> *usr_gpio_o, ap_uint<1> overload, int *iOverloadCount, int framesize) {
#pragma HLS interface ap_ctrl_hs port=input
//#pragma HLS INTERFACE bram port=cal_constants storage_type=RAM_1P
#pragma HLS INTERFACE s_axilite register port=cal_step
#pragma HLS INTERFACE s_axilite register port=cal_offset
#pragma HLS INTERFACE s_axilite register port=iCurrentRange
#pragma HLS INTERFACE s_axilite register port=iOverloadCount
#pragma HLS INTERFACE s_axilite register port=framesize
#pragma HLS INTERFACE ap_ctrl_none register port=usr_gpio_o // gpio to gain range
#pragma HLS INTERFACE ap_ctrl_none register port=overload
#pragma HLS INTERFACE ap_vld port=cal_step
	fADCStepVal=cal_step[iCurrentGain];
	fADCOffset=cal_offset[iCurrentGain];
//	iCurrentOverloads=*iOverloadCount;

	/*if (framesize!=0 && iCurrentFrameSize!=framesize) { //change in framesize
		iCurrentFrameSize=framesize;
		iCurrentOverloads=0;
	}*/
	if (overload) {
		iCurrentOverloads++;
		*usr_gpio_o=0x1;
	}
	else *usr_gpio_o=0x0;

/*	else {
	//	*usr_gpio_o=0x0;
	//	iCurrentOverloads=0;
		iCurrentOverloads=*iOverloadCount;
	}*/

//	*iOverloadCount=5;//testing only
	*iOverloadCount=iCurrentOverloads;
	/*counter++;
	if (counter>=iCurrentFrameSize) {
		counter=0;
		iCurrentOverloads=0;
	}*/
	// change range here
	iCurrentGain=iCurrentRange; // 001 is 12.0V i think
#if 0
	switch (iCurrentGain) {
	case 0:
		*usr_gpio_o=0x6;	// 0.9V
		break;
	case 1:
		*usr_gpio_o=0x7;	// 1.2V
		break;
	case 2:
		*usr_gpio_o=0x4;	// 1.8V
		break;
	case 3:
		*usr_gpio_o=0x5;	// 2.4V
		break;
	case 4:
		*usr_gpio_o=0x2;	// 4.5V
		break;
	case 5:
		*usr_gpio_o=0x3;	// 6.0V
		break;
	case 6:
		*usr_gpio_o=0x0;	// 9.0V
		break;
	case 7:
		*usr_gpio_o=0x1;	// 12.0V
		break;
	}
#endif
	float temp;
	if (input & 0x800000) // negative*/
		input |= 0xff000000; // set upper bits
	else input &= 0x00ffffff; // clear out upper bits*/

	return (float)((float)input*fADCStepVal)-fADCOffset;

}
