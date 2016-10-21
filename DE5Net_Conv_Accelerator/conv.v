module conv (
// Global signals
	input clk,

// Input buffers: read
	output     in_buf_0_read_n = 1,
	output     [`IFM_ADR_W - 1 : 0] in_buf_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] in_buf_0_readdata,

	output     in_buf_1_read_n = 1,
	output     [`IFM_ADR_W - 1 : 0] in_buf_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] in_buf_1_readdata,

// Weight buffers: read
	output     w_buf_0_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_0_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_0_0_readdata,

	output     w_buf_0_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_0_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_0_1_readdata,

	output     w_buf_1_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_1_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_1_0_readdata,

	output     w_buf_1_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_1_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_1_1_readdata,

	output     w_buf_2_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_2_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_2_0_readdata,

	output     w_buf_2_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_2_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_2_1_readdata,

	output     w_buf_3_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_3_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_3_0_readdata,

	output     w_buf_3_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_3_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_3_1_readdata,

	output     w_buf_4_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_4_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_4_0_readdata,

	output     w_buf_4_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_4_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_4_1_readdata,

	output     w_buf_5_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_5_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_5_0_readdata,

	output     w_buf_5_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_5_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_5_1_readdata,

	output     w_buf_6_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_6_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_6_0_readdata,

	output     w_buf_6_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_6_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_6_1_readdata,

	output     w_buf_7_0_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_7_0_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_7_0_readdata,

	output     w_buf_7_1_read_n = 1,
	output     [`WGHT_ADR_W - 1 : 0] w_buf_7_1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] w_buf_7_1_readdata,

// Output buffers, port 1: read
	output     out_buf_0_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_0_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_0_p1_readdata,

	output     out_buf_1_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_1_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_1_p1_readdata,

	output     out_buf_2_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_2_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_2_p1_readdata,

	output     out_buf_3_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_3_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_3_p1_readdata,

	output     out_buf_4_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_4_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_4_p1_readdata,

	output     out_buf_5_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_5_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_5_p1_readdata,

	output     out_buf_6_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_6_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_6_p1_readdata,

	output     out_buf_7_p1_read_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_7_p1_address = 0,
	input      [`DATA_WIDTH - 1 : 0] out_buf_7_p1_readdata,

// Output buffers, port 2: write
	output     out_buf_0_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_0_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_0_p2_writedata = 0,

	output     out_buf_1_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_1_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_1_p2_writedata = 0,

	output     out_buf_2_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_2_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_2_p2_writedata = 0,

	output     out_buf_3_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_3_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_3_p2_writedata = 0,

	output     out_buf_4_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_4_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_4_p2_writedata = 0,

	output     out_buf_5_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_5_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_5_p2_writedata = 0,

	output     out_buf_6_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_6_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_6_p2_writedata = 0,

	output     out_buf_7_p2_write_n = 1,
	output     [`OFM_ADR_W - 1 : 0] out_buf_7_p2_address = 0,
	output  [`DATA_WIDTH - 1 : 0] out_buf_7_p2_writedata = 0,

// Handshake signals
	output  done = 0, 
	input enable,
	input [`N_IDX_SZ - 1 : 0] n
);

// Parameters
	localparam IDLE 		= 0;
	localparam BUSY 		= 1;

// State Machine signals
	reg state = 0;
	reg rd_enable1;
	reg rd_enable2;
	wire wr_enable;
	reg rd_enable2_prev1;	
	reg rd_enable2_prev2;
	
	reg [7:0] w = 0;
	reg [7:0] h = 0;
	reg [7:0] i = 0;
	reg [7:0] j = 0;
	reg [7:0] pipe_delay = 0;

	reg inc_h = 0;
	reg inc_w = 0;
	reg inc_i = 0;
	reg inc_j = 0;
	wire waiting;

// Covolution registers
	reg [`IFM_ADR_W - 1 : 0] ifm_addr = 0;
	reg [`WGHT_ADR_W - 1: 0] wght_addr = 0;
	reg [`OFM_ADR_W - 1 : 0] ofm_addr = 0;
	
	reg [`DATA_WIDTH - 1 : 0] out_partial_0_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_0_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_1_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_1_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_2_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_2_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_3_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_3_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_4_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_4_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_5_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_5_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_6_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_6_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_7_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] out_partial_7_1 = 0;
	
	wire [`DATA_WIDTH - 1 : 0] ofm_0;
	wire [`DATA_WIDTH - 1 : 0] ofm_1;
	wire [`DATA_WIDTH - 1 : 0] ofm_2;
	wire [`DATA_WIDTH - 1 : 0] ofm_3;
	wire [`DATA_WIDTH - 1 : 0] ofm_4;
	wire [`DATA_WIDTH - 1 : 0] ofm_5;
	wire [`DATA_WIDTH - 1 : 0] ofm_6;
	wire [`DATA_WIDTH - 1 : 0] ofm_7;
	
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_2 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_3 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_4 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_5 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_6 = 0;
	reg [`DATA_WIDTH - 1 : 0] ofm_accum_7 = 0;

