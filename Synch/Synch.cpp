#include "ap_int.h"

volatile bool bStarted    = false;
volatile bool SyncStarted = false;
volatile bool SpiSyncLast = false;
volatile bool doSingle    = false;
volatile bool pulseReady  = false;

bool Synch(int bufStart, volatile bool spiSync) {

#pragma HLS INTERFACE s_axilite register port=bufStart
#pragma HLS INTERFACE ap_ctrl_none register port=spiSync
#pragma HLS INTERFACE ap_ctrl_none register port=return

    if (!bufStart) {
        // Software wrote 0 to bufStart — full reset of all state
        bStarted    = false;
        SyncStarted = false;
        SpiSyncLast = false;
        doSingle    = false;
        pulseReady  = false;
    } else {
        // Detect falling edge of spiSync to set SyncStarted
        if (spiSync) {
            SpiSyncLast = true;
        } else if (!spiSync && SpiSyncLast) {
            // Falling edge detected — sync pulse has completed
            SyncStarted = true;
            SpiSyncLast = false;  // reset so we can detect the next edge
        }

        // Once both bufStart is nonzero and sync has been seen, latch bStarted
        // and hold it — do not re-evaluate to 0 every iteration
        if (SyncStarted) {
            bStarted = true;
        }
    }

    return bStarted;
}
