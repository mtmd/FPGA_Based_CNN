module ifm_loader (
input clk,
output reg SDRAM_RE_N =	1,
output reg [`RAM_ADR_W - 1 : 0] SDRAM_ADDR,
input SDRAM_WAIT,
input enable,
input [`N_IDX_SZ - 1 : 0] n
);
localparam IDLE 		= 1'b0;
localparam IFM_LD		= 1'b1;

reg 		  state = 0;

reg [`RAM_ADR_W - 1 : 0] k = 0;
reg [`RAM_ADR_W - 1 : 0] offset = 0;

always @ (posedge clk)
begin
	case (state)
	IDLE: 
	begin
		state <= enable ? IFM_LD : IDLE;
		k 	<= 0;
		offset <= `img_base + (n) * `IFM_SIZE;
	end
	IFM_LD:
	begin
		state <= (k == (`IFM_SIZE * `Tn)) ? IDLE : IFM_LD;
		k <= (SDRAM_WAIT == 0) ? k + 1'b1 : k;	
	end
	endcase
end
always @ (*)
begin
	case (state)
		IDLE:
		begin
			SDRAM_RE_N <= 1;
			SDRAM_ADDR <= 0;
		end
		IFM_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset + k;
		end
	endcase
end
endmodule