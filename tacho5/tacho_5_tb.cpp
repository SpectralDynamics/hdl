#include <stdio.h>
#include "tacho_5.h"


int main(void)
{
    unsigned int data_stream;
    unsigned int tb_count;
    uint4_t tb_unit = IRPM;
    uint8_t tb_avg = 1;

    int i, tmp;


    tb_unit = IRPM;
    for ( i=0; i< 10; i++) {
    	tb_count = 50000* i;
    	 tacho_quant( tb_count, tb_unit, tb_avg, &data_stream);
    	    printf("count: %x\t%x\n", tb_count, data_stream);
    }

    tb_unit = FRPM;
    for ( i=0; i< 10; i++) {
    	tb_count = 50000* i;
    	 tacho_quant( tb_count, tb_unit, tb_avg, &data_stream);
    	    printf("count: %x\t%x\n", tb_count, data_stream);
    }
    tb_unit = FKHZ;
    for ( i=0; i< 10; i++) {
    	tb_count = 50000* i;
    	 tacho_quant( tb_count, tb_unit, tb_avg, &data_stream);
    	    printf("count: %x\t%x\n", tb_count, data_stream);
    }
}
