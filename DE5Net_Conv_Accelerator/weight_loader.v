module weight_loader (
input clk,
output reg SDRAM_RE_N	=	1,
output reg [`RAM_ADR_W - 1 : 0] SDRAM_ADDR  =  0,
input SDRAM_WAIT,
input enable,
input [`M_IDX_SZ - 1 : 0] m,
input [`N_IDX_SZ - 1 : 0] n
);
localparam IDLE 		= 0;
localparam W0_LD		= 1;
localparam W1_LD		= 2;
localparam W2_LD		= 3;
localparam W3_LD		= 4;
localparam W4_LD		= 5;
localparam W5_LD		= 6;
localparam W6_LD		= 7;
localparam W7_LD		= 8;

reg [3:0]  state = 0;

reg [`WGHT_CNTR_W - 1 : 0] k0 = 0;
reg [`WGHT_CNTR_W - 1 : 0] k1 = 0;
reg [`WGHT_CNTR_W - 1 : 0] k2 = 0;
reg [`WGHT_CNTR_W - 1 : 0] k3 = 0; 
reg [`WGHT_CNTR_W - 1 : 0] k4 = 0;
reg [`WGHT_CNTR_W - 1 : 0] k5 = 0;
reg [`WGHT_CNTR_W - 1 : 0] k6 = 0;
reg [`WGHT_CNTR_W - 1 : 0] k7 = 0; 

reg [`RAM_ADR_W - 1 : 0] partial_offset = 0;

reg [`RAM_ADR_W - 1 : 0] offset0 = 0;
reg [`RAM_ADR_W - 1 : 0] offset1 = 0;
reg [`RAM_ADR_W - 1 : 0] offset2 = 0;
reg [`RAM_ADR_W - 1 : 0] offset3 = 0;
reg [`RAM_ADR_W - 1 : 0] offset4 = 0;
reg [`RAM_ADR_W - 1 : 0] offset5 = 0;
reg [`RAM_ADR_W - 1 : 0] offset6 = 0;
reg [`RAM_ADR_W - 1 : 0] offset7 = 0;

always @ (posedge clk)
begin
	case (state)
	IDLE: 
	begin
		state <= enable ? W0_LD : IDLE;
		
		partial_offset <= n * `KERNEL_SIZE;
		
		offset0 <= `weight_base + (m + 8'd0) * (`KERNEL_SIZE * `N) + partial_offset;
		offset1 <= `weight_base + (m + 8'd1) * (`KERNEL_SIZE * `N) + partial_offset;
		offset2 <= `weight_base + (m + 8'd2) * (`KERNEL_SIZE * `N) + partial_offset;
		offset3 <= `weight_base + (m + 8'd3) * (`KERNEL_SIZE * `N) + partial_offset;
		offset4 <= `weight_base + (m + 8'd4) * (`KERNEL_SIZE * `N) + partial_offset;
		offset5 <= `weight_base + (m + 8'd5) * (`KERNEL_SIZE * `N) + partial_offset;
		offset6 <= `weight_base + (m + 8'd6) * (`KERNEL_SIZE * `N) + partial_offset;
		offset7 <= `weight_base + (m + 8'd7) * (`KERNEL_SIZE * `N) + partial_offset;
	
		k0 	<= 0;
		k1		<= 0;
		k2		<= 0;
		k3		<= 0;
		k4 	<= 0;
		k5		<= 0;
		k6		<= 0;
		k7		<= 0;		
	end
	W0_LD:
	begin
		state <= ((k0 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W0_LD : W1_LD;
		k0 <= (SDRAM_WAIT == 0) ? k0 + 1'b1 : k0;	
	end
	W1_LD:
	begin
		state <= ((k1 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W1_LD : W2_LD;
		k1 <= (SDRAM_WAIT == 0) ? k1 + 1'b1 : k1;	
	end
	W2_LD:
	begin
		state <= ((k2 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W2_LD : W3_LD;
		k2 <= (SDRAM_WAIT == 0) ? k2 + 1'b1 : k2;	
	end
	W3_LD:
	begin
		state <= ((k3 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W3_LD : W4_LD;
		k3 <= (SDRAM_WAIT == 0) ? k3 + 1'b1 : k3;	
	end
	W4_LD:
	begin
		state <= ((k4 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W4_LD : W5_LD;
		k4 <= (SDRAM_WAIT == 0) ? k4 + 1'b1 : k4;	
	end
	W5_LD:
	begin
		state <= ((k5 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W5_LD : W6_LD;
		k5 <= (SDRAM_WAIT == 0) ? k5 + 1'b1 : k5;	
	end
	W6_LD:
	begin
		state <= ((k6 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W6_LD : W7_LD;
		k6 <= (SDRAM_WAIT == 0) ? k6 + 1'b1 : k6;	
	end
	W7_LD:
	begin
		state <= ((k7 < ((`KERNEL_SIZE * `Tn - 1))) || (SDRAM_WAIT == 1)) 
					? W7_LD : IDLE;
		k7 <= (SDRAM_WAIT == 0) ? k7 + 1'b1 : k7;	
	end
	endcase
end

always @ (*)
begin
	case (state)
		IDLE:
		begin
			SDRAM_RE_N <= 1;
			SDRAM_ADDR <= offset0 + k0;
		end
		W0_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset0 + k0;
		end
		W1_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset1 + k1;
		end
		W2_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset2 + k2;
		end
		W3_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset3 + k3;
		end
		W4_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset4 + k4;
		end
		W5_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset5 + k5;
		end
		W6_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset6 + k6;
		end
		W7_LD:
		begin
			SDRAM_RE_N <= 0;
			SDRAM_ADDR <= offset7 + k7;
		end
	endcase
end
endmodule