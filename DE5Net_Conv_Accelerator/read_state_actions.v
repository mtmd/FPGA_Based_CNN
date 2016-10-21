module read_state_actions (
input clk,
input [`NUM_RD_ST_W - 1 : 0]  read_state,
input SDRAM_RDVAL,
input [`DATA_WIDTH - 1: 0] SDRAM_READDATA,

output reg in_buf_0_read_n = 1,
output reg in_buf_0_write_n = 1,
output reg [`IFM_ADR_W - 1 : 0] in_buf_0_address,
output reg [`DATA_WIDTH - 1 : 0]	in_buf_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	in_buf_0_readdata,

output reg in_buf_1_read_n = 1,
output reg in_buf_1_write_n = 1,
output reg [`IFM_ADR_W - 1 : 0]	in_buf_1_address,
output reg [`DATA_WIDTH - 1 : 0]	in_buf_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	in_buf_1_readdata,

output reg out_buf_0_p1_read_n = 1,
output reg out_buf_0_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_0_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_0_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_0_p1_readdata ,

output reg out_buf_0_p2_read_n = 1,
output reg out_buf_0_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_0_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_0_p2_writedata = 0,

output reg out_buf_1_p1_read_n = 1,
output reg out_buf_1_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_1_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_1_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_1_p1_readdata,

output reg out_buf_1_p2_read_n = 1,
output reg out_buf_1_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_1_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_1_p2_writedata = 0,

output reg out_buf_2_p1_read_n = 1,
output reg out_buf_2_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_2_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_2_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_2_p1_readdata,

output reg out_buf_2_p2_read_n = 1,
output reg out_buf_2_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_2_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_2_p2_writedata = 0,

output reg out_buf_3_p1_read_n = 1,
output reg out_buf_3_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_3_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_3_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_3_p1_readdata,

output reg out_buf_3_p2_read_n = 1,
output reg out_buf_3_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_3_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_3_p2_writedata = 0,

output reg out_buf_4_p1_read_n = 1,
output reg out_buf_4_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_4_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_4_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_4_p1_readdata,

output reg out_buf_4_p2_read_n = 1,
output reg out_buf_4_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_4_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_4_p2_writedata = 0,

output reg out_buf_5_p1_read_n = 1,
output reg out_buf_5_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_5_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_5_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_5_p1_readdata,

output reg out_buf_5_p2_read_n = 1,
output reg out_buf_5_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_5_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_5_p2_writedata = 0,

output reg out_buf_6_p1_read_n = 1,
output reg out_buf_6_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_6_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_6_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_6_p1_readdata,

output reg out_buf_6_p2_read_n = 1,
output reg out_buf_6_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_6_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_6_p2_writedata = 0,

output reg out_buf_7_p1_read_n = 1,
output reg out_buf_7_p1_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_7_p1_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_7_p1_writedata = 0,
input      [`DATA_WIDTH - 1 : 0]	out_buf_7_p1_readdata,

output reg out_buf_7_p2_read_n = 1,
output reg out_buf_7_p2_write_n = 1,
output reg [`OFM_ADR_W - 1 : 0] out_buf_7_p2_address = 0,
output reg [`DATA_WIDTH - 1 : 0]	out_buf_7_p2_writedata = 0,

output reg w_buf_0_0_read_n 	= 1,
output reg w_buf_0_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_0_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_0_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_0_0_readdata,

output reg w_buf_0_1_read_n 	= 1,
output reg w_buf_0_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_0_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_0_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_0_1_readdata,

output reg w_buf_1_0_read_n 	= 1,
output reg w_buf_1_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_1_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_1_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_1_0_readdata,

output reg w_buf_1_1_read_n 	= 1,
output reg w_buf_1_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_1_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_1_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_1_1_readdata,

output reg w_buf_2_0_read_n 	= 1,
output reg w_buf_2_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_2_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_2_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_2_0_readdata,

output reg w_buf_2_1_read_n 	= 1,
output reg w_buf_2_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_2_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_2_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_2_1_readdata,

output reg w_buf_3_0_read_n 	= 1,
output reg w_buf_3_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_3_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_3_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_3_0_readdata,

output reg w_buf_3_1_read_n 	= 1,
output reg w_buf_3_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_3_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_3_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_3_1_readdata,

output reg w_buf_4_0_read_n 	= 1,
output reg w_buf_4_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_4_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_4_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_4_0_readdata,

output reg w_buf_4_1_read_n 	= 1,
output reg w_buf_4_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_4_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_4_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_4_1_readdata,

output reg w_buf_5_0_read_n 	= 1,
output reg w_buf_5_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_5_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_5_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_5_0_readdata,

output reg w_buf_5_1_read_n 	= 1,
output reg w_buf_5_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_5_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_5_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_5_1_readdata,

output reg w_buf_6_0_read_n 	= 1,
output reg w_buf_6_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_6_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_6_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_6_0_readdata,

output reg w_buf_6_1_read_n 	= 1,
output reg w_buf_6_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_6_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_6_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_6_1_readdata,

output reg w_buf_7_0_read_n 	= 1,
output reg w_buf_7_0_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_7_0_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_7_0_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_7_0_readdata,

output reg w_buf_7_1_read_n 	= 1,
output reg w_buf_7_1_write_n 	= 1,
output reg [`WGHT_ADR_W - 1 : 0] w_buf_7_1_address,
output reg [`DATA_WIDTH - 1 : 0]	w_buf_7_1_writedata,
input      [`DATA_WIDTH - 1 : 0]	w_buf_7_1_readdata,

input      ow_out_buf_0_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_0_p1_address,

input      ow_out_buf_1_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_1_p1_address,

input      ow_out_buf_2_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_2_p1_address,

input      ow_out_buf_3_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_3_p1_address,

input      ow_out_buf_4_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_4_p1_address,

input      ow_out_buf_5_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_5_p1_address,

input      ow_out_buf_6_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_6_p1_address,

input      ow_out_buf_7_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] ow_out_buf_7_p1_address,

