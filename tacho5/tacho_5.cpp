
#include "tacho_5.h"


/*
- uint count:	output tacho_counter, number of system clock between two triggers
- uint4_t unit:	Desired quantity for output
- uint8_t avg:	Average Period
*/
static unsigned int prev_count = 0;


void tacho_quant( unsigned int count, uint4_t unit, uint8 avg, unsigned int *out_data)
{

#pragma HLS INTERFACE s_axilite register port=out_data			// it will be visiable memory mapped value

static float Tt, freq, r;
static unsigned int ir;
static union {
	unsigned int ii;
	float ff;
} value;


	if (count != prev_count) {
		if (unit != CNT) {
//			Tt = (2*10*(float)(count))/(1e+6);						// [ms], (1 count -> (2*system clock) * 10 ns)
			Tt = (float)(2*count)/(1e+5);							// [ms], 10ns * 2 * count / (1e+6)
//			if (avg !=1) Tt /= avg;
			freq = 1/Tt;											// [kHz]
//			r = 60 * 1000 * freq;									// [rpm]
			r = 60000 * freq;										// [rpm]  r = 60 * 1000 * freq[kHz]
			ir = (unsigned int)r;									// [rpm]
		}

		switch (unit) {
			case FRPM:	value.ff = r;	break;						// float speed
			case FKHZ:	value.ff = freq;	break;					// freq [kHz]
			case FHZ:	value.ff = freq*1000;	break;				// freq [Hz]
			case TPER:	value.ff = Tt;	break;						// Tperiod [ms]
			case IRPM:	value.ii = ir; break;						// unsigned int speed
			default:
			case CNT:	value.ii = count;	break;					// counter
		}															// switch()

		*out_data = value.ii;
		prev_count = count;
	}																// if ()


}








