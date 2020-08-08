# Intelligent & Reconfigurable Wireless Physical Layer (PHY)
Source Code for Reconfigurable &amp; Intelligent Wireless Physical Layer (PHY)

- To replicate the MAB, synthesize the .cpp files in the 'HLS Files' folder using Vivalo HLS with the following parameters:
    1) Board: ZC706 without daughter board
    2) Clock period: 20ns

- To replicate the PHY, dump the .v files in the 'Verilog PHY Files' folder using Vivado IP Packager.

- To replicate Dynamic Partial Reconfiguration, use the TCL files and create the block design with the following parameters:
    1) Board: ZC706 without daughter board
    2) Clock period: 20ns
