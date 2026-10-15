#include "ap_axi_sdata.h"
#include "hls_stream.h"
//static float fScaler = 1.0;
#define DWIDTH 23
#define type ap_int<DWIDTH>
volatile int interp_counter=0;
typedef hls::axis<type, 0, 0, 0> pkt;
#define CWIDTH 19
#define ctype ap_int<CWIDTH>
typedef hls::axis<ctype, 0, 0, 0> cpkt;
void streamToData(hls::stream<cpkt > &COLAIN65536OUT262144, hls::stream<pkt > &IN1024OUT8192, hls::stream<pkt > &IN2048OUT8192, hls::stream<pkt > &IN4096OUT8192, hls::stream<pkt > &IN8192OUT65536, hls::stream<pkt > &IN16384OUT65536, hls::stream<pkt > &IN32768OUT65536, hls::stream<pkt > &IN65536OUT262144,hls::stream<pkt > &IN131072OUT262144,hls::stream<pkt > &IN262144OUT262144,ap_uint<16> *ColaData,ap_uint<16> *ColaCountsOut,ap_uint<24> *DacData, ap_uint<4> *interp, ap_uint<20> *DacCountsOut)
{
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
#pragma HLS interface ap_ctrl_none port=DacData
#pragma HLS interface ap_ctrl_none port=ColaData
#pragma HLS interface ap_ctrl_none port=ColaCountsOut
#pragma HLS INTERFACE s_axilite port=interp bundle=control
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS interface s_axilite port=DacCountsOut bundle=control
	ap_int<24> DacCounts=0;
	ap_uint<16> ColaCounts=0;
	pkt tmp;
	cpkt ctmp;
	ap_uint<4> samp_index=*interp;
//	float fScaler = 1.900917;
	switch (samp_index) {
	  case 0:
		  IN1024OUT8192.read(tmp);
	//	  fScaler = 0.807;//1.230365;
		  break;
	  case 1:
	  	  IN2048OUT8192.read(tmp);
	 // 	  fScaler = 1.032753;
	  	  break;
	  case 2:
	  	  IN4096OUT8192.read(tmp);
	// 	  fScaler = 1.029153;
	  	  break;
	  case 3:
		  IN8192OUT65536.read(tmp);
//		  fScaler = 0.808;//1.227937;
	   	  break;
	  case 4:
	  	  IN16384OUT65536.read(tmp);
	//  	  fScaler = 1.029153;
	  	  break;
	  case 5:
	  	  IN32768OUT65536.read(tmp);
	//  	  fScaler = 1.022404;
	   	  break;
	  case 6:
	  	  IN65536OUT262144.read(tmp);
	  	  COLAIN65536OUT262144.read(ctmp);
	//  	  fScaler = 1.028697;
	   	  break;
	  case 7:
	  	  IN131072OUT262144.read(tmp);
	//  	  fScaler = 1.5864325;//1.269146;
	      break;
	  default:
	   	  IN262144OUT262144.read(tmp);
	 //  	  fScaler = 1.056065;//1.900917;
	}
	DacCounts = tmp.data;
	/* Cola stream is BIPOLAR SIGNED through the FIR (fir_compiler = two's
	 * complement); convert to offset-binary here for the unipolar AD5541:
	 * +32768 => bipolar zero = mid-scale (1.25V). Same conversion on the
	 * direct (non-FIR) path so both carry DriveScale's signed counts. */
	if (samp_index==6) {
		ap_int<19> colaVal = ctmp.data;          // signed FIR output
		colaVal += 32768;
		if (colaVal < 0) ColaCounts = 0;
		else if (colaVal > 65535) ColaCounts = 65535;
		else ColaCounts = (ap_uint<16>)colaVal;
	} else {
		ap_int<19> colaVal = (ap_int<16>)(*ColaData);  // signed bits from DriveScale ring
		colaVal += 32768;
		if (colaVal < 0) ColaCounts = 0;
		else if (colaVal > 65535) ColaCounts = 65535;
		else ColaCounts = (ap_uint<16>)colaVal;
	}
//	DacCounts = temp;  // quantize only case

	if (DacCounts > 524287) DacCounts=524287;
	else if (DacCounts < -524288) DacCounts=-524288;
	DacCounts &= 0xfffff;
	*DacCountsOut = (ap_uint<20>)DacCounts;  // expose current DAC code via AXI-Lite
	DacCounts |= 0x100000;
	*DacData = DacCounts;
	*ColaCountsOut = ColaCounts;
//	interp_counter++;
	return;
}
