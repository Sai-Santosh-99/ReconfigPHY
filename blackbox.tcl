update_design -cell design_1_i/MAB1/inst/u1 -black_box
update_design -cell design_1_i/MAB2/inst/u1 -black_box
update_design -cell design_1_i/MAB3/inst/u1 -black_box
update_design -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT/DAT_Mod_Ins -black_box
update_design -cell design_1_i/OFDM/inst/DPR_QAM_QPSK_v1_0_S00_AXI_inst/T1/UUT1/DataSymDem_ins -black_box

lock_design -level routing

write_checkpoint -force Checkpoint/static_route_design.dcp
close_project