// Delay registers
	reg [`IFM_ADR_W - 1 : 0] ifm_addr_prev = 0;
	reg [`WGHT_ADR_W - 1: 0] wght_addr_prev = 0;
	reg [`OFM_ADR_W - 1 : 0] ofm_addr_prev = 0;
	wire [`OFM_ADR_W - 1 : 0] ofm_addr_wr;

	reg [`DATA_WIDTH - 1 : 0] ifm_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] ifm_1 = 0;
	
	reg [`DATA_WIDTH - 1 : 0] wght_0_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_0_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_1_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_1_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_2_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_2_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_3_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_3_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_4_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_4_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_5_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_5_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_6_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_6_1 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_7_0 = 0;
	reg [`DATA_WIDTH - 1 : 0] wght_7_1 = 0;

// Connect buffer signals
	assign in_buf_0_read_n = rd_enable1;
	assign in_buf_1_read_n = rd_enable1;
		
	assign w_buf_0_0_read_n = rd_enable1;
	assign w_buf_0_1_read_n = rd_enable1;
	assign w_buf_1_0_read_n = rd_enable1;
	assign w_buf_1_1_read_n = rd_enable1;
	assign w_buf_2_0_read_n = rd_enable1;
	assign w_buf_2_1_read_n = rd_enable1;
	assign w_buf_3_0_read_n = rd_enable1;
	assign w_buf_3_1_read_n = rd_enable1;
	assign w_buf_4_0_read_n = rd_enable1;
	assign w_buf_4_1_read_n = rd_enable1;
	assign w_buf_5_0_read_n = rd_enable1;
	assign w_buf_5_1_read_n = rd_enable1;
	assign w_buf_6_0_read_n = rd_enable1;
	assign w_buf_6_1_read_n = rd_enable1;
	assign w_buf_7_0_read_n = rd_enable1;
	assign w_buf_7_1_read_n = rd_enable1;

	assign out_buf_0_p1_read_n = rd_enable2_prev2;
	assign out_buf_1_p1_read_n = rd_enable2_prev2;
	assign out_buf_2_p1_read_n = rd_enable2_prev2;
	assign out_buf_3_p1_read_n = rd_enable2_prev2;
	assign out_buf_4_p1_read_n = rd_enable2_prev2;
	assign out_buf_5_p1_read_n = rd_enable2_prev2;
	assign out_buf_6_p1_read_n = rd_enable2_prev2;
	assign out_buf_7_p1_read_n = rd_enable2_prev2;

	assign out_buf_0_p2_write_n = wr_enable;
	assign out_buf_1_p2_write_n = wr_enable;
	assign out_buf_2_p2_write_n = wr_enable;
	assign out_buf_3_p2_write_n = wr_enable;
	assign out_buf_4_p2_write_n = wr_enable;
	assign out_buf_5_p2_write_n = wr_enable;
	assign out_buf_6_p2_write_n = wr_enable;
	assign out_buf_7_p2_write_n = wr_enable;

	assign in_buf_0_address = ifm_addr_prev;
	assign in_buf_1_address = ifm_addr_prev;

	assign w_buf_0_0_address = wght_addr_prev;
	assign w_buf_0_1_address = wght_addr_prev;
	assign w_buf_1_0_address = wght_addr_prev;
	assign w_buf_1_1_address = wght_addr_prev;
	assign w_buf_2_0_address = wght_addr_prev;
	assign w_buf_2_1_address = wght_addr_prev;
	assign w_buf_3_0_address = wght_addr_prev;
	assign w_buf_3_1_address = wght_addr_prev;
	assign w_buf_4_0_address = wght_addr_prev;
	assign w_buf_4_1_address = wght_addr_prev;
	assign w_buf_5_0_address = wght_addr_prev;
	assign w_buf_5_1_address = wght_addr_prev;
	assign w_buf_6_0_address = wght_addr_prev;
	assign w_buf_6_1_address = wght_addr_prev;
	assign w_buf_7_0_address = wght_addr_prev;
	assign w_buf_7_1_address = wght_addr_prev;

	assign out_buf_0_p1_address = ofm_addr_prev;
	assign out_buf_1_p1_address = ofm_addr_prev;
	assign out_buf_2_p1_address = ofm_addr_prev;
	assign out_buf_3_p1_address = ofm_addr_prev;
	assign out_buf_4_p1_address = ofm_addr_prev;
	assign out_buf_5_p1_address = ofm_addr_prev;
	assign out_buf_6_p1_address = ofm_addr_prev;
	assign out_buf_7_p1_address = ofm_addr_prev;

	assign out_buf_0_p2_address = ofm_addr_wr;
	assign out_buf_1_p2_address = ofm_addr_wr;
	assign out_buf_2_p2_address = ofm_addr_wr;
	assign out_buf_3_p2_address = ofm_addr_wr;
	assign out_buf_4_p2_address = ofm_addr_wr;
	assign out_buf_5_p2_address = ofm_addr_wr;
	assign out_buf_6_p2_address = ofm_addr_wr;
	assign out_buf_7_p2_address = ofm_addr_wr;
	
	assign out_buf_0_p2_writedata = ofm_accum_0;
	assign out_buf_1_p2_writedata = ofm_accum_1;
	assign out_buf_2_p2_writedata = ofm_accum_2;
	assign out_buf_3_p2_writedata = ofm_accum_3;
	assign out_buf_4_p2_writedata = ofm_accum_4;
	assign out_buf_5_p2_writedata = ofm_accum_5;
	assign out_buf_6_p2_writedata = ofm_accum_6;
	assign out_buf_7_p2_writedata = ofm_accum_7;
	
	// synchronize read/write/compute
	assign done 			= (!inc_h && pipe_delay == 10) ? 1 : 0;
	assign wr_enable 		= ((i == 0) && (pipe_delay == 7) && (w != 0 || h != 0)) ? 0 : 1;
	assign waiting 		= (!inc_h && pipe_delay == 10) ? 0 : 1;
	assign ofm_addr_wr 	= ofm_addr - 1;
	
	// Load partial computed OFM elements, if n == 0 then already stored Kernel bias terms will be loaded!
   assign ofm_0 = (i == 0 && pipe_delay == 7) ? out_buf_0_p1_readdata : ofm_accum_0;
   assign ofm_1 = (i == 0 && pipe_delay == 7) ? out_buf_1_p1_readdata : ofm_accum_1;
   assign ofm_2 = (i == 0 && pipe_delay == 7) ? out_buf_2_p1_readdata : ofm_accum_2;
   assign ofm_3 = (i == 0 && pipe_delay == 7) ? out_buf_3_p1_readdata : ofm_accum_3;
   assign ofm_4 = (i == 0 && pipe_delay == 7) ? out_buf_4_p1_readdata : ofm_accum_4;
   assign ofm_5 = (i == 0 && pipe_delay == 7) ? out_buf_5_p1_readdata : ofm_accum_5;
   assign ofm_6 = (i == 0 && pipe_delay == 7) ? out_buf_6_p1_readdata : ofm_accum_6;
   assign ofm_7 = (i == 0 && pipe_delay == 7) ? out_buf_7_p1_readdata : ofm_accum_7;

// State Machine: controller
always @(*)
begin
	inc_j <= j < (`Kj - 1);
	inc_i <= i < (`Ki - 1);
	inc_w <= w < (`Wout - 1);
	inc_h <= h < (`Hout);
end
always @ (posedge clk)
begin
	case (state)
		IDLE : state <= enable ? BUSY : IDLE;
		BUSY : state <= (!waiting) ? IDLE : BUSY;
	endcase
end

always @ (posedge clk)
begin
	rd_enable2 <= rd_enable1;
	rd_enable2_prev1 <= rd_enable2;
	rd_enable2_prev2 <= rd_enable2_prev1;
	
	case (state)
		IDLE:
		begin
			i <= 0;
			j <= 0; 
			w <= 0;
			h <= 0;
			pipe_delay <= 0;	
			rd_enable1 <= 1;
		end
		BUSY :
		begin
			rd_enable1 <= 0;

			if (inc_j)
			begin
				j <= j + 1;
				pipe_delay <= pipe_delay + 1;
			end
			else if (inc_i)
			begin
				j <= 0;
				i <= i + 1;
				pipe_delay <= 0;
			end
			else if (inc_w)
			begin
				j <= 0;
				i <= 0;
				w <= w + 1;
				pipe_delay <= 0;
			end
			else if (inc_h)
			begin
				i <= 0;
				j <= 0;
				w <= 0;
				h <= h + 1;
				pipe_delay <= 0;
			end	
		end
	endcase
end

// Perform Convolution: 8 PE -> pipelined MACs
always @ (posedge clk)
begin
	// compute address
	ifm_addr <= (w * `S + i) + `Win * (h * `S + j);
	wght_addr <= i + `Kj * j;
	ofm_addr <= w + `Wout * h;
	
	// Use Filter 1 of Kernels
	out_partial_0_0 <= ifm_0 * wght_0_0;
	out_partial_1_0 <= ifm_0 * wght_1_0;
	out_partial_2_0 <= ifm_0 * wght_2_0;
	out_partial_3_0 <= ifm_0 * wght_3_0;
	out_partial_4_0 <= ifm_0 * wght_4_0;
	out_partial_5_0 <= ifm_0 * wght_5_0;
	out_partial_6_0 <= ifm_0 * wght_6_0;
	out_partial_7_0 <= ifm_0 * wght_7_0;
	
	// Use Filter 2 of Kernels, 0 if remaining IFM tile < Tn-1
	out_partial_0_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_0_1 : 0;
	out_partial_1_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_1_1 : 0;
	out_partial_2_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_2_1 : 0;
	out_partial_3_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_3_1 : 0;
	out_partial_4_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_4_1 : 0;
	out_partial_5_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_5_1 : 0;
	out_partial_6_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_6_1 : 0;
	out_partial_7_1 <= ((n + `Tn-1) < `N) ? ifm_1 * wght_7_1 : 0;
	
	// Accumulate for convolution
	ofm_accum_0 <= ofm_0 + out_partial_0_0 + out_partial_0_1;
	ofm_accum_1 <= ofm_1 + out_partial_1_0 + out_partial_1_1;
	ofm_accum_2 <= ofm_2 + out_partial_2_0 + out_partial_2_1;
	ofm_accum_3 <= ofm_3 + out_partial_3_0 + out_partial_3_1;
	ofm_accum_4 <= ofm_4 + out_partial_4_0 + out_partial_4_1;
	ofm_accum_5 <= ofm_5 + out_partial_5_0 + out_partial_5_1;
	ofm_accum_6 <= ofm_6 + out_partial_6_0 + out_partial_6_1;
	ofm_accum_7 <= ofm_7 + out_partial_7_0 + out_partial_7_1;
end

// Delay Registers
always @ (posedge clk)
begin
	ifm_addr_prev <= ifm_addr;
	wght_addr_prev <= wght_addr;

	ofm_addr_prev <= ofm_addr;

	ifm_0 <= in_buf_0_readdata;
	ifm_1 <= in_buf_1_readdata;

	wght_0_0 <= w_buf_0_0_readdata;
	wght_0_1 <= w_buf_0_1_readdata;
	wght_1_0 <= w_buf_1_0_readdata;
	wght_1_1 <= w_buf_1_1_readdata;
	wght_2_0 <= w_buf_2_0_readdata;
	wght_2_1 <= w_buf_2_1_readdata;
	wght_3_0 <= w_buf_3_0_readdata;
	wght_3_1 <= w_buf_3_1_readdata;
	wght_4_0 <= w_buf_4_0_readdata;
	wght_4_1 <= w_buf_4_1_readdata;
	wght_5_0 <= w_buf_5_0_readdata;
	wght_5_1 <= w_buf_5_1_readdata;
	wght_6_0 <= w_buf_6_0_readdata;
	wght_6_1 <= w_buf_6_1_readdata;
	wght_7_0 <= w_buf_7_0_readdata;
	wght_7_1 <= w_buf_7_1_readdata;
end
	
endmodule
