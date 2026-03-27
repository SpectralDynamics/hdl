#ifndef __TACHO_H__
#define __TACHO_H__

//#include <hls_stream.h>
#include <ap_int.h>

// units
#define CNT 0			// integer, count
#define IRPM 1			// integer,	rpm
#define FRPM 2			// float,   rpm
#define FKHZ 3			// float,	kHz
#define FHZ 4			// float,	Hz
#define TPER 5			// float,	T period


typedef ap_uint<4> uint4_t;
typedef ap_uint<8> uint8;


void tacho_quant( unsigned int count, uint4_t unit, uint8 avg, unsigned int *out_data);


#endif
