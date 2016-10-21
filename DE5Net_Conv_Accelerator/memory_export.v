module memory_export (
input				clk,
output  			read_n,
output  			write_n,
output  			chipselect,
input 			waitrequest,
output  [31:0] address,
output  [1:0] 	byteenable,
input				readdatavalid,
input   [15:0]	readdata,
output  [15:0] writedata,
input				reset_n,

input  			read_n_ex,
input  			write_n_ex,
input  			chipselect_ex,
output 			waitrequest_ex,
input   [31:0]	address_ex,
input   [1:0] 	byteenable_ex,
output			readdatavalid_ex,
output  [15:0]	readdata_ex,
input   [15:0] writedata_ex,
output			reset_n_ex
);
assign read_n 			= read_n_ex;
assign write_n 			= write_n_ex;
assign chipselect 		= chipselect_ex;
assign waitrequest_ex 	= waitrequest;
assign address 			= address_ex;
assign byteenable 		= byteenable_ex;
assign readdatavalid_ex = readdatavalid;
assign readdata_ex 		= readdata;
assign writedata 			= writedata_ex;
assign reset_n_ex 		= reset_n;



endmodule