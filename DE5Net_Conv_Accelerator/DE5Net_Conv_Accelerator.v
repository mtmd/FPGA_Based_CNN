// DE5-Net convolution accelerator design.
//
// Implements 1st convolutional layer of AlexNet.
//
//
//
//
//
//
//
//
//
//

module DE5Net_Conv_Accelerator(

	//////////// CLOCK//////////
	OSC_50_B3B,
	OSC_50_B3D,
	OSC_50_B4A,
	OSC_50_B4D,
	OSC_50_B7A,
	OSC_50_B7D,
	OSC_50_B8A,
	OSC_50_B8D,

	//////////// LED x 10//////////
	LED,
	LED_BRACKET,
	LED_RJ45_L,
	LED_RJ45_R,

	//////////// BUTTON x 4 and CPU_RESET_n//////////
	BUTTON,
	CPU_RESET_n,

	//////////// SWITCH x 4//////////
	SW,

	//////////// 7-Segement//////////
	HEX0_D,
	HEX0_DP,
	HEX1_D,
	HEX1_DP,

	//////////// PCIe x 8//////////
	PCIE_PERST_n,
	PCIE_REFCLK_p,
	PCIE_RX_p,
	PCIE_SMBCLK,
	PCIE_SMBDAT,
	PCIE_TX_p,
	PCIE_WAKE_n,

	//////////// RZQ//////////
	RZQ_0,
	RZQ_1,
	RZQ_4,
	RZQ_5,

	//////////// DDR3 SODIMM, DDR3 SODIMM_A//////////
	DDR3A_A,
	DDR3A_BA,
	DDR3A_CAS_n,
	DDR3A_CK,
	DDR3A_CK_n,
	DDR3A_CKE,
	DDR3A_CS_n,
	DDR3A_DM,
	DDR3A_DQ,
	DDR3A_DQS,
	DDR3A_DQS_n,
	DDR3A_EVENT_n,
	DDR3A_ODT,
	DDR3A_RAS_n,
	DDR3A_RESET_n,
	DDR3A_SCL,
	DDR3A_SDA,
	DDR3A_WE_n
	//DDR3A_OCT_RZQIN
);

//=======================================================
//  PARAMETER declarations
//=======================================================

`include "cnn_parameters.vh"
`include "main_states.vh"
`include "read_states.vh"
`include "parameters.vh"
`include "bit_width.vh"

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK//////////
input 		          		OSC_50_B3B;
input 		          		OSC_50_B3D;
input 		          		OSC_50_B4A;
input 		          		OSC_50_B4D;
input 		          		OSC_50_B7A;
input 		          		OSC_50_B7D;
input 		          		OSC_50_B8A;
input 		          		OSC_50_B8D;

//////////// LED x 10//////////
output		     [3:0]		LED;
output		     [3:0]		LED_BRACKET;
output		          		LED_RJ45_L;
output		          		LED_RJ45_R;

//////////// BUTTON x 4 and CPU_RESET_n//////////
input 		     [3:0]		BUTTON;
input 		          		CPU_RESET_n;

//////////// SWITCH x 4//////////
input 		     [3:0]		SW;

//////////// 7-Segement//////////
output		     [6:0]		HEX0_D;
output		          		HEX0_DP;
output		     [6:0]		HEX1_D;
output		          		HEX1_DP;

//////////// PCIe x 8//////////
input 		          		PCIE_PERST_n;
input 		          		PCIE_REFCLK_p;
input 		     [7:0]		PCIE_RX_p;
inout 		          		PCIE_SMBCLK;
inout 		          		PCIE_SMBDAT;
output		     [7:0]		PCIE_TX_p;
output		          		PCIE_WAKE_n;

//////////// RZQ//////////
input 		          		RZQ_0;
input 		          		RZQ_1;
input 		          		RZQ_4;
input 		          		RZQ_5;

//////////// DDR3 SODIMM, DDR3 SODIMM_A//////////
output		    [15:0]		DDR3A_A;
output		     [2:0]		DDR3A_BA;
output		          		DDR3A_CAS_n;
output		     [1:0]		DDR3A_CK;
output		     [1:0]		DDR3A_CK_n;
output		     [1:0]		DDR3A_CKE;
output		     [1:0]		DDR3A_CS_n;
output		     [7:0]		DDR3A_DM;
inout 		    [63:0]		DDR3A_DQ;
inout 		     [0:0]		DDR3A_DQS;
inout 		     [0:0]		DDR3A_DQS_n;
input 		          		DDR3A_EVENT_n;
output		     [1:0]		DDR3A_ODT;
output		          		DDR3A_RAS_n;
output		          		DDR3A_RESET_n;
output		          		DDR3A_SCL;
inout 		          		DDR3A_SDA;
output		          		DDR3A_WE_n;
//input		          			DDR3A_OCT_RZQIN;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire sys_clk;
wire global_reset_n;

wire [`M_IDX_SZ - 1 : 0] m;
wire [`N_IDX_SZ - 1 : 0] n;

wire in_buf_0_read_n;
wire in_buf_0_write_n;
wire in_buf_0_waitrequest;
wire [`IFM_ADR_W - 1 : 0] in_buf_0_address;
wire in_buf_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] in_buf_0_readdata;
wire [`DATA_WIDTH - 1 : 0] in_buf_0_writedata;

wire in_buf_1_read_n;
wire in_buf_1_write_n;
wire in_buf_1_waitrequest;
wire [`IFM_ADR_W - 1 : 0] in_buf_1_address;
wire in_buf_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] in_buf_1_readdata;
wire [`DATA_WIDTH - 1 : 0] in_buf_1_writedata;

wire out_buf_0_p1_read_n;
wire out_buf_0_p1_write_n;
wire out_buf_0_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_0_p1_address;
wire out_buf_0_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_0_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_0_p1_writedata;

wire out_buf_0_p2_read_n;
wire out_buf_0_p2_write_n;
wire out_buf_0_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_0_p2_address;
wire out_buf_0_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_0_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_0_p2_writedata;

wire out_buf_1_p1_read_n;
wire out_buf_1_p1_write_n;
wire out_buf_1_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_1_p1_address;
wire out_buf_1_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_1_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_1_p1_writedata;

wire out_buf_1_p2_read_n;
wire out_buf_1_p2_write_n;
wire out_buf_1_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_1_p2_address;
wire out_buf_1_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_1_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_1_p2_writedata;

wire out_buf_2_p1_read_n;
wire out_buf_2_p1_write_n;
wire out_buf_2_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_2_p1_address;
wire out_buf_2_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_2_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_2_p1_writedata;

wire out_buf_2_p2_read_n;
wire out_buf_2_p2_write_n;
wire out_buf_2_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_2_p2_address;
wire out_buf_2_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_2_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_2_p2_writedata;

wire out_buf_3_p1_read_n;
wire out_buf_3_p1_write_n;
wire out_buf_3_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_3_p1_address;
wire out_buf_3_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_3_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_3_p1_writedata;

wire out_buf_3_p2_read_n;
wire out_buf_3_p2_write_n;
wire out_buf_3_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_3_p2_address;
wire out_buf_3_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_3_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_3_p2_writedata;

wire out_buf_4_p1_read_n;
wire out_buf_4_p1_write_n;
wire out_buf_4_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_4_p1_address;
wire out_buf_4_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_4_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_4_p1_writedata;

wire out_buf_4_p2_read_n;
wire out_buf_4_p2_write_n;
wire out_buf_4_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_4_p2_address;
wire out_buf_4_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_4_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_4_p2_writedata;

wire out_buf_5_p1_read_n;
wire out_buf_5_p1_write_n;
wire out_buf_5_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_5_p1_address;
wire out_buf_5_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_5_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_5_p1_writedata;

wire out_buf_5_p2_read_n;
wire out_buf_5_p2_write_n;
wire out_buf_5_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_5_p2_address;
wire out_buf_5_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_5_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_5_p2_writedata;

wire out_buf_6_p1_read_n;
wire out_buf_6_p1_write_n;
wire out_buf_6_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_6_p1_address;
wire out_buf_6_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_6_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_6_p1_writedata;

wire out_buf_6_p2_read_n;
wire out_buf_6_p2_write_n;
wire out_buf_6_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_6_p2_address;
wire out_buf_6_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_6_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_6_p2_writedata;

wire out_buf_7_p1_read_n;
wire out_buf_7_p1_write_n;
wire out_buf_7_p1_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_7_p1_address;
wire out_buf_7_p1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_7_p1_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_7_p1_writedata;

wire out_buf_7_p2_read_n;
wire out_buf_7_p2_write_n;
wire out_buf_7_p2_waitrequest;
wire [`OFM_ADR_W - 1 : 0] out_buf_7_p2_address;
wire out_buf_7_p2_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] out_buf_7_p2_readdata;
wire [`DATA_WIDTH - 1 : 0] out_buf_7_p2_writedata;

wire w_buf_0_0_read_n;
wire w_buf_0_0_write_n;
wire w_buf_0_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_0_0_address;
wire w_buf_0_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_0_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_0_0_writedata;

wire w_buf_0_1_read_n;
wire w_buf_0_1_write_n;
wire w_buf_0_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_0_1_address;
wire w_buf_0_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_0_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_0_1_writedata;

wire w_buf_1_0_read_n;
wire w_buf_1_0_write_n;
wire w_buf_1_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_1_0_address;
wire w_buf_1_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_1_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_1_0_writedata;

wire w_buf_1_1_read_n;
wire w_buf_1_1_write_n;
wire w_buf_1_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_1_1_address;
wire w_buf_1_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_1_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_1_1_writedata;

wire w_buf_2_0_read_n;
wire w_buf_2_0_write_n;
wire w_buf_2_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_2_0_address;
wire w_buf_2_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_2_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_2_0_writedata;

wire w_buf_2_1_read_n;
wire w_buf_2_1_write_n;
wire w_buf_2_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_2_1_address;
wire w_buf_2_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_2_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_2_1_writedata;

wire w_buf_3_0_read_n;
wire w_buf_3_0_write_n;
wire w_buf_3_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_3_0_address;
wire w_buf_3_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_3_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_3_0_writedata;

wire w_buf_3_1_read_n;
wire w_buf_3_1_write_n;
wire w_buf_3_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_3_1_address;
wire w_buf_3_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_3_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_3_1_writedata;

wire w_buf_4_0_read_n;
wire w_buf_4_0_write_n;
wire w_buf_4_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_4_0_address;
wire w_buf_4_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_4_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_4_0_writedata;

wire w_buf_4_1_read_n;
wire w_buf_4_1_write_n;
wire w_buf_4_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_4_1_address;
wire w_buf_4_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_4_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_4_1_writedata;

wire w_buf_5_0_read_n;
wire w_buf_5_0_write_n;
wire w_buf_5_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_5_0_address;
wire w_buf_5_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_5_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_5_0_writedata;

wire w_buf_5_1_read_n;
wire w_buf_5_1_write_n;
wire w_buf_5_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_5_1_address;
wire w_buf_5_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_5_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_5_1_writedata;

wire w_buf_6_0_read_n;
wire w_buf_6_0_write_n;
wire w_buf_6_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_6_0_address;
wire w_buf_6_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_6_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_6_0_writedata;

wire w_buf_6_1_read_n;
wire w_buf_6_1_write_n;
wire w_buf_6_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_6_1_address;
wire w_buf_6_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_6_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_6_1_writedata;

wire w_buf_7_0_read_n;
wire w_buf_7_0_write_n;
wire w_buf_7_0_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_7_0_address;
wire w_buf_7_0_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_7_0_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_7_0_writedata;

wire w_buf_7_1_read_n;
wire w_buf_7_1_write_n;
wire w_buf_7_1_waitrequest;
wire [`WGHT_ADR_W - 1 : 0] w_buf_7_1_address;
wire w_buf_7_1_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] w_buf_7_1_readdata;
wire [`DATA_WIDTH - 1 : 0] w_buf_7_1_writedata;

wire conv_done;
wire conv_en;

wire conv_in_buf_0_read_n;
wire [`IFM_ADR_W - 1 : 0] conv_in_buf_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_in_buf_0_readdata;

