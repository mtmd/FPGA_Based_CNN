module ofm_wb (
input clk,

output reg sdram_write_n = 1,
output reg [`DATA_WIDTH - 1 : 0] sdram_writedata	= 0,
output reg [`RAM_ADR_W - 1 : 0] sdram_address = 0,
input	sdram_waitrequest,
 
output reg out_buf_0_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_0_p1_readdata,
output reg [`OFM_ADR_W - 1 : 0] out_buf_0_p1_address = 0,
input out_buf_0_p1_readdatavalid,

output reg out_buf_1_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_1_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_1_p1_address = 0,
input	out_buf_1_p1_readdatavalid,

output reg out_buf_2_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_2_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_2_p1_address = 0,
input out_buf_2_p1_readdatavalid,

output reg out_buf_3_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_3_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_3_p1_address = 0,
input out_buf_3_p1_readdatavalid,

output reg out_buf_4_p1_read_n = 1,
input	[`DATA_WIDTH - 1 : 0] out_buf_4_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_4_p1_address = 0,
input out_buf_4_p1_readdatavalid,

output reg out_buf_5_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_5_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_5_p1_address = 0,
input out_buf_5_p1_readdatavalid,

output reg out_buf_6_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_6_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_6_p1_address = 0,
input out_buf_6_p1_readdatavalid,

output reg out_buf_7_p1_read_n = 1,
input [`DATA_WIDTH - 1 : 0] out_buf_7_p1_readdata,
output reg [`OFM_ADR_W - 1 :0] out_buf_7_p1_address = 0,
input out_buf_7_p1_readdatavalid,

output reg done = 0, 
input enable,

input [`M_IDX_SZ - 1 : 0] m,
input [`N_IDX_SZ - 1 : 0] n
);
localparam IDLE = 0;
localparam O0_ST = 1;
localparam O1_ST = 2;
localparam O2_ST = 3;
localparam O3_ST = 4;
localparam O4_ST = 5;
localparam O5_ST = 6;
localparam O6_ST = 7;
localparam O7_ST = 8;
localparam DONE = 9;
localparam MID0 = 10;
localparam MID1 = 11;

localparam MID2 = 12;
localparam MID3 = 13;

localparam MID4 = 14;
localparam MID5 = 15;

localparam MID6 = 16;
localparam MID7 = 17;

localparam MID8 = 18;
localparam MID9 = 19;

localparam MID10 = 20;
localparam MID11 = 21;

localparam MID12 = 22;
localparam MID13 = 23;

localparam MID14 = 24;
localparam MID15 = 25;

reg [4:0]  state = 0;

reg [`OFM_ADR_W - 1 : 0] k0 = 0;
reg [`OFM_ADR_W - 1 : 0] k1 = 0;
reg [`OFM_ADR_W - 1 : 0] k2 = 0;
reg [`OFM_ADR_W - 1 : 0] k3 = 0; 
reg [`OFM_ADR_W - 1 : 0] k4 = 0;
reg [`OFM_ADR_W - 1 : 0] k5 = 0;
reg [`OFM_ADR_W - 1 : 0] k6 = 0;
reg [`OFM_ADR_W - 1 : 0] k7 = 0; 

reg [`OFM_ADR_W - 1 : 0] l0 = 0;
reg [`OFM_ADR_W - 1 : 0] l1 = 0;
reg [`OFM_ADR_W - 1 : 0] l2 = 0;
reg [`OFM_ADR_W - 1 : 0] l3 = 0; 
reg [`OFM_ADR_W - 1 : 0] l4 = 0;
reg [`OFM_ADR_W - 1 : 0] l5 = 0;
reg [`OFM_ADR_W - 1 : 0] l6 = 0;
reg [`OFM_ADR_W - 1 : 0] l7 = 0; 

reg [`OFM_ADR_W - 1 : 0] m0 = 0;
reg [`OFM_ADR_W - 1 : 0] m1 = 0;
reg [`OFM_ADR_W - 1 : 0] m2 = 0;
reg [`OFM_ADR_W - 1 : 0] m3 = 0; 
reg [`OFM_ADR_W - 1 : 0] m4 = 0;
reg [`OFM_ADR_W - 1 : 0] m5 = 0;
reg [`OFM_ADR_W - 1 : 0] m6 = 0;
reg [`OFM_ADR_W - 1 : 0] m7 = 0; 

