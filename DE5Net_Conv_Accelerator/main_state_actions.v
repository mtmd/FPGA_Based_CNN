module main_state_actions (
input clk,

output reg sdram_we_n = 1,
output reg sdram_re_n = 1,
input SDRAM_WAIT, 
output reg [`DATA_WIDTH - 1 : 0] sdram_writedata,
output reg sdram_chipselect,
output reg [`RAM_ADR_W - 1 : 0] sdram_addr = 0,

input ol_SDRAM_RE_N,
input [`RAM_ADR_W - 1 : 0] ol_SDRAM_ADDR,
output reg ol_en = 0,

input il_SDRAM_RE_N,
input [`RAM_ADR_W - 1 : 0] il_SDRAM_ADDR,
output reg il_en = 0,
 
input wl_SDRAM_RE_N,
input [`RAM_ADR_W - 1 : 0] wl_SDRAM_ADDR,
output reg wl_en = 0,

input [`NUM_STATES_W - 1 : 0] state,

input [7:0] msg,

output reg [7:0] to_cc = 0, 

output reg conv_en = 0,

output reg ow_en = 0,
input ow_sdram_write_n,
input [`DATA_WIDTH - 1 : 0] ow_sdram_writedata,
input	[`RAM_ADR_W - 1 : 0] ow_sdram_address
);

always @ (*)
begin
	case (state)
		`WAIT_FOR_CC:
		begin
			sdram_re_n <= 1;
			sdram_we_n <= 1;
			sdram_addr <= 0;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b0;
			
			to_cc <= 0;
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;
		end
		`DEBUG: 
		begin
			sdram_re_n <= 1;
			sdram_we_n <= 1;
			sdram_addr <= 0;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b0;
			
			to_cc <= msg;
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;			
		end
		`INIT_LOAD_OFM:
		begin
			sdram_re_n <= ol_SDRAM_RE_N;
			sdram_we_n <= 1;
			sdram_addr <= ol_SDRAM_ADDR;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;	
		
			il_en <= 1'b0;
			ol_en <= 1'b1;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;		
		end
		`LOAD_OFM:
		begin
			sdram_re_n <= ol_SDRAM_RE_N;
			sdram_we_n <= 1;
			sdram_addr <= ol_SDRAM_ADDR;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;

			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;			
		end
		`INIT_LOAD_IFM:
		begin
			sdram_re_n <= il_SDRAM_RE_N;
			sdram_we_n <= 1;
			sdram_addr <= il_SDRAM_ADDR;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;

			il_en <= 1'b1;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;			
		end
		`LOAD_IFM:
		begin
			sdram_re_n <= il_SDRAM_RE_N;
			sdram_we_n <= 1;
			sdram_addr <= il_SDRAM_ADDR;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;			
		end
		`INIT_LOAD_WEIGHT:
		begin
			sdram_re_n <= wl_SDRAM_RE_N;
			sdram_we_n <= 1;
			sdram_addr <= wl_SDRAM_ADDR;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;	

			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b1;
			conv_en <= 1'b0;
			ow_en <= 1'b0;			
		end
		`LOAD_WEIGHT:
		begin
			sdram_re_n <= wl_SDRAM_RE_N;
			sdram_we_n <= 1;
			sdram_addr <= wl_SDRAM_ADDR;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;			
		end
		`INIT_CONV:
		begin
			sdram_re_n <= 1'b1;
			sdram_we_n <= 1'b1;
			sdram_addr <= 1'b0;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b0;
			
			to_cc <= 0;			
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b1;
			ow_en <= 1'b0;		
		end
		`CONV:
		begin
			sdram_re_n <= 1'b1;
			sdram_we_n <= 1'b1;
			sdram_addr <= 1'b0;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b0;
			
			to_cc <= 0;			
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;				
		end
		`INIT_WRITE_BACK:
		begin
			sdram_re_n <= 1;
			sdram_we_n <= ow_sdram_write_n;
			sdram_addr <= ow_sdram_address;
			sdram_writedata <= ow_sdram_writedata;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;		
		
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b1;				
		end
		`WRITE_BACK:
		begin
			sdram_re_n <= 1;
			sdram_we_n <= ow_sdram_write_n;
			sdram_addr <= ow_sdram_address;
			sdram_writedata <= ow_sdram_writedata;
			sdram_chipselect <= 1'b1;
			
			to_cc <= 0;
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;					
		end
		default:
		begin
			sdram_re_n <= 1'b1;
			sdram_we_n <= 1'b1;
			sdram_addr <= 1'b0;
			sdram_writedata <= 1'b0;
			sdram_chipselect <= 1'b0;
			
			to_cc <= 0;
			
			il_en <= 1'b0;
			ol_en <= 1'b0;
			wl_en <= 1'b0;
			conv_en <= 1'b0;
			ow_en <= 1'b0;					
		end
	endcase
end
endmodule