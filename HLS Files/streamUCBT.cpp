// Board- ZC706
// Period- 20ns

#include "ap_int.h"
#include "hls_math.h"
#include <math.h>

void streamUCBT(ap_uint<32> inform, float *Q){
#pragma HLS INTERFACE axis register both port=inform
#pragma HLS INTERFACE axis register both port=Q

	static float X, T, N;

	ap_uint<13> rewardFloat;
	float reward;
	float Q_in, m, V, a, b;

	rewardFloat = inform.range(14,2);
	reward = (float)rewardFloat/4096.0;

	if(inform[1] == 0 && inform[0] == 0){
		X = 1;
		T = 1;
		N = 4;
	}
	else if(inform[1] == 1 && inform[0] == 0){
		N = N + 1;
	}
	else{
		X = X + reward;
		T = T + 1;
		N = N + 1;
	}

	m = (float) X/T;
	V = (float) m - (m*m) + hls::sqrt(2*hls::log(N)/T);
	a = (float) hls::sqrt(hls::log(N)/T*V);

	Q_in = (float) m + a;
	*Q = Q_in;

}