wire conv_in_buf_1_read_n;
wire [`IFM_ADR_W - 1 : 0] conv_in_buf_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_in_buf_1_readdata;

wire conv_w_buf_0_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_0_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_0_0_readdata;

wire conv_w_buf_0_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_0_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_0_1_readdata;

wire conv_w_buf_1_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_1_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_1_0_readdata;

wire conv_w_buf_1_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_1_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_1_1_readdata;

wire conv_w_buf_2_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_2_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_2_0_readdata;

wire conv_w_buf_2_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_2_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_2_1_readdata;

wire conv_w_buf_3_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_3_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_3_0_readdata;

wire conv_w_buf_3_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_3_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_3_1_readdata;

wire conv_w_buf_4_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_4_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_4_0_readdata;

wire conv_w_buf_4_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_4_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_4_1_readdata;

wire conv_w_buf_5_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_5_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_5_0_readdata;

wire conv_w_buf_5_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_5_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_5_1_readdata;

wire conv_w_buf_6_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_6_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_6_0_readdata;

wire conv_w_buf_6_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_6_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_6_1_readdata;

wire conv_w_buf_7_0_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_7_0_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_7_0_readdata;

wire conv_w_buf_7_1_read_n;
wire [`WGHT_ADR_W - 1 : 0] conv_w_buf_7_1_address;
wire [`DATA_WIDTH - 1 : 0] conv_w_buf_7_1_readdata;

wire conv_out_buf_0_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_0_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_0_p1_readdata;

wire conv_out_buf_1_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_1_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_1_p1_readdata;

wire conv_out_buf_2_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_2_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_2_p1_readdata;

wire conv_out_buf_3_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_3_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_3_p1_readdata;

wire conv_out_buf_4_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_4_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_4_p1_readdata;

wire conv_out_buf_5_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_5_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_5_p1_readdata;

wire conv_out_buf_6_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_6_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_6_p1_readdata;

wire conv_out_buf_7_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_7_p1_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_7_p1_readdata;

wire conv_out_buf_0_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_0_p2_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_0_p2_writedata;

wire conv_out_buf_1_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_1_p2_address; 
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_1_p2_writedata; 

wire conv_out_buf_2_p2_write_n; 
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_2_p2_address; 
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_2_p2_writedata;

wire conv_out_buf_3_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_3_p2_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_3_p2_writedata;

wire conv_out_buf_4_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_4_p2_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_4_p2_writedata;

wire conv_out_buf_5_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_5_p2_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_5_p2_writedata;

wire conv_out_buf_6_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_6_p2_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_6_p2_writedata;

wire conv_out_buf_7_p2_write_n;
wire [`OFM_ADR_W - 1 : 0] conv_out_buf_7_p2_address;
wire [`DATA_WIDTH - 1 : 0] conv_out_buf_7_p2_writedata;

wire sdram_read_n;
wire sdram_write_n;
wire sdram_chipselect;
wire sdram_waitrequest_n;
wire [`RAM_ADR_W - 1 : 0] sdram_address;
wire sdram_readdatavalid;
wire [`DATA_WIDTH - 1 : 0] sdram_readdata;
wire [`DATA_WIDTH - 1 : 0] sdram_writedata;
wire sdram_mem_ready;
wire sdram_mem_cal_done;
wire self_test_fail;
wire self_test_done;

wire [7:0] from_cc;
wire [7:0] to_cc;	
wire [7:0] msg;

wire [`NUM_STATES_W - 1 : 0] state;
wire [`NUM_RD_ST_W - 1 : 0] read_state;
reg [33:0] to_sevenseg_led;

wire [`RAM_ADR_W - 1 : 0] ol_SDRAM_ADDR;
wire ol_SDRAM_RE_N;
wire ol_en;

wire [`RAM_ADR_W - 1 : 0] il_SDRAM_ADDR;
wire il_SDRAM_RE_N;
wire il_en;

wire [`RAM_ADR_W - 1 : 0] wl_SDRAM_ADDR;
wire wl_SDRAM_RE_N;
wire wl_en;

wire ow_sdram_write_n;
wire [`DATA_WIDTH - 1 : 0] ow_sdram_writedata;
wire [`RAM_ADR_W - 1 : 0] ow_sdram_address;

wire ow_out_buf_0_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_0_p1_address;

wire ow_out_buf_1_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_1_p1_address;

wire ow_out_buf_2_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_2_p1_address;

wire ow_out_buf_3_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_3_p1_address;

wire ow_out_buf_4_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_4_p1_address;

wire ow_out_buf_5_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_5_p1_address;

wire ow_out_buf_6_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_6_p1_address;

wire ow_out_buf_7_p1_read_n;
wire [`OFM_ADR_W - 1 : 0] ow_out_buf_7_p1_address;

wire ow_en;
wire outbuf0_sdram_done;

wire sdram_inbuf0_done;
wire sdram_wbuf0_done;
wire sdram_outbuf0_done;

wire 			init;
wire 			sdram_ref_clk;
wire  		refxcvr_clk;
wire			reconfig_xcvr_clk;
wire 			status_check_sw;
wire [1:0]  disp_sel_sw;
wire [1:0]  LED_sel_pb;
wire 			chk_pcie_status;
wire 			any_rstn_rr_led;
wire [31:0] idx_weight;
reg  [9:0]  LED_sel;
reg  [31:0] timer = 0;

reg  alive_led;
reg  comp_led;
reg  L0_led;
reg  gen2_led;
reg  gen3_led;
reg  [3:0] lane_active_led;
wire debug_pb;

// PCIe HIP signals
wire    [31:0]   hip_ctrl_test_in;             //           .test_in
wire             fbout_reconfigclk;
wire    [52:0]   tl_cfg_tl_cfg_sts;
wire    [31:0]   tl_cfg_tl_cfg_ctl;            //            tl_cfg.tl_cfg_ctl
wire    [3:0]    tl_cfg_tl_cfg_add;            //                  .tl_cfg_add
wire             pld_clk_clk;
reg     [24:0]   alive_cnt;
wire             any_rstn;
reg              any_rstn_r;
reg              any_rstn_rr;
wire             gen2_speed;
wire             gen3_speed;
wire    [5:0]    ltssm;
  
 
//=======================================================
//  Structural coding
//=======================================================

// Map Clocks
assign sdram_ref_clk		= OSC_50_B8A;
assign refxcvr_clk		= OSC_50_B3D;

// Map Hex Displays
toSevenSeg tss0 (to_sevenseg_led[3:0],  HEX0_D);
toSevenSeg tss1 (to_sevenseg_led[7:4],  HEX1_D);

// Map LEDs
assign LED 					= LED_sel[3:0];
assign LED_BRACKET 		= LED_sel[7:4];
assign LED_RJ45_L 		= LED_sel[8];
assign LED_RJ45_R 		= LED_sel[9];

// Map Switches
assign status_check_sw 	= SW[0];
assign disp_sel_sw 		= SW[2:1];
assign chk_pcie_status	= SW[3];

// Map Push Buttons
assign global_reset_n	= BUTTON[0];
assign LED_sel_pb 		= BUTTON[2:1];

//**** CAUTION: this reset will cause Host Kernel Crash! ****//
assign pcie_man_rstn		= BUTTON[3];

// Uncomment(comment) following(previous) line to use Push Button as debug
//assign debug_pb			= BUTTON[3];

// PCIE HIP assignments
assign any_rstn = PCIE_PERST_n & pcie_man_rstn;
assign any_rstn_rr_led = any_rstn_rr;
assign gen2_speed  = tl_cfg_tl_cfg_sts[32:31] == 2'b10;
assign gen3_speed  = tl_cfg_tl_cfg_sts[32:31] == 2'b11;
assign hip_ctrl_test_in[4:0]  =  5'b01000;
assign hip_ctrl_test_in[5] =  1'b1;
assign hip_ctrl_test_in[31:6] =  26'h2;

// Generate Transiever Recofiguration Ctrl clock
pll_reconfig_xcvr_clk_src inst(
	.refclk   (refxcvr_clk),
	.rst      (~PCIE_PERST_n),
	.outclk_0 (reconfig_xcvr_clk)
);

//reset Synchronizer
always @(posedge reconfig_xcvr_clk or negedge any_rstn)
 begin
	if (any_rstn == 0)
	  begin
		 any_rstn_r <= 0;
		 any_rstn_rr <= 0;
	  end
	else
	  begin
		 any_rstn_r <= 1;
		 any_rstn_rr <= any_rstn_r;
	  end
 end

//------------ Status & Debug signals ------------//
always @ (posedge sys_clk)
begin
	case (state)
		`WAIT_FOR_CC: timer <= timer;
		`DEBUG: timer <= timer;
		`INIT_LOAD_OFM: timer <= timer;
		`LOAD_OFM: timer <= timer + 1;
		`INIT_LOAD_IFM: timer <= timer;
		`LOAD_IFM: timer <= timer + 1;
		`INIT_LOAD_WEIGHT: timer <= timer;
		`LOAD_WEIGHT: timer <= timer + 1;
		`INIT_WRITE_BACK: timer <= timer;
		`WRITE_BACK: timer <= timer + 1;
		default: timer <= timer;
	endcase
end
always @(posedge sys_clk)
begin
	case (disp_sel_sw)
	0: to_sevenseg_led <= state;
	1: to_sevenseg_led <= read_state;
	2: to_sevenseg_led <= from_cc;
	3: to_sevenseg_led <= timer; 
	default: to_sevenseg_led <= 0;
	endcase
end

