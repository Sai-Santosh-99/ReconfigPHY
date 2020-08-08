void informTransfer( unsigned int inform,  unsigned int *inform_out){

#pragma HLS INTERFACE axis register both port=inform_out
#pragma HLS INTERFACE s_axilite port=inform

	*inform_out = inform;
}
