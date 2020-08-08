
open_checkpoint Implement/UCBT_QPSK/top_ucbt_qpsk_synth.dcp
write_bitstream -file Bitstreams/UCBT_QPSK.bit 
close_project 

open_checkpoint Implement/UCBV_QPSK/top_ucb_synth.dcp
write_bitstream -file Bitstreams/UCBV_QPSK.bit 
close_project 

open_checkpoint Implement/UCB_QAM/top_ucb_qam_synth.dcp
write_bitstream -file Bitstreams/UCB_QAM.bit 
close_project 

open_checkpoint Implement/BLANK/top_ucb_synth.dcp
write_bitstream -file Bitstreams/BLANK.bit 
close_project 