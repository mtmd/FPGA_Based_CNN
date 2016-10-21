`ifndef _main_states_vh_
`define _main_states_vh_

`define NUM_STATES_W 4

`define WAIT_FOR_CC				  	4'd0
`define DEBUG  						4'd1

`define INIT_LOAD_OFM  				4'd2
`define LOAD_OFM  					4'd3

`define INIT_LOAD_IFM  				4'd4
`define LOAD_IFM  					4'd5

`define INIT_LOAD_WEIGHT  			4'd6
`define LOAD_WEIGHT  				4'd7

`define DONE  							4'd8

`define INIT_CONV						4'd9
`define CONV							4'd10

`define LOOP_CTRL						4'd11

`define INIT_WRITE_BACK				4'd12
`define WRITE_BACK					4'd13

`endif


