#include<iostream>
#include "ap_int.h"
#include "ap_axi_sdata.h"
#include "hls_stream.h"
#define DWIDTH 24
#define type ap_int<DWIDTH>
typedef hls::axis<type, 0, 0, 0> pkt;
#define CWIDTH 16
#define ctype ap_uint<CWIDTH>
typedef hls::axis<ctype, 0, 0, 0> cpkt;

//float fDACScaleFactor=0.000009536752; //5./0x7ffff
float fDACScaleFactor=0.000022888227; //12./0x7ffff+
float fColaScaleFactor=0.00003814755474174105;
float fColaScaleFactorRecip=1.0f/0.00003814755474174105f; //constant-folded; multiply instead of fdiv
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
float DriveScale(float input, float *ColaInput, hls::stream<cpkt > &COLAIN65536OUT262144, hls::stream<pkt > &IN1024OUT8192, hls::stream<pkt > &IN2048OUT8192, hls::stream<pkt > &IN4096OUT8192,hls::stream<pkt > &IN8192OUT65536, hls::stream<pkt > &IN16384OUT65536, hls::stream<pkt > &IN32768OUT65536, hls::stream<pkt > &IN65536OUT262144,hls::stream<pkt > &IN131072OUT262144,hls::stream<pkt > &IN262144OUT262144,/*float *output, */volatile float *ScaleValue, volatile int *ZeroCross, volatile float calibratedStep[4], volatile float calibratedOffset[4], volatile float OffsetCounts[4], volatile int *samp_index,volatile int *iCurrentFilter,volatile ap_uint<4> *interp, volatile float *fClipValue,float *loopback,unsigned short *ColaOutput,volatile int *sync_reset,volatile int *alignOffset,volatile int *colaEnable,volatile int *group_delay,volatile float calibratedStepRecip[4],volatile int *loop_delay,volatile int *dbg_ready) {
#pragma HLS interface ap_ctrl_hs port=return
#pragma HLS interface ap_none port=input
#pragma HLS interface ap_none port=ColaInput
//#pragma HLS interface ap_ovld port=output
#pragma HLS interface ap_none port=interp
#pragma HLS interface ap_ctrl_hs port=loopback
#pragma HLS interface ap_none port=ColaOutput
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
#pragma HLS INTERFACE s_axilite register port=sync_reset
#pragma HLS INTERFACE s_axilite register port=alignOffset
#pragma HLS INTERFACE s_axilite register port=colaEnable
#pragma HLS INTERFACE s_axilite register port=group_delay
#pragma HLS INTERFACE s_axilite register port=loop_delay
#pragma HLS INTERFACE s_axilite register port=dbg_ready
#pragma HLS INTERFACE s_axilite register port=calibratedStepRecip
#pragma HLS allocation operation instances=fmul limit=1
#pragma HLS INTERFACE axis port=COLAIN65536OUT262144
#pragma HLS INTERFACE axis port=IN1024OUT8192
#pragma HLS INTERFACE axis port=IN2048OUT8192
#pragma HLS INTERFACE axis port=IN4096OUT8192
#pragma HLS INTERFACE axis port=IN8192OUT65536
#pragma HLS INTERFACE axis port=IN16384OUT65536
#pragma HLS INTERFACE axis port=IN32768OUT65536
#pragma HLS INTERFACE axis port=IN65536OUT262144
#pragma HLS INTERFACE axis port=IN131072OUT262144
#pragma HLS INTERFACE axis port=IN262144OUT262144
  /* ch9 loopback delay line (added 2026-09-15). The loopback is the DAC
   * sample BEFORE the interpolation FIRs, so it leads the analog output by
   * a rate-dependent amount (measured 53..212 samples across 1024..262144,
   * including the ADC filter latency). Delaying it here lines ch9 up with
   * the ADC data. Same shape as colaDelayBuf: 256 entries, LUTRAM, and the
   * delay comes from software so retuning needs no bitstream. */
  static float loopDelayBuf[256];
#pragma HLS BIND_STORAGE variable=loopDelayBuf type=RAM_1P impl=LUTRAM
  /* sentinel-arrival diagnostic (2026-09-15); see dbg_ready */
  static unsigned char s_dac_sent_cnt  = 0;
  static unsigned char s_cola_sent_cnt = 0;
  static int loopWrPtr = 0;
  static int loopFill  = 0;
  static unsigned short colaDelayBuf[256];
#pragma HLS BIND_STORAGE variable=colaDelayBuf type=RAM_1P impl=LUTRAM
  static int colaWrPtr = 0;
  static bool s_dac_ready   = false;
  static bool s_cola_ready  = false;
  static int  s_invoc       = 0;
  static int  s_dac_invoc   = 0;
  static int  s_cola_invoc  = 0;
  static int  s_align_ofs   = 0;
  static bool s_align_valid = false;
  if (*sync_reset) {
    s_dac_ready = false; s_cola_ready = false;
    s_invoc = 0; s_dac_invoc = 0; s_cola_invoc = 0;
    s_align_ofs = 0; s_align_valid = false;
    colaWrPtr = 0;
    loopWrPtr = 0;
    loopFill  = 0;
  }
  ap_int<24> DacCounts=0;
  float output;
  unsigned short ColaOut=0;
  union { float f; unsigned int u; } s_ib, s_cb;
  s_ib.f = input;
  s_cb.f = *ColaInput;
  bool bColaEnabled = *colaEnable;
  if (bColaEnabled) {
    bool cola_is_sent = (s_cb.u == 0xeeeeeeee);
    s_invoc++;
    if (s_ib.u == 0xffffffff) { s_dac_ready = true; s_ib.f = 0.0f; s_dac_invoc = s_invoc;
                                if (s_dac_sent_cnt < 255) s_dac_sent_cnt++; }
    if (cola_is_sent)         { s_cola_ready = true; s_cola_invoc = s_invoc;
                                if (s_cola_sent_cnt < 255) s_cola_sent_cnt++; }
    if (s_dac_ready && s_cola_ready && !s_align_valid) {
      s_align_ofs = s_dac_invoc - s_cola_invoc;
      s_align_valid = true;
    }
    *alignOffset = s_align_ofs;
    *dbg_ready = (s_dac_ready ? 1 : 0) | (s_cola_ready ? 2 : 0)
               | (s_align_valid ? 4 : 0) | (bColaEnabled ? 8 : 0)
               | ((int)s_dac_sent_cnt << 8) | ((int)s_cola_sent_cnt << 16);
    if (!s_dac_ready || !s_cola_ready) {
      colaDelayBuf[colaWrPtr] = 0;
      colaWrPtr = (colaWrPtr + 1) & 0xFF;
      pkt tmp;
      tmp.data = ap_int<24>(0);
      cpkt ctmp;
      ctmp.data = ap_uint<16>(0);
      int idx = *samp_index;
      switch (idx) {
      case 0: IN1024OUT8192.write(tmp);      break;
      case 1: IN2048OUT8192.write(tmp);      break;
      case 2: IN4096OUT8192.write(tmp);      break;
      case 3: IN8192OUT65536.write(tmp);     break;
      case 4: IN16384OUT65536.write(tmp);    break;
      case 5: IN32768OUT65536.write(tmp);    break;
      case 6:
    	  IN65536OUT262144.write(tmp);
    	  COLAIN65536OUT262144.write(ctmp);
    	  break;
      case 7: IN131072OUT262144.write(tmp);  break;
      default: IN262144OUT262144.write(tmp); break;
      }
      *interp = idx;
      *ColaOutput = 0;
      loopDelayBuf[loopWrPtr] = 0.0f;
      loopWrPtr = (loopWrPtr + 1) & 0xFF;
      if (loopFill < 256) loopFill++;
      *loopback = 0.0f;
      return 0.0f;
    }
  } else {
    *alignOffset = 0;
  }
  if (*ZeroCross) // using ZeroCross for enable for now, fix later
	  oldScaleValue=*ScaleValue;
  else oldScaleValue=0.0;
	  currentScaleValue=oldScaleValue;
  static float fDACScaleRecip=1.0f/0.000022888227f; //12./0x7ffff+ default, see fDACScaleFactor
  if (calibratedStep[*iCurrentFilter]!=0.0f && calibratedStepRecip[*iCurrentFilter]!=0.0f)
	  fDACScaleRecip=calibratedStepRecip[*iCurrentFilter]; //software writes 1/calibratedStep; multiply instead of fdiv
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
	volatile float temp = s_ib.f;
//	volatile float colaTemp = *ColaInput;
	output = temp*currentScaleValue;
	{
		int ld = *loop_delay;
		if (ld < 0)   ld = 0;
		if (ld > 255) ld = 255;
		loopDelayBuf[loopWrPtr] = output;
		*loopback = (loopFill >= ld) ? loopDelayBuf[(loopWrPtr - ld) & 0xFF] : 0.0f;
		loopWrPtr = (loopWrPtr + 1) & 0xFF;
		if (loopFill < 256) loopFill++;
	}
	if (bColaEnabled) {
		/* The Sine app sends UNIPOLAR cola values in 0..2.5 V units (centered 1.25V) --
		 * same convention as the ORIGINAL pre-FIR cola (ColaOutput=ColaInput*26214).
		 * The single-rate redesign added the SIGNED interpolation FIR (fir_cola_u),
		 * which needs a zero-centered signal, so RECENTER here: subtract the 1.25V
		 * midpoint -> bipolar +/-1.25, then x0.5 to pre-compensate the FIR's 2x
		 * passband gain (measured 2026-07-17). The +32768 offset-binary conversion
		 * back to the unipolar AD5541 happens AFTER the FIR in streamToData.
		 * Chain: UO=0 ->(0-1.25)*0.5*26214=-16384 ->FIRx2=-32768 ->+32768=0 =0V;
		 *        UO=1.25 ->0 ->32768 =1.25V;  UO=2.5 ->+16384 ->32768 ->65535 =2.5V.
		 * (Older wrong scales: x0.10417 = ancient +/-12 drive-V; x0.5 w/o recenter
		 * = assumed bipolar +/-1.25 input -> unipolar client clipped at +2.5V top.)
		 * Sentinel (no cola sample) -> 0 = mid-scale 1.25V. */
		float ColaNormalized = (s_cb.u == 0xeeeeeeee) ? 0.0f : ((s_cb.f - 1.25f) * 0.5f);
		/*
		 * The per-rate cola delay lives in the DRIVER now (2026-09-15). It
		 * writes group_delay on every rate change, the same pattern as
		 * loop_delay, so retuning needs no bitstream. colaDelay and
		 * group_delay subtract into the same index below, so one can do
		 * everything the other did and having both was two places to tune.
		 *
		 * The table removed here was 22,13,24,29,32,43,41,40,40 by
		 * samp_index 0..8. It was only ever right for samp_index <= 6: at
		 * its own calibration point (group_delay=1) 65536 and below landed
		 * within ~10 samples, but 131072 measured -43 and 262144 -130.
		 *
		 * The -50 headroom below is a different thing and stays: it keeps
		 * the 256-entry ring wrap away from normal group_delay values.
		 */
		const int colaDelay = 0;
		/* SIGNED bipolar counts (+/-32767, two's complement) for the SIGNED FIR;
		 * the ring buffer / streams just carry the bit pattern. */
		int colaI = (int)(ColaNormalized * fColaScaleFactorRecip);
		if (colaI > 32767) colaI = 32767;
		else if (colaI < -32768) colaI = -32768;
		unsigned short colaRaw = (unsigned short)colaI;
		colaDelayBuf[colaWrPtr] = colaRaw;
		/* 2026-10-28: the cola read index uses a CONSTANT in place of s_align_ofs.
		 * s_align_ofs latches once per boot (s_align_valid is only cleared by
		 * sync_reset, which never reaches this block while samples flow), and on
		 * the cola FIFO drain + prefill bitstream it came out 18 on most boots and
		 * 17 on some, moving cola by one sample for that whole boot. That
		 * bitstream starts cola and DAC in lockstep, so there is no per-run skew
		 * left to compensate. 18 = the common value, so the driver's group_delay
		 * table (#640, centred on 18-boots) and the ring headroom are unchanged.
		 * s_align_ofs is still computed and reported via alignOffset.
		 * The -50 keeps the 256-entry ring wrap away from normal group_delay values. */
		const int kAlignNominal = 18;
		ColaOut = colaDelayBuf[((int)colaWrPtr - (int)colaDelay - (int)(*group_delay) - kAlignNominal - 50) & 0xFF];
		*ColaOutput = ColaOut;
		colaWrPtr = (colaWrPtr + 1) & 0xFF;
	} else {
		ColaOut=0;
		*ColaOutput = 0;
	}
  volatile int offsetCounts = (int)((calibratedOffset[*iCurrentFilter]*fDACScaleRecip)+0.5f);
  volatile int calibratedCounts = (int)((currentScaleValue*temp)*fDACScaleRecip);//   /(*calibratedStep);
  calibratedCounts -= offsetCounts;
  volatile int clipCounts = (int)(*fClipValue*fDACScaleRecip);
  if (calibratedCounts>clipCounts) calibratedCounts = clipCounts;
  else if (calibratedCounts<(-1*clipCounts)) calibratedCounts = -1*clipCounts;
  DacCounts = calibratedCounts;
  pkt tmp;
  tmp.data = DacCounts;
  cpkt ctmp;
  ctmp.data = ColaOut;
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
	  COLAIN65536OUT262144.write(ctmp);
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
