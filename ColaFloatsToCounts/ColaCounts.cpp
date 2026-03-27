#include<iostream>
#include "ap_int.h"
float fDACScaleFactor=0.00003814755474174105;

short ColaCounts(float input) {

#pragma HLS interface ap_ctrl_hs port=input

  return (short)(input/fDACScaleFactor);//sum|input;//(int)(input*fScale)|0x100000;
}
