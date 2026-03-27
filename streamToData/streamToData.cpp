#include "ap_axi_sdata.h"
#include "hls_stream.h"
//static float fScaler = 1.0;
#define DWIDTH 23
#define type ap_int<DWIDTH>
volatile int interp_counter=0;
typedef hls::axis<type, 0, 0, 0> pkt;
void streamToData(hls::stream<pkt > &IN1024OUT8192, hls::stream<pkt > &IN2048OUT8192, hls::stream<pkt > &IN4096OUT8192, hls::stream<pkt > &IN8192OUT65536, hls::stream<pkt > &IN16384OUT65536, hls::stream<pkt > &IN32768OUT65536, hls::stream<pkt > &IN65536OUT262144,hls::stream<pkt > &IN131072OUT262144,hls::stream<pkt > &IN262144OUT262144,ap_uint<24> *DacData, ap_uint<4> *interp)
{
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
#pragma HLS interface ap_ctrl_none port=interp
#pragma HLS interface ap_ctrl_none port=return
	ap_int<24> DacCounts=0;
	pkt tmp;
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
//	DacCounts = temp;  // quantize only case

	if (DacCounts > 524287) DacCounts=524287;
	else if (DacCounts < -524288) DacCounts=-524288;
	DacCounts &= 0xfffff;
	DacCounts |= 0x100000;
	*DacData = DacCounts;
//	interp_counter++;
	return;
}
