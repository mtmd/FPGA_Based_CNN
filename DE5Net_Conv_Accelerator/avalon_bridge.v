module avalon_bridge (
	clk,
	reset_n,

	avl_master_ready,
	avl_master_addr,
	avl_master_rdata_valid,
	avl_master_rdata,
	avl_master_wdata,
	avl_master_be,
	avl_master_read_req,
	avl_master_write_req,
	avl_master_size,

	avl_slave_ready,
	avl_slave_addr,
	avl_slave_rdata_valid,
	avl_slave_rdata,
	avl_slave_wdata,
	avl_slave_be,
	avl_slave_read_req,
	avl_slave_write_req,
	avl_slave_size
);

	// Parameters
	parameter ADDR_WIDTH   = 64;
	parameter DATA_WIDTH_M = 64;
	parameter BE_WIDTH_M	  = 8;
	parameter DATA_WIDTH_S = 64;
	parameter BE_WIDTH_S	  = 8;
	parameter MAX_BSIZE   = 1;
	
	// Clock and reset
	input               clk;
	input               reset_n;

	// Master interface
	input               			avl_master_ready;                 //              avl.waitrequest_n
	output [ADDR_WIDTH-1:0]    avl_master_addr;                  //                 .address
	input               			avl_master_rdata_valid;           //                 .readdatavalid
	input  [DATA_WIDTH_M-1:0]  avl_master_rdata;                 //                 .readdata
	output [DATA_WIDTH_M-1:0]  avl_master_wdata;                 //                 .writedata
	output [BE_WIDTH_M-1:0]    avl_master_be;                    //                 .byteenable
	output              			avl_master_read_req;              //                 .read
	output              			avl_master_write_req;             //                 .write
	output [MAX_BSIZE-1:0]     avl_master_size;
	
	// Slave Interface
	output             			avl_slave_ready;                  //              avl.waitrequest_n
	input  [ADDR_WIDTH-1:0]    avl_slave_addr;                  //                 .address
	output             			avl_slave_rdata_valid;           //                 .readdatavalid
	output [DATA_WIDTH_S-1:0]  avl_slave_rdata;                 //                 .readdata
	input  [DATA_WIDTH_S-1:0]  avl_slave_wdata;                 //                 .writedata
	input  [BE_WIDTH_S-1:0]    avl_slave_be;                    //                 .byteenable
	input              			avl_slave_read_req;              //                 .read
	input              			avl_slave_write_req;             //                 .write
	input  [MAX_BSIZE-1:0]      avl_slave_size;

assign avl_slave_ready = avl_master_ready;
assign avl_master_addr = avl_slave_addr;
assign avl_slave_rdata_valid = avl_master_rdata_valid;
assign avl_master_size = avl_slave_size;

generate if (DATA_WIDTH_S < DATA_WIDTH_M) begin
		assign avl_slave_rdata = avl_master_rdata[DATA_WIDTH_S-1:0];
		assign avl_master_wdata = {{DATA_WIDTH_M-DATA_WIDTH_S{1'b0}}, avl_slave_wdata};
		assign avl_master_be = {{BE_WIDTH_M-BE_WIDTH_S{1'b0}}, avl_slave_be};
	end
	else begin
		assign avl_slave_rdata = {{DATA_WIDTH_S-DATA_WIDTH_M{1'b0}}, avl_master_rdata};
		assign avl_master_wdata = avl_slave_wdata[DATA_WIDTH_M-1:0];
		assign avl_master_be = avl_slave_be[BE_WIDTH_M-1:0];
	end
endgenerate

assign avl_master_read_req = avl_slave_read_req;
assign avl_master_write_req = avl_slave_write_req;

endmodule
