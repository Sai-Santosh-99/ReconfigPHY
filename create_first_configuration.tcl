read_xdc fplan.xdc

opt_design
place_design
route_design

write_checkpoint -force Implement/UCB_QAM/top_ucb_qam_synth.dcp
