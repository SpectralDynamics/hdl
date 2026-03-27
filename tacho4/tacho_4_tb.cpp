#include <stdio.h>
#include "tacho_4.h"

// void tacho_control( int *in_data, int spird_data,
//		uint1_t *spiwr_en, uint1_t *spird_en, uint2_t *spiwr_addr, uint2_t *spird_addr, int *spiwr_data,
//		uint4_t *spi_strobe, uint2_t *cs_line, uint1_t *cnt_en, uint1_t *slope, uint1_t *square, uint8 *avg)

int main(void)
{
    int tb_in_data;
    int tbrd_data = 3;

    uint1_t tbwr_en = 0;
    uint1_t tbrd_en = 0;
    uint2_t tbwr_addr = 0;
    uint2_t tbrd_addr = 0;
    uint4_t tb_strobe = 0;
    uint2_t tb_cs_line = 0;
    uint1_t tb_cnt_en = 0;
    uint1_t tb_slope = 0;
    uint1_t tb_square = 0;
    uint8 tb_avg = 1;

    int tbwr_data = 0;

    int i, tmp;

    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);

    tb_in_data = 0x41000086;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);

    tb_in_data = 0x42000002;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);


    tb_in_data = 0x45000001;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, start: %x\n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en, tb_cnt_en);

    tb_in_data = 0x44000000;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, start: %x\n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en, tb_cnt_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
//    tb_in_data = 0x400001BB;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);



//SPI
    tb_in_data = 0x49000064;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);

//GPIO
    tb_in_data = 0x4A000701;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);

//DAC
    tb_in_data = 0x48000A0;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);

//ADC
    tb_in_data = 0x4600000;
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);
    tacho_control( &tb_in_data, tbrd_data, &tbwr_en, &tbrd_en, &tbwr_addr, &tbrd_addr, &tbwr_data, &tb_strobe, &tb_cs_line, &tb_cnt_en, &tb_slope, &tb_square, &tb_avg);
    printf("in_data: %x, wr_data: %x, cs: %x, wr_en: %x, \n", tb_in_data, tbwr_data, tb_cs_line, tbwr_en);

}
