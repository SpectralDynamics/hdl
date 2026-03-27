#ifndef __TACHO_CONTROL_H__
#define __TACHO_CONTROL_H__

//#include <hls_stream.h>
#include <ap_int.h>

typedef ap_uint<1> uint1_t;
typedef ap_uint<2> uint2_t;
typedef ap_uint<3> uint3_t;
typedef ap_uint<4> uint4_t;
typedef ap_uint<8> uint8;
typedef ap_uint<10> uint10_t;

typedef ap_uint<20> uint20_t;

// data bits in ctrl_reg1:
// B0:	Coupling Select (COUP_SEL_A  0:DC, 1:AC)					default: AC (1)		GPIO_P0
// B1:	Filter Select (FILTER_SEL_A  Low pass, 0: 500kHz, 1:50kHz)	default: 50 kHz (1)	GPIO_P1
// B2:	Range_Select (RANGE_SEL_A  0:25V, 1:5V)						default: 25V (0)	GPIO_P2
// B3:	OE_n GPIO output 0:enable, 1:disable						default: disable (1)GPIO_P3
// B4:	DC TRACK (CH_PC_TRK, 0:nop, 1:CH_POS)						default: CH_POS (1)	GPIO_P4
// B5:	RC_SEL (Low pass)											default: (1)		GPIO_P5
// B6:	N/C															default: (0)
// B7:	Power CNTR 0:OFF, 1:ON										default: ON, (1)	GPIO_P7
// B8:  Trigger slope 0:NEG, 1:POS									default: POS (1)	slope output
// B9:	Square Enable 0:dis, 1:en									default: dis (0)	square output
// B10:
// B11:
// B12:
// B13:
// B14:
// B15:
// B16:
// B17:
// B18:
// B19:
// B20:
// B21:
// B22:
// B23:
// B24: Command code B0
// B25: Command code B1
// B26: Command code B2
// B27: Command code B3
// B28: Command code B4
// B29: Command code B5
// B30:	New command/parameter
// B31: Not used

#define COUP_SEL_MASK 0x1
#define FIL_SEL_MASK 0x2
#define RANGE_SEL_MASK 0x4
#define GPIO_OE_MASK 0x8
#define TRACK_SEL_MASK 0x10
#define RC_SEL_MASK 0x20
#define POW_EN_MASK 0x80
#define SLOPE_MASK 0x100
#define SQUARE_MASK 0x200

// states
#define IDLE 0
#define SETUP_ST1 1
#define SETUP_ST2 2
#define SETUP_ST3 3
#define SETUP_ST4 4
#define SETUP_ST5 5
#define SETUP_ST6 6
#define SETUP_ST7 7
#define SETUP_ST8 8
#define SETUP_ST9 9
#define SETUP_ST10 10
#define SETUP_ST11 11
#define SETUP_ST12 12
#define SETUP_ST13 13
#define SETUP_ST14 14
#define SETUP_ST15 15
#define SETUP_ST16 16
#define SETUP_ST17 17
#define SETUP_ST18 18
#define SETUP_ST19 19
#define SETUP_ST20 20
#define SETUP_ST21 21
#define SETUP_ST22 22
#define SETUP_ST23 23
#define SETUP_ST24 24
#define SETUP_ST25 25
#define SETUP_ST26 26

#define ADC_ST1 31
#define ADC_ST2 32
#define ADC_ST3 33
#define ADC_ST4 34
#define ADC_ST5 35
#define ADC_ST6 36

#define LAST_STATE 40





#define NEW_CMD 0x40000000				// B30
#define CMD_MASK 0x3F000000				// B29-B24
#define CMD_DIST 24						// command from B24

// commands
#define WR_REG1 0						// WR_CTRL_REG1 command	(control bits)
#define WR_REG2 1						// WR_CTRL_REG2 command (trigger level)
#define WR_REG3 2						// WR_CTRL_REG3 command (avg period)
#define WR_REG4 3						// WR_CTRL_REG4 command (pulse/rev)
#define SETUP 4							// SETUP command						cca. 3 ms
#define START 5							// START / STOP measurement
#define RD_ADC 6						// Read_ADC output
#define RD_RXBUF 7						// Read SPI RX buffer
#define SET_DAC 8						// SET_DAC A output
#define SET_SPI 9						// SPI_INIT command
#define SET_GPIO 10						// SET_GPIO EXPander port command


#define SPI_S_SPTE_MASK 0x1
#define SPI_S_SPRF_MASK 0x2
#define SPI_S_BUSY_MASK 0x4

void tacho_control( int *in_data, int spird_data,
		uint1_t *spiwr_en, uint1_t *spird_en, uint2_t *spiwr_addr, uint2_t *spird_addr, int *spiwr_data,
		uint4_t *spi_strobe, uint2_t *cs_line, uint1_t *cnt_en, uint1_t *slope, uint1_t *square, uint8 *avg);


#endif
