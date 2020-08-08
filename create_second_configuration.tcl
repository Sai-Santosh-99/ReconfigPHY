open_checkpoint Checkpoint/static_route_design.dcp

read_checkpoint -cell design_1_i/MAB1/inst/u1 Synth/UCB_T/ucb_synth.dcp
read_checkpoint -cell design_1_i/MAB2/inst/u1 Synth/UCB_T/ucb_synth.dcp
read_checkpoint -cell design_1_i/MAB3/inst/u1 Synth/UCB_T/ucb_synth.dcp
read_checkpoint -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT/DAT_Mod_Ins Synth/QPSK/mod_synth.dcp
read_checkpoint -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT1/DataSymDem_ins Synth/QPSK/demod_synth.dcp

opt_design
place_design
route_design

write_checkpoint -force Implement/UCBT_QPSK/top_ucbt_qpsk_synth.dcp
close_project