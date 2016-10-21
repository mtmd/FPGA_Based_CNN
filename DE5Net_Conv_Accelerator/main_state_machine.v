module main_state_machine (
input clk,
input reset_n,

input [7:0] from_cc,
output reg [7:0] msg,

input conv_done, 
input sdram_inbuf0_done,
input sdram_wbuf0_done, 
input sdram_outbuf0_done,
input outbuf0_sdram_done, 

output reg [`NUM_STATES_W - 1 : 0] state = 0,
output reg [`NUM_RD_ST_W - 1 : 0] read_state = 0,

output reg [`M_IDX_SZ - 1 : 0] m = 0,
output reg [`N_IDX_SZ - 1 : 0] n = 0
);
reg [`NUM_STATES_W - 1 : 0] next_state_debug;
reg [7:0] 	from_cc_latch = 0;

initial
begin
	m = 0;
	n = 0;
end

always @ (posedge clk)
begin
	from_cc_latch <= from_cc;
	
	if(!reset_n) begin
		state <= `WAIT_FOR_CC;
		read_state <= `IDLE;
		m <= 0;
		n <= 0;
	end
	else begin
		case (state)
			`WAIT_FOR_CC: 
			begin
				state <= (from_cc_latch == `START)	? `INIT_LOAD_IFM : `WAIT_FOR_CC;
				read_state <= `IDLE;
			end
			
			//IFMs
			`INIT_LOAD_IFM: 
			begin
				state <= `LOAD_IFM;			
				read_state <= `FROM_SDRAM_TO_INBUF_0;
			end
			`LOAD_IFM: 
			begin
				state <= sdram_inbuf0_done	? `DEBUG : `LOAD_IFM;
				read_state <= `FROM_SDRAM_TO_INBUF_0;
				msg <= `CHECK_IFM;
			end
			
			//Weights
			`INIT_LOAD_WEIGHT: 
			begin
				state <= `LOAD_WEIGHT;
				read_state <= `FROM_SDRAM_TO_WBUF_0;
			end
			`LOAD_WEIGHT:
			begin
				state <= sdram_wbuf0_done ? `DEBUG : `LOAD_WEIGHT;
				read_state <= `FROM_SDRAM_TO_WBUF_0;
				msg <= `CHECK_WEIGHT;
			end
			
			//OFMs
			`INIT_LOAD_OFM: 
			begin
				state <= `LOAD_OFM;
				read_state <= `FROM_SDRAM_TO_OUTBUF;
			end
			`LOAD_OFM: 
			begin
				state <= sdram_outbuf0_done ? `DEBUG : `LOAD_OFM;
				read_state <= `FROM_SDRAM_TO_OUTBUF;
				msg <= `CHECK_OFM;
			end
			
			//Convolution
			`INIT_CONV:	
			begin
				state <= `CONV;
				read_state <= `CONV_READ_STATE;
			end
			`CONV: 
			begin
				state <= conv_done ? `DEBUG : `CONV;
				read_state <= `CONV_READ_STATE;
				msg <= `CHECK_RESULT;
			end
			
			//Write back
			`INIT_WRITE_BACK: 
			begin
				state <= `WRITE_BACK;
				read_state <= `FROM_OFM_TO_SDRAM;
			end
			`WRITE_BACK:
			begin
				state <= outbuf0_sdram_done ? `DEBUG : `WRITE_BACK;
				read_state <= `FROM_OFM_TO_SDRAM;
				msg <= `CHECK_WB;
			end
			
			`LOOP_CTRL: 
			begin
				if (m < (`M - `Tm))
				begin
					m <= m + `Tm;
					state <= `INIT_LOAD_WEIGHT;
				end	
				else if (n < (`N - `Tn))
				begin
					n <= n + `Tn;
					m <= 0;
					state <= `INIT_LOAD_IFM;
				end
				else
				begin
					state <= `DONE;
				end	
			end
			
			`DEBUG: 
			begin
				state <= (from_cc_latch == msg) ? next_state_debug : `DEBUG;
				read_state <= `WAIT_FOR_DEBUG;
			end
			
			`DONE: state <= `WAIT_FOR_CC;
			
			default:
			begin
				state <= state;
				read_state <= read_state;
			end
		endcase
	end
end


always @ (posedge clk)
begin
	case (state)
		`INIT_LOAD_IFM: next_state_debug <= `INIT_LOAD_WEIGHT;
		`LOAD_IFM: next_state_debug <= `INIT_LOAD_WEIGHT;
		
		`INIT_LOAD_WEIGHT: next_state_debug <= `INIT_LOAD_OFM;
		`LOAD_WEIGHT: next_state_debug <= `INIT_LOAD_OFM;		
		
		`INIT_LOAD_OFM: next_state_debug <= `INIT_CONV;
		`LOAD_OFM: next_state_debug <= `INIT_CONV;
		
		`INIT_CONV: next_state_debug <= `INIT_WRITE_BACK;
		`CONV: next_state_debug <= `INIT_WRITE_BACK;
		
		`INIT_WRITE_BACK: next_state_debug <= `LOOP_CTRL;
		`WRITE_BACK: next_state_debug <= `LOOP_CTRL;
		
		default: next_state_debug <= next_state_debug;
	endcase
end

endmodule