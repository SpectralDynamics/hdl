#ifndef __TACHO_H__
#define __TACHO_H__

//#include <hls_stream.h>
#include <ap_int.h>

// states
#define idle 0
#define waiting_trigger 1
#define counter1_run 2
#define counter2_run 3
#define NUM_STATES 4


typedef ap_uint<1> uint1_t;
typedef ap_uint<8> uint8;


// void tacho( uint1_t en, uint1_t trig, hls::stream<int> &out_data);
int tacho( uint1_t en, uint1_t trig, uint8 avg, unsigned int *out_data);


#endif
