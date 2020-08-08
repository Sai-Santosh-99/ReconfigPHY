read_checkpoint -cell design_1_i/MAB1/inst/u1 Synth/UCB/ucb_synth.dcp
read_checkpoint -cell design_1_i/MAB2/inst/u1 Synth/UCB/ucb_synth.dcp
read_checkpoint -cell design_1_i/MAB3/inst/u1 Synth/UCB/ucb_synth.dcp
read_checkpoint -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT/DAT_Mod_Ins Synth/QAM/mod_synth.dcp
read_checkpoint -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT1/DataSymDem_ins Synth/QAM/demod_synth.dcp


set_property HD.RECONFIGURABLE 1 [get_cells design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT/DAT_Mod_Ins]
set_property HD.RECONFIGURABLE 1 [get_cells design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT1/DataSymDem_ins]
set_property HD.RECONFIGURABLE 1 [get_cells design_1_i/MAB1/inst/u1]
set_property HD.RECONFIGURABLE 1 [get_cells design_1_i/MAB2/inst/u1]
set_property HD.RECONFIGURABLE 1 [get_cells design_1_i/MAB3/inst/u1]

write_checkpoint -force Checkpoint/top_link_ucb_qam.dcp