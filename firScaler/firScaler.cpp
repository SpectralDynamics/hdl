#include <stdlib.h>

#include "ap_axi_sdata.h"
#include "hls_stream.h"
#define DWIDTH 24
#define type ap_int<DWIDTH>

typedef hls::axis<type, 0, 0, 0> pkt;

void firScaler(hls::stream<pkt > &preScale, hls::stream<pkt > &postScale) {
#pragma HLS INTERFACE axis port=preScale
#pragma HLS INTERFACE axis port=postScale
//#pragma HLS interface ap_ctrl_none port=interp
#pragma HLS interface ap_ctrl_none port=return
//	int index = *interp;
	pkt tmp;
	ap_int<24> DacCounts=0;
	preScale.read(tmp);
	DacCounts=tmp.data;
	tmp.data = ap_int<24>((float)tmp.data * 1.0);//304135); //avg of the two for now
	postScale.write(tmp);
	return;
#if 0
	if (index==0) {
		tmp.data = ap_int<24>((float)tmp.data * 1.031674);
	}
	else {
		tmp.data = ap_int<24>((float)tmp.data * 1.029153);
	}
#endif
}
