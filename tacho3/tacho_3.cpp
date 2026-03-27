//#include <hls_stream>
//#include "ap_int.h"
#include "tacho_3.h"

// V1.1 09.18.2025
// Now out_data is normal output port instead of AXI

// V1.2 10.10.2025
// include avg period


static unsigned int counter1, counter2;
static uint8 trig_cnt;
static unsigned int PrevState = idle, NextState = idle;
//static unsigned int NewEvent, PrevEvent = NOP;
static uint1_t pre_trig = 0;
static int error=100;

// void tacho( uint1_t en, uint1_t trig, hls::stream<int> &out_data)
int tacho( uint1_t en, uint1_t trig, uint8 avg, unsigned int *out_data)
{

// #pragma HLS INTERFACE s_axilite register port=out_data			// it will be visiable memory mapped value
	#pragma HLS INTERFACE ap_none register port=return
	#pragma HLS INTERFACE ap_none register port=out_data				// it is a data port
	#pragma HLS INTERFACE ap_none register port=en
	#pragma HLS INTERFACE ap_none register port=trig
	#pragma HLS INTERFACE ap_none register port=avg

	uint1_t t_trig;

	t_trig = trig & (~pre_trig);									// raising edge of trig
	pre_trig = trig;


    switch(NextState)
    {
	case idle:		if ( en == 1 ) {
						NextState = waiting_trigger;
					}
					PrevState = idle;
					error=1000;
					break;

	case waiting_trigger:
					if ( t_trig ) {
						error=2000;
						counter1 = 0;
						trig_cnt = avg;
//						if ( PrevState != idle) {
//							*out_data = counter2;					// counter2 processing
//							counter2 = 0;							// clear counter2
//							PrevState = NUM_STATES;
//						}
						NextState = counter1_run;
					}
					if ( en == false ) {
						error=3000;
						NextState = idle;
					}
					else error=4000;
					break;

	case counter1_run:
					counter1++;										// counter1 run
					if ( t_trig ) {
				//		error++;
						trig_cnt--;
						if (!trig_cnt) {
							error++;
							trig_cnt = avg;
							counter2 = 0;
							error = counter1+1000000;//
							*out_data = counter1+1000000;					// counter1 processing
							counter1 = 0;
							NextState = counter2_run;
						}
					//	else error=7000;
					}
					if ( en == 0 ) {
						error+=800;
						counter1 = 0;
						NextState = idle;
					}
					break;

	case counter2_run:
					counter2++;										// counter2 run
					if ( t_trig ) {
					//	error++;
						trig_cnt--;
						if (!trig_cnt) {
							error++;
							trig_cnt = avg;
							counter1 = 0;
							error = counter2;//
							*out_data = counter2;					// counter1 processing
							counter2 = 0;
							NextState = counter1_run;
						}
					//	else error=11000;
					}
					if ( en == false ) {
						error+=400;
						counter1 = 0;
						NextState = idle;
					}
				//	else error=12000;
					break;

	default:
		error=13000;
					break;
    }																// switch(NextState)

	return error;

}																	// tacho()

/*
- idle_state:
    Waiting for START Command from Host
	if START COMMAND goto waiting_trigger_state
- waiting_trigger_state
    Waiting for HW trigger signal (pos_trig)
	if TRIGGER goto counter1_run_state
- counter1_run_state
    Start counter1, Stop Counter2, save counter2 result to buffer or FIFO
	if TRIGGER goto counter2_run_state
	if STOP COMMAND, Goto idle_state
- counter2_run_state
    Start counter2, Stop Counter1, save counter1 result to buffer or FIFO
	if TRIGGER goto counter1_run_state
	if STOP COMMAND, Goto idle_state

- en	0: tacho IP stop
		1: tacho IP run

*/







