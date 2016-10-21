module ofm_loader (
input clk,
output reg SDRAM_RE_N =	1,
output reg [`RAM_ADR_W - 1 : 0] SDRAM_ADDR  =  0,
input	SDRAM_WAIT,
input enable,
input [`M_IDX_SZ - 1 : 0] m,
input [`N_IDX_SZ - 1 : 0] n
);
localparam IDLE = 1'b0;
localparam OFM_LD = 1'b1;

reg state = 0;

reg [`RAM_ADR_W - 1 : 0] k = 0;
reg [`RAM_ADR_W - 1 : 0] offset = 0;

always @ (posedge clk)
begin
	case (state)
	IDLE: 
	begin
		state <= (enable /*&& n > 0*/) ? OFM_LD : IDLE;
		k <= 0;
		offset <= `out_base + m * `OFM_SIZE;
	end
	OFM_LD:
	begin
		state <= (k == (`OFM_SIZE * `Tm)) ? IDLE : OFM_LD;
		k <= (SDRAM_WAIT == 0) ? k + 1'b1 : k;			
	end
	endcase
end

always @ (*)
begin
	SDRAM_ADDR <= offset + k;
	case (state)
		IDLE:
		begin
			SDRAM_RE_N <= 1;
		end
		OFM_LD:
		begin
			SDRAM_RE_N <= 0;
		end
	endcase
end
endmodule