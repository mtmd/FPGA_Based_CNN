`ifndef _read_states_vh_
`define _read_states_vh_

`define NUM_RD_ST_W 3

`define IDLE 	 						0
`define FROM_SDRAM_TO_OUTBUF 	 	1
`define FROM_SDRAM_TO_INBUF_0  	2
`define FROM_SDRAM_TO_WBUF_0 	 	3
`define CONV_READ_STATE				4
`define FROM_OFM_TO_SDRAM			5
`define WAIT_FOR_DEBUG				6

`endif