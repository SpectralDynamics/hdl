
#include "ap_int.h"
bool bStarted=false;
bool SyncStarted=false;
bool BufferStart(volatile int bufStart,bool spiSync) {

#pragma HLS INTERFACE s_axilite register port=bufStart
#pragma HLS INTERFACE ap_ctrl_none register port=spiSync
#pragma HLS INTERFACE ap_ctrl_none register port=return
/*	ap_uint<8> usr_gpio_o;
/*	usr_gpio_o=sync;*/
	if (spiSync) SyncStarted=true;
	if (bufStart && SyncStarted)
		bStarted=true;
	if (!bufStart) {
		bStarted=false;
		SyncStarted=false;
	}
  return bStarted;// usr_gpio_o;//sum|input;//(int)(input*fScale)|0x100000;
}
