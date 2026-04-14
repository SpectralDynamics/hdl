#include "ap_int.h"

volatile bool bStarted             = false;
volatile bool SyncStarted          = false;
volatile bool SpiSyncLast          = false;
volatile bool doSingle             = false;
volatile bool pulseReady           = false;
volatile bool bCurrentSynch        = false;  /* latched output: set by HLS, cleared by driver */
volatile bool bSpuriousSynchLastIn = false;  /* previous bSpuriousSynch_i, for 1->0 edge detect */

bool Synch(int bufStart, volatile bool *bSpuriousSynch, volatile bool *bRunningAcq,
           volatile bool spiSync, volatile bool *bSynch) {

#pragma HLS INTERFACE s_axilite register port=bufStart
#pragma HLS INTERFACE ap_ctrl_none register port=spiSync
#pragma HLS INTERFACE s_axilite register port=bRunningAcq
#pragma HLS INTERFACE s_axilite register port=bSpuriousSynch
#pragma HLS INTERFACE ap_ctrl_none register port=bSynch
#pragma HLS INTERFACE ap_ctrl_none register port=return

    if (*bRunningAcq) {
        /*
         * Clear latch on 1->0 transition of bSpuriousSynch_i.
         * The Linux driver clears by writing 1 then 0 to bSpuriousSynch_i.
         * Using a transition rather than a level avoids false clears at
         * startup when bSpuriousSynch_i is already 0.
         */
        bool curIn = *bSpuriousSynch;
        if (bSpuriousSynchLastIn && !curIn) {
            bCurrentSynch = false;
        }
        bSpuriousSynchLastIn = curIn;

        /*
         * Set latch on spiSync falling edge (high->low), once per transition.
         * Placed after the clear check so that a sync arriving at the same
         * time as a driver clear wins — the latch remains set.
         */
        if (spiSync) {
            SpiSyncLast = true;
        } else if (!spiSync && SpiSyncLast) {
            bCurrentSynch = true;
            SpiSyncLast   = false;
        }

        *bSynch         = bCurrentSynch;
        *bSpuriousSynch = bCurrentSynch;
        return bStarted;
    }

    if (!bufStart) {
        /* Software wrote 0 to bufStart: full reset of all state */
        bStarted             = false;
        SyncStarted          = false;
        SpiSyncLast          = false;
        doSingle             = false;
        pulseReady           = false;
        bCurrentSynch        = false;
        bSpuriousSynchLastIn = false;
    } else {
        /* Detect falling edge of spiSync to set SyncStarted */
        if (spiSync) {
            SpiSyncLast = true;
        } else if (!spiSync && SpiSyncLast) {
            SyncStarted = true;
            SpiSyncLast = false;
        }

        if (SyncStarted) {
            bStarted = true;
        }
    }

    return bStarted;
}
