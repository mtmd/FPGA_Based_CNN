#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports OSC_50_B3B]
create_clock -period 20 [get_ports OSC_50_B3D]
create_clock -period 20 [get_ports OSC_50_B4A]
create_clock -period 20 [get_ports OSC_50_B4D]
create_clock -period 20 [get_ports OSC_50_B7A]
create_clock -period 20 [get_ports OSC_50_B7D]
create_clock -period 20 [get_ports OSC_50_B8A]
create_clock -period 20 [get_ports OSC_50_B8D]


create_clock -period "100 MHz" -name {reconfig_xcvr_clk} {*reconfig_xcvr_clk*}
#create_clock -period "100 MHz" -name {OSC_50_B8A} {OSC_50_B8A}
#create_clock -period "50 MHz" -name {OSC_50_B3D} {OSC_50_B3D}

# JTAG Signal Constraints constrain the TCK port, assuming a 10MHz JTAG clock and 3ns delays
create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks -create_base_clocks

create_generated_clock -name {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_pcs|ch[4].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|clocktopld} -source {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_pcs|ch[3].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|clocktopld} -divide_by 1 {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_pcs|ch[4].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|clocktopld}
create_generated_clock -name {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_pcs|ch[4].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|observablebyteserdesclock} -source {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_pcs|ch[3].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|observablebyteserdesclock} -divide_by 1 {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_pcs|ch[4].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|observablebyteserdesclock}


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tms]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock altera_reserved_tck 5 [get_ports altera_reserved_tdo]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
#set_false_path -from [get_ports {reconfig_xcvr_clk}] -to [get_ports {hsma_clk_out_p2}]
set_false_path -from [get_ports {PCIE_PERST_n}]

set_false_path -from [get_ports {BUTTON[0]}]
set_false_path -from [get_ports {BUTTON[1]}]
set_false_path -from [get_ports {BUTTON[2]}]
set_false_path -from [get_ports {BUTTON[3]}]

set_false_path -from [get_ports {SW[0]}]
set_false_path -from [get_ports {SW[1]}]
set_false_path -from [get_ports {SW[2]}]
set_false_path -from [get_ports {SW[3]}]

set_false_path -to [get_ports {LED[0]}]
set_false_path -to [get_ports {LED[1]}]
set_false_path -to [get_ports {LED[2]}]
set_false_path -to [get_ports {LED[3]}]
set_false_path -to [get_ports {LED_BRACKET[0]}]
set_false_path -to [get_ports {LED_BRACKET[1]}]
set_false_path -to [get_ports {LED_BRACKET[2]}]
set_false_path -to [get_ports {LED_BRACKET[3]}]
set_false_path -to [get_ports {LED_RJ45_L}]
set_false_path -to [get_ports {LED_RJ45_R}]

set_false_path -to [get_ports {HEX0_D[0]}]
set_false_path -to [get_ports {HEX0_D[1]}]
set_false_path -to [get_ports {HEX0_D[2]}]
set_false_path -to [get_ports {HEX0_D[3]}]
set_false_path -to [get_ports {HEX0_D[4]}]
set_false_path -to [get_ports {HEX0_D[5]}]
set_false_path -to [get_ports {HEX0_D[6]}]
set_false_path -to [get_ports {HEX1_D[0]}]
set_false_path -to [get_ports {HEX1_D[1]}]
set_false_path -to [get_ports {HEX1_D[2]}]
set_false_path -to [get_ports {HEX1_D[3]}]
set_false_path -to [get_ports {HEX1_D[4]}]
set_false_path -to [get_ports {HEX1_D[5]}]
set_false_path -to [get_ports {HEX1_D[6]}]

#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -from [get_clocks {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_xcvr_avmm|avmm_interface_insts[*].stratixv_hssi_avmm_interface_inst|pmatestbussel[0]}] -to [get_clocks {reconfig_xcvr_clk}] -setup -end 2
set_multicycle_path -from [get_clocks {u0|pcie_system|pcie_256_dma|altera_s5_a2p|altpcie_hip_256_pipen1b|g_xcvr.sv_xcvr_pipe_native|inst_sv_xcvr_native|inst_sv_xcvr_avmm|avmm_interface_insts[*].stratixv_hssi_avmm_interface_inst|pmatestbussel[0]}] -to [get_clocks {reconfig_xcvr_clk}] -hold -end 2


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