reg [`RAM_ADR_W - 1 : 0] ram_adr = 0;

reg [`DATA_WIDTH - 1 : 0] data0;
reg rdreq0;
reg wrreq0;
wire empty0;
wire full;
wire [`DATA_WIDTH - 1 : 0] q0;
wire [3:0] usedw0;

reg [`DATA_WIDTH - 1 : 0] data1;
reg rdreq1;
reg wrreq1;
wire empty1;
wire [`DATA_WIDTH - 1 : 0] q1;
wire [3:0] usedw1;

reg [`DATA_WIDTH - 1 : 0] data2;
reg rdreq2;
reg wrreq2;
wire empty2;
wire [`DATA_WIDTH - 1 : 0] q2;
wire [3:0] usedw2;

reg [`DATA_WIDTH - 1 : 0] data3;
reg rdreq3;
reg wrreq3;
wire empty3;
wire [`DATA_WIDTH - 1 : 0] q3;
wire [3:0] usedw3;

reg [`DATA_WIDTH - 1 : 0] data4;
reg rdreq4;
reg wrreq4;
wire empty4;
wire [`DATA_WIDTH - 1 : 0] q4;
wire [3:0] usedw4;

reg [`DATA_WIDTH - 1 : 0] data5;
reg rdreq5;
reg wrreq5;
wire empty5;
wire [`DATA_WIDTH - 1 : 0] q5;
wire [3:0] usedw5;

reg [`DATA_WIDTH - 1 : 0] data6;
reg rdreq6;
reg wrreq6;
wire empty6;
wire [`DATA_WIDTH - 1 : 0] q6;
wire [3:0] usedw6;

reg [`DATA_WIDTH - 1 : 0] data7;
reg rdreq7;
reg wrreq7;
wire empty7;
wire [`DATA_WIDTH - 1 : 0] q7;
wire [3:0] usedw7;
always @ (*)
begin
	rdreq0 <= (sdram_waitrequest == 0 && empty0 == 0) ? 1'b1 : 1'b0;
	wrreq0 <= out_buf_0_p1_readdatavalid && state != IDLE;
	data0 <= out_buf_0_p1_readdata;
	out_buf_0_p1_address <= k0;
	
	rdreq1 <= (sdram_waitrequest == 0 && empty1 == 0) ? 1'b1 : 1'b0;
	wrreq1 <= out_buf_1_p1_readdatavalid && state != IDLE;
	data1 <= out_buf_1_p1_readdata;
	out_buf_1_p1_address <= k1;	
	
	rdreq2 <= (sdram_waitrequest == 0 && empty2 == 0) ? 1'b1 : 1'b0;
	wrreq2 <= out_buf_2_p1_readdatavalid && state != IDLE;
	data2 <= out_buf_2_p1_readdata;
	out_buf_2_p1_address <= k2;
	
	rdreq3 <= (sdram_waitrequest == 0 && empty3 == 0) ? 1'b1 : 1'b0;
	wrreq3 <= out_buf_3_p1_readdatavalid && state != IDLE;
	data3 <= out_buf_3_p1_readdata;
	out_buf_3_p1_address <= k3;

	rdreq4 <= (sdram_waitrequest == 0 && empty4 == 0) ? 1'b1 : 1'b0;
	wrreq4 <= out_buf_4_p1_readdatavalid && state != IDLE;
	data4 <= out_buf_4_p1_readdata;
	out_buf_4_p1_address <= k4;	

	rdreq5 <= (sdram_waitrequest == 0 && empty5 == 0) ? 1'b1 : 1'b0;
	wrreq5 <= out_buf_5_p1_readdatavalid && state != IDLE;
	data5 <= out_buf_5_p1_readdata;
	out_buf_5_p1_address <= k5;

	rdreq6 <= (sdram_waitrequest == 0 && empty6 == 0) ? 1'b1 : 1'b0;
	wrreq6 <= out_buf_6_p1_readdatavalid && state != IDLE;
	data6 <= out_buf_6_p1_readdata;
	out_buf_6_p1_address <= k6;

	rdreq7 <= (sdram_waitrequest == 0 && empty7 == 0) ? 1'b1 : 1'b0;
	wrreq7 <= out_buf_7_p1_readdatavalid && state != IDLE;
	data7 <= out_buf_7_p1_readdata;
	out_buf_7_p1_address <= k7;	
end
always @ (posedge clk)
begin
	case (state)
	IDLE: 
	begin
		state <= enable ? MID14 : IDLE;
		k0 <= 0;
		k1	<= 0;
		k2	<= 0;
		k3	<= 0;
		k4 <= 0;
		k5	<= 0;
		k6	<= 0;
		k7	<= 0;		
		
		l0 <= 0;
		l1	<= 0;
		l2	<= 0;
		l3	<= 0;
		l4 <= 0;
		l5	<= 0;
		l6	<= 0;
		l7	<= 0;		
		
		m0 <= 0;
		m1	<= 0;
		m2	<= 0;
		m3	<= 0;
		m4 <= 0;
		m5	<= 0;
		m6	<= 0;
		m7	<= 0;		

		out_buf_0_p1_read_n <= 1;
		out_buf_1_p1_read_n <= 1;
		out_buf_2_p1_read_n <= 1;
		out_buf_3_p1_read_n <= 1;
		out_buf_4_p1_read_n <= 1;
		out_buf_5_p1_read_n <= 1;
		out_buf_6_p1_read_n <= 1;
		out_buf_7_p1_read_n <= 1;
		
		ram_adr <= `out_base + (m) * `OFM_SIZE;
	end
	MID14:
	begin
		state <= O0_ST; //MID15;
		out_buf_0_p1_read_n <= 0;
	end
	MID15:
	begin
		state <= O0_ST;
		out_buf_0_p1_read_n <= 0;		
	end	
	O0_ST:
	begin
		state <= ((l0 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O0_ST : MID0;	
		k0 <= (usedw0 < 10) ? k0 + 1'b1 : k0;	
		m0 <= (usedw0 < 10) ? k0 : m0;
		out_buf_0_p1_read_n <= (usedw0 < 10 && k0 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l0 <= (sdram_waitrequest == 0 && empty0 == 0) ? l0 + 1'b1 : l0;	
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty0 == 0) ? ram_adr + 1'b1 : ram_adr;	
		
		//out_buf_1_p1_read_n <= 1;
	end
	MID0:
	begin
		state <= O1_ST; //MID1;
		out_buf_1_p1_read_n <= 0;
	end
	MID1:
	begin
		state <= O1_ST;
		out_buf_1_p1_read_n <= 0;		
	end
	O1_ST:
	begin
		state <= ((l1 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O1_ST : MID2;	
		k1 <= (usedw1 < 10) ? k1 + 1'b1 : k1;	
		m1 <= (usedw1 < 10) ? k1 : m1;
		out_buf_1_p1_read_n <= (usedw1 < 10 && k1 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l1 <= (sdram_waitrequest == 0 && empty1 == 0) ? l1 + 1'b1 : l1;	
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty1 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	MID2:
	begin
		state <= O2_ST; //MID3;
		out_buf_2_p1_read_n <= 0;		
	end
	MID3:
	begin
		state <= O2_ST;
		out_buf_2_p1_read_n <= 0;			
	end
	O2_ST:
	begin
		state <= ((l2 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O2_ST : MID4;	
		k2 <= (usedw2 < 10) ? k2 + 1'b1 : k2;	
		m2 <= (usedw2 < 10) ? k2 : m2;
		out_buf_2_p1_read_n <= (usedw2 < 10 && k2 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l2 <= (sdram_waitrequest == 0 && empty2 == 0) ? l2 + 1'b1 : l2;	
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty2 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	MID4:
	begin
		state <= O3_ST; //MID5;
		out_buf_3_p1_read_n <= 0;		
	end
	MID5:
	begin
		state <= O3_ST;
		out_buf_3_p1_read_n <= 0;			
	end	
	O3_ST:
	begin
		state <= ((l3 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O3_ST : MID6;	
		k3 <= (usedw3 < 10) ? k3 + 1'b1 : k3;	
		m3 <= (usedw3 < 10) ? k3 : m3;
		out_buf_3_p1_read_n <= (usedw3 < 10 && k3 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l3 <= (sdram_waitrequest == 0 && empty3 == 0) ? l3 + 1'b1 : l3;	
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty3 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	MID6:
	begin
		state <= O4_ST; //MID7;
		out_buf_4_p1_read_n <= 0;		
	end
	MID7:
	begin
		state <= O4_ST;
		out_buf_4_p1_read_n <= 0;			
	end		
	O4_ST:
	begin
		state <= ((l4 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O4_ST : MID8;	
		k4 <= (usedw4 < 10) ? k4 + 1'b1 : k4;	
		m4 <= (usedw4 < 10) ? k4 : m4;
		out_buf_4_p1_read_n <= (usedw4 < 10 && k4 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l4 <= (sdram_waitrequest == 0 && empty4 == 0) ? l4 + 1'b1 : l4;
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty4 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	MID8:
	begin
		state <= O5_ST; //MID9;
		out_buf_5_p1_read_n <= 0;		
	end
	MID9:
	begin
		state <= O5_ST;
		out_buf_5_p1_read_n <= 0;			
	end		
	O5_ST:
	begin
		state <= ((l5 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O5_ST : MID10;	
		k5 <= (usedw5 < 10) ? k5 + 1'b1 : k5;	
		m5 <= (usedw5 < 10) ? k5 : m5;
		out_buf_5_p1_read_n <= (usedw5 < 10 && k5 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l5 <= (sdram_waitrequest == 0 && empty5 == 0) ? l5 + 1'b1 : l5;
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty5 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	MID10:
	begin
		state <= O6_ST; //MID11;
		out_buf_6_p1_read_n <= 0;		
	end
	MID11:
	begin
		state <= O6_ST;
		out_buf_6_p1_read_n <= 0;			
	end		
	O6_ST:
	begin
		state <= ((l6 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O6_ST : MID12;	
		k6 <= (usedw6 < 10) ? k6 + 1'b1 : k6;	
		m6 <= (usedw6 < 10) ? k6 : m6;
		out_buf_6_p1_read_n <= (usedw6 < 10 && k6 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l6 <= (sdram_waitrequest == 0 && empty6 == 0) ? l6 + 1'b1 : l6;
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty6 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	MID12:
	begin
		state <= O7_ST; //MID13;
		out_buf_7_p1_read_n <= 0;		
	end
	MID13:
	begin
		state <= O7_ST;
		out_buf_7_p1_read_n <= 0;			
	end		
	O7_ST:
	begin
		state <= ((l7 < (`OFM_SIZE)) || (sdram_waitrequest == 1)) ? O7_ST : DONE;	
		k7 <= (usedw7 < 10) ? k7 + 1'b1 : k7;	
		m7 <= (usedw7 < 10) ? k7 : m7;
		out_buf_7_p1_read_n <= (usedw7 < 10 && k7 < (`OFM_SIZE - 1)) ? 1'b0 : 1'b1;
		
		l7 <= (sdram_waitrequest == 0 && empty7 == 0) ? l7 + 1'b1 : l7;	
		
		sdram_address <= (sdram_waitrequest == 0) ? ram_adr : sdram_address;
		
		ram_adr <= (sdram_waitrequest == 0 && empty7 == 0) ? ram_adr + 1'b1 : ram_adr;	
	end
	DONE:
	begin 
		state <= IDLE;
	end
	endcase
end
always @ (*)
begin
	case (state)
		IDLE:
		begin
			done <= 0;
			sdram_write_n <= 1;
			sdram_writedata <= 0;
		end
		O0_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q0;
		end
		O1_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q1;		
		end
		O2_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q2;
		end
		O3_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q3;		
		end
		O4_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q4;
		end
		O5_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q5;		
		end
		O6_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q6;
		end
		O7_ST:
		begin
			done <= 0;
			sdram_write_n <= 0;
			sdram_writedata <= q7;
		end
		DONE:
		begin
			done <= 1;
			sdram_write_n <= 1;
			sdram_writedata <= 0;
		end
		default:
		begin
			done <= 0;
			sdram_write_n <= 1;
			sdram_writedata <= 0;
		end
	endcase
end

fifo_v2 fifo_v2_inst0 (
	.clock (clk),
	.data (data0),
	.rdreq (rdreq0),
	.wrreq (wrreq0),
	.empty (empty0),
	.full (full),
	.q (q0),
	.usedw (usedw0)
);
fifo_v2 fifo_v2_inst1 (
	.clock (clk),
	.data (data1),
	.rdreq (rdreq1),
	.wrreq (wrreq1),
	.empty (empty1),
	.full (),
	.q (q1),
	.usedw (usedw1)
);
fifo_v2 fifo_v2_inst2 (
	.clock (clk),
	.data (data2),
	.rdreq (rdreq2),
	.wrreq (wrreq2),
	.empty (empty2),
	.full (),
	.q (q2),
	.usedw (usedw2)
);
fifo_v2 fifo_v2_inst3 (
	.clock (clk),
	.data (data3),
	.rdreq (rdreq3),
	.wrreq (wrreq3),
	.empty (empty3),
	.full (),
	.q (q3),
	.usedw (usedw3)
);
fifo_v2 fifo_v2_inst4 (
	.clock (clk),
	.data (data4),
	.rdreq (rdreq4),
	.wrreq (wrreq4),
	.empty (empty4),
	.full (),
	.q (q4),
	.usedw (usedw4)
);
fifo_v2 fifo_v2_inst5 (
	.clock (clk),
	.data (data5),
	.rdreq (rdreq5),
	.wrreq (wrreq5),
	.empty (empty5),
	.full (),
	.q (q5),
	.usedw (usedw5)
);
fifo_v2 fifo_v2_inst6 (
	.clock (clk),
	.data (data6),
	.rdreq (rdreq6),
	.wrreq (wrreq6),
	.empty (empty6),
	.full (),
	.q (q6),
	.usedw (usedw6)
);
fifo_v2 fifo_v2_inst7 (
	.clock (clk),
	.data (data7),
	.rdreq (rdreq7),
	.wrreq (wrreq7),
	.empty (empty7),
	.full (),
	.q (q7),
	.usedw (usedw7)
);
endmodule