input      conv_in_buf_0_read_n,
input      [`IFM_ADR_W - 1 : 0] conv_in_buf_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_in_buf_0_readdata = 0,

input      conv_in_buf_1_read_n,
input      [`IFM_ADR_W - 1 : 0] conv_in_buf_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_in_buf_1_readdata = 0,

input      conv_w_buf_0_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_0_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_0_0_readdata = 0,

input      conv_w_buf_0_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_0_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_0_1_readdata = 0,

input      conv_w_buf_1_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_1_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_1_0_readdata = 0,

input      conv_w_buf_1_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_1_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_1_1_readdata = 0,

input      conv_w_buf_2_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_2_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_2_0_readdata = 0,

input      conv_w_buf_2_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_2_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_2_1_readdata = 0,

input      conv_w_buf_3_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_3_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_3_0_readdata = 0,

input      conv_w_buf_3_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_3_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_3_1_readdata = 0,

input      conv_w_buf_4_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_4_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_4_0_readdata = 0,

input      conv_w_buf_4_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_4_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_4_1_readdata = 0,

input      conv_w_buf_5_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_5_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_5_0_readdata = 0,

input      conv_w_buf_5_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_5_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_5_1_readdata = 0,

input      conv_w_buf_6_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_6_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_6_0_readdata = 0,

input      conv_w_buf_6_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_6_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_6_1_readdata = 0,

input      conv_w_buf_7_0_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_7_0_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_7_0_readdata = 0,

input      conv_w_buf_7_1_read_n,
input      [`WGHT_ADR_W - 1 : 0] conv_w_buf_7_1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_w_buf_7_1_readdata = 0,

input      conv_out_buf_0_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_0_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_0_p1_readdata = 0,

input      conv_out_buf_1_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_1_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_1_p1_readdata = 0,

input      conv_out_buf_2_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_2_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_2_p1_readdata = 0,

input      conv_out_buf_3_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_3_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_3_p1_readdata = 0,

input      conv_out_buf_4_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_4_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_4_p1_readdata = 0,

input      conv_out_buf_5_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_5_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_5_p1_readdata = 0,

input      conv_out_buf_6_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_6_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_6_p1_readdata = 0,

input      conv_out_buf_7_p1_read_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_7_p1_address,
output reg [`DATA_WIDTH - 1 : 0] conv_out_buf_7_p1_readdata = 0,

input      conv_out_buf_0_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_0_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_0_p2_writedata,

input      conv_out_buf_1_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_1_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_1_p2_writedata,

input      conv_out_buf_2_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_2_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_2_p2_writedata,

input      conv_out_buf_3_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_3_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_3_p2_writedata,

input      conv_out_buf_4_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_4_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_4_p2_writedata,

input      conv_out_buf_5_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_5_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_5_p2_writedata,

input      conv_out_buf_6_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_6_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_6_p2_writedata,

input      conv_out_buf_7_p2_write_n,
input      [`OFM_ADR_W - 1 : 0] conv_out_buf_7_p2_address,
input      [`DATA_WIDTH - 1 : 0] conv_out_buf_7_p2_writedata,

output reg sdram_inbuf0_done = 0,
output reg sdram_wbuf0_done = 0,
output reg sdram_outbuf0_done = 0,

