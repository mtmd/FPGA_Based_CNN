module memory_export2 (
	
	clk,
	reset_n,
	
	avl_master_chipselect,
	avl_master_addr,
	avl_master_rdata,
	avl_master_wdata,
	avl_master_be,
	avl_master_write_req,
	avl_master_waitrequest,

	avl_slave_chipselect,
	avl_slave_addr,
	avl_slave_rdata,
	avl_slave_wdata,
	avl_slave_be,
	avl_slave_write_req,
	avl_slave_waitrequest
);

	// Parameters
	parameter ADDR_WIDTH   = 64;
	parameter DATA_WIDTH_M = 64;
	parameter BE_WIDTH_M	  = 8;
	parameter DATA_WIDTH_S = 64;
	parameter BE_WIDTH_S	  = 8;
	
	// Clock and reset
	input               clk;
	input               reset_n;

	// Master interface
	output               			avl_master_chipselect;                 //              avl.waitrequest_n
	output [ADDR_WIDTH-1:0]    avl_master_addr;                  //                 .address
	input  [DATA_WIDTH_M-1:0]  avl_master_rdata;                 //                 .readdata
	output [DATA_WIDTH_M-1:0]  avl_master_wdata;                 //                 .writedata
	output [BE_WIDTH_M-1:0]    avl_master_be;                    //                 .byteenable
	output              			avl_master_write_req;             //                 .write
	input						avl_master_waitrequest;
	
	// Slave Interface
	input             			avl_slave_chipselect;                  //              avl.waitrequest_n
	input  [ADDR_WIDTH-1:0]    avl_slave_addr;                  //                 .address
	output [DATA_WIDTH_S-1:0]  avl_slave_rdata;                 //                 .readdata
	input  [DATA_WIDTH_S-1:0]  avl_slave_wdata;                 //                 .writedata
	input  [BE_WIDTH_S-1:0]    avl_slave_be;                    //                 .byteenable
	input              			avl_slave_write_req;             //                 .write
	output						avl_slave_waitrequest;

assign avl_master_chipselect = avl_slave_chipselect;
assign avl_master_addr = avl_slave_addr;
assign avl_slave_waitrequest = avl_master_waitrequest;

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

assign avl_master_write_req = avl_slave_write_req;

endmodule
