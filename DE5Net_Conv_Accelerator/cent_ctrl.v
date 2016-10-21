/* The central Controller to control Off-Chip Memory Read/Write and Design Debuging */

module cent_ctrl (
	input 				clk,
	input 				reset_n,
	
	output	[4:0]		fpga_address,											// avalon master interface for PIO IP cores
	output				fpga_write_n,											//
	output	[31:0]	fpga_writedata,										//
	output				fpga_chipselect,										//
	input 	[31:0]	fpga_readdata,											//
	input 				fpga_waitrequest,										//
	
	input             avl_ready,                                  //              avl.waitrequest_n
	output            avl_burstbegin,                             //                 .beginbursttransfer
	output  [24:0]    avl_addr,                                   //                 .address
	input             avl_rdata_valid,                            //                 .readdatavalid
	input   [63:0]    avl_rdata,                                  //                 .readdata
	output  [63:0]    avl_wdata,                                  //                 .writedata
	output  [7:0]     avl_be,                                     //                 .byteenable
	output            avl_read_req,                               //                 .read
	output            avl_write_req,                              //                 .write
	output            avl_size,                                   //                 .burstcount
	
	input 				mem_local_init_done,
	input 				mem_local_cal_success,
	input 				mem_local_cal_fail,
	
	output				mem_cal_done = 0,							// export to indicate calibration done
	output				mem_ready = 0,								// export to indicate calibration succesful
	
	output reg			read_done = 0,
	output reg			fail = 0,
	input					debug_pb,
	input					pcie_load_done,
	
	input 				pcie_clk,
	input 				pcie_reset_n,
	input 	[2:0]		pcie_addr,										// avalon slave interface for PCIE HIP core
	input					pcie_write_req,								//
	input					pcie_read_req,									//
	input	   [31:0]	pcie_writedata,								//
	output reg [31:0]	pcie_readdata,									//
	output 				pcie_waitrequest,								//
	output reg			pcie_readdatavalid,							//
	input		[3:0]		pcie_byteenable,

	output  [13:0]    ocmem_addr,                                 // avalon master interface for On-Chip Mem core
	output            ocmem_chipselect,                           //
	input   [31:0]    ocmem_rdata,                                //
	output  [31:0]    ocmem_wdata,                                //
	output  [3:0]     ocmem_be,                                   //
	output reg        ocmem_write_req,                            //
	input             ocmem_waitrequest,                          //
	
	input             sdram_ready,                                //              avl.waitrequest_n
	output  [24:0]    sdram_addr,                                 //                 .address
	input             sdram_rdata_valid,                          //                 .readdatavalid
	input   [63:0]    sdram_rdata,                                //                 .readdata
	output  [63:0]    sdram_wdata,                                //                 .writedata
	output  [7:0]     sdram_be,                                   //                 .byteenable
	output reg        sdram_read_req,                             //                 .read
	output reg        sdram_write_req,                            //                 .write
	output            sdram_size                                  //                 .burstcount
);

// Global Parameters
	`include "cnn_parameters.vh"
	`include "parameters.vh"

// local parameters
	localparam TO_CC_OFFSET   = 8'h00;								// Specify Qsys PIO Base Adresses here
	localparam FROM_CC_OFFSET = 8'h10;								//

// local signals
	wire	[7:0]		to_cc_loc;
	reg 	[7:0]		to_cc;
	reg 	[7:0]		from_cc;
	reg 	[7:0]		msg;
	wire				compute_start;
	reg            compute_done;
	reg            read_done_next;
	wire           mem_load_done;
	reg 				write_n_loc;
	reg 				flag, flag2;
	reg 	[7:0]		m, n;
	reg				pb_prev;
	wire				pb_rise;