input [`N_IDX_SZ - 1 : 0] n
);

reg [`WGHT_ADR_W - 1 : 0] idx_weight_0_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_0_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_1_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_1_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_2_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_2_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_3_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_3_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_4_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_4_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_5_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_5_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_6_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_6_1 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_7_0 = 0;
reg [`WGHT_ADR_W - 1 : 0] idx_weight_7_1 = 0;


reg [`IFM_ADR_W - 1 : 0] idx_in_0  = 0;
reg [`IFM_ADR_W - 1 : 0] idx_in_1  = 0;

reg [`OFM_ADR_W - 1 : 0] idx_out_0 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_1 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_2 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_3 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_4 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_5 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_6 = 0;
reg [`OFM_ADR_W - 1 : 0] idx_out_7 = 0;


always @ (posedge clk)
begin
	case (read_state)
	`IDLE:
	begin
		in_buf_0_read_n <= 1;
		in_buf_0_write_n <= 1;
		
		in_buf_1_read_n <= 1;
		in_buf_1_write_n <= 1;

		out_buf_0_p1_read_n <= 1;
		out_buf_0_p1_write_n	<= 1;
		
		out_buf_0_p2_read_n <= 1;
		out_buf_0_p2_write_n <= 1;
		
		out_buf_1_p1_read_n <= 1;
		out_buf_1_p1_write_n	<= 1;
		
		out_buf_1_p2_read_n <= 1;
		out_buf_1_p2_write_n <= 1;
		
		out_buf_2_p1_read_n <= 1;
		out_buf_2_p1_write_n	<= 1;
		
		out_buf_2_p2_read_n <= 1;
		out_buf_2_p2_write_n <= 1;
		
		out_buf_3_p1_read_n <= 1;
		out_buf_3_p1_write_n	<= 1;
		
		out_buf_3_p2_read_n <= 1;
		out_buf_3_p2_write_n <= 1;

		out_buf_4_p1_read_n <= 1;
		out_buf_4_p1_write_n	<= 1;
		
		out_buf_4_p2_read_n <= 1;
		out_buf_4_p2_write_n <= 1;

		out_buf_5_p1_read_n <= 1;
		out_buf_5_p1_write_n	<= 1;
		
		out_buf_5_p2_read_n <= 1;
		out_buf_5_p2_write_n <= 1;

		out_buf_6_p1_read_n <= 1;
		out_buf_6_p1_write_n	<= 1;
	
		out_buf_6_p2_read_n <= 1;
		out_buf_6_p2_write_n <= 1;
		
		out_buf_7_p1_read_n <= 1;
		out_buf_7_p1_write_n	<= 1;
		
		out_buf_7_p2_read_n <= 1;
		out_buf_7_p2_write_n <= 1;
		
		w_buf_0_0_read_n <= 1;
		w_buf_0_0_write_n <= 1;
		
		w_buf_0_1_read_n <= 1;
		w_buf_0_1_write_n <= 1;
		
		w_buf_1_0_read_n <= 1;
		w_buf_1_0_write_n <= 1;
		
		w_buf_1_1_read_n <= 1;
		w_buf_1_1_write_n <= 1;
		
		w_buf_2_0_read_n <= 1;
		w_buf_2_0_write_n <= 1;
		
		w_buf_2_1_read_n <= 1;
		w_buf_2_1_write_n <= 1;
		
		w_buf_3_0_read_n <= 1;
		w_buf_3_0_write_n <= 1;
		
		w_buf_3_1_read_n <= 1;
		w_buf_3_1_write_n <= 1;

		w_buf_4_0_read_n <= 1;
		w_buf_4_0_write_n <= 1;
		
		w_buf_4_1_read_n <= 1;
		w_buf_4_1_write_n <= 1;

		w_buf_5_0_read_n <= 1;
		w_buf_5_0_write_n <= 1;
		
		w_buf_5_1_read_n <= 1;
		w_buf_5_1_write_n <= 1;

		w_buf_6_0_read_n <= 1;
		w_buf_6_0_write_n <= 1;
		
		w_buf_6_1_read_n <= 1;
		w_buf_6_1_write_n <= 1;

		w_buf_7_0_read_n <= 1;
		w_buf_7_0_write_n <= 1;
		
		w_buf_7_1_read_n <= 1;
		w_buf_7_1_write_n <= 1;
		
		
		idx_weight_0_0 <= 0;
		idx_weight_0_1 <= 0;
		idx_weight_1_0 <= 0;
		idx_weight_1_1 <= 0;
		idx_weight_2_0 <= 0;
		idx_weight_2_1 <= 0;
		idx_weight_3_0 <= 0;
		idx_weight_3_1 <= 0;
		idx_weight_4_0 <= 0;
		idx_weight_4_1 <= 0;
		idx_weight_5_0 <= 0;
		idx_weight_5_1 <= 0;
		idx_weight_6_0 <= 0;
		idx_weight_6_1 <= 0;
		idx_weight_7_0 <= 0;
		idx_weight_7_1 <= 0;


		idx_in_0  <= 0;
		idx_in_1  <= 0;

		idx_out_0 <= 0;
		idx_out_1 <= 0;
		idx_out_2 <= 0;
		idx_out_3 <= 0;
		idx_out_4 <= 0;
		idx_out_5 <= 0;
		idx_out_6 <= 0;
		idx_out_7 <= 0;
		
		sdram_inbuf0_done <= 0;
		sdram_wbuf0_done = 0;
		sdram_outbuf0_done = 0;
	end
	`FROM_SDRAM_TO_INBUF_0:
	begin
		in_buf_0_read_n <= 1;
		in_buf_1_read_n <= 1;
		
		in_buf_0_address <= SDRAM_RDVAL ? idx_in_0 : in_buf_0_address;
		in_buf_1_address <= SDRAM_RDVAL ? idx_in_1 : in_buf_1_address;
		
		in_buf_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : in_buf_0_writedata;
		in_buf_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : in_buf_1_writedata;
		
		if (idx_in_0 <`IFM_SIZE)
		begin
			in_buf_0_write_n <= 0;
			//in_buf_1_write_n <= (idx_in_0 >= (`IFM_SIZE - 1)) ? 1'b0 : 1'b1;
			idx_in_0 <= SDRAM_RDVAL ? idx_in_0 + 1'b1 : idx_in_0;
			sdram_inbuf0_done	<= 0;
		end
		else if (idx_in_1 < `IFM_SIZE)
		begin
			in_buf_0_write_n <= 1;						
			in_buf_1_write_n <= 0;								
			idx_in_1 <= SDRAM_RDVAL ? idx_in_1 + 1'b1: idx_in_1;			
			sdram_inbuf0_done <= 0;
		end
		else
		begin
			in_buf_0_write_n <= 1;
			in_buf_1_write_n <= 1;			
			/*idx_in_0 <= 0;
			idx_in_1 <= 0;*/			
			sdram_inbuf0_done <= 1;
		end
	end
	`FROM_SDRAM_TO_WBUF_0:
	begin
		in_buf_0_read_n  <= 1;
		in_buf_0_write_n <= 1;
		
		in_buf_1_read_n  <= 1;
		in_buf_1_write_n <= 1;
		
		idx_in_0 <= 0;
		idx_in_1 <= 0;
		
		sdram_inbuf0_done <= 0;
		
		w_buf_0_0_address <= SDRAM_RDVAL ? idx_weight_0_0 : w_buf_0_0_address;
		w_buf_0_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_0_0_writedata;
		
		w_buf_0_1_address <= SDRAM_RDVAL ? idx_weight_0_1 : w_buf_0_1_address;
		w_buf_0_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_0_1_writedata;		
			
		w_buf_1_0_address <= SDRAM_RDVAL ? idx_weight_1_0 : w_buf_1_0_address;
		w_buf_1_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_1_0_writedata;		
		
		w_buf_1_1_address <= SDRAM_RDVAL ? idx_weight_1_1 : w_buf_1_1_address;
		w_buf_1_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_1_1_writedata;	
	
		w_buf_2_0_address <= SDRAM_RDVAL ? idx_weight_2_0 : w_buf_2_0_address;
		w_buf_2_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_2_0_writedata;	
		
		w_buf_2_1_address <= SDRAM_RDVAL ? idx_weight_2_1 : w_buf_2_1_address;
		w_buf_2_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_2_1_writedata;		
		
		w_buf_3_0_address <= SDRAM_RDVAL ? idx_weight_3_0 : w_buf_3_0_address;
		w_buf_3_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_3_0_writedata;		
		
		w_buf_3_1_address <= SDRAM_RDVAL ? idx_weight_3_1 : w_buf_3_1_address;
		w_buf_3_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_3_1_writedata;		
		
		w_buf_4_0_address <= SDRAM_RDVAL ? idx_weight_4_0 : w_buf_4_0_address;
		w_buf_4_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_4_0_writedata;		
		
		w_buf_4_1_address <= SDRAM_RDVAL ? idx_weight_4_1 : w_buf_4_1_address;
		w_buf_4_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_4_1_writedata;		
		
		w_buf_5_0_address <= SDRAM_RDVAL ? idx_weight_5_0 : w_buf_5_0_address;
		w_buf_5_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_5_0_writedata;	
	
		w_buf_5_1_address <= SDRAM_RDVAL ? idx_weight_5_1 : w_buf_5_1_address;
		w_buf_5_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_5_1_writedata;	
	
		w_buf_6_0_address <= SDRAM_RDVAL ? idx_weight_6_0 : w_buf_6_0_address;
		w_buf_6_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_6_0_writedata;		
		
		w_buf_6_1_address <= SDRAM_RDVAL ? idx_weight_6_1 : w_buf_6_1_address;
		w_buf_6_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_6_1_writedata;
		
		w_buf_7_0_address <= SDRAM_RDVAL ? idx_weight_7_0 : w_buf_7_0_address;
		w_buf_7_0_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_7_0_writedata;
		
		w_buf_7_1_address <= SDRAM_RDVAL ? idx_weight_7_1 : w_buf_7_1_address;
		w_buf_7_1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : w_buf_7_1_writedata;		
		
		if (idx_weight_0_0 <`KERNEL_SIZE)
		begin
			w_buf_0_0_write_n <= 0;
			//w_buf_0_1_write_n <= 0;
			idx_weight_0_0 <= SDRAM_RDVAL ? idx_weight_0_0 + 1'b1 : idx_weight_0_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_0_1 < `KERNEL_SIZE)
		begin
			w_buf_0_0_write_n <= 1;
			w_buf_0_1_write_n <= 0;
			//w_buf_1_0_write_n <= 0;
			idx_weight_0_1 <= SDRAM_RDVAL ? idx_weight_0_1 + 1'b1 : idx_weight_0_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_1_0 <`KERNEL_SIZE)
		begin
			w_buf_0_1_write_n <= 1;
			w_buf_1_0_write_n <= 0;
			//w_buf_1_1_write_n <= 0;
			idx_weight_1_0 <= SDRAM_RDVAL ? idx_weight_1_0 + 1'b1 : idx_weight_1_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_1_1 < `KERNEL_SIZE)
		begin
			w_buf_1_0_write_n <= 1;
			w_buf_1_1_write_n <= 0;
			//w_buf_2_0_write_n <= 0;
			idx_weight_1_1 <= SDRAM_RDVAL ? idx_weight_1_1 + 1'b1 : idx_weight_1_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_2_0 <`KERNEL_SIZE)
		begin
			w_buf_1_1_write_n <= 1;
			w_buf_2_0_write_n <= 0;
			//w_buf_2_1_write_n <= 0;			
			idx_weight_2_0 <= SDRAM_RDVAL ? idx_weight_2_0 + 1'b1 : idx_weight_2_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_2_1 < `KERNEL_SIZE)
		begin
			w_buf_2_0_write_n <= 1;
			w_buf_2_1_write_n <= 0;
			//w_buf_3_0_write_n <= 0;
			idx_weight_2_1 <= SDRAM_RDVAL ? idx_weight_2_1 + 1'b1 : idx_weight_2_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_3_0 <`KERNEL_SIZE)
		begin
			w_buf_2_1_write_n <= 1;
			w_buf_3_0_write_n <= 0;
			//w_buf_3_1_write_n <= 0;
			idx_weight_3_0 <= SDRAM_RDVAL ? idx_weight_3_0 + 1'b1 : idx_weight_3_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_3_1 < `KERNEL_SIZE)
		begin
			w_buf_3_0_write_n <= 1;
			w_buf_3_1_write_n <= 0;
			//w_buf_4_0_write_n <= 0;
			idx_weight_3_1	<= SDRAM_RDVAL ? idx_weight_3_1 + 1'b1 : idx_weight_3_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_4_0 <`KERNEL_SIZE)
		begin
			w_buf_3_1_write_n <= 1;
			w_buf_4_0_write_n <= 0;
			//w_buf_4_1_write_n <= 0;
			idx_weight_4_0 <= SDRAM_RDVAL ? idx_weight_4_0 + 1'b1 : idx_weight_4_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_4_1 < `KERNEL_SIZE)
		begin
			w_buf_4_0_write_n <= 1;
			w_buf_4_1_write_n <= 0;
			//w_buf_5_0_write_n <= 0;
			idx_weight_4_1 <= SDRAM_RDVAL ? idx_weight_4_1 + 1'b1 : idx_weight_4_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_5_0 <`KERNEL_SIZE)
		begin
			w_buf_4_1_write_n <= 1;
			w_buf_5_0_write_n <= 0;
			//w_buf_5_1_write_n <= 0;
			idx_weight_5_0 <= SDRAM_RDVAL ? idx_weight_5_0 + 1'b1 : idx_weight_5_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_5_1 < `KERNEL_SIZE)
		begin
			w_buf_5_0_write_n <= 1;
			w_buf_5_1_write_n <= 0;
			//w_buf_6_0_write_n <= 0;
			idx_weight_5_1 <= SDRAM_RDVAL ? idx_weight_5_1 + 1'b1 : idx_weight_5_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_6_0 <`KERNEL_SIZE)
		begin
			w_buf_5_1_write_n <= 1;
			w_buf_6_0_write_n <= 0;
			//w_buf_6_1_write_n <= 0;
			idx_weight_6_0 <= SDRAM_RDVAL ? idx_weight_6_0 + 1'b1 : idx_weight_6_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_6_1 < `KERNEL_SIZE)
		begin
			w_buf_6_0_write_n <= 1;
			w_buf_6_1_write_n <= 0;
			//w_buf_7_0_write_n <= 0;
			idx_weight_6_1 <= SDRAM_RDVAL ? idx_weight_6_1 + 1'b1 : idx_weight_6_1;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_7_0 <`KERNEL_SIZE)
		begin
			w_buf_6_1_write_n <= 1;
			w_buf_7_0_write_n <= 0;
			//w_buf_7_1_write_n <= 0;
			idx_weight_7_0 <= SDRAM_RDVAL ? idx_weight_7_0 + 1'b1 : idx_weight_7_0;
			sdram_wbuf0_done <= 0;
		end
		else if (idx_weight_7_1 < `KERNEL_SIZE)
		begin
			w_buf_7_0_write_n <= 1;
			w_buf_7_1_write_n <= 0;
			idx_weight_7_1 <= SDRAM_RDVAL ? idx_weight_7_1 + 1'b1 : idx_weight_7_1;
			sdram_wbuf0_done <= 0;
		end		
		else
		begin
			/*idx_weight_0_0	<= 0;
			idx_weight_0_1	<= 0;
			idx_weight_1_0	<= 0;
			idx_weight_1_1	<= 0;
			idx_weight_2_0	<= 0;
			idx_weight_2_1	<= 0;
			idx_weight_3_0	<= 0;
			idx_weight_3_1	<= 0;
			idx_weight_4_0	<= 0;
			idx_weight_4_1	<= 0;
			idx_weight_5_0	<= 0;
			idx_weight_5_1	<= 0;
			idx_weight_6_0	<= 0;
			idx_weight_6_1	<= 0;
			idx_weight_7_0	<= 0;
			idx_weight_7_1	<= 0;*/
			
			w_buf_7_1_write_n	<= 1;
			
			sdram_wbuf0_done <= 1;
		end
	end
	`FROM_SDRAM_TO_OUTBUF:
	begin
		in_buf_0_write_n <= 1;
		in_buf_1_write_n <= 1;
		
		idx_weight_0_0	<= 0;
		idx_weight_0_1	<= 0;
		idx_weight_1_0	<= 0;
		idx_weight_1_1	<= 0;
		idx_weight_2_0	<= 0;
		idx_weight_2_1	<= 0;
		idx_weight_3_0	<= 0;
		idx_weight_3_1	<= 0;
		idx_weight_4_0	<= 0;
		idx_weight_4_1	<= 0;
		idx_weight_5_0	<= 0;
		idx_weight_5_1	<= 0;
		idx_weight_6_0	<= 0;
		idx_weight_6_1	<= 0;
		idx_weight_7_0	<= 0;
		idx_weight_7_1	<= 0;
	
		sdram_wbuf0_done <= 0;

		out_buf_0_p1_address <= SDRAM_RDVAL ? idx_out_0 : out_buf_0_p1_address;
		out_buf_0_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_0_p1_writedata;
		
		out_buf_1_p1_address <= SDRAM_RDVAL ? idx_out_1 : out_buf_1_p1_address;
		out_buf_1_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_1_p1_writedata;
		
		out_buf_2_p1_address <= SDRAM_RDVAL ? idx_out_2 : out_buf_2_p1_address;
		out_buf_2_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_2_p1_writedata;
		
		out_buf_3_p1_address  <= SDRAM_RDVAL ? idx_out_3 : out_buf_3_p1_address;
		out_buf_3_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_3_p1_writedata;	
	
		out_buf_4_p1_address  <= SDRAM_RDVAL ? idx_out_4 : out_buf_4_p1_address;
		out_buf_4_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_4_p1_writedata;
	
		out_buf_5_p1_address  <= SDRAM_RDVAL ? idx_out_5 : out_buf_5_p1_address;
		out_buf_5_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_5_p1_writedata;	
		
		out_buf_6_p1_address  <= SDRAM_RDVAL ? idx_out_6 : out_buf_6_p1_address;
		out_buf_6_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_6_p1_writedata;		
		
		out_buf_7_p1_address  <= SDRAM_RDVAL ? idx_out_7 : out_buf_7_p1_address;
		out_buf_7_p1_writedata <= SDRAM_RDVAL ? SDRAM_READDATA : out_buf_7_p1_writedata;		
		/*if (n == 0)
		begin
			sdram_outbuf0_done <= 1;
		end
		else*/
		if (idx_out_0 <`OFM_SIZE)
		begin
			out_buf_0_p1_write_n	 <= 0;
			//out_buf_1_p1_write_n	 <= 0;
			idx_out_0 <= SDRAM_RDVAL ? idx_out_0 + 1'b1 : idx_out_0;
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_1 < `OFM_SIZE)
		begin
			out_buf_0_p1_write_n	 <= 1;
			out_buf_1_p1_write_n	 <= 0;
			//out_buf_2_p1_write_n	 <= 0;
			idx_out_1 <= SDRAM_RDVAL ? idx_out_1 + 1'b1 : idx_out_1;
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_2 < `OFM_SIZE)
		begin
			out_buf_1_p1_write_n	 <= 1;
			out_buf_2_p1_write_n	 <= 0;
			//out_buf_3_p1_write_n	 <= 0;
			idx_out_2 <= SDRAM_RDVAL ? idx_out_2 + 1'b1 : idx_out_2;
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_3 < `OFM_SIZE)
		begin
			out_buf_2_p1_write_n	 <= 1;
			out_buf_3_p1_write_n	 <= 0;
			//out_buf_4_p1_write_n	 <= 0;
			idx_out_3 <= SDRAM_RDVAL ? idx_out_3 + 1'b1 : idx_out_3;
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_4 < `OFM_SIZE)
		begin
			out_buf_3_p1_write_n	 <= 1;
			out_buf_4_p1_write_n	 <= 0;
			//out_buf_5_p1_write_n	 <= 0;
			idx_out_4 <= SDRAM_RDVAL ? idx_out_4 + 1'b1 : idx_out_4;			
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_5 < `OFM_SIZE)
		begin
			out_buf_4_p1_write_n	 <= 1;
			out_buf_5_p1_write_n	 <= 0;
			//out_buf_6_p1_write_n	 <= 0;
			idx_out_5 <= SDRAM_RDVAL ? idx_out_5 + 1'b1 : idx_out_5;
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_6 < `OFM_SIZE)
		begin
			out_buf_5_p1_write_n	 <= 1;
			out_buf_6_p1_write_n	 <= 0;
			//out_buf_7_p1_write_n	 <= 0;
			idx_out_6 <= SDRAM_RDVAL ? idx_out_6 + 1'b1 : idx_out_6;
			sdram_outbuf0_done <= 0;
		end
		else if (idx_out_7 < `OFM_SIZE)
		begin
			out_buf_6_p1_write_n	 <= 1;
			out_buf_7_p1_write_n	 <= 0;
			idx_out_7 <= SDRAM_RDVAL ? idx_out_7 + 1'b1 : idx_out_7;			
			sdram_outbuf0_done <= 0;
		end
		else
		begin
			/*idx_out_0 <= 0;
			idx_out_1 <= 0;
			idx_out_2 <= 0;
			idx_out_3 <= 0;
			idx_out_4 <= 0;
			idx_out_5 <= 0;
			idx_out_6 <= 0;
			idx_out_7 <= 0;*/
			
			out_buf_7_p1_write_n	 <= 1;
			
			sdram_outbuf0_done <= 1;
		end
	end
	`CONV_READ_STATE:
	begin
		idx_out_0 <= 0;
		idx_out_1 <= 0;
		idx_out_2 <= 0;
		idx_out_3 <= 0;
		idx_out_4 <= 0;
		idx_out_5 <= 0;
		idx_out_6 <= 0;
		idx_out_7 <= 0;
		
		sdram_outbuf0_done	<= 0;
		
		in_buf_0_read_n <= conv_in_buf_0_read_n;
		in_buf_0_address <= conv_in_buf_0_address;
		conv_in_buf_0_readdata <= in_buf_0_readdata;

		in_buf_1_read_n <= conv_in_buf_1_read_n;
		in_buf_1_address <= conv_in_buf_1_address;
		conv_in_buf_1_readdata <= in_buf_1_readdata;

		w_buf_0_0_read_n <= conv_w_buf_0_0_read_n;
		w_buf_0_0_address <= conv_w_buf_0_0_address;
		conv_w_buf_0_0_readdata <= w_buf_0_0_readdata;

		w_buf_0_1_read_n <= conv_w_buf_0_1_read_n;
		w_buf_0_1_address <= conv_w_buf_0_1_address;
		conv_w_buf_0_1_readdata <= w_buf_0_1_readdata;

		w_buf_1_0_read_n <= conv_w_buf_1_0_read_n;
		w_buf_1_0_address <= conv_w_buf_1_0_address;
		conv_w_buf_1_0_readdata <= w_buf_1_0_readdata;

		w_buf_1_1_read_n <= conv_w_buf_1_1_read_n;
		w_buf_1_1_address <= conv_w_buf_1_1_address;
		conv_w_buf_1_1_readdata <= w_buf_1_1_readdata;

		w_buf_2_0_read_n <= conv_w_buf_2_0_read_n;
		w_buf_2_0_address <= conv_w_buf_2_0_address;
		conv_w_buf_2_0_readdata <= w_buf_2_0_readdata;

		w_buf_2_1_read_n <= conv_w_buf_2_1_read_n;
		w_buf_2_1_address <= conv_w_buf_2_1_address;
		conv_w_buf_2_1_readdata <= w_buf_2_1_readdata;

		w_buf_3_0_read_n <= conv_w_buf_3_0_read_n;
		w_buf_3_0_address <= conv_w_buf_3_0_address;
		conv_w_buf_3_0_readdata <= w_buf_3_0_readdata;

		w_buf_3_1_read_n <= conv_w_buf_3_1_read_n;
		w_buf_3_1_address <= conv_w_buf_3_1_address;
		conv_w_buf_3_1_readdata <= w_buf_3_1_readdata;

		w_buf_4_0_read_n <= conv_w_buf_4_0_read_n;
		w_buf_4_0_address <= conv_w_buf_4_0_address;
		conv_w_buf_4_0_readdata <= w_buf_4_0_readdata;

		w_buf_4_1_read_n <= conv_w_buf_4_1_read_n;
		w_buf_4_1_address <= conv_w_buf_4_1_address;
		conv_w_buf_4_1_readdata <= w_buf_4_1_readdata;

		w_buf_5_0_read_n <= conv_w_buf_5_0_read_n;
		w_buf_5_0_address <= conv_w_buf_5_0_address;
		conv_w_buf_5_0_readdata <= w_buf_5_0_readdata;

		w_buf_5_1_read_n <= conv_w_buf_5_1_read_n;
		w_buf_5_1_address <= conv_w_buf_5_1_address;
		conv_w_buf_5_1_readdata <= w_buf_5_1_readdata;

		w_buf_6_0_read_n <= conv_w_buf_6_0_read_n;
		w_buf_6_0_address <= conv_w_buf_6_0_address;
		conv_w_buf_6_0_readdata <= w_buf_6_0_readdata;

		w_buf_6_1_read_n <= conv_w_buf_6_1_read_n;
		w_buf_6_1_address <= conv_w_buf_6_1_address;
		conv_w_buf_6_1_readdata <= w_buf_6_1_readdata;

		w_buf_7_0_read_n <= conv_w_buf_7_0_read_n;
		w_buf_7_0_address <= conv_w_buf_7_0_address;
		conv_w_buf_7_0_readdata <= w_buf_7_0_readdata;

		w_buf_7_1_read_n <= conv_w_buf_7_1_read_n;
		w_buf_7_1_address <= conv_w_buf_7_1_address;
		conv_w_buf_7_1_readdata <= w_buf_7_1_readdata;

		out_buf_0_p1_read_n <= conv_out_buf_0_p1_read_n;
		out_buf_0_p1_address <= conv_out_buf_0_p1_address;
		conv_out_buf_0_p1_readdata <= out_buf_0_p1_readdata;

		out_buf_1_p1_read_n <= conv_out_buf_1_p1_read_n;
		out_buf_1_p1_address <= conv_out_buf_1_p1_address;
		conv_out_buf_1_p1_readdata <= out_buf_1_p1_readdata;

		out_buf_2_p1_read_n <= conv_out_buf_2_p1_read_n;
		out_buf_2_p1_address <= conv_out_buf_2_p1_address;
		conv_out_buf_2_p1_readdata <= out_buf_2_p1_readdata;

		out_buf_3_p1_read_n <= conv_out_buf_3_p1_read_n;
		out_buf_3_p1_address <= conv_out_buf_3_p1_address;
		conv_out_buf_3_p1_readdata <= out_buf_3_p1_readdata;

		out_buf_4_p1_read_n <= conv_out_buf_4_p1_read_n;
		out_buf_4_p1_address <= conv_out_buf_4_p1_address;
		conv_out_buf_4_p1_readdata <= out_buf_4_p1_readdata;

		out_buf_5_p1_read_n <= conv_out_buf_5_p1_read_n;
		out_buf_5_p1_address <= conv_out_buf_5_p1_address;
		conv_out_buf_5_p1_readdata <= out_buf_5_p1_readdata;

		out_buf_6_p1_read_n <= conv_out_buf_6_p1_read_n;
		out_buf_6_p1_address <= conv_out_buf_6_p1_address;
		conv_out_buf_6_p1_readdata <= out_buf_6_p1_readdata;

		out_buf_7_p1_read_n <= conv_out_buf_7_p1_read_n;
		out_buf_7_p1_address <= conv_out_buf_7_p1_address;
		conv_out_buf_7_p1_readdata <= out_buf_7_p1_readdata;

		out_buf_0_p2_write_n <= conv_out_buf_0_p2_write_n;
		out_buf_0_p2_address <= conv_out_buf_0_p2_address;
		out_buf_0_p2_writedata <= conv_out_buf_0_p2_writedata;

		out_buf_1_p2_write_n <= conv_out_buf_1_p2_write_n;
		out_buf_1_p2_address <= conv_out_buf_1_p2_address;
		out_buf_1_p2_writedata <= conv_out_buf_1_p2_writedata;

		out_buf_2_p2_write_n <= conv_out_buf_2_p2_write_n;
		out_buf_2_p2_address <= conv_out_buf_2_p2_address;
		out_buf_2_p2_writedata <= conv_out_buf_2_p2_writedata;

		out_buf_3_p2_write_n <= conv_out_buf_3_p2_write_n;
		out_buf_3_p2_address <= conv_out_buf_3_p2_address;
		out_buf_3_p2_writedata <= conv_out_buf_3_p2_writedata;

		out_buf_4_p2_write_n <= conv_out_buf_4_p2_write_n;
		out_buf_4_p2_address <= conv_out_buf_4_p2_address;
		out_buf_4_p2_writedata <= conv_out_buf_4_p2_writedata;

		out_buf_5_p2_write_n <= conv_out_buf_5_p2_write_n;
		out_buf_5_p2_address <= conv_out_buf_5_p2_address;
		out_buf_5_p2_writedata <= conv_out_buf_5_p2_writedata;

		out_buf_6_p2_write_n <= conv_out_buf_6_p2_write_n;
		out_buf_6_p2_address <= conv_out_buf_6_p2_address;
		out_buf_6_p2_writedata <= conv_out_buf_6_p2_writedata;

		out_buf_7_p2_write_n <= conv_out_buf_7_p2_write_n;
		out_buf_7_p2_address <= conv_out_buf_7_p2_address;
		out_buf_7_p2_writedata <= conv_out_buf_7_p2_writedata;
	end
	`FROM_OFM_TO_SDRAM:
	begin
		in_buf_0_read_n       <= 1;
		in_buf_0_write_n		 <= 1;
		
		in_buf_1_read_n		 <= 1;
		in_buf_1_write_n		 <= 1;
		
		out_buf_0_p1_read_n	 <= ow_out_buf_0_p1_read_n;
		out_buf_0_p1_address  <= ow_out_buf_0_p1_address;
		
		out_buf_1_p1_read_n	 <= ow_out_buf_1_p1_read_n;
		out_buf_1_p1_address  <= ow_out_buf_1_p1_address;

		out_buf_2_p1_read_n	 <= ow_out_buf_2_p1_read_n;
		out_buf_2_p1_address  <= ow_out_buf_2_p1_address;

		out_buf_3_p1_read_n	 <= ow_out_buf_3_p1_read_n;
		out_buf_3_p1_address  <= ow_out_buf_3_p1_address;

		out_buf_4_p1_read_n	 <= ow_out_buf_4_p1_read_n;
		out_buf_4_p1_address  <= ow_out_buf_4_p1_address;

		out_buf_5_p1_read_n	 <= ow_out_buf_5_p1_read_n;
		out_buf_5_p1_address  <= ow_out_buf_5_p1_address;

		out_buf_6_p1_read_n	 <= ow_out_buf_6_p1_read_n;
		out_buf_6_p1_address  <= ow_out_buf_6_p1_address;		
		
		out_buf_7_p1_read_n	 <= ow_out_buf_7_p1_read_n;
		out_buf_7_p1_address  <= ow_out_buf_7_p1_address;
	end
	`WAIT_FOR_DEBUG:
	begin
		in_buf_0_read_n <= 1;
		in_buf_0_write_n <= 1;
		
		in_buf_1_read_n <= 1;
		in_buf_1_write_n <= 1;

		out_buf_0_p1_read_n <= 1;
		out_buf_0_p1_write_n	<= 1;
		
		out_buf_0_p2_read_n <= 1;
		out_buf_0_p2_write_n <= 1;
		
		out_buf_1_p1_read_n <= 1;
		out_buf_1_p1_write_n	<= 1;
		
		out_buf_1_p2_read_n <= 1;
		out_buf_1_p2_write_n <= 1;
		
		out_buf_2_p1_read_n <= 1;
		out_buf_2_p1_write_n	<= 1;
		
		out_buf_2_p2_read_n <= 1;
		out_buf_2_p2_write_n <= 1;
		
		out_buf_3_p1_read_n <= 1;
		out_buf_3_p1_write_n	<= 1;
		
		out_buf_3_p2_read_n <= 1;
		out_buf_3_p2_write_n <= 1;

		out_buf_4_p1_read_n <= 1;
		out_buf_4_p1_write_n	<= 1;
		
		out_buf_4_p2_read_n <= 1;
		out_buf_4_p2_write_n <= 1;

		out_buf_5_p1_read_n <= 1;
		out_buf_5_p1_write_n	<= 1;
		
		out_buf_5_p2_read_n <= 1;
		out_buf_5_p2_write_n <= 1;

		out_buf_6_p1_read_n <= 1;
		out_buf_6_p1_write_n	<= 1;
	
		out_buf_6_p2_read_n <= 1;
		out_buf_6_p2_write_n <= 1;
		
		out_buf_7_p1_read_n <= 1;
		out_buf_7_p1_write_n	<= 1;
		
		out_buf_7_p2_read_n <= 1;
		out_buf_7_p2_write_n <= 1;
		
		w_buf_0_0_read_n <= 1;
		w_buf_0_0_write_n <= 1;
		
		w_buf_0_1_read_n <= 1;
		w_buf_0_1_write_n <= 1;
		
		w_buf_1_0_read_n <= 1;
		w_buf_1_0_write_n <= 1;
		
		w_buf_1_1_read_n <= 1;
		w_buf_1_1_write_n <= 1;
		
		w_buf_2_0_read_n <= 1;
		w_buf_2_0_write_n <= 1;
		
		w_buf_2_1_read_n <= 1;
		w_buf_2_1_write_n <= 1;
		
		w_buf_3_0_read_n <= 1;
		w_buf_3_0_write_n <= 1;
		
		w_buf_3_1_read_n <= 1;
		w_buf_3_1_write_n <= 1;

		w_buf_4_0_read_n <= 1;
		w_buf_4_0_write_n <= 1;
		
		w_buf_4_1_read_n <= 1;
		w_buf_4_1_write_n <= 1;

		w_buf_5_0_read_n <= 1;
		w_buf_5_0_write_n <= 1;
		
		w_buf_5_1_read_n <= 1;
		w_buf_5_1_write_n <= 1;

		w_buf_6_0_read_n <= 1;
		w_buf_6_0_write_n <= 1;
		
		w_buf_6_1_read_n <= 1;
		w_buf_6_1_write_n <= 1;

		w_buf_7_0_read_n <= 1;
		w_buf_7_0_write_n <= 1;
		
		w_buf_7_1_read_n <= 1;
		w_buf_7_1_write_n <= 1;
	end
	default:
	begin
		in_buf_0_read_n <= 1;
		in_buf_0_write_n <= 1;
		
		in_buf_1_read_n <= 1;
		in_buf_1_write_n <= 1;
		
		sdram_inbuf0_done <= 0;
		sdram_wbuf0_done <= 0;
	end
	endcase
end
endmodule
