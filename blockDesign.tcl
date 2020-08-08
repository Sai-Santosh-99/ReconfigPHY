create_project tutorial C:/Summer/Tutorial/tutorial -part xc7z045ffg900-2
set_property board_part xilinx.com:zc706:part0:1.4 [current_project]
set_property  ip_repo_paths  {C:/Summer/Tutorial/comparePR C:/Summer/Tutorial/compareHLS C:/Summer/Tutorial/informTransfer C:/Summer/Tutorial/streamBlank_1.0} [current_project]
update_ip_catalog
set_property  ip_repo_paths  {C:/Summer/Tutorial/comparePR C:/Summer/Tutorial/DPR_QAM_QPSK_1.0 C:/Summer/Tutorial/compareHLS C:/Summer/Tutorial/informTransfer C:/Summer/Tutorial/streamBlank_1.0} [current_project]
update_ip_catalog
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:DPR_QAM_QPSK:1.0 DPR_QAM_QPSK_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:streamBlank:1.0 streamBlank_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:streamBlank:1.0 streamBlank_1
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:streamBlank:1.0 streamBlank_2
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/DPR_QAM_QPSK_0/S00_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins DPR_QAM_QPSK_0/S00_AXI]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:informTransfer:1.0 informTransfer_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:informTransfer:1.0 informTransfer_1
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:informTransfer:1.0 informTransfer_2
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (50 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (50 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/informTransfer_0/s_axi_AXILiteS} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins informTransfer_0/s_axi_AXILiteS]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (50 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (50 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/informTransfer_1/s_axi_AXILiteS} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins informTransfer_1/s_axi_AXILiteS]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (50 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (50 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/informTransfer_2/s_axi_AXILiteS} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins informTransfer_2/s_axi_AXILiteS]
endgroup
regenerate_bd_layout
set_property location {3.5 1475 226} [get_bd_cells streamBlank_0]
set_property location {3 925 745} [get_bd_cells streamBlank_2]
set_property location {4 1477 582} [get_bd_cells streamBlank_2]
set_property location {4 1516 395} [get_bd_cells streamBlank_1]
connect_bd_net [get_bd_pins informTransfer_0/inform_out_TVALID] [get_bd_pins streamBlank_0/s_inform_tvalid]
connect_bd_net [get_bd_pins informTransfer_0/inform_out_TREADY] [get_bd_pins streamBlank_0/s_inform_tready]
connect_bd_net [get_bd_pins informTransfer_0/inform_out_TDATA] [get_bd_pins streamBlank_0/s_inform_tdata]
connect_bd_net [get_bd_pins informTransfer_1/inform_out_TVALID] [get_bd_pins streamBlank_1/s_inform_tvalid]
connect_bd_net [get_bd_pins informTransfer_1/inform_out_TREADY] [get_bd_pins streamBlank_1/s_inform_tready]
connect_bd_net [get_bd_pins informTransfer_1/inform_out_TDATA] [get_bd_pins streamBlank_1/s_inform_tdata]
connect_bd_net [get_bd_pins informTransfer_2/inform_out_TVALID] [get_bd_pins streamBlank_2/s_inform_tvalid]
connect_bd_net [get_bd_pins informTransfer_2/inform_out_TREADY] [get_bd_pins streamBlank_2/s_inform_tready]
connect_bd_net [get_bd_pins informTransfer_2/inform_out_TDATA] [get_bd_pins streamBlank_2/s_inform_tdata]
connect_bd_intf_net [get_bd_intf_pins informTransfer_2/inform_out] [get_bd_intf_pins streamBlank_2/S_INFORM]
connect_bd_intf_net [get_bd_intf_pins informTransfer_1/inform_out] [get_bd_intf_pins streamBlank_1/S_INFORM]
connect_bd_intf_net [get_bd_intf_pins informTransfer_0/inform_out] [get_bd_intf_pins streamBlank_0/S_INFORM]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK0 (50 MHz)" }  [get_bd_pins streamBlank_0/s_inform_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK0 (50 MHz)" }  [get_bd_pins streamBlank_1/s_inform_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK0 (50 MHz)" }  [get_bd_pins streamBlank_2/s_inform_aclk]
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:compare:1.0 compare_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (50 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (50 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/compare_0/s_axi_AXILiteS} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins compare_0/s_axi_AXILiteS]
set_property location {4.5 1966 430} [get_bd_cells compare_0]
connect_bd_net [get_bd_pins streamBlank_0/final_q] [get_bd_pins compare_0/Q1_TDATA]
connect_bd_net [get_bd_pins streamBlank_0/final_q_valid] [get_bd_pins compare_0/Q1_TVALID]
connect_bd_net [get_bd_pins streamBlank_1/final_q] [get_bd_pins compare_0/Q2_TDATA]
connect_bd_net [get_bd_pins streamBlank_1/final_q_valid] [get_bd_pins compare_0/Q2_TVALID]
connect_bd_net [get_bd_pins streamBlank_2/final_q] [get_bd_pins compare_0/Q3_TDATA]
connect_bd_net [get_bd_pins streamBlank_2/final_q_valid] [get_bd_pins compare_0/Q3_TVALID]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:comparePR:1.0 comparePR_0
endgroup
set_property location {5 1882 838} [get_bd_cells comparePR_0]
connect_bd_net [get_bd_pins comparePR_0/Q1_TVALID] [get_bd_pins streamBlank_0/final_q_valid]
connect_bd_net [get_bd_pins comparePR_0/Q1_TDATA] [get_bd_pins streamBlank_0/final_q]
connect_bd_net [get_bd_pins comparePR_0/Q2_TVALID] [get_bd_pins streamBlank_1/final_q_valid]
connect_bd_net [get_bd_pins comparePR_0/Q2_TDATA] [get_bd_pins streamBlank_1/final_q]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (50 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (50 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/comparePR_0/s_axi_AXILiteS} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins comparePR_0/s_axi_AXILiteS]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
endgroup
set_property location {3 724 744} [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins informTransfer_2/ap_start]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins informTransfer_1/ap_start]
connect_bd_net [get_bd_pins informTransfer_0/ap_start] [get_bd_pins xlconstant_0/dout]
set_property location {4 1573 621} [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins compare_0/ap_start] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins comparePR_0/ap_start] [get_bd_pins xlconstant_0/dout]
set_property name machine1 [get_bd_cells informTransfer_0]
set_property name machine2 [get_bd_cells informTransfer_1]
set_property name machine3 [get_bd_cells informTransfer_2]
set_property name MAB1 [get_bd_cells streamBlank_0]
set_property name MAB2 [get_bd_cells streamBlank_1]
set_property name MAB3 [get_bd_cells streamBlank_2]
set_property name Compare [get_bd_cells compare_0]
set_property name Compare2 [get_bd_cells comparePR_0]
set_property name OFDM [get_bd_cells DPR_QAM_QPSK_0]
regenerate_bd_layout
validate_bd_design
connect_bd_net [get_bd_pins MAB2/final_q_ready] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins MAB1/final_q_ready] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_pins MAB3/final_q_ready] [get_bd_pins xlconstant_0/dout]
regenerate_bd_layout
validate_bd_design
save_bd_design
make_wrapper -files [get_files C:/Summer/Tutorial/tutorial/tutorial.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse C:/Summer/Tutorial/tutorial/tutorial.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
launch_runs synth_1 -jobs 4
