// Board- ZC706
// Period- 20ns

#include "hls_math.h"
#include <math.h>
#include "ap_int.h"

void comparePR(float Q1, float Q2, ap_uint<2> *select){
#pragma HLS INTERFACE s_axilite port=select
#pragma HLS INTERFACE axis register both port=Q1
#pragma HLS INTERFACE axis register both port=Q2

	ap_uint<2> selectIn;

    if(Q1 >= Q2)
    {
    	selectIn = 1;
    }
    else{
    	selectIn = 2;
    }

    *select = selectIn;
}
