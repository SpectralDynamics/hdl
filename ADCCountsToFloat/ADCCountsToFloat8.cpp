// 8-channel consolidation of ADCCountsToFloat.cpp: one shared float pipeline
// (sitofp/fmul/fsub) serves all channels instead of 8 duplicated cores.
// ap_start is driven by the common adc_valid; all 8 outputs are registered and
// settle long before the next sample strobe (128 clks @ 262.144 kHz), so the
// cpack capture timing (previous conversion at each strobe) is unchanged.
#include "ap_int.h"
#define NUM_RANGES 8
#define NUM_CH 8

// per-channel persistent state (was one set of statics per core instance)
static unsigned iCurrentGain[NUM_CH];
static unsigned iCurrentOverloads[NUM_CH];
static unsigned iCurrentGainChanges[NUM_CH];
static int iCountdownGainChange[NUM_CH];
static bool doOnce[NUM_CH] = {true,true,true,true,true,true,true,true};

void ADCCountsToFloat8(
	volatile int input0, volatile int input1, volatile int input2, volatile int input3,
	volatile int input4, volatile int input5, volatile int input6, volatile int input7,
	float *out0, float *out1, float *out2, float *out3,
	float *out4, float *out5, float *out6, float *out7,
	ap_uint<3> *usr_gpio_o0, ap_uint<3> *usr_gpio_o1, ap_uint<3> *usr_gpio_o2, ap_uint<3> *usr_gpio_o3,
	ap_uint<3> *usr_gpio_o4, ap_uint<3> *usr_gpio_o5, ap_uint<3> *usr_gpio_o6, ap_uint<3> *usr_gpio_o7,
	volatile bool chanValid0, volatile bool chanValid1, volatile bool chanValid2, volatile bool chanValid3,
	volatile bool chanValid4, volatile bool chanValid5, volatile bool chanValid6, volatile bool chanValid7,
	volatile float cal_step[NUM_CH][NUM_RANGES],
	volatile float cal_offset[NUM_CH][NUM_RANGES],
	volatile unsigned iCurrentRange[NUM_CH],
	volatile unsigned iOverloadCount[NUM_CH],
	volatile int OLValid[NUM_CH],
	volatile int *reset,
	volatile int *pointOffset,
	volatile unsigned gainChanged[NUM_CH],
	volatile int status[NUM_CH]) {
#pragma HLS INTERFACE ap_ctrl_hs port=return
#pragma HLS INTERFACE ap_none register port=input0
#pragma HLS INTERFACE ap_none register port=input1
#pragma HLS INTERFACE ap_none register port=input2
#pragma HLS INTERFACE ap_none register port=input3
#pragma HLS INTERFACE ap_none register port=input4
#pragma HLS INTERFACE ap_none register port=input5
#pragma HLS INTERFACE ap_none register port=input6
#pragma HLS INTERFACE ap_none register port=input7
#pragma HLS INTERFACE ap_none register port=out0
#pragma HLS INTERFACE ap_none register port=out1
#pragma HLS INTERFACE ap_none register port=out2
#pragma HLS INTERFACE ap_none register port=out3
#pragma HLS INTERFACE ap_none register port=out4
#pragma HLS INTERFACE ap_none register port=out5
#pragma HLS INTERFACE ap_none register port=out6
#pragma HLS INTERFACE ap_none register port=out7
#pragma HLS INTERFACE ap_none register port=usr_gpio_o0
#pragma HLS INTERFACE ap_none register port=usr_gpio_o1
#pragma HLS INTERFACE ap_none register port=usr_gpio_o2
#pragma HLS INTERFACE ap_none register port=usr_gpio_o3
#pragma HLS INTERFACE ap_none register port=usr_gpio_o4
#pragma HLS INTERFACE ap_none register port=usr_gpio_o5
#pragma HLS INTERFACE ap_none register port=usr_gpio_o6
#pragma HLS INTERFACE ap_none register port=usr_gpio_o7
#pragma HLS INTERFACE ap_none register port=chanValid0
#pragma HLS INTERFACE ap_none register port=chanValid1
#pragma HLS INTERFACE ap_none register port=chanValid2
#pragma HLS INTERFACE ap_none register port=chanValid3
#pragma HLS INTERFACE ap_none register port=chanValid4
#pragma HLS INTERFACE ap_none register port=chanValid5
#pragma HLS INTERFACE ap_none register port=chanValid6
#pragma HLS INTERFACE ap_none register port=chanValid7
#pragma HLS INTERFACE s_axilite register port=cal_step
#pragma HLS INTERFACE s_axilite register port=cal_offset
#pragma HLS INTERFACE s_axilite register port=iCurrentRange
#pragma HLS INTERFACE s_axilite register port=iOverloadCount
#pragma HLS INTERFACE s_axilite register port=OLValid
#pragma HLS INTERFACE s_axilite register port=reset
#pragma HLS INTERFACE s_axilite register port=pointOffset
#pragma HLS INTERFACE s_axilite register port=gainChanged
#pragma HLS INTERFACE s_axilite register port=status
#pragma HLS allocation operation instances=fmul limit=1
#pragma HLS allocation operation instances=fsub limit=1

	int in[NUM_CH];
#pragma HLS ARRAY_PARTITION variable=in complete
	bool cv[NUM_CH];
#pragma HLS ARRAY_PARTITION variable=cv complete
	float outv[NUM_CH];
#pragma HLS ARRAY_PARTITION variable=outv complete
	ap_uint<3> gpio[NUM_CH];
#pragma HLS ARRAY_PARTITION variable=gpio complete

	in[0]=input0; in[1]=input1; in[2]=input2; in[3]=input3;
	in[4]=input4; in[5]=input5; in[6]=input6; in[7]=input7;
	cv[0]=chanValid0; cv[1]=chanValid1; cv[2]=chanValid2; cv[3]=chanValid3;
	cv[4]=chanValid4; cv[5]=chanValid5; cv[6]=chanValid6; cv[7]=chanValid7;
	int ptOfs = *pointOffset;

PROC_CH: for (int ch = 0; ch < NUM_CH; ch++) {
#pragma HLS PIPELINE
		volatile int vInput = in[ch]; // optimizer screws up data without this (see ADCCountsToFloat.cpp)
		volatile int vStatus = vInput & 0xff000000;
		status[ch] = vStatus;
		//set scale and offset based on gain from previous gain range
		float fADCStepVal = cal_step[ch][iCurrentGain[ch]];
		float fADCOffset = cal_offset[ch][iCurrentGain[ch]];
		unsigned thisRange = iCurrentRange[ch] & 0x7;
		if (thisRange != iCurrentGain[ch]) {
			iCountdownGainChange[ch]++;
			doOnce[ch] = true;
		}
		else {
			iCountdownGainChange[ch] = 0;
		}
		// change range here for next time through
		if (iCountdownGainChange[ch] >= ptOfs) { // hold off applying scale for pointOffset points
			if (doOnce[ch]) {
				iCurrentGainChanges[ch]++;
				doOnce[ch] = false;
			}
			iCurrentGain[ch] = thisRange;
		}
		if (vInput & 0x8000000) {  // overload flag
			iCurrentOverloads[ch]++;
		}
		vInput &= 0x00ffffff;
		OLValid[ch] = cv[ch] ? 1 : 0;
		switch (thisRange) {
			case 0:
				gpio[ch] = 0x0;	// 12V
				break;
			case 1:
				gpio[ch] = 0x1;	// 6V
				break;
			case 2:
				gpio[ch] = 0x4;	// 3V
				break;
			case 3:
				gpio[ch] = 0x2;	// 2.4V
				break;
			case 4:
				gpio[ch] = 0x5;	// 1.5V
				break;
			case 5:
				gpio[ch] = 0x3;	// 1.2V
				break;
			case 6:
				gpio[ch] = 0x6;	// 0.6V
				break;
			case 7:
				gpio[ch] = 0x7;	// 0.3V
				break;
		}
		float retVal;
		if (vInput & 0x800000) // negative
		{	vInput |= 0xff000000; // set upper bits to keep negative across 32 bits
			retVal = (float)((float)vInput*fADCStepVal)-fADCOffset;
		}
		else
		{
			vInput &= 0x00ffffff; // clear out upper bits
			retVal = (float)((float)vInput*fADCStepVal)-fADCOffset;
		}
		iOverloadCount[ch] = iCurrentOverloads[ch];
		gainChanged[ch] = iCurrentGainChanges[ch];
		outv[ch] = retVal;
	}

	*out0 = outv[0]; *out1 = outv[1]; *out2 = outv[2]; *out3 = outv[3];
	*out4 = outv[4]; *out5 = outv[5]; *out6 = outv[6]; *out7 = outv[7];
	*usr_gpio_o0 = gpio[0]; *usr_gpio_o1 = gpio[1]; *usr_gpio_o2 = gpio[2]; *usr_gpio_o3 = gpio[3];
	*usr_gpio_o4 = gpio[4]; *usr_gpio_o5 = gpio[5]; *usr_gpio_o6 = gpio[6]; *usr_gpio_o7 = gpio[7];
}