// default values and connections
	assign to_cc_loc = fpga_readdata;
	assign fpga_writedata = {{24{1'b0}}, from_cc};
	assign fpga_address = (write_n_loc) ? TO_CC_OFFSET : FROM_CC_OFFSET;// access only the data registers in PIO cores (at 0x0 for both PIO)
	assign fpga_chipselect = 1'b1;									      		// chipselect always 1
	assign fpga_write_n = write_n_loc;
	assign mem_cal_done = mem_local_init_done;
	assign mem_ready = mem_local_cal_success && ~mem_local_cal_fail;
	assign mem_load_done = (check_count == `out_base) ? 1'b1 : 1'b0;
	assign compute_start = mem_load_done && pcie_load_done;

// --- Uncomment 'pb_rise' in the following code to halt execution in "DEBUG" state for debugging
// Detect rising edge
always@(posedge clk)
begin
	pb_prev <= debug_pb;
end
assign pb_rise = debug_pb & ~pb_prev;
	
always@(posedge clk)
begin
	if(!reset_n) begin
		from_cc <= 0;
		msg <= 0;
		flag <= 0;
		to_cc <= 0;
		write_n_loc <= 1;
	end
	else begin
		if(compute_start) begin					            // Wait for SDRAM initialization and model loading
			if(!flag) begin   									// To start the state machines
				from_cc <= `START;
				write_n_loc <= 0;
				msg <= `CHECK_IFM;
				flag <= 1;
			end
			else begin 
				if(to_cc == msg) begin							
					//if(pb_rise) begin
						from_cc <= msg;								// Nothing to do: wait for msg from FPGA and return it
						write_n_loc <= 0;								// assert write to FROM_CC PIO data register
					//end
				end
				else begin
					write_n_loc <= 1;
					to_cc <= (to_cc_loc != to_cc && to_cc_loc != 0) ? to_cc_loc : to_cc; // preserve to_cc data as it might get corrupted
				end
				
				//if(pb_rise) begin
					if(m >= `M) 									msg <= `CHECK_IFM;		// Wait for IFM
					else if(to_cc == `CHECK_WB && m != 0) 	msg <= `CHECK_WEIGHT;	// Wait for Weight, new Weight loading
					else if(to_cc == `CHECK_IFM) 				msg <= `CHECK_WEIGHT;	// Wait for Weight, new IFM loaded
					else if(to_cc == `CHECK_WEIGHT) 			msg <= `CHECK_OFM;		// Wait for out buf
					else if(to_cc == `CHECK_OFM) 				msg <= `CHECK_RESULT;	// Wait for conv
					else if(to_cc == `CHECK_RESULT) 			msg <= `CHECK_WB;			// Wait for WB
				//end
			end
		end
	end
end

// Tile counters
always@(posedge clk)
begin
	if(!reset_n) begin
		m <= 0;
		n <= 0;
		flag2 <= 0;
		compute_done <= 0;
	end
	else if (n < `N) begin
		if(m >= `M/* && pb_rise*/) begin
			n <= n + `Tn;
			m <= 0;
		end
		else begin
			if(to_cc == `CHECK_WB) begin
				if(!flag2) begin
					m <= m + `Tm;
					flag2 <= 1;
				end
			end
			else flag2 <= 0;
		end
	end
	else compute_done <= 1;
end


//==================================================
//======== SDRAM Self Init/Check Driver Begins ==========
//==================================================

// Parameters	
	localparam 		WAIT = 0;
	localparam 		WRITE = 1;
	localparam		WRITE_CHECK = 2;
	localparam 		READ = 3;
	
// Avalon interface signals
	wire 		avl_master_ready;
	reg  		avl_slave_burstbegin, avl_slave_burstbegin_next;
	reg  [24:0] avl_slave_addr, avl_slave_addr_next;      	
	wire 		avl_master_rdata_valid;	
	wire [63:0] avl_master_rdata;     	
	reg  [63:0] avl_slave_wdata;      	
	wire [7:0]  avl_slave_byte_en;    	
	reg  		avl_slave_read_req;   	
	reg 	 	avl_slave_write_req; 	

// Internal driver signals
	reg  [1:0]	state, state_next;
	reg  [24:0] check_count, check_count_next;
	reg  [7:0]  out1_count, out1_count_next;
	reg  [18:0] out2_count, out2_count_next;
	reg         mem_wr_done, mem_wr_done_next;
	wire [63:0] img_base_64b;
	wire [63:0] ifm_size_64b;
	wire [63:0] ifm_size_64b_x2;
	integer i;
	
// Read checker signals
	wire [15:0] val;
	reg  [18:0] count, count_next;
	reg         write_check_fail, write_check_fail_next;
	reg         fail_next;
	
// Assign in/out port signals
	assign avl_master_ready = avl_ready;
	assign avl_burstbegin = avl_slave_burstbegin;
	assign avl_addr = avl_slave_addr;      	
	assign avl_master_rdata_valid = avl_rdata_valid;	
	assign avl_master_rdata = avl_rdata;     	
	assign avl_wdata = avl_slave_wdata;      	
	assign avl_be = avl_slave_byte_en;
	assign avl_slave_byte_en = {8{1'b1}}; // all ones
	assign avl_read_req = avl_slave_read_req;   	
	assign avl_write_req = avl_slave_write_req; 	
	assign avl_size = 1'b1;	
	
	assign img_base_64b = {{39{1'b0}}, `img_base};
	assign ifm_size_64b = {{39{1'b0}}, `IFM_SIZE};
	assign ifm_size_64b_x2 = {{39{1'b0}}, `IFM_SIZE} * 64'd2;

// Controller
always@(*) 
begin
	// Remember previous vals, prevent latching
	state_next = state;
	avl_slave_addr_next = avl_slave_addr;
	avl_slave_burstbegin_next = avl_slave_burstbegin;
	mem_wr_done_next = mem_wr_done;
	out1_count_next = out1_count;
	out2_count_next = out2_count;
	read_done_next = read_done;
	
	// Default active/inactive signals
	avl_slave_write_req = 0;
	avl_slave_read_req = 0;
	avl_slave_wdata = {64{1'b0}};
	
	// State Machine
	case(state)
		WAIT: begin
			if(reset_n && mem_ready) begin       // Wait for SDRAM local calibration to pass
				if(!mem_wr_done) begin
					state_next = WRITE;
					avl_slave_burstbegin_next = 1;
				end
				else if(compute_done && !read_done) begin
					state_next = READ;
					avl_slave_burstbegin_next = 1;
				end
			end
		end
		
		WRITE: begin
			avl_slave_write_req = 1;
			
			if(avl_master_ready) begin // Start/Continue Writing fake data if PCIE interface not available
				avl_slave_burstbegin_next = 1;
				avl_slave_addr_next = avl_slave_addr + 1;
				
				if (avl_slave_addr < `weight_base) begin					// write Kernel Bias:
					avl_slave_wdata = {{39{1'b0}}, avl_slave_addr};		// sequential data -> 0 to 95
				end
				else if (avl_slave_addr < `img_base) begin				// write Kernel Wts:
					avl_slave_wdata = {{63{1'b0}}, 1'b1};					// all 1's
				end
				else if (avl_slave_addr < `out_base) begin											// write Image Data:
					if(avl_slave_addr < img_base_64b + ifm_size_64b) begin
						avl_slave_wdata = {{39{1'b0}}, avl_slave_addr} - img_base_64b; 		// Chan 1 - 0 to IFM_SIZE-1
					end
					else if(avl_slave_addr < img_base_64b + ifm_size_64b_x2) begin
						avl_slave_wdata = {{39{1'b0}}, avl_slave_addr} - img_base_64b - ifm_size_64b + 64'd1;		// Chan 2 - 1 to IFM_SIZE
					end
					else begin
						avl_slave_wdata = {{39{1'b0}}, avl_slave_addr} - img_base_64b - ifm_size_64b_x2 + 64'd2;	// Chan 3 - 2 to IFM_SIZE+1
					end
				end
				else if (avl_slave_addr < `out_base + `OFM_SIZE * `M) begin
					avl_slave_wdata = {{58{1'b0}}, out1_count};
					out2_count_next = out2_count + 1;
					
					if(out2_count == `OFM_SIZE - 1) begin
						out1_count_next = out1_count + 1;
						out2_count_next = 0;
					end
					
					if(avl_slave_addr == `out_base + `OFM_SIZE * `M - 1) begin
						state_next = WRITE_CHECK;
						avl_slave_burstbegin_next = 0;
						avl_slave_addr_next = 0;
					end
				end
			end
			else avl_slave_burstbegin_next = 0;
		end
		
		WRITE_CHECK: begin
			avl_slave_read_req = (mem_wr_done) ? 0 : 1;
			if((avl_slave_addr == `out_base) && mem_load_done) state_next = WAIT;
			
			if(avl_master_ready) begin 								// read back the written data to check data integrity
				avl_slave_burstbegin_next = (mem_wr_done) ? 0 : 1;
				avl_slave_addr_next = (mem_wr_done) ? avl_slave_addr : avl_slave_addr + 1;
					
				if(avl_slave_addr == `out_base-1) begin			// init done, wait for compute
					avl_slave_burstbegin_next = 0;
					mem_wr_done_next = 1;
				end
			end
			else avl_slave_burstbegin_next = 0;
		end
		
		READ: begin
			avl_slave_read_req = 1;
			
			if(avl_master_ready) begin
				avl_slave_burstbegin_next = 1;
				avl_slave_addr_next = avl_slave_addr + 1;			// continue from out_base offset
				
				if(avl_slave_addr == `out_base + `OFM_SIZE * `M - 1) begin
					state_next = WAIT;
					avl_slave_burstbegin_next = 0;
					read_done_next = 1;
				end
			end
			else avl_slave_burstbegin_next = 0;
		end
		
		default: state_next = WAIT;
	endcase
end

// Controller Registers
always@(posedge clk)
begin
	if(!reset_n) begin
		state <= WAIT;
		avl_slave_addr <= 0;;
		avl_slave_burstbegin <= 0;
		write_check_fail <= 0;
		read_done <= 0;
		check_count <= 0;
		mem_wr_done <= 0;
		out1_count = 0;
		out2_count = 0;
	end
	else begin
		state <= state_next;
		avl_slave_addr <= avl_slave_addr_next;
		avl_slave_burstbegin <= avl_slave_burstbegin_next;
		write_check_fail <= write_check_fail_next;
		read_done <= read_done_next;
		check_count <= check_count_next;
		mem_wr_done <= mem_wr_done_next;
		out1_count = out1_count_next;
		out2_count = out2_count_next;
	end
end
//============ Initialization ends ===============
	
//===== Check Data integrity and Computation =====
ram rom(val, count_next, 0, 1'b0, clk); 				// instantiate ROM

always@(*)
begin
	write_check_fail_next = write_check_fail;
	check_count_next = check_count;
	count_next = count;
	fail_next = (fail) ? 1'b1 : (write_check_fail) ? 1'b1 : 1'b0;
	
	case(state) 
		WRITE_CHECK: begin		// check written data
			if(avl_master_rdata_valid && !write_check_fail) begin
				check_count_next = check_count + 1;
			
				if (check_count < `weight_base) begin			// check Kernel Bias
					write_check_fail_next = (avl_master_rdata != {{39{1'b0}}, check_count}) ? 1'b1 : 1'b0;
				end
				else if (check_count < `img_base) begin			// check Kernel Wts
					write_check_fail_next = (avl_master_rdata != {{63{1'b0}}, 1'b1}) ? 1'b1 : 1'b0;
				end
				else if (check_count < `out_base) begin			// check Image Data
					if(check_count < img_base_64b + ifm_size_64b) begin
						write_check_fail_next = (avl_master_rdata != {{39{1'b0}}, check_count} - img_base_64b) ? 1'b1 : 1'b0;
					end
					else if(check_count < img_base_64b + ifm_size_64b_x2) begin
						write_check_fail_next = (avl_master_rdata != {{39{1'b0}}, check_count} - img_base_64b - ifm_size_64b + 64'd1) ? 1'b1 : 1'b0;
					end
					else begin
						write_check_fail_next = (avl_master_rdata != {{39{1'b0}}, check_count} - img_base_64b - ifm_size_64b_x2 + 64'd2) ? 1'b1 : 1'b0;
					end
				end
			end
		end
		
		READ: begin												// check convolution self-computed data (fake data)
			if(avl_master_rdata_valid) begin
				count_next = count + 1;
				
				if(avl_master_rdata != val) begin		// check correctness of each value
					fail_next = 1;
				end
			end
		end
	endcase
end

always@(posedge clk)
begin
	count <= (!reset_n) ? 0 : count_next;
	fail <= (!reset_n) ? 0 : fail_next;
end
//=========== Computation Check End ============


//==================================================================
//======== SDRAM Read/Write Interface for PCIE HIP Begins ==========
//==================================================================

// Local Parameter 
	localparam		DDR3_WAIT = 0;
	localparam		DDR3_WRITE = 1;
	localparam		DDR3_WRITE_FINISH = 2;
	localparam		DDR3_READ = 3;
	localparam		DDR3_READ_FINISH = 4;
	localparam		ONCHIP_MEM_DEPTH = 16384; // Change this if changed in Qsys system

// Local signals
	reg  [2:0]	ddr3_state, ddr3_state_next;
	reg  [2:0]	pcie_req_action;
	reg  [24:0] sdram_addr_count, sdram_addr_count_next;
	reg  [13:0] ocmem_addr_count, ocmem_addr_count_next;
	reg  [13:0] addr_count, addr_count_next;
	reg  [31:0] addr_offset, addr_offset_next;
	reg  [31:0] readdata;
	reg			pcie_readdatavalid_next, pcie_read_req_prev;
	reg			pcie_read_stall;
	reg  [31:0] pcie_readdata_next;
	reg  [3:0]  sync_count1, sync_count2;

// Default values
	assign sdram_size = 1;
	assign sdram_addr = sdram_addr_count;
	assign sdram_be = {8{1'b1}};
	assign sdram_wdata = {{32{1'b0}}, ocmem_rdata};
	assign ocmem_chipselect = 1;
	assign ocmem_wdata = sdram_rdata[31:0];
	assign ocmem_be = {4{1'b1}};
	assign ocmem_addr = (ddr3_state == DDR3_WRITE) ? ocmem_addr_count_next : ocmem_addr_count;
	assign pcie_waitrequest = 0;
	
// ----------- PCIE requested action ---------- //
// PCIE Linux Driver can:
// 1) transfer data from Host to DDR3: driver first writes to On-chip memory through BAR4,
//    then signals cent_ctrl of its completion by writing ('pcie_write_req') through BAR2.
//    
// 2) transfer data from DDR3 to Host: driver signals a read requirement by first writing
//    ('pcie_write_req') through BAR2, waits for DDR3 to On-Chip mem transfer and then reads
//    data via BAR4 to host memory.

always@(posedge pcie_clk)
begin
	if(pcie_write_req) begin
		pcie_req_action = (pcie_addr) ? DDR3_WRITE : DDR3_READ;
		sync_count1 = 0;
		addr_offset = pcie_writedata;
	end
	else if(sync_count1 == 15) begin // wait for next "clk" edge before asserting back to DDR3_WAIT
		pcie_req_action = DDR3_WAIT;  // NOTE: change max count for sync1 if frequencies changes
		addr_offset = 0;
		sync_count1 = 0;
	end
	
	sync_count1 = sync_count1 + 1;
end

always@(*)
begin
	if(pcie_read_req_prev) begin
		pcie_readdatavalid = 1;
	end
	else begin
		pcie_readdatavalid = 0;
	end
end

always@(posedge pcie_clk)
begin
	pcie_read_req_prev = pcie_read_req;
	sync_count2 = sync_count2 + 1;
	
	case(ddr3_state)
		DDR3_WAIT: pcie_read_stall = 0;
	
		DDR3_WRITE_FINISH: begin
			if(pcie_read_req)	begin
				pcie_read_stall = 1;
				sync_count2 = 0;
			end
			else if(sync_count2 == 15) begin // wait for next "clk" edge before asserting back to DDR3_WAIT
				pcie_read_stall = 0;		      // NOTE: change max count for sync2 if frequencies changes
				sync_count2 = 0;
			end
		end
	
		DDR3_READ_FINISH: begin
			if(ocmem_addr_count == ONCHIP_MEM_DEPTH-1 && pcie_read_req) begin
				pcie_read_stall = 1;
				sync_count2 = 0;
			end
			else if(sync_count2 == 15) begin // wait for next "clk" edge before asserting back to DDR3_WAIT
				pcie_read_stall = 0;		      // NOTE: change max count for sync2 if frequencies changes
				sync_count2 = 0;
			end
		end
	endcase
end
	
// State Machine
always@(*)
begin
	// Default value
	ddr3_state_next = ddr3_state;
	sdram_addr_count_next = sdram_addr_count;
	ocmem_addr_count_next = ocmem_addr_count;
	addr_count_next = addr_count;
	sdram_write_req = 0;
	sdram_read_req = 0;
	ocmem_write_req = 0;
	pcie_readdata = 0;
	
	case(ddr3_state)
		DDR3_WAIT: begin
			ddr3_state_next = pcie_req_action;
			sdram_addr_count_next = addr_offset;
			ocmem_addr_count_next = 0;
			addr_count_next = 0;
		end
		
		DDR3_WRITE: begin							// On-Chip Mem -> Off-Chip (DDR3) Mem
			sdram_write_req = 1;
			
			if(sdram_ready) begin
				sdram_addr_count_next = sdram_addr_count + 1;
				ocmem_addr_count_next = ocmem_addr_count + 1;
				if(ocmem_addr_count == ONCHIP_MEM_DEPTH-1) ddr3_state_next = DDR3_WRITE_FINISH;
			end
		end
		
		DDR3_WRITE_FINISH: begin				// Wait for the next read poll from driver
			if(pcie_read_stall) begin
				pcie_readdata = 1;
				if(sync_count2 >= 1) ddr3_state_next = DDR3_WAIT;
			end
		end
		
		DDR3_READ: begin							// Off-Chip (DDR3) Mem -> On-Chip Mem requests
			sdram_read_req = 1;
			
			if(sdram_ready) begin
				sdram_addr_count_next = sdram_addr_count + 1;
				addr_count_next = addr_count + 1;
				if(addr_count == ONCHIP_MEM_DEPTH-1) ddr3_state_next = DDR3_READ_FINISH;
			end
			
			if(sdram_rdata_valid) begin
				ocmem_addr_count_next = ocmem_addr_count + 1;
				ocmem_write_req = 1; 
			end
		end
		
		DDR3_READ_FINISH: begin					
			if(sdram_rdata_valid) begin							// finish data transfer
				if(ocmem_addr_count < ONCHIP_MEM_DEPTH-1)
					ocmem_addr_count_next = ocmem_addr_count + 1;
				ocmem_write_req = 1; 
			end
			
			if(ocmem_addr_count == ONCHIP_MEM_DEPTH-1) begin // Wait for the next read poll from driver
				if(pcie_read_stall) begin
					pcie_readdata = 2;
					if(sync_count2 >= 1) ddr3_state_next = DDR3_WAIT;
				end
			end
		end
	endcase
end

// State Machine Registers
always@(posedge clk)
begin
	if(!reset_n) begin
		ddr3_state = DDR3_WAIT;
	end
	else begin
		ddr3_state = ddr3_state_next;
	end
	
	sdram_addr_count = sdram_addr_count_next;
	ocmem_addr_count = ocmem_addr_count_next;
	addr_count = addr_count_next;
end
endmodule

// Computed expected values are stored in the RAM (for fake data)
module ram(q, a, d, we, clk);
   output reg [15:0] q;
   input      [15:0] d;
   input      [18:0] a;
   input      we, clk;
   
   (* ram_init_file = "mem_init.mif" *) reg [15:0] mem [0:524288];
   
    always @(posedge clk) begin
        if (we)
            mem[a] <= d;
        q <= mem[a];
   end
endmodule
