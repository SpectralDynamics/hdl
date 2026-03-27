#include<iostream>
#include "ap_int.h"
#define NUM_RANGES 8
int counter=0;
//int iCurrentFrameSize=4096;
//volatile int LEDCountdown=0;
volatile int sampleRate=64000;
#define DEF_FE_STEP 0.000000488281
//int rampVal=0;
volatile float fADCStepVal;
volatile float fADCOffset=0.0;
volatile float retVal=0.0;
volatile unsigned iCurrentGain=0;
static unsigned iCurrentOverloads=0;
static unsigned iCurrentGainChanges=0;
//static bool bGainChange=true;
volatile unsigned iLastRange=0;
static int iCountdownGainChange=0;
static bool doOnce=true;
float ADCCountsToFloat(volatile int input, /*float *output, */volatile float cal_step[NUM_RANGES], volatile float cal_offset[NUM_RANGES], volatile unsigned *iCurrentRange,ap_uint<3> *usr_gpio_o, volatile unsigned *iOverloadCount,volatile bool chanValid,volatile int *OLValid, volatile int *reset, volatile int *pointOffset,volatile unsigned *gainChanged, volatile int *status) {
#pragma HLS interface ap_ctrl_hs port=input
//#pragma HLS BIND_STORAGE variable=iCurrentOverloads type=RAM_2P impl=BRAM
//#pragma HLS INTERFACE bram port=cal_constants storage_type=RAM_1P
#pragma HLS INTERFACE s_axilite register port=cal_step
#pragma HLS INTERFACE s_axilite register port=cal_offset
#pragma HLS INTERFACE s_axilite register port=iCurrentRange
#pragma HLS INTERFACE s_axilite register port=iOverloadCount
//#pragma HLS INTERFACE s_axilite register port=framesize
//#pragma HLS INTERFACE ap_ctrl_none register port=return
#pragma HLS INTERFACE ap_ctrl_none register port=chanValid // gpio to gain range
#pragma HLS INTERFACE ap_ctrl_none register port=usr_gpio_o
#pragma HLS INTERFACE s_axilite register port=OLValid
#pragma HLS INTERFACE s_axilite register port=reset
#pragma HLS INTERFACE s_axilite register port=pointOffset
#pragma HLS INTERFACE s_axilite register port=gainChanged
#pragma HLS INTERFACE s_axilite register port=status
//#pragma HLS reset variable=reset
//#pragma HLS BIND_STORAGE variable=reset type=RAM_2P impl=LUTRAM
//#pragma HLS BIND_STORAGE variable=iOverloadCount type=RAM_2P impl=BRAM
//#pragma HLS INTERFACE ap_ctrl_none register port=overload
//#pragma HLS INTERFACE ap_vld port=cal_step
//	static unsigned iCurrentOverloads;
	volatile int vInput=input; // optimizer screws up data without this
	volatile int vStatus=vInput&0xff000000;
	*status = vStatus;// >> 24;
/*	int resettime= *reset;

	*reset=0;*/
//	unsigned tempOverloadCount = *iOverloadCount;
//	unsigned tempgainChanged = *gainChanged;
	//set scale and offset based on gain from previous gain range
	fADCStepVal=cal_step[iCurrentGain];
	fADCOffset=cal_offset[iCurrentGain];
	int thisRange = *iCurrentRange&0x7;
#if 1
	if (thisRange != iCurrentGain) {
	//	bGainChange=*gainChanged;
	//	*gainChanged += 1;
		iCountdownGainChange++;
		doOnce=true;
	}
	else {
		iCountdownGainChange=0;
	//	uGainChange=0x0;
	}
	// change range here for next time through
	if (iCountdownGainChange>=*pointOffset)  { // hold off applying scale for 34 points
		if (doOnce) {
			iCurrentGainChanges++;
			doOnce=false;
		}
		iCurrentGain=thisRange;
	}
#endif
#if 1
	if (vInput&0x8000000) {  // overload flag
	//	if (LEDCountdown<=0)
		//	LEDCountdown=32000;
		iCurrentOverloads++;
	/*	iOverloadCount++;
		gainChanged++;*/
	}
	//iCurrentOverloads++;
	/* tempOverloadCount++;
	tempgainChanged=iCurrentOverloads;*/
	vInput &= 0x00ffffff;
#endif
	if (chanValid)
		*OLValid=1;
	else
		*OLValid=0;
//	if (bGainChange)
//	*gainChanged=bGainChange;//iCurrentOverloads|0xffff0000;
//	*iOverloadCount=iCurrentOverloads;
//	*gainChanged=iCurrentOverloads;
	if (0/*resettime*/) { // doesn't reset
		iCurrentOverloads=20;
	//	*gainChanged=0;
	//	*reset=0;
	}
	switch (thisRange) {
		case 0:
			*usr_gpio_o=0x0;	// 12V
			break;
		case 1:
			*usr_gpio_o=0x1;	// 6V
			break;
		case 2:
			*usr_gpio_o=0x4;	// 3V
			break;
		case 3:
			*usr_gpio_o=0x2;	// 2.4V
			break;
		case 4:
			*usr_gpio_o=0x5;	// 1.5V
			break;
		case 5:
			*usr_gpio_o=0x3;	// 1.2V
			break;
		case 6:
			*usr_gpio_o=0x6;	// 0.6V
			break;
		case 7:
			*usr_gpio_o=0x7;	// 0.3V
			break;
	}

	if (vInput & 0x800000) // negative*/
	{	vInput |= 0xff000000; // set upper bits to keep negative across 32 bits
		retVal = (float)((float)vInput*fADCStepVal)-fADCOffset;
	}
	else
	{
	 	vInput &= 0x00ffffff; // clear out upper bits
	 	retVal = (float)((float)vInput*fADCStepVal)-fADCOffset;
	}
	*iOverloadCount = iCurrentOverloads;
	*gainChanged = iCurrentGainChanges;
	return (float)retVal;

}
