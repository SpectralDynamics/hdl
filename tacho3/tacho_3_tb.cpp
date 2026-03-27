#include <stdio.h>
#include "tacho_3.h"


int main(void)
{
    unsigned int data_stream;
    uint1_t en_tb = 0;
    uint1_t trig_tb = 0;
    uint8 avg_tb = 1;
    int i, tmp;

    tacho( en_tb, trig_tb, avg_tb, &data_stream);		// idle_state
    printf("Reset, Idle state: %d\n", data_stream);

    en_tb = 1;									// start tacho
    for ( i = 0; i < 10; i++ ) {				// waiting_trigger
        if ( i < 1) trig_tb = 1;
        else trig_tb = 0;
        tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: waiting_trigger: %d\n", data_stream);

    for ( i = 0; i < 50; i++ ) {				// counter1_run
        if ( i < 1) trig_tb = 1;
        else trig_tb = 0;
        tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: counter1_run: %d\n", data_stream);

    for ( i = 0; i < 45; i++ ) {				// counter2_run
        if ( i < 1) trig_tb = 1;
        else trig_tb = 0;
        tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: counter2_run: %d\n", data_stream);

    for ( i = 0; i < 40; i++ ) {				// counter1_run
        if ( i < 1) trig_tb = 1;
        else trig_tb = 0;
        tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: counter1_run: %d\n", data_stream);

    for ( i = 0; i < 35; i++ ) {				// counter2_run
        if ( i < 1) trig_tb = 1;
        else trig_tb = 0;
        tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: counter2_run: %d\n", data_stream);

    for ( i = 0; i < 30; i++ ) {				// counter1_run
        if ( i < 1) trig_tb = 1;
        else trig_tb = 0;
        tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: counter1_run: %d\n", data_stream);

     for ( i = 0; i < 10; i++ ) {				// idle
         en_tb = 0;
         tacho( en_tb, trig_tb, avg_tb, &data_stream);
    }
    printf("State: idle, %d\n", data_stream);


//    printf("stream: ");
//    while (!data_stream.empty() ) {
//    	tmp = data_stream.read();
//    	printf("%d, ", tmp);
//    }
//    printf("\n");
	
}
