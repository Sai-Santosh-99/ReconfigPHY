// Board- ZC706
// Period- 20ns

#include "hls_math.h"
#include <math.h>
#include "ap_int.h"
#include <ap_fixed.h>

void compare(float Q1, float Q2, float Q3, ap_uint<2> *select){
#pragma HLS INTERFACE s_axilite port=select
#pragma HLS INTERFACE axis register both port=Q1
#pragma HLS INTERFACE axis register both port=Q2
#pragma HLS INTERFACE axis register both port=Q3

	ap_uint<2> selectIn;

    if(Q1 >= Q2 && Q1 >= Q3)
    {
    	selectIn = 1;
    }
    else if(Q2 >= Q1 && Q2 >= Q3)
    {
    	selectIn = 2;
    }
    else
    {
    	selectIn = 3;
    }

    *select = selectIn;
}
