//#include <hls_stream>
//#include "ap_int.h"
#include "tacho_4.h"

// Version 1.5.0	10.12.2025
//

static uint20_t cp_config = 0x00400;						// spi_config default
//static uint20_t cp_config = 0x00004;						// spi_config default
static int data_e = 0;										// Test: Prev input data
static int data0 = 0;
static int data1;
static int command = 0xaaaa;								//
static unsigned int next_state = IDLE;


static uint10_t ctrl_reg1 = 0x1BB;							// Default
static uint8 ctrl_reg2 = 166;								// Trigger level, 166/256 = 0,65 -> 5*0,65 = 3,24V
static uint8 ctrl_reg3 = 1;									// avg period
static uint20_t ctrl_reg4 = 1000;							// pulse/rev 1.000, not used

void tacho_control( int *in_data, int spird_data,
		uint1_t *spiwr_en, uint1_t *spird_en, uint2_t *spiwr_addr, uint2_t *spird_addr, int *spiwr_data,
		uint4_t *spi_strobe, uint2_t *cs_line, uint1_t *cnt_en, uint1_t *slope, uint1_t *square, uint8 *avg)
{

//#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE s_axilite register port=in_data			// it will be visiable memory mapped value
#pragma HLS INTERFACE ap_none register port=spiwr_en			//
#pragma HLS INTERFACE ap_none register port=spiwr_addr			//
#pragma HLS INTERFACE ap_none register port=spiwr_data			//
#pragma HLS INTERFACE ap_none register port=spi_strobe			//
#pragma HLS INTERFACE ap_none register port=cs_line				//
#pragma HLS INTERFACE ap_none register port=spird_en			//
#pragma HLS INTERFACE ap_none register port=spird_addr			//
#pragma HLS INTERFACE ap_none register port=cnt_en				//
#pragma HLS INTERFACE ap_none register port=avg					//
#pragma HLS INTERFACE ap_none register port=slope				//
#pragma HLS INTERFACE ap_none register port=square				//


  int test_data;

  test_data = *in_data;

  switch(next_state) {

  case IDLE:
	  	  if (test_data != data_e) {
	          data_e = test_data;
	          data0 = test_data;
	          if ( data0 & NEW_CMD) {								// New Command or parameter
	 	          command = ((data0 & CMD_MASK)>>CMD_DIST);
	  	          data0 = (data0 & ~NEW_CMD);						// clear NEW_CMD
	  	          switch(command) {
	  	            case WR_REG1:									// control bits
	  	            	ctrl_reg1 = (uint10_t)((data0 & 0x3ff) | 0xB8);	// POW_CNTR, RC_SEL, DC_TRACK and GPIO_OE = 1!!!
	  	            	*in_data = data0;
	  	            	break;										// next_state = IDLE
	  	            case WR_REG2:									// Trigger level, 8 bits
	  	            	ctrl_reg2 = (uint8)(data0 & 0xff);
	  	            	*in_data = data0;
	  	            	break;										// next_state = IDLE
	  	            case WR_REG3:									// Avg period
	  	            	ctrl_reg3 = (uint8)(data0 & 0xff);
	  	            	*avg = ctrl_reg3;							// done
	  	            	*in_data = data0;
	  	            	break;										// next_state = IDLE
	  	            case WR_REG4:
	  	            	ctrl_reg4 = (uint20_t)(data0 & 0xfffff);	// Pulse/rev, not used
	  	            	*in_data = data0;
	  	            	break;										// next_state = IDLE
	  	            case SETUP:
	  	            	*cnt_en =0;									// Stop count
	  	            	if (ctrl_reg1 & SLOPE_MASK) *slope =1; else *slope =0;
	  	            	if (ctrl_reg1 & SQUARE_MASK) *square =1; else *square =0;
	  	            	*avg = ctrl_reg3;							// avg period

	  	            	*cs_line = 0;								// SET SPI
	  	            	*spiwr_data = (unsigned int)cp_config;		// LSB first, LOOP_EN, CPOL, CPHA, 16 bits BAUD Divisor
	  	            	*spi_strobe = 0x7;							// copy 20 bits
	  	            	*spiwr_addr = 2;							// SPI config reg (reg2)
	  	    	  	    *spird_addr = 1;							// SPI status
	  	    	  	    next_state = SETUP_ST1;
	  	            	break;
	  	            case START:
	  	            	if (data0 & 1) *cnt_en = 1;					// START
	  	            	else *cnt_en =0;							// STOP
	  	            	break;										// next_state = IDLE
	  	            case RD_ADC:
	  	            	*cs_line = 3;
	  	            	*spiwr_data = 0xffff;						// dummy
	  	            	*spi_strobe = 3;							//
	  	            	*spiwr_addr = 0;							// SPI data reg (reg0)
	  	    	  	    *spird_addr = 1;							// SPI status
	  	    	  	    next_state = ADC_ST1;
	  	            	break;
	  	            case RD_RXBUF:
	  	            	*spird_addr = 0;
	  	            	next_state = ADC_ST5;
	  	            	break;

	  	            // ------------------------ original commands ---------------------
	  	            case SET_DAC:									//
	  	            	*cs_line = 2;
	  	            	*spiwr_data = ((data0 & 0xff) |0x2100);		// DAC control + data byte
	  	            	*spi_strobe = 0x3;							// 2 byte
	  	            	*spiwr_addr = 0;							// SPI data reg (reg0)
	  	    	  	    *spird_addr = 1;							// SPI status
	  	    	  	    next_state = SETUP_ST25;
	  	    	  	    break;
	  	            case SET_SPI:
	  	            	*cs_line = 0;
	  	            	cp_config = (uint20_t)(data0 & 0xfffff);	// LSB first, LOOP_EN, CPOL, CPHA, 16 bits BAUD Divisor
	  	            	*spiwr_data = (unsigned int)cp_config;
	  	            	*spi_strobe = 0x7;							// copy 20 bits
	  	            	*spiwr_addr = 2;							// SPI config reg (reg2)
	  	    	  	    *spird_addr = 1;							// SPI status
	  	    	  	    next_state = SETUP_ST25;
	  	            	break;
	  	            case SET_GPIO:
	  	            	*cs_line = 1;
	  	            	*spiwr_data = (data0 & 0xffff);				// High byte: Px address, Low byte: data
	  	            	*spi_strobe = 0x3;							// 2 byte
	  	            	*spiwr_addr = 0;							// SPI data reg (reg0)
	  	    	  	    *spird_addr = 1;							// SPI status
	  	 	          next_state = SETUP_ST25;
	  	            	break;
	  	            default: break;
	  	          }													// switch()
	          }														// if ( data0 & ~NEW_CMD)
	      }															// if (test_data != data_e)
	  	  // *spird_en = 0;
	  	  break;													// case IDLE

  case SETUP_ST1:													// SET SPI
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST2;
	  	  break;
  case SETUP_ST2:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST3;
	  	  break;

  case SETUP_ST3:													// SET GPIO_P0 -----------------
	  	  *cs_line = 1;
	  	  if (ctrl_reg1 & COUP_SEL_MASK) *spiwr_data =0x0001;
	  	  else *spiwr_data = 0x0000;								// High byte: Px address, Low byte: data
	  	  *spi_strobe = 0x3;										// 2 byte
	  	  *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST4;
	  	  break;
  case SETUP_ST4:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST5;
	  	  break;
  case SETUP_ST5:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST6;
	  	  break;

  case SETUP_ST6:													// SET GPIO_P1 --------------------
	  	  // *cs_line = 1;
	  	  if (ctrl_reg1 & FIL_SEL_MASK) *spiwr_data =0x0101;
	  	  else *spiwr_data = 0x0100;								// High byte: Px address, Low byte: data
	  	  // *spi_strobe = 0x3;										// 2 byte
	  	  // *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  // *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST7;
	  	  break;
  case SETUP_ST7:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST8;
	  	  break;
  case SETUP_ST8:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST9;
	  	  break;

  case SETUP_ST9:													// SET GPIO_P2 --------------------
	  	  // *cs_line = 1;
	  	  if (ctrl_reg1 & RANGE_SEL_MASK) *spiwr_data =0x0201;
	  	  else *spiwr_data = 0x0200;								// High byte: Px address, Low byte: data
	  	  // *spi_strobe = 0x3;										// 2 byte
	  	  // *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  // *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST10;
	  	  break;
  case SETUP_ST10:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST11;
	  	  break;
  case SETUP_ST11:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST12;
	  	  break;

  case SETUP_ST12:													// SET GPIO_P3 --------------------
	  	  // *cs_line = 1;
	  	  if (ctrl_reg1 & GPIO_OE_MASK) *spiwr_data =0x0301;
	  	  else *spiwr_data = 0x0300;								// High byte: Px address, Low byte: data
	  	  // *spi_strobe = 0x3;										// 2 byte
	  	  // *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  // *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST13;
	  	  break;
  case SETUP_ST13:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST14;
	  	  break;
  case SETUP_ST14:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST15;
	  	  break;

  case SETUP_ST15:													// SET GPIO_P4 --------------------
	  	  // *cs_line = 1;
	  	  if (ctrl_reg1 & TRACK_SEL_MASK) *spiwr_data =0x0401;
	  	  else *spiwr_data = 0x0400;								// High byte: Px address, Low byte: data
	  	  // *spi_strobe = 0x3;										// 2 byte
	  	  // *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  // *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST16;
	  	  break;
  case SETUP_ST16:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST17;
	  	  break;
  case SETUP_ST17:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST18;
	  	  break;

  case SETUP_ST18:													// SET GPIO_P5 --------------------
	  	  // *cs_line = 1;
	  	  if (ctrl_reg1 & RC_SEL_MASK) *spiwr_data =0x0501;
	  	  else *spiwr_data = 0x0500;								// High byte: Px address, Low byte: data
	  	  // *spi_strobe = 0x3;										// 2 byte
	  	  // *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  // *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST19;
	  	  break;
  case SETUP_ST19:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST20;
	  	  break;
  case SETUP_ST20:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST21;
	  	  break;

  case SETUP_ST21:													// SET GPIO_P7 --------------------
	  	  // *cs_line = 1;
	  	  if (ctrl_reg1 & POW_EN_MASK) *spiwr_data =0x0701;
	  	  else *spiwr_data = 0x0700;								// High byte: Px address, Low byte: data
	  	  // *spi_strobe = 0x3;										// 2 byte
	  	  // *spiwr_addr = 0;											// SPI data reg (reg0)
	  	  // *spird_addr = 1;											// SPI status
	  	  next_state = SETUP_ST22;
	  	  break;
  case SETUP_ST22:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST23;
	  	  break;
  case SETUP_ST23:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = SETUP_ST24;
	  	  break;													// end GPIO setting --------------------


  case SETUP_ST24:													// SET Trigger level (Write DAC)
	  	while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
       	*cs_line = 2;
       	*spiwr_data = (((int)(ctrl_reg2)&0xff) | 0x2100);			// DAC control + data byte
       	*spi_strobe = 0x3;											// 2 byte
       	*spiwr_addr = 0;											// SPI data reg (reg0)
  	    *spird_addr = 1;											// SPI status
  	    next_state = SETUP_ST25;
  	    break;
  case SETUP_ST25:													// SET SPI
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  *spiwr_en = 1;											// Write enable
	  	  next_state = SETUP_ST26;
	  	  break;
  case SETUP_ST26:													// SET SPI
	  	  *spiwr_en = 0;											// Write enable clear
	  	  next_state = LAST_STATE;
	  	  break;													// end GPIO setting --------------------


  case ADC_ST1:														// RD_ADC -----------------------------
//	      *spird_addr = 1;											// SPI module status bits
		  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	      *spird_en = 1;											// Write enable
	      *spiwr_en = 1;
	      next_state = ADC_ST2;
	      break;
  case ADC_ST2:														// RD_ADC -----------------------------
		  *spird_addr = 1;											// SPI module status bits
		  *spird_en = 0;
		  *spiwr_en = 0;
		  while ( !( spird_data & SPI_S_SPRF_MASK));				// wait for Receive flag
		  *spird_addr = 0;											// SPI module data reg
//		  next_state = ADC_ST3;
		  next_state = ADC_ST5;
		  break;
//  case ADC_ST3:													// RD_ADC -----------------------------
//	  	  *spird_addr = 0;											// SPI module data reg
//	  	  data1 = spird_data;										// ADC data
//	  	  next_state = ADC_ST4;
//	  	  break;
//  case ADC_ST4:													// RD_ADC -----------------------------
//	  	  *spird_addr = 1;											// SPI module status bits
//          next_state = LAST_STATE;
//	  	  break;

  case ADC_ST5:														// RD_ADC -----------------------------
	  	  *spird_addr = 0;											// SPI module data reg
	  	  data1 = spird_data;										// RX data
	  	  next_state = ADC_ST6;
	  	  break;
  case ADC_ST6:														// RD_ADC -----------------------------
		  *in_data = ((data1>>5)&0xff);
		  *spird_addr = 1;
		  next_state = IDLE;
		  break;


  case LAST_STATE:
	  	  *spird_addr = 1;											// SPI module status bits
	  	  while ( (spird_data & SPI_S_BUSY_MASK));					// wait while busy
	  	  data0 = (data0 & ~NEW_CMD);								// clear NEW_CMD
  	      *in_data = data0;
	  	  next_state = IDLE;
		  break;

  default:	break;

  }																	// switch()
  return;
}																	// tacho_control()


