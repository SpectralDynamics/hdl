#include "ap_int.h"

/*
 * ColaGate: pass-through gate for the cola DAC data path.
 *
 * Inserted between fifo_generator_5 (cola sample stream, 16-bit) and the
 * cola SPI peripheral that drives the Pmod DA3 / AD5541A.
 *
 *   - bRunningAcq HIGH  (acquisition running): output = fifo_generator_5 data
 *   - bRunningAcq LOW   (stopped/idle):        output = 0
 *
 * bRunningAcq is driven by the Synch IP's new bRunningAcqOut fabric pin, so
 * whenever the client stops (bRunningAcq goes false) the cola data line is
 * forced to 0 instead of holding the last streamed code.
 *
 * Free-running combinational block: ap_ctrl_none on return, ap_none on all
 * data ports (plain fabric wires, no handshake, no AXI-Lite).
 */
void ColaGate(bool bRunningAcq, ap_uint<16> dataIn, ap_uint<16> *dataOut) {
#pragma HLS INTERFACE ap_none port=bRunningAcq
#pragma HLS INTERFACE ap_none port=dataIn
#pragma HLS INTERFACE ap_none port=dataOut
#pragma HLS INTERFACE ap_ctrl_none port=return

    if (bRunningAcq)
        *dataOut = dataIn;
    else
        *dataOut = (ap_uint<16>)0;
}
