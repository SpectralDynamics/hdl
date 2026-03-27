#include<iostream>
#include "ap_int.h"
#include "ap_axi_sdata.h"
#include "hls_stream.h"
#define DWIDTH 24
#define type ap_int<DWIDTH>
typedef hls::axis<type, 0, 0, 0> pkt;
//float fDACScaleFactor=0.000009536752; //5./0x7ffff
float fDACScaleFactor=0.000022888227; //12./0x7ffff+
float fColaScaleFactor=0.00003814755474174105;
//float fColaScaleFactor=0.00003814755474174105*15.; //normalize from 12. to 1.25
float fColaNormalize=0.1041666666666667; //normalize from 12 to -12 to 1.25 to -1.25
//int rampVal=0;
bool bLastValPositive=true;
float oldScaleValue=0.;
int counter=0;
float currentScaleValue=0.;
volatile float lastOutput=1.0;
bool ZeroBeenCrossed=false;
volatile int dacCounter=0;
volatile int interp_counter=0;
//#define fDACScaleFactor=1./(float)0x7ffff;
float DriveScale(float input, hls::stream<pkt > &IN1024OUT8192, hls::stream<pkt > &IN2048OUT8192, hls::stream<pkt > &IN4096OUT8192,hls::stream<pkt > &IN8192OUT65536, hls::stream<pkt > &IN16384OUT65536, hls::stream<pkt > &IN32768OUT65536, hls::stream<pkt > &IN65536OUT262144,hls::stream<pkt > &IN131072OUT262144,hls::stream<pkt > &IN262144OUT262144,/*float *output, */volatile float *ScaleValue, volatile int *ZeroCross, volatile float calibratedStep[4], volatile float calibratedOffset[4], volatile float OffsetCounts[4], volatile int *samp_index,volatile int *iCurrentFilter,volatile ap_uint<4> *interp, volatile float *fClipValue,float *loopback) {
#pragma HLS interface ap_ctrl_hs port=return
#pragma HLS interface ap_none port=input
//#pragma HLS interface ap_ovld port=output
#pragma HLS interface ap_none port=interp
#pragma HLS interface ap_ctrl_hs port=loopback
//#pragma HLS interface ap_none port=ColaOutput
//#pragma HLS interface ap_ovalid port=dma_underflow
//#pragma HLS INTERFACE s_axilite register port=underrun
#pragma HLS INTERFACE s_axilite register port=ScaleValue
#pragma HLS INTERFACE s_axilite register port=ZeroCross
#pragma HLS INTERFACE s_axilite register port=calibratedStep
#pragma HLS INTERFACE s_axilite register port=calibratedOffset
#pragma HLS INTERFACE s_axilite register port=OffsetCounts
#pragma HLS INTERFACE s_axilite register port=samp_index
#pragma HLS INTERFACE s_axilite register port=iCurrentFilter
#pragma HLS INTERFACE s_axilite register port=fClipValue
#pragma HLS INTERFACE axis port=IN1024OUT8192
#pragma HLS INTERFACE axis port=IN2048OUT8192
#pragma HLS INTERFACE axis port=IN4096OUT8192
#pragma HLS INTERFACE axis port=IN8192OUT65536
#pragma HLS INTERFACE axis port=IN16384OUT65536
#pragma HLS INTERFACE axis port=IN32768OUT65536
#pragma HLS INTERFACE axis port=IN65536OUT262144
#pragma HLS INTERFACE axis port=IN131072OUT262144
#pragma HLS INTERFACE axis port=IN262144OUT262144
  ap_int<24> DacCounts=0;
  float output;
  if (*ZeroCross) // using ZeroCross for enable for now, fix later
	  oldScaleValue=*ScaleValue;
  else oldScaleValue=0.0;
	  currentScaleValue=oldScaleValue;
  if (calibratedStep[*iCurrentFilter]!=0.0)
	  fDACScaleFactor=calibratedStep[*iCurrentFilter]; //testing standalone only!
//	  currentScaleValue=1.0; // testing standalone only

//	  ZeroBeenCrossed=false; //reset

/*  if (input==0.) ZeroBeenCrossed=true;

  else if (input<0.) {// negative and nonzero
	  if (bLastValPositive)  ZeroBeenCrossed=true;
	  bLastValPositive=false;
  }

  else { // positive
  	  if (!bLastValPositive) ZeroBeenCrossed=true;
	  bLastValPositive=true;
  }*/

	dacCounter=0;
	volatile float temp = input;
	output = temp*currentScaleValue;
	*loopback = output;
//	float ColaNormalized = (float)((temp*fColaNormalize)+1.25); // add 1.25 to convert to unipolar 0-2.5
//	*ColaOutput = (unsigned short)(ColaNormalized/fColaScaleFactor);
  volatile int offsetCounts = (int)((calibratedOffset[*iCurrentFilter]/fDACScaleFactor)+0.5);
  volatile int calibratedCounts = (int)((currentScaleValue*temp)/fDACScaleFactor);//   /(*calibratedStep);
  calibratedCounts -= offsetCounts;
  volatile int clipCounts = (int)(*fClipValue/fDACScaleFactor);
  if (calibratedCounts>clipCounts) calibratedCounts = clipCounts;
  else if (calibratedCounts<(-1*clipCounts)) calibratedCounts = -1*clipCounts;
  DacCounts = calibratedCounts;
  pkt tmp;
  tmp.data = DacCounts;

  int index=*samp_index;
//  tmp.last = 1;
  switch (index) {
  case 0:
	  IN1024OUT8192.write(tmp);
	  break;
  case 1:
  	  IN2048OUT8192.write(tmp);
  	  break;
  case 2:
  	  IN4096OUT8192.write(tmp);
  	  break;
  case 3:
	  IN8192OUT65536.write(tmp);
   	  break;
  case 4:
	  IN16384OUT65536.write(tmp);
 	  break;
   case 5:
	  IN32768OUT65536.write(tmp);
   	  break;
   case 6:
	  IN65536OUT262144.write(tmp);
   	  break;
   case 7:
	  IN131072OUT262144.write(tmp);
      break;
  default:  //add dds later
	  IN262144OUT262144.write(tmp);
  }
  *interp = index;
  return output;//sum|input;//(int)(input*fScale)|0x100000;
}