// Status LED Logic
always@(*)
begin
	if(chk_pcie_status) begin
		if(!status_check_sw) LED_sel = {6'h00, self_test_fail, self_test_done, sdram_mem_ready, sdram_mem_cal_done};
		else begin
			case(LED_sel_pb)
			0: LED_sel = to_sevenseg_led[17:8];
			1: LED_sel = to_sevenseg_led[27:18];
			2: LED_sel = {4'h0, to_sevenseg_led[33:28]};
			default: LED_sel = 0;
			endcase
		end
	end
	else begin
		LED_sel[0]   = comp_led;
		LED_sel[1]   = L0_led;
		LED_sel[2]   = gen2_led;
		LED_sel[3]   = gen3_led;
		LED_sel[7:4] = lane_active_led;
		LED_sel[8]   = alive_led;
		LED_sel[9]   = any_rstn_rr_led;
	end
end

//PCIE LED logic
always @(posedge pld_clk_clk or negedge any_rstn_rr)
begin
	if (any_rstn_rr == 0) begin
		 alive_cnt <= 0;
		 alive_led <= 0;
		 comp_led <= 0;
		 L0_led <= 0;
		 gen2_led <= 0;
		 gen3_led <= 0;
		 lane_active_led[3:2] <= 0;
		 lane_active_led[0] <= 0;
	end
	else begin
		 alive_cnt <= alive_cnt +1;
		 alive_led <= alive_cnt[24];
		 comp_led <= ~(ltssm[4 : 0] == 5'b00011);
		 L0_led <= ~(ltssm[4 : 0] == 5'b01111);
		 gen2_led <= ~gen2_speed;
		 gen3_led <= ~gen3_speed;
		 if (tl_cfg_tl_cfg_sts[35])
			lane_active_led <= ~(4'b0001);
		 else if (tl_cfg_tl_cfg_sts[36])
			lane_active_led <= ~(4'b0011);
		 else if (tl_cfg_tl_cfg_sts[37])
			lane_active_led <= ~(4'b1111);
		 else if (tl_cfg_tl_cfg_sts[38])
			lane_active_led <= alive_cnt[24] ? ~(4'b1111) : ~(4'b0111);
	end
end
//-------------------------------------------//

// Qsys System
mem_system u0 (
	  .sys_clk_clk											(sys_clk),											//                    sys_clk.clk
	  
	  .sys_ref_clk_clk									(sdram_ref_clk),    			               //               sys_ref_clk.clk
	  .sys_sdram_pll_0_ref_reset_reset_n			(global_reset_n),									// sys_sdram_pll_0_ref_reset.reset_n
	  
	  .from_cc_export										(from_cc),											//                  from_cc.export
	  .to_cc_export										(to_cc),												//                    to_cc.export                    
	  
	  .user_io_debug                             (debug_pb),                               //                   user_io.debug
     .user_io_pcie_load_done_n                  (chk_pcie_status),
	  
	  .self_test_status_fail							(self_test_fail),									//          self_test_status.fail
     .self_test_status_read_done						(self_test_done),
	  
	  .sdram_status_mem_cal_done						(sdram_mem_cal_done),            			//                          .mem_cal_done
	  .sdram_status_mem_ready							(sdram_mem_ready),         					//                          .mem_ready        
	  
	  .memory_mem_a										(DDR3A_A),        								//                    memory.mem_a
	  .memory_mem_ba										(DDR3A_BA),       								//                          .mem_ba
	  .memory_mem_ck										(DDR3A_CK),       								//                          .mem_ck
	  .memory_mem_ck_n									(DDR3A_CK_n),     								//                          .mem_ck_n
	  .memory_mem_cke										(DDR3A_CKE),      								//                          .mem_cke
	  .memory_mem_cs_n									(DDR3A_CS_n),     								//                          .mem_cs_n
	  .memory_mem_dm										(DDR3A_DM),       								//                          .mem_dm
	  .memory_mem_ras_n									(DDR3A_RAS_n),    								//                          .mem_ras_n
	  .memory_mem_cas_n									(DDR3A_CAS_n),    								//                          .mem_cas_n
	  .memory_mem_we_n									(DDR3A_WE_n),     								//                          .mem_we_n
	  .memory_mem_reset_n								(DDR3A_RESET_n),  								//                          .mem_reset_n
	  .memory_mem_dq										(DDR3A_DQ),       								//                          .mem_dq
	  .memory_mem_dqs										(DDR3A_DQS),      								//                          .mem_dqs
	  .memory_mem_dqs_n									(DDR3A_DQS_n),    								//                          .mem_dqs_n
	  .memory_mem_odt										(DDR3A_ODT),      								//                          .mem_odt
	  .oct_rzqin											(RZQ_4),												//                       oct.rzqin
	  
	  .mem_if_ddr3_0_avl_waitrequest_n				(sdram_waitrequest_n),						   //         mem_if_ddr3_0_avl.waitrequest
	  .mem_if_ddr3_0_avl_address						(sdram_address),							   	//                          .address
	  .mem_if_ddr3_0_avl_readdatavalid				(sdram_readdatavalid),						   //                          .readdataval
	  .mem_if_ddr3_0_avl_readdata						(sdram_readdata),							   	//                          .readdata
	  .mem_if_ddr3_0_avl_writedata					(sdram_writedata),							   //                          .writedata
	  .mem_if_ddr3_0_avl_byteenable					(8'hff),									   		//                          .byteenable
	  .mem_if_ddr3_0_avl_read							(~sdram_read_n),							   	//                          .read
	  .mem_if_ddr3_0_avl_write							(~sdram_write_n),							   	//                          .write
	  .mem_if_ddr3_0_avl_burstcount					(1'b1),										   	//                          .burstcount
	  
	   .refclk_clk               (PCIE_REFCLK_p     ), 												//     refclk.clk
		.pcie_rstn_npor           (any_rstn_rr),                            						//         pcie_rstn.npor
		.reset_reset_n            ((pcie_man_rstn==1'b0)?1'b0:(PCIE_PERST_n==1'b0)?1'b0:1'b1), // reconfig_xcvr_rst.reconfig_xcvr_rst
		.pcie_rstn_pin_perst      (PCIE_PERST_n),                         						//                  .pin_perst
		.clk_clk                  (reconfig_xcvr_clk        ),										//     reconfig_xcvr_clk.clk
		.hip_serial_rx_in0        (PCIE_RX_p[0]      ),													// hip_serial.rx_in0
		.hip_serial_rx_in1        (PCIE_RX_p[1]      ),													//           .rx_in1
		.hip_serial_rx_in2        (PCIE_RX_p[2]      ),													//           .rx_in2
		.hip_serial_rx_in3        (PCIE_RX_p[3]      ),													//           .rx_in3
		.hip_serial_rx_in4        (PCIE_RX_p[4]      ),													//           .rx_in4
		.hip_serial_rx_in5        (PCIE_RX_p[5]      ),													//           .rx_in5
		.hip_serial_rx_in6        (PCIE_RX_p[6]      ),													//           .rx_in6
		.hip_serial_rx_in7        (PCIE_RX_p[7]      ),													//           .rx_in7
		.hip_serial_tx_out0       (PCIE_TX_p[0]      ),													//           .tx_out0
		.hip_serial_tx_out1       (PCIE_TX_p[1]      ),													//           .tx_out1
		.hip_serial_tx_out2       (PCIE_TX_p[2]      ),													//           .tx_out2
		.hip_serial_tx_out3       (PCIE_TX_p[3]      ),													//           .tx_out3
		.hip_serial_tx_out4       (PCIE_TX_p[4]      ),													//           .tx_out4
		.hip_serial_tx_out5       (PCIE_TX_p[5]      ),													//           .tx_out5
		.hip_serial_tx_out6       (PCIE_TX_p[6]      ),													//           .tx_out6
		.hip_serial_tx_out7       (PCIE_TX_p[7]      ),													//           .tx_out7
		.hip_ctrl_test_in         (hip_ctrl_test_in  ),													//           .test_in
		.pld_clk_clk              (pld_clk_clk),
		.tl_cfg_tl_cfg_sts        (tl_cfg_tl_cfg_sts),
		.hip_pipe_sim_ltssmstate  (ltssm),
		.tl_cfg_tl_cfg_ctl        (tl_cfg_tl_cfg_ctl           ),
		.tl_cfg_tl_cfg_add        (tl_cfg_tl_cfg_add           ),
		.intx_interface_intx_req  (1'b0), 
	  
	  
	  .in_buf_0_read_n                  					(in_buf_0_read_n),
	  .in_buf_0_write_n                 					(in_buf_0_write_n),
	  .in_buf_0_chipselect              					(1'b1),
	  .in_buf_0_waitrequest             					(in_buf_0_waitrequest),
	  .in_buf_0_address                     			 	(in_buf_0_address),
	  .in_buf_0_byteenable      	            		 	(2'b11),
	  .in_buf_0_readdatavalid                   			(in_buf_0_readdatavalid),
	  .in_buf_0_readdata                    			 	(in_buf_0_readdata),
	  .in_buf_0_writedata                       		 	(in_buf_0_writedata),
	  .in_buf_0_reset_reset_n   	            		 	(1'b1),
			
	  .in_buf_1_read_n                          			(in_buf_1_read_n),
	  .in_buf_1_write_n                         			(in_buf_1_write_n),
	  .in_buf_1_chipselect                      			(1'b1),
	  .in_buf_1_waitrequest                     			(in_buf_1_waitrequest),
	  .in_buf_1_address                         			(in_buf_1_address),
	  .in_buf_1_byteenable                      			(2'b11),
	  .in_buf_1_readdatavalid                   			(in_buf_1_readdatavalid),
	  .in_buf_1_readdata                        			(in_buf_1_readdata),
	  .in_buf_1_writedata                       			(in_buf_1_writedata),
	  .in_buf_1_reset_reset_n          						(1'b1),
			
	  .out_buf_0_p1_read_n									(out_buf_0_p1_read_n),        
	  .out_buf_0_p1_write_n       							(out_buf_0_p1_write_n),
	  .out_buf_0_p1_chipselect								(1'b1),    
	  .out_buf_0_p1_waitrequest   							(out_buf_0_p1_waitrequest),
	  .out_buf_0_p1_address       							(out_buf_0_p1_address),
	  .out_buf_0_p1_byteenable    							(2'b11),
	  .out_buf_0_p1_readdatavalid 							(out_buf_0_p1_readdatavalid),
	  .out_buf_0_p1_readdata      							(out_buf_0_p1_readdata),
	  .out_buf_0_p1_writedata     							(out_buf_0_p1_writedata),
	  .out_buf_0_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_0_p2_read_n									(out_buf_0_p2_read_n),        
	  .out_buf_0_p2_write_n       							(out_buf_0_p2_write_n),
	  .out_buf_0_p2_chipselect								(1'b1),    
	  .out_buf_0_p2_waitrequest   							(out_buf_0_p2_waitrequest),
	  .out_buf_0_p2_address       							(out_buf_0_p2_address),
	  .out_buf_0_p2_byteenable    							(2'b11),
	  .out_buf_0_p2_readdatavalid 							(out_buf_0_p2_readdatavalid),
	  .out_buf_0_p2_readdata      							(out_buf_0_p2_readdata),
	  .out_buf_0_p2_writedata     							(out_buf_0_p2_writedata),
	  .out_buf_0_p2_reset_reset_n 							(1'b1),
			
	  .out_buf_1_p1_read_n									(out_buf_1_p1_read_n),        
	  .out_buf_1_p1_write_n       							(out_buf_1_p1_write_n),
	  .out_buf_1_p1_chipselect								(1'b1),    
	  .out_buf_1_p1_waitrequest   							(out_buf_1_p1_waitrequest),
	  .out_buf_1_p1_address       							(out_buf_1_p1_address),
	  .out_buf_1_p1_byteenable    							(2'b11),
	  .out_buf_1_p1_readdatavalid 							(out_buf_1_p1_readdatavalid),
	  .out_buf_1_p1_readdata      							(out_buf_1_p1_readdata),
	  .out_buf_1_p1_writedata     							(out_buf_1_p1_writedata),
	  .out_buf_1_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_1_p2_read_n									(out_buf_1_p2_read_n),        
	  .out_buf_1_p2_write_n       							(out_buf_1_p2_write_n),
	  .out_buf_1_p2_chipselect								(1'b1),    
	  .out_buf_1_p2_waitrequest   							(out_buf_1_p2_waitrequest),
	  .out_buf_1_p2_address       							(out_buf_1_p2_address),
	  .out_buf_1_p2_byteenable    							(2'b11),
	  .out_buf_1_p2_readdatavalid 							(out_buf_1_p2_readdatavalid),
	  .out_buf_1_p2_readdata      							(out_buf_1_p2_readdata),
	  .out_buf_1_p2_writedata     							(out_buf_1_p2_writedata),
	  .out_buf_1_p2_reset_reset_n 							(1'b1),
			
	  .out_buf_2_p1_read_n									(out_buf_2_p1_read_n),        
	  .out_buf_2_p1_write_n       							(out_buf_2_p1_write_n),
	  .out_buf_2_p1_chipselect								(1'b1),    
	  .out_buf_2_p1_waitrequest   							(out_buf_2_p1_waitrequest),
	  .out_buf_2_p1_address       							(out_buf_2_p1_address),
	  .out_buf_2_p1_byteenable    							(2'b11),
	  .out_buf_2_p1_readdatavalid 							(out_buf_2_p1_readdatavalid),
	  .out_buf_2_p1_readdata      							(out_buf_2_p1_readdata),
	  .out_buf_2_p1_writedata     							(out_buf_2_p1_writedata),
	  .out_buf_2_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_2_p2_read_n									(out_buf_2_p2_read_n),        
	  .out_buf_2_p2_write_n       							(out_buf_2_p2_write_n),
	  .out_buf_2_p2_chipselect								(1'b1),    
	  .out_buf_2_p2_waitrequest   							(out_buf_2_p2_waitrequest),
	  .out_buf_2_p2_address       							(out_buf_2_p2_address),
	  .out_buf_2_p2_byteenable    							(2'b11),
	  .out_buf_2_p2_readdatavalid 							(out_buf_2_p2_readdatavalid),
	  .out_buf_2_p2_readdata      							(out_buf_2_p2_readdata),
	  .out_buf_2_p2_writedata     							(out_buf_2_p2_writedata),
	  .out_buf_2_p2_reset_reset_n 							(1'b1),
			
	  .out_buf_3_p1_read_n									(out_buf_3_p1_read_n),        
	  .out_buf_3_p1_write_n       							(out_buf_3_p1_write_n),
	  .out_buf_3_p1_chipselect								(1'b1),    
	  .out_buf_3_p1_waitrequest   							(out_buf_3_p1_waitrequest),
	  .out_buf_3_p1_address       							(out_buf_3_p1_address),
	  .out_buf_3_p1_byteenable    							(2'b11),
	  .out_buf_3_p1_readdatavalid 							(out_buf_3_p1_readdatavalid),
	  .out_buf_3_p1_readdata      							(out_buf_3_p1_readdata),
	  .out_buf_3_p1_writedata     							(out_buf_3_p1_writedata),
	  .out_buf_3_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_3_p2_read_n									(out_buf_3_p2_read_n),        
	  .out_buf_3_p2_write_n       							(out_buf_3_p2_write_n),
	  .out_buf_3_p2_chipselect								(1'b1),    
	  .out_buf_3_p2_waitrequest   							(out_buf_3_p2_waitrequest),
	  .out_buf_3_p2_address       							(out_buf_3_p2_address),
	  .out_buf_3_p2_byteenable    							(2'b11),
	  .out_buf_3_p2_readdatavalid 							(out_buf_3_p2_readdatavalid),
	  .out_buf_3_p2_readdata      							(out_buf_3_p2_readdata),
	  .out_buf_3_p2_writedata     							(out_buf_3_p2_writedata),
	  .out_buf_3_p2_reset_reset_n 							(1'b1),
			
	  .out_buf_4_p1_read_n									(out_buf_4_p1_read_n),        
	  .out_buf_4_p1_write_n       							(out_buf_4_p1_write_n),
	  .out_buf_4_p1_chipselect								(1'b1),    
	  .out_buf_4_p1_waitrequest   							(out_buf_4_p1_waitrequest),
	  .out_buf_4_p1_address       							(out_buf_4_p1_address),
	  .out_buf_4_p1_byteenable    							(2'b11),
	  .out_buf_4_p1_readdatavalid 							(out_buf_4_p1_readdatavalid),
	  .out_buf_4_p1_readdata      							(out_buf_4_p1_readdata),
	  .out_buf_4_p1_writedata     							(out_buf_4_p1_writedata),
	  .out_buf_4_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_4_p2_read_n									(out_buf_4_p2_read_n),        
	  .out_buf_4_p2_write_n       							(out_buf_4_p2_write_n),
	  .out_buf_4_p2_chipselect								(1'b1),    
	  .out_buf_4_p2_waitrequest   							(out_buf_4_p2_waitrequest),
	  .out_buf_4_p2_address       							(out_buf_4_p2_address),
	  .out_buf_4_p2_byteenable    							(2'b11),
	  .out_buf_4_p2_readdatavalid 							(out_buf_4_p2_readdatavalid),
	  .out_buf_4_p2_readdata      							(out_buf_4_p2_readdata),
	  .out_buf_4_p2_writedata     							(out_buf_4_p2_writedata),
	  .out_buf_4_p2_reset_reset_n 							(1'b1),
			
	  .out_buf_5_p1_read_n									(out_buf_5_p1_read_n),        
	  .out_buf_5_p1_write_n       							(out_buf_5_p1_write_n),
	  .out_buf_5_p1_chipselect								(1'b1),    
	  .out_buf_5_p1_waitrequest   							(out_buf_5_p1_waitrequest),
	  .out_buf_5_p1_address       							(out_buf_5_p1_address),
	  .out_buf_5_p1_byteenable    							(2'b11),
	  .out_buf_5_p1_readdatavalid 							(out_buf_5_p1_readdatavalid),
	  .out_buf_5_p1_readdata      							(out_buf_5_p1_readdata),
	  .out_buf_5_p1_writedata     							(out_buf_5_p1_writedata),
	  .out_buf_5_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_5_p2_read_n									(out_buf_5_p2_read_n),        
	  .out_buf_5_p2_write_n       							(out_buf_5_p2_write_n),
	  .out_buf_5_p2_chipselect								(1'b1),    
	  .out_buf_5_p2_waitrequest   							(out_buf_5_p2_waitrequest),
	  .out_buf_5_p2_address       							(out_buf_5_p2_address),
	  .out_buf_5_p2_byteenable    							(2'b11),
	  .out_buf_5_p2_readdatavalid 							(out_buf_5_p2_readdatavalid),
	  .out_buf_5_p2_readdata      							(out_buf_5_p2_readdata),
	  .out_buf_5_p2_writedata     							(out_buf_5_p2_writedata),
	  .out_buf_5_p2_reset_reset_n 							(1'b1),
			
	  .out_buf_6_p1_read_n									(out_buf_6_p1_read_n),        
	  .out_buf_6_p1_write_n       							(out_buf_6_p1_write_n),
	  .out_buf_6_p1_chipselect								(1'b1),    
	  .out_buf_6_p1_waitrequest   							(out_buf_6_p1_waitrequest),
	  .out_buf_6_p1_address       							(out_buf_6_p1_address),
	  .out_buf_6_p1_byteenable    							(2'b11),
	  .out_buf_6_p1_readdatavalid 							(out_buf_6_p1_readdatavalid),
	  .out_buf_6_p1_readdata      							(out_buf_6_p1_readdata),
	  .out_buf_6_p1_writedata     							(out_buf_6_p1_writedata),
	  .out_buf_6_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_6_p2_read_n									(out_buf_6_p2_read_n),        
	  .out_buf_6_p2_write_n       							(out_buf_6_p2_write_n),
	  .out_buf_6_p2_chipselect								(1'b1),    
	  .out_buf_6_p2_waitrequest   							(out_buf_6_p2_waitrequest),
	  .out_buf_6_p2_address       							(out_buf_6_p2_address),
	  .out_buf_6_p2_byteenable    							(2'b11),
	  .out_buf_6_p2_readdatavalid 							(out_buf_6_p2_readdatavalid),
	  .out_buf_6_p2_readdata      							(out_buf_6_p2_readdata),
	  .out_buf_6_p2_writedata     							(out_buf_6_p2_writedata),
	  .out_buf_6_p2_reset_reset_n 							(1'b1), 
			
	  .out_buf_7_p1_read_n									(out_buf_7_p1_read_n),        
	  .out_buf_7_p1_write_n       							(out_buf_7_p1_write_n),
	  .out_buf_7_p1_chipselect								(1'b1),    
	  .out_buf_7_p1_waitrequest   							(out_buf_7_p1_waitrequest),
	  .out_buf_7_p1_address       							(out_buf_7_p1_address),
	  .out_buf_7_p1_byteenable    							(2'b11),
	  .out_buf_7_p1_readdatavalid 							(out_buf_7_p1_readdatavalid),
	  .out_buf_7_p1_readdata      							(out_buf_7_p1_readdata),
	  .out_buf_7_p1_writedata     							(out_buf_7_p1_writedata),
	  .out_buf_7_p1_reset_reset_n 							(1'b1),
			
	  .out_buf_7_p2_read_n									(out_buf_7_p2_read_n),        
	  .out_buf_7_p2_write_n       							(out_buf_7_p2_write_n),
	  .out_buf_7_p2_chipselect								(1'b1),    
	  .out_buf_7_p2_waitrequest   							(out_buf_7_p2_waitrequest),
	  .out_buf_7_p2_address       							(out_buf_7_p2_address),
	  .out_buf_7_p2_byteenable    							(2'b11),
	  .out_buf_7_p2_readdatavalid 							(out_buf_7_p2_readdatavalid),
	  .out_buf_7_p2_readdata      							(out_buf_7_p2_readdata),
	  .out_buf_7_p2_writedata     							(out_buf_7_p2_writedata),
	  .out_buf_7_p2_reset_reset_n 							(1'b1),
	 
	  .w_buf_0_0_read_n										(w_buf_0_0_read_n),          
	  .w_buf_0_0_write_n         							(w_buf_0_0_write_n),
	  .w_buf_0_0_chipselect      							(1'b1),
	  .w_buf_0_0_waitrequest     							(w_buf_0_0_waitrequest),
	  .w_buf_0_0_address         							(w_buf_0_0_address),
	  .w_buf_0_0_byteenable      							(2'b11),
	  .w_buf_0_0_readdatavalid   							(w_buf_0_0_readdatavalid),
	  .w_buf_0_0_readdata        							(w_buf_0_0_readdata),
	  .w_buf_0_0_writedata       							(w_buf_0_0_writedata),
	  .w_buf_0_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_0_1_read_n										(w_buf_0_1_read_n),          
	  .w_buf_0_1_write_n         							(w_buf_0_1_write_n),
	  .w_buf_0_1_chipselect      							(1'b1),
	  .w_buf_0_1_waitrequest     							(w_buf_0_1_waitrequest),
	  .w_buf_0_1_address         							(w_buf_0_1_address),
	  .w_buf_0_1_byteenable      							(2'b11),
	  .w_buf_0_1_readdatavalid   							(w_buf_0_1_readdatavalid),
	  .w_buf_0_1_readdata        							(w_buf_0_1_readdata),
	  .w_buf_0_1_writedata       							(w_buf_0_1_writedata),
	  .w_buf_0_1_reset_reset_n 								(1'b1),
	  
	  .w_buf_1_0_read_n										(w_buf_1_0_read_n),          
	  .w_buf_1_0_write_n         							(w_buf_1_0_write_n),
	  .w_buf_1_0_chipselect      							(1'b1),
	  .w_buf_1_0_waitrequest     							(w_buf_1_0_waitrequest),
	  .w_buf_1_0_address         							(w_buf_1_0_address),
	  .w_buf_1_0_byteenable      							(2'b11),
	  .w_buf_1_0_readdatavalid   							(w_buf_1_0_readdatavalid),
	  .w_buf_1_0_readdata        							(w_buf_1_0_readdata),
	  .w_buf_1_0_writedata       							(w_buf_1_0_writedata),
	  .w_buf_1_0_reset_reset_n 								(1'b1), 
	  
	  .w_buf_1_1_read_n										(w_buf_1_1_read_n),          
	  .w_buf_1_1_write_n         							(w_buf_1_1_write_n),
	  .w_buf_1_1_chipselect      							(1'b1),
	  .w_buf_1_1_waitrequest     							(w_buf_1_1_waitrequest),
	  .w_buf_1_1_address         							(w_buf_1_1_address),
	  .w_buf_1_1_byteenable      							(2'b11),
	  .w_buf_1_1_readdatavalid   							(w_buf_1_1_readdatavalid),
	  .w_buf_1_1_readdata        							(w_buf_1_1_readdata),
	  .w_buf_1_1_writedata       							(w_buf_1_1_writedata),
	  .w_buf_1_1_reset_reset_n 								(1'b1),  
	  
	  .w_buf_2_0_read_n										(w_buf_2_0_read_n),          
	  .w_buf_2_0_write_n         							(w_buf_2_0_write_n),
	  .w_buf_2_0_chipselect      							(1'b1),
	  .w_buf_2_0_waitrequest     							(w_buf_2_0_waitrequest),
	  .w_buf_2_0_address         							(w_buf_2_0_address),
	  .w_buf_2_0_byteenable      							(2'b11),
	  .w_buf_2_0_readdatavalid   							(w_buf_2_0_readdatavalid),
	  .w_buf_2_0_readdata        							(w_buf_2_0_readdata),
	  .w_buf_2_0_writedata       							(w_buf_2_0_writedata),
	  .w_buf_2_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_2_1_read_n										(w_buf_2_1_read_n),          
	  .w_buf_2_1_write_n         							(w_buf_2_1_write_n),
	  .w_buf_2_1_chipselect      							(1'b1),
	  .w_buf_2_1_waitrequest     							(w_buf_2_1_waitrequest),
	  .w_buf_2_1_address         							(w_buf_2_1_address),
	  .w_buf_2_1_byteenable      							(2'b11),
	  .w_buf_2_1_readdatavalid   							(w_buf_2_1_readdatavalid),
	  .w_buf_2_1_readdata        							(w_buf_2_1_readdata),
	  .w_buf_2_1_writedata       							(w_buf_2_1_writedata),
	  .w_buf_2_1_reset_reset_n 								(1'b1),  
	  
	  .w_buf_3_0_read_n										(w_buf_3_0_read_n),          
	  .w_buf_3_0_write_n         							(w_buf_3_0_write_n),
	  .w_buf_3_0_chipselect      							(1'b1),
	  .w_buf_3_0_waitrequest     							(w_buf_3_0_waitrequest),
	  .w_buf_3_0_address         							(w_buf_3_0_address),
	  .w_buf_3_0_byteenable      							(2'b11),
	  .w_buf_3_0_readdatavalid   							(w_buf_3_0_readdatavalid),
	  .w_buf_3_0_readdata        							(w_buf_3_0_readdata),
	  .w_buf_3_0_writedata       							(w_buf_3_0_writedata),
	  .w_buf_3_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_3_1_read_n										(w_buf_3_1_read_n),          
	  .w_buf_3_1_write_n         							(w_buf_3_1_write_n),
	  .w_buf_3_1_chipselect      							(1'b1),
	  .w_buf_3_1_waitrequest     							(w_buf_3_1_waitrequest),
	  .w_buf_3_1_address         							(w_buf_3_1_address),
	  .w_buf_3_1_byteenable      							(2'b11),
	  .w_buf_3_1_readdatavalid   							(w_buf_3_1_readdatavalid),
	  .w_buf_3_1_readdata        							(w_buf_3_1_readdata),
	  .w_buf_3_1_writedata       							(w_buf_3_1_writedata),
	  .w_buf_3_1_reset_reset_n 								(1'b1),
	  
	  .w_buf_4_0_read_n										(w_buf_4_0_read_n),          
	  .w_buf_4_0_write_n         							(w_buf_4_0_write_n),
	  .w_buf_4_0_chipselect      							(1'b1),
	  .w_buf_4_0_waitrequest     							(w_buf_4_0_waitrequest),
	  .w_buf_4_0_address         							(w_buf_4_0_address),
	  .w_buf_4_0_byteenable      							(2'b11),
	  .w_buf_4_0_readdatavalid   							(w_buf_4_0_readdatavalid),
	  .w_buf_4_0_readdata        							(w_buf_4_0_readdata),
	  .w_buf_4_0_writedata       							(w_buf_4_0_writedata),
	  .w_buf_4_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_4_1_read_n										(w_buf_4_1_read_n),          
	  .w_buf_4_1_write_n         							(w_buf_4_1_write_n),
	  .w_buf_4_1_chipselect      							(1'b1),
	  .w_buf_4_1_waitrequest     							(w_buf_4_1_waitrequest),
	  .w_buf_4_1_address         							(w_buf_4_1_address),
	  .w_buf_4_1_byteenable      							(2'b11),
	  .w_buf_4_1_readdatavalid   							(w_buf_4_1_readdatavalid),
	  .w_buf_4_1_readdata        							(w_buf_4_1_readdata),
	  .w_buf_4_1_writedata       							(w_buf_4_1_writedata),
	  .w_buf_4_1_reset_reset_n 								(1'b1),
	  
	  .w_buf_5_0_read_n										(w_buf_5_0_read_n),          
	  .w_buf_5_0_write_n         							(w_buf_5_0_write_n),
	  .w_buf_5_0_chipselect      							(1'b1),
	  .w_buf_5_0_waitrequest     							(w_buf_5_0_waitrequest),
	  .w_buf_5_0_address         							(w_buf_5_0_address),
	  .w_buf_5_0_byteenable      							(2'b11),
	  .w_buf_5_0_readdatavalid   							(w_buf_5_0_readdatavalid),
	  .w_buf_5_0_readdata        							(w_buf_5_0_readdata),
	  .w_buf_5_0_writedata       							(w_buf_5_0_writedata),
	  .w_buf_5_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_5_1_read_n										(w_buf_5_1_read_n),          
	  .w_buf_5_1_write_n         							(w_buf_5_1_write_n),
	  .w_buf_5_1_chipselect      							(1'b1),
	  .w_buf_5_1_waitrequest     							(w_buf_5_1_waitrequest),
	  .w_buf_5_1_address         							(w_buf_5_1_address),
	  .w_buf_5_1_byteenable      							(2'b11),
	  .w_buf_5_1_readdatavalid   							(w_buf_5_1_readdatavalid),
	  .w_buf_5_1_readdata        							(w_buf_5_1_readdata),
	  .w_buf_5_1_writedata       							(w_buf_5_1_writedata),
	  .w_buf_5_1_reset_reset_n 								(1'b1),
	  
	  .w_buf_6_0_read_n										(w_buf_6_0_read_n),          
	  .w_buf_6_0_write_n         							(w_buf_6_0_write_n),
	  .w_buf_6_0_chipselect      							(1'b1),
	  .w_buf_6_0_waitrequest     							(w_buf_6_0_waitrequest),
	  .w_buf_6_0_address         							(w_buf_6_0_address),
	  .w_buf_6_0_byteenable      							(2'b11),
	  .w_buf_6_0_readdatavalid   							(w_buf_6_0_readdatavalid),
	  .w_buf_6_0_readdata        							(w_buf_6_0_readdata),
	  .w_buf_6_0_writedata       							(w_buf_6_0_writedata),
	  .w_buf_6_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_6_1_read_n										(w_buf_6_1_read_n),          
	  .w_buf_6_1_write_n         							(w_buf_6_1_write_n),
	  .w_buf_6_1_chipselect      							(1'b1),
	  .w_buf_6_1_waitrequest     							(w_buf_6_1_waitrequest),
	  .w_buf_6_1_address         							(w_buf_6_1_address),
	  .w_buf_6_1_byteenable      							(2'b11),
	  .w_buf_6_1_readdatavalid   							(w_buf_6_1_readdatavalid),
	  .w_buf_6_1_readdata        							(w_buf_6_1_readdata),
	  .w_buf_6_1_writedata       							(w_buf_6_1_writedata),
	  .w_buf_6_1_reset_reset_n 								(1'b1), 
	  
	  .w_buf_7_0_read_n										(w_buf_7_0_read_n),          
	  .w_buf_7_0_write_n         							(w_buf_7_0_write_n),
	  .w_buf_7_0_chipselect      							(1'b1),
	  .w_buf_7_0_waitrequest     							(w_buf_7_0_waitrequest),
	  .w_buf_7_0_address         							(w_buf_7_0_address),
	  .w_buf_7_0_byteenable      							(2'b11),
	  .w_buf_7_0_readdatavalid   							(w_buf_7_0_readdatavalid),
	  .w_buf_7_0_readdata        							(w_buf_7_0_readdata),
	  .w_buf_7_0_writedata       							(w_buf_7_0_writedata),
	  .w_buf_7_0_reset_reset_n 								(1'b1),
	  
	  .w_buf_7_1_read_n										(w_buf_7_1_read_n),          
	  .w_buf_7_1_write_n         							(w_buf_7_1_write_n),
	  .w_buf_7_1_chipselect      							(1'b1),
	  .w_buf_7_1_waitrequest     							(w_buf_7_1_waitrequest),
	  .w_buf_7_1_address         							(w_buf_7_1_address),
	  .w_buf_7_1_byteenable      							(2'b11),
	  .w_buf_7_1_readdatavalid   							(w_buf_7_1_readdatavalid),
	  .w_buf_7_1_readdata        							(w_buf_7_1_readdata),
	  .w_buf_7_1_writedata       							(w_buf_7_1_writedata),
	  .w_buf_7_1_reset_reset_n 								(1'b1)
		  
    );
weight_loader wl_0 (
							.clk							(sys_clk),
							.SDRAM_ADDR						(wl_SDRAM_ADDR),
							.SDRAM_RE_N						(wl_SDRAM_RE_N),		
							.SDRAM_WAIT						(~sdram_waitrequest_n),
							.enable							(wl_en),
							
							.m (m),
							.n (n)
);
ofm_loader ol_0(
							.clk							(sys_clk),
							.SDRAM_ADDR 					(ol_SDRAM_ADDR),
							.SDRAM_RE_N						(ol_SDRAM_RE_N),
							.SDRAM_WAIT						(~sdram_waitrequest_n),
							.enable							(ol_en),
							
							.m (m),
							.n (n)
							
);
ifm_loader il_0(
							.clk							(sys_clk),
							.SDRAM_ADDR						(il_SDRAM_ADDR),
							.SDRAM_RE_N						(il_SDRAM_RE_N),
							.SDRAM_WAIT						(~sdram_waitrequest_n),
							.enable							(il_en),
							.n (n)
);
main_state_machine msm_0(
							.clk							(sys_clk),
							.reset_n						(global_reset_n),
							
							.from_cc						(from_cc),
							.msg							(msg),
							
							.conv_done						(conv_done),
							.sdram_inbuf0_done				(sdram_inbuf0_done),
							.sdram_wbuf0_done				(sdram_wbuf0_done),
							.sdram_outbuf0_done				(sdram_outbuf0_done),
							.outbuf0_sdram_done				(outbuf0_sdram_done),
							
							.state							(state),
							.read_state						(read_state),
							
							.m								(m),
							.n								(n)
);
main_state_actions msa_0(
							.clk							(sys_clk),

							.sdram_we_n						(sdram_write_n),
							.sdram_re_n						(sdram_read_n),								
							.SDRAM_WAIT						(~sdram_waitrequest_n),
							.sdram_writedata				(sdram_writedata),
							.sdram_chipselect 				(sdram_chipselect),
							.sdram_addr						(sdram_address),								
							
							.ol_SDRAM_ADDR					(ol_SDRAM_ADDR),
							.ol_SDRAM_RE_N					(ol_SDRAM_RE_N),	
							.ol_en							(ol_en),
							
							.il_SDRAM_ADDR					(il_SDRAM_ADDR),
							.il_SDRAM_RE_N					(il_SDRAM_RE_N),
							.il_en							(il_en),
							
							.wl_SDRAM_RE_N					(wl_SDRAM_RE_N),
							.wl_SDRAM_ADDR					(wl_SDRAM_ADDR),
							.wl_en							(wl_en),
							
							.state							(state),
							
							.msg							(msg),
							

							.to_cc							(to_cc),
							
							
							.conv_en						(conv_en),
							
							.ow_sdram_write_n				(ow_sdram_write_n),
							.ow_sdram_writedata				(ow_sdram_writedata),
							.ow_sdram_address				(ow_sdram_address),
							.ow_en							(ow_en)
							
);
read_state_actions rsa_0(
							.clk							(sys_clk),	
							.read_state						(read_state),
							.SDRAM_RDVAL					(sdram_readdatavalid),
							.SDRAM_READDATA					(sdram_readdata),
							
							.in_buf_0_read_n				(in_buf_0_read_n),
							.in_buf_0_write_n				(in_buf_0_write_n),
							.in_buf_0_address				(in_buf_0_address),
							.in_buf_0_writedata				(in_buf_0_writedata),
							.in_buf_0_readdata				(in_buf_0_readdata),

							.in_buf_1_read_n				(in_buf_1_read_n),
							.in_buf_1_write_n				(in_buf_1_write_n),
							.in_buf_1_address				(in_buf_1_address),
							.in_buf_1_writedata				(in_buf_1_writedata),
							.in_buf_1_readdata				(in_buf_1_readdata),
							
							.out_buf_0_p1_read_n			(out_buf_0_p1_read_n),
							.out_buf_0_p1_write_n			(out_buf_0_p1_write_n),
							.out_buf_0_p1_address			(out_buf_0_p1_address),
							.out_buf_0_p1_writedata			(out_buf_0_p1_writedata),
							.out_buf_0_p1_readdata			(out_buf_0_p1_readdata),
	
 							   .out_buf_0_p2_read_n				(out_buf_0_p2_read_n),                         
							.out_buf_0_p2_write_n			(out_buf_0_p2_write_n),
							.out_buf_0_p2_address			(out_buf_0_p2_address),
							.out_buf_0_p2_writedata			(out_buf_0_p2_writedata),
	
							.out_buf_1_p1_read_n			(out_buf_1_p1_read_n),
							.out_buf_1_p1_write_n			(out_buf_1_p1_write_n),
							.out_buf_1_p1_address			(out_buf_1_p1_address),
							.out_buf_1_p1_writedata			(out_buf_1_p1_writedata),
							.out_buf_1_p1_readdata			(out_buf_1_p1_readdata),
	
 							   .out_buf_1_p2_read_n				(out_buf_1_p2_read_n),                         
							.out_buf_1_p2_write_n			(out_buf_1_p2_write_n),
							.out_buf_1_p2_address			(out_buf_1_p2_address),
							.out_buf_1_p2_writedata			(out_buf_1_p2_writedata),
	
							.out_buf_2_p1_read_n			(out_buf_2_p1_read_n),
							.out_buf_2_p1_write_n			(out_buf_2_p1_write_n),
							.out_buf_2_p1_address			(out_buf_2_p1_address),
							.out_buf_2_p1_writedata			(out_buf_2_p1_writedata),
							.out_buf_2_p1_readdata			(out_buf_2_p1_readdata),
	
 							   .out_buf_2_p2_read_n				(out_buf_2_p2_read_n),                         
							.out_buf_2_p2_write_n			(out_buf_2_p2_write_n),
							.out_buf_2_p2_address			(out_buf_2_p2_address),
							.out_buf_2_p2_writedata			(out_buf_2_p2_writedata),
	
							.out_buf_3_p1_read_n			(out_buf_3_p1_read_n),
							.out_buf_3_p1_write_n			(out_buf_3_p1_write_n),
							.out_buf_3_p1_address			(out_buf_3_p1_address),
							.out_buf_3_p1_writedata			(out_buf_3_p1_writedata),
							.out_buf_3_p1_readdata			(out_buf_3_p1_readdata),
	
 							   .out_buf_3_p2_read_n				(out_buf_3_p2_read_n),                         
							.out_buf_3_p2_write_n			(out_buf_3_p2_write_n),
							.out_buf_3_p2_address			(out_buf_3_p2_address),
							.out_buf_3_p2_writedata			(out_buf_3_p2_writedata),
	
							.out_buf_4_p1_read_n			(out_buf_4_p1_read_n),
							.out_buf_4_p1_write_n			(out_buf_4_p1_write_n),
							.out_buf_4_p1_address			(out_buf_4_p1_address),
							.out_buf_4_p1_writedata			(out_buf_4_p1_writedata),
							.out_buf_4_p1_readdata			(out_buf_4_p1_readdata),
	
 							   .out_buf_4_p2_read_n				(out_buf_4_p2_read_n),                         
							.out_buf_4_p2_write_n			(out_buf_4_p2_write_n),
							.out_buf_4_p2_address			(out_buf_4_p2_address),
							.out_buf_4_p2_writedata			(out_buf_4_p2_writedata),
	
							.out_buf_5_p1_read_n			(out_buf_5_p1_read_n),
							.out_buf_5_p1_write_n			(out_buf_5_p1_write_n),
							.out_buf_5_p1_address			(out_buf_5_p1_address),
							.out_buf_5_p1_writedata			(out_buf_5_p1_writedata),
							.out_buf_5_p1_readdata			(out_buf_5_p1_readdata),
	
 							   .out_buf_5_p2_read_n				(out_buf_5_p2_read_n),                         
							.out_buf_5_p2_write_n			(out_buf_5_p2_write_n),
							.out_buf_5_p2_address			(out_buf_5_p2_address),
							.out_buf_5_p2_writedata			(out_buf_5_p2_writedata),
	
							.out_buf_6_p1_read_n			(out_buf_6_p1_read_n),
							.out_buf_6_p1_write_n			(out_buf_6_p1_write_n),
							.out_buf_6_p1_address			(out_buf_6_p1_address),
							.out_buf_6_p1_writedata			(out_buf_6_p1_writedata),
							.out_buf_6_p1_readdata			(out_buf_6_p1_readdata),
	
 							   .out_buf_6_p2_read_n				(out_buf_6_p2_read_n),                         
							.out_buf_6_p2_write_n			(out_buf_6_p2_write_n),
							.out_buf_6_p2_address			(out_buf_6_p2_address),
							.out_buf_6_p2_writedata			(out_buf_6_p2_writedata),
	
							.out_buf_7_p1_read_n			(out_buf_7_p1_read_n),
							.out_buf_7_p1_write_n			(out_buf_7_p1_write_n),
							.out_buf_7_p1_address			(out_buf_7_p1_address),
							.out_buf_7_p1_writedata			(out_buf_7_p1_writedata),
							.out_buf_7_p1_readdata			(out_buf_7_p1_readdata),
	
 							   .out_buf_7_p2_read_n				(out_buf_7_p2_read_n),                         
							.out_buf_7_p2_write_n			(out_buf_7_p2_write_n),
							.out_buf_7_p2_address			(out_buf_7_p2_address),
							.out_buf_7_p2_writedata			(out_buf_7_p2_writedata),

							.w_buf_0_0_read_n				(w_buf_0_0_read_n),
							.w_buf_0_0_write_n				(w_buf_0_0_write_n),
							.w_buf_0_0_address				(w_buf_0_0_address),
							.w_buf_0_0_writedata			(w_buf_0_0_writedata),
							.w_buf_0_0_readdata				(w_buf_0_0_readdata),

							.w_buf_0_1_read_n				(w_buf_0_1_read_n),
							.w_buf_0_1_write_n				(w_buf_0_1_write_n),
							.w_buf_0_1_address				(w_buf_0_1_address),
							.w_buf_0_1_writedata			(w_buf_0_1_writedata),
							.w_buf_0_1_readdata				(w_buf_0_1_readdata),
	
							.w_buf_1_0_read_n				(w_buf_1_0_read_n),
							.w_buf_1_0_write_n				(w_buf_1_0_write_n),
							.w_buf_1_0_address				(w_buf_1_0_address),
							.w_buf_1_0_writedata			(w_buf_1_0_writedata),
							.w_buf_1_0_readdata				(w_buf_1_0_readdata),

							.w_buf_1_1_read_n				(w_buf_1_1_read_n),
							.w_buf_1_1_write_n				(w_buf_1_1_write_n),
							.w_buf_1_1_address				(w_buf_1_1_address),
							.w_buf_1_1_writedata			(w_buf_1_1_writedata),
							.w_buf_1_1_readdata				(w_buf_1_1_readdata),
	
							.w_buf_2_0_read_n				(w_buf_2_0_read_n),
							.w_buf_2_0_write_n				(w_buf_2_0_write_n),
							.w_buf_2_0_address				(w_buf_2_0_address),
							.w_buf_2_0_writedata			(w_buf_2_0_writedata),
							.w_buf_2_0_readdata				(w_buf_2_0_readdata),

							.w_buf_2_1_read_n				(w_buf_2_1_read_n),
							.w_buf_2_1_write_n				(w_buf_2_1_write_n),
							.w_buf_2_1_address				(w_buf_2_1_address),
							.w_buf_2_1_writedata			(w_buf_2_1_writedata),
							.w_buf_2_1_readdata				(w_buf_2_1_readdata),
	
							.w_buf_3_0_read_n				(w_buf_3_0_read_n),
							.w_buf_3_0_write_n				(w_buf_3_0_write_n),
							.w_buf_3_0_address				(w_buf_3_0_address),
							.w_buf_3_0_writedata			(w_buf_3_0_writedata),
							.w_buf_3_0_readdata				(w_buf_3_0_readdata),

							.w_buf_3_1_read_n				(w_buf_3_1_read_n),
							.w_buf_3_1_write_n				(w_buf_3_1_write_n),
							.w_buf_3_1_address				(w_buf_3_1_address),
							.w_buf_3_1_writedata			(w_buf_3_1_writedata),
							.w_buf_3_1_readdata				(w_buf_3_1_readdata),
	
							.w_buf_4_0_read_n				(w_buf_4_0_read_n),
							.w_buf_4_0_write_n				(w_buf_4_0_write_n),
							.w_buf_4_0_address				(w_buf_4_0_address),
							.w_buf_4_0_writedata			(w_buf_4_0_writedata),
							.w_buf_4_0_readdata				(w_buf_4_0_readdata),

							.w_buf_4_1_read_n				(w_buf_4_1_read_n),
							.w_buf_4_1_write_n				(w_buf_4_1_write_n),
							.w_buf_4_1_address				(w_buf_4_1_address),
							.w_buf_4_1_writedata			(w_buf_4_1_writedata),
							.w_buf_4_1_readdata				(w_buf_4_1_readdata),
	
							.w_buf_5_0_read_n				(w_buf_5_0_read_n),
							.w_buf_5_0_write_n				(w_buf_5_0_write_n),
							.w_buf_5_0_address				(w_buf_5_0_address),
							.w_buf_5_0_writedata			(w_buf_5_0_writedata),
							.w_buf_5_0_readdata				(w_buf_5_0_readdata),

							.w_buf_5_1_read_n				(w_buf_5_1_read_n),
							.w_buf_5_1_write_n				(w_buf_5_1_write_n),
							.w_buf_5_1_address				(w_buf_5_1_address),
							.w_buf_5_1_writedata			(w_buf_5_1_writedata),
							.w_buf_5_1_readdata				(w_buf_5_1_readdata),
	
							.w_buf_6_0_read_n				(w_buf_6_0_read_n),
							.w_buf_6_0_write_n				(w_buf_6_0_write_n),
							.w_buf_6_0_address				(w_buf_6_0_address),
							.w_buf_6_0_writedata			(w_buf_6_0_writedata),
							.w_buf_6_0_readdata				(w_buf_6_0_readdata),

							.w_buf_6_1_read_n				(w_buf_6_1_read_n),
							.w_buf_6_1_write_n				(w_buf_6_1_write_n),
							.w_buf_6_1_address				(w_buf_6_1_address),
							.w_buf_6_1_writedata			(w_buf_6_1_writedata),
							.w_buf_6_1_readdata				(w_buf_6_1_readdata),
	
							.w_buf_7_0_read_n				(w_buf_7_0_read_n),
							.w_buf_7_0_write_n				(w_buf_7_0_write_n),
							.w_buf_7_0_address				(w_buf_7_0_address),
							.w_buf_7_0_writedata			(w_buf_7_0_writedata),
							.w_buf_7_0_readdata				(w_buf_7_0_readdata),

							.w_buf_7_1_read_n				(w_buf_7_1_read_n),
							.w_buf_7_1_write_n				(w_buf_7_1_write_n),
							.w_buf_7_1_address				(w_buf_7_1_address),
							.w_buf_7_1_writedata			(w_buf_7_1_writedata),
							.w_buf_7_1_readdata				(w_buf_7_1_readdata),
	
							.ow_out_buf_0_p1_read_n			(ow_out_buf_0_p1_read_n),
							.ow_out_buf_0_p1_address		(ow_out_buf_0_p1_address),

							.ow_out_buf_1_p1_read_n			(ow_out_buf_1_p1_read_n),
							.ow_out_buf_1_p1_address		(ow_out_buf_1_p1_address),

							.ow_out_buf_2_p1_read_n			(ow_out_buf_2_p1_read_n),
							.ow_out_buf_2_p1_address		(ow_out_buf_2_p1_address),

							.ow_out_buf_3_p1_read_n			(ow_out_buf_3_p1_read_n),
							.ow_out_buf_3_p1_address		(ow_out_buf_3_p1_address),

							.ow_out_buf_4_p1_read_n			(ow_out_buf_4_p1_read_n),
							.ow_out_buf_4_p1_address		(ow_out_buf_4_p1_address),

							.ow_out_buf_5_p1_read_n			(ow_out_buf_5_p1_read_n),
							.ow_out_buf_5_p1_address		(ow_out_buf_5_p1_address),

							.ow_out_buf_6_p1_read_n			(ow_out_buf_6_p1_read_n),
							.ow_out_buf_6_p1_address		(ow_out_buf_6_p1_address),

							.ow_out_buf_7_p1_read_n			(ow_out_buf_7_p1_read_n),
							.ow_out_buf_7_p1_address		(ow_out_buf_7_p1_address),

							.conv_in_buf_0_read_n   		(conv_in_buf_0_read_n),
							.conv_in_buf_0_address  		(conv_in_buf_0_address),
							.conv_in_buf_0_readdata 		(conv_in_buf_0_readdata),

							.conv_in_buf_1_read_n   		(conv_in_buf_1_read_n),
							.conv_in_buf_1_address  		(conv_in_buf_1_address),
							.conv_in_buf_1_readdata 		(conv_in_buf_1_readdata),

							.conv_w_buf_0_0_read_n  		(conv_w_buf_0_0_read_n),
							.conv_w_buf_0_0_address 		(conv_w_buf_0_0_address),
							.conv_w_buf_0_0_readdata		(conv_w_buf_0_0_readdata),

							.conv_w_buf_0_1_read_n  		(conv_w_buf_0_1_read_n),
							.conv_w_buf_0_1_address 		(conv_w_buf_0_1_address),
							.conv_w_buf_0_1_readdata		(conv_w_buf_0_1_readdata),

							.conv_w_buf_1_0_read_n  		(conv_w_buf_1_0_read_n),
							.conv_w_buf_1_0_address 		(conv_w_buf_1_0_address),
							.conv_w_buf_1_0_readdata		(conv_w_buf_1_0_readdata),

							.conv_w_buf_1_1_read_n  		(conv_w_buf_1_1_read_n),
							.conv_w_buf_1_1_address 		(conv_w_buf_1_1_address),
							.conv_w_buf_1_1_readdata		(conv_w_buf_1_1_readdata),

							.conv_w_buf_2_0_read_n  		(conv_w_buf_2_0_read_n),
							.conv_w_buf_2_0_address 		(conv_w_buf_2_0_address),
							.conv_w_buf_2_0_readdata		(conv_w_buf_2_0_readdata),

							.conv_w_buf_2_1_read_n  		(conv_w_buf_2_1_read_n),
							.conv_w_buf_2_1_address 		(conv_w_buf_2_1_address),
							.conv_w_buf_2_1_readdata		(conv_w_buf_2_1_readdata),

							.conv_w_buf_3_0_read_n  		(conv_w_buf_3_0_read_n),
							.conv_w_buf_3_0_address 		(conv_w_buf_3_0_address),
							.conv_w_buf_3_0_readdata		(conv_w_buf_3_0_readdata),

							.conv_w_buf_3_1_read_n  		(conv_w_buf_3_1_read_n),
							.conv_w_buf_3_1_address 		(conv_w_buf_3_1_address),
							.conv_w_buf_3_1_readdata		(conv_w_buf_3_1_readdata),

							.conv_w_buf_4_0_read_n  		(conv_w_buf_4_0_read_n),
							.conv_w_buf_4_0_address 		(conv_w_buf_4_0_address),
							.conv_w_buf_4_0_readdata		(conv_w_buf_4_0_readdata),

							.conv_w_buf_4_1_read_n  		(conv_w_buf_4_1_read_n),
							.conv_w_buf_4_1_address 		(conv_w_buf_4_1_address),
							.conv_w_buf_4_1_readdata		(conv_w_buf_4_1_readdata),

							.conv_w_buf_5_0_read_n  		(conv_w_buf_5_0_read_n),
							.conv_w_buf_5_0_address 		(conv_w_buf_5_0_address),
							.conv_w_buf_5_0_readdata		(conv_w_buf_5_0_readdata),

							.conv_w_buf_5_1_read_n  		(conv_w_buf_5_1_read_n),
							.conv_w_buf_5_1_address 		(conv_w_buf_5_1_address),
							.conv_w_buf_5_1_readdata		(conv_w_buf_5_1_readdata),

							.conv_w_buf_6_0_read_n  		(conv_w_buf_6_0_read_n),
							.conv_w_buf_6_0_address 		(conv_w_buf_6_0_address),
							.conv_w_buf_6_0_readdata		(conv_w_buf_6_0_readdata),

							.conv_w_buf_6_1_read_n  		(conv_w_buf_6_1_read_n),
							.conv_w_buf_6_1_address 		(conv_w_buf_6_1_address),
							.conv_w_buf_6_1_readdata		(conv_w_buf_6_1_readdata),

							.conv_w_buf_7_0_read_n  		(conv_w_buf_7_0_read_n),
							.conv_w_buf_7_0_address 		(conv_w_buf_7_0_address),
							.conv_w_buf_7_0_readdata		(conv_w_buf_7_0_readdata),

							.conv_w_buf_7_1_read_n  		(conv_w_buf_7_1_read_n),
							.conv_w_buf_7_1_address 		(conv_w_buf_7_1_address),
							.conv_w_buf_7_1_readdata		(conv_w_buf_7_1_readdata),

							.conv_out_buf_0_p1_read_n    (conv_out_buf_0_p1_read_n),
							.conv_out_buf_0_p1_address   (conv_out_buf_0_p1_address),
							.conv_out_buf_0_p1_readdata  (conv_out_buf_0_p1_readdata),

							.conv_out_buf_1_p1_read_n    (conv_out_buf_1_p1_read_n),
							.conv_out_buf_1_p1_address   (conv_out_buf_1_p1_address),
							.conv_out_buf_1_p1_readdata  (conv_out_buf_1_p1_readdata),

							.conv_out_buf_2_p1_read_n    (conv_out_buf_2_p1_read_n),
							.conv_out_buf_2_p1_address   (conv_out_buf_2_p1_address),
							.conv_out_buf_2_p1_readdata  (conv_out_buf_2_p1_readdata),

							.conv_out_buf_3_p1_read_n    (conv_out_buf_3_p1_read_n),
							.conv_out_buf_3_p1_address   (conv_out_buf_3_p1_address),
							.conv_out_buf_3_p1_readdata  (conv_out_buf_3_p1_readdata),

							.conv_out_buf_4_p1_read_n    (conv_out_buf_4_p1_read_n),
							.conv_out_buf_4_p1_address   (conv_out_buf_4_p1_address),
							.conv_out_buf_4_p1_readdata  (conv_out_buf_4_p1_readdata),

							.conv_out_buf_5_p1_read_n    (conv_out_buf_5_p1_read_n),
							.conv_out_buf_5_p1_address   (conv_out_buf_5_p1_address),
							.conv_out_buf_5_p1_readdata  (conv_out_buf_5_p1_readdata),

							.conv_out_buf_6_p1_read_n    (conv_out_buf_6_p1_read_n),
							.conv_out_buf_6_p1_address   (conv_out_buf_6_p1_address),
							.conv_out_buf_6_p1_readdata  (conv_out_buf_6_p1_readdata),

							.conv_out_buf_7_p1_read_n    (conv_out_buf_7_p1_read_n),
							.conv_out_buf_7_p1_address   (conv_out_buf_7_p1_address),
							.conv_out_buf_7_p1_readdata  (conv_out_buf_7_p1_readdata),

							.conv_out_buf_0_p2_write_n   (conv_out_buf_0_p2_write_n),
							.conv_out_buf_0_p2_address   (conv_out_buf_0_p2_address),
							.conv_out_buf_0_p2_writedata (conv_out_buf_0_p2_writedata),

							.conv_out_buf_1_p2_write_n   (conv_out_buf_1_p2_write_n),
							.conv_out_buf_1_p2_address   (conv_out_buf_1_p2_address),
							.conv_out_buf_1_p2_writedata (conv_out_buf_1_p2_writedata),

							.conv_out_buf_2_p2_write_n   (conv_out_buf_2_p2_write_n),
							.conv_out_buf_2_p2_address   (conv_out_buf_2_p2_address),
							.conv_out_buf_2_p2_writedata (conv_out_buf_2_p2_writedata),

							.conv_out_buf_3_p2_write_n   (conv_out_buf_3_p2_write_n),
							.conv_out_buf_3_p2_address   (conv_out_buf_3_p2_address),
							.conv_out_buf_3_p2_writedata (conv_out_buf_3_p2_writedata),

							.conv_out_buf_4_p2_write_n   (conv_out_buf_4_p2_write_n),
							.conv_out_buf_4_p2_address   (conv_out_buf_4_p2_address),
							.conv_out_buf_4_p2_writedata (conv_out_buf_4_p2_writedata),

							.conv_out_buf_5_p2_write_n   (conv_out_buf_5_p2_write_n),
							.conv_out_buf_5_p2_address   (conv_out_buf_5_p2_address),
							.conv_out_buf_5_p2_writedata (conv_out_buf_5_p2_writedata),

							.conv_out_buf_6_p2_write_n   (conv_out_buf_6_p2_write_n),
							.conv_out_buf_6_p2_address   (conv_out_buf_6_p2_address),
							.conv_out_buf_6_p2_writedata (conv_out_buf_6_p2_writedata),

							.conv_out_buf_7_p2_write_n   (conv_out_buf_7_p2_write_n),
							.conv_out_buf_7_p2_address   (conv_out_buf_7_p2_address),
							.conv_out_buf_7_p2_writedata (conv_out_buf_7_p2_writedata),
	
							.sdram_inbuf0_done				(sdram_inbuf0_done),
							.sdram_wbuf0_done				(sdram_wbuf0_done),
							.sdram_outbuf0_done				(sdram_outbuf0_done),
	
							.n								(n)
);
conv conv_0(
							.clk (sys_clk),
							
							.in_buf_0_read_n (conv_in_buf_0_read_n),
							.in_buf_0_address (conv_in_buf_0_address),
							.in_buf_0_readdata (conv_in_buf_0_readdata),

							.in_buf_1_read_n (conv_in_buf_1_read_n),
							.in_buf_1_address (conv_in_buf_1_address),
							.in_buf_1_readdata (conv_in_buf_1_readdata),

							.w_buf_0_0_read_n (conv_w_buf_0_0_read_n),
							.w_buf_0_0_address (conv_w_buf_0_0_address),
							.w_buf_0_0_readdata (conv_w_buf_0_0_readdata),

							.w_buf_0_1_read_n (conv_w_buf_0_1_read_n),
							.w_buf_0_1_address (conv_w_buf_0_1_address),
							.w_buf_0_1_readdata (conv_w_buf_0_1_readdata),

							.w_buf_1_0_read_n (conv_w_buf_1_0_read_n),
							.w_buf_1_0_address (conv_w_buf_1_0_address),
							.w_buf_1_0_readdata (conv_w_buf_1_0_readdata),

							.w_buf_1_1_read_n (conv_w_buf_1_1_read_n),
							.w_buf_1_1_address (conv_w_buf_1_1_address),
							.w_buf_1_1_readdata (conv_w_buf_1_1_readdata),

							.w_buf_2_0_read_n (conv_w_buf_2_0_read_n),
							.w_buf_2_0_address (conv_w_buf_2_0_address),
							.w_buf_2_0_readdata (conv_w_buf_2_0_readdata),

							.w_buf_2_1_read_n (conv_w_buf_2_1_read_n),
							.w_buf_2_1_address (conv_w_buf_2_1_address),
							.w_buf_2_1_readdata (conv_w_buf_2_1_readdata),

							.w_buf_3_0_read_n (conv_w_buf_3_0_read_n),
							.w_buf_3_0_address (conv_w_buf_3_0_address),
							.w_buf_3_0_readdata (conv_w_buf_3_0_readdata),

							.w_buf_3_1_read_n (conv_w_buf_3_1_read_n),
							.w_buf_3_1_address (conv_w_buf_3_1_address),
							.w_buf_3_1_readdata (conv_w_buf_3_1_readdata),

							.w_buf_4_0_read_n (conv_w_buf_4_0_read_n),
							.w_buf_4_0_address (conv_w_buf_4_0_address),
							.w_buf_4_0_readdata (conv_w_buf_4_0_readdata),

							.w_buf_4_1_read_n (conv_w_buf_4_1_read_n),
							.w_buf_4_1_address (conv_w_buf_4_1_address),
							.w_buf_4_1_readdata (conv_w_buf_4_1_readdata),

							.w_buf_5_0_read_n (conv_w_buf_5_0_read_n),
							.w_buf_5_0_address (conv_w_buf_5_0_address),
							.w_buf_5_0_readdata (conv_w_buf_5_0_readdata),

							.w_buf_5_1_read_n (conv_w_buf_5_1_read_n),
							.w_buf_5_1_address (conv_w_buf_5_1_address),
							.w_buf_5_1_readdata (conv_w_buf_5_1_readdata),

							.w_buf_6_0_read_n (conv_w_buf_6_0_read_n),
							.w_buf_6_0_address (conv_w_buf_6_0_address),
							.w_buf_6_0_readdata (conv_w_buf_6_0_readdata),

							.w_buf_6_1_read_n (conv_w_buf_6_1_read_n),
							.w_buf_6_1_address (conv_w_buf_6_1_address),
							.w_buf_6_1_readdata (conv_w_buf_6_1_readdata),

							.w_buf_7_0_read_n (conv_w_buf_7_0_read_n),
							.w_buf_7_0_address (conv_w_buf_7_0_address),
							.w_buf_7_0_readdata (conv_w_buf_7_0_readdata),

							.w_buf_7_1_read_n (conv_w_buf_7_1_read_n),
							.w_buf_7_1_address (conv_w_buf_7_1_address),
							.w_buf_7_1_readdata (conv_w_buf_7_1_readdata),

							.out_buf_0_p1_read_n (conv_out_buf_0_p1_read_n),
							.out_buf_0_p1_address (conv_out_buf_0_p1_address),
							.out_buf_0_p1_readdata (conv_out_buf_0_p1_readdata),

							.out_buf_1_p1_read_n (conv_out_buf_1_p1_read_n),
							.out_buf_1_p1_address (conv_out_buf_1_p1_address),
							.out_buf_1_p1_readdata (conv_out_buf_1_p1_readdata),

							.out_buf_2_p1_read_n (conv_out_buf_2_p1_read_n),
							.out_buf_2_p1_address (conv_out_buf_2_p1_address),
							.out_buf_2_p1_readdata (conv_out_buf_2_p1_readdata),

							.out_buf_3_p1_read_n (conv_out_buf_3_p1_read_n),
							.out_buf_3_p1_address (conv_out_buf_3_p1_address),
							.out_buf_3_p1_readdata (conv_out_buf_3_p1_readdata),

							.out_buf_4_p1_read_n (conv_out_buf_4_p1_read_n),
							.out_buf_4_p1_address (conv_out_buf_4_p1_address),
							.out_buf_4_p1_readdata (conv_out_buf_4_p1_readdata),

							.out_buf_5_p1_read_n (conv_out_buf_5_p1_read_n),
							.out_buf_5_p1_address (conv_out_buf_5_p1_address),
							.out_buf_5_p1_readdata (conv_out_buf_5_p1_readdata),

							.out_buf_6_p1_read_n (conv_out_buf_6_p1_read_n),
							.out_buf_6_p1_address (conv_out_buf_6_p1_address),
							.out_buf_6_p1_readdata (conv_out_buf_6_p1_readdata),

							.out_buf_7_p1_read_n (conv_out_buf_7_p1_read_n),
							.out_buf_7_p1_address (conv_out_buf_7_p1_address),
							.out_buf_7_p1_readdata (conv_out_buf_7_p1_readdata),

							.out_buf_0_p2_write_n (conv_out_buf_0_p2_write_n),
							.out_buf_0_p2_address (conv_out_buf_0_p2_address),
							.out_buf_0_p2_writedata (conv_out_buf_0_p2_writedata),

							.out_buf_1_p2_write_n (conv_out_buf_1_p2_write_n),
							.out_buf_1_p2_address (conv_out_buf_1_p2_address),
							.out_buf_1_p2_writedata (conv_out_buf_1_p2_writedata),

							.out_buf_2_p2_write_n (conv_out_buf_2_p2_write_n),
							.out_buf_2_p2_address (conv_out_buf_2_p2_address),
							.out_buf_2_p2_writedata (conv_out_buf_2_p2_writedata),

							.out_buf_3_p2_write_n (conv_out_buf_3_p2_write_n),
							.out_buf_3_p2_address (conv_out_buf_3_p2_address),
							.out_buf_3_p2_writedata (conv_out_buf_3_p2_writedata),

							.out_buf_4_p2_write_n (conv_out_buf_4_p2_write_n),
							.out_buf_4_p2_address (conv_out_buf_4_p2_address),
							.out_buf_4_p2_writedata (conv_out_buf_4_p2_writedata),

							.out_buf_5_p2_write_n (conv_out_buf_5_p2_write_n),
							.out_buf_5_p2_address (conv_out_buf_5_p2_address),
							.out_buf_5_p2_writedata (conv_out_buf_5_p2_writedata),

							.out_buf_6_p2_write_n (conv_out_buf_6_p2_write_n),
							.out_buf_6_p2_address (conv_out_buf_6_p2_address),
							.out_buf_6_p2_writedata (conv_out_buf_6_p2_writedata),

							.out_buf_7_p2_write_n (conv_out_buf_7_p2_write_n),
							.out_buf_7_p2_address (conv_out_buf_7_p2_address),
							.out_buf_7_p2_writedata (conv_out_buf_7_p2_writedata),
							
							.done	(conv_done), 
							.enable (conv_en),
							.n (n)
);
ofm_wb ow_0 (
							.clk								(sys_clk),
							
							.sdram_write_n					(ow_sdram_write_n),
							.sdram_writedata				(ow_sdram_writedata),
							.sdram_address					(ow_sdram_address),
							.sdram_waitrequest			(~sdram_waitrequest_n),
							 
							.out_buf_0_p1_read_n			(ow_out_buf_0_p1_read_n),
							.out_buf_0_p1_readdata		(out_buf_0_p1_readdata),
							.out_buf_0_p1_address		(ow_out_buf_0_p1_address),
							.out_buf_0_p1_readdatavalid(out_buf_0_p1_readdatavalid),

							.out_buf_1_p1_read_n			(ow_out_buf_1_p1_read_n),
							.out_buf_1_p1_readdata		(out_buf_1_p1_readdata),
							.out_buf_1_p1_address		(ow_out_buf_1_p1_address),
							.out_buf_1_p1_readdatavalid(out_buf_1_p1_readdatavalid),

							.out_buf_2_p1_read_n			(ow_out_buf_2_p1_read_n),
							.out_buf_2_p1_readdata		(out_buf_2_p1_readdata),
							.out_buf_2_p1_address		(ow_out_buf_2_p1_address),
							.out_buf_2_p1_readdatavalid(out_buf_2_p1_readdatavalid),

							.out_buf_3_p1_read_n			(ow_out_buf_3_p1_read_n),
							.out_buf_3_p1_readdata		(out_buf_3_p1_readdata),
							.out_buf_3_p1_address		(ow_out_buf_3_p1_address),
							.out_buf_3_p1_readdatavalid(out_buf_3_p1_readdatavalid),

							.out_buf_4_p1_read_n			(ow_out_buf_4_p1_read_n),
							.out_buf_4_p1_readdata		(out_buf_4_p1_readdata),
							.out_buf_4_p1_address		(ow_out_buf_4_p1_address),
							.out_buf_4_p1_readdatavalid(out_buf_4_p1_readdatavalid),

							.out_buf_5_p1_read_n			(ow_out_buf_5_p1_read_n),
							.out_buf_5_p1_readdata		(out_buf_5_p1_readdata),
							.out_buf_5_p1_address		(ow_out_buf_5_p1_address),
							.out_buf_5_p1_readdatavalid(out_buf_5_p1_readdatavalid),

							.out_buf_6_p1_read_n			(ow_out_buf_6_p1_read_n),
							.out_buf_6_p1_readdata		(out_buf_6_p1_readdata),
							.out_buf_6_p1_address		(ow_out_buf_6_p1_address),
							.out_buf_6_p1_readdatavalid(out_buf_6_p1_readdatavalid),

							.out_buf_7_p1_read_n			(ow_out_buf_7_p1_read_n),
							.out_buf_7_p1_readdata		(out_buf_7_p1_readdata),
							.out_buf_7_p1_address		(ow_out_buf_7_p1_address),
							.out_buf_7_p1_readdatavalid(out_buf_7_p1_readdatavalid),
							
							.done								(outbuf0_sdram_done),						
							.enable							(ow_en),
							
							.m (m),
							.n (n)								
);
endmodule
