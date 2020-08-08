open_checkpoint Checkpoint/static_route_design.dcp

update_design -buffer_ports -cell design_1_i/MAB1/inst/u1
update_design -buffer_ports -cell design_1_i/MAB2/inst/u1
update_design -buffer_ports -cell design_1_i/MAB3/inst/u1
update_design -buffer_ports -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT/DAT_Mod_Ins
update_design -buffer_ports -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT1/DataSymDem_ins

write_checkpoint -force Checkpoint/top_link_blank.dcp

place_design
route_design

write_checkpoint -force Implement/BLANK/top_ucb_synth.dcp
close_project