`ifndef _cnn_parameters_vh
`define _cnn_parameters_vh
`define conv1BiasSz 	 	64'd96
`define conv1KernelSz	64'd34848
`define imgSz 				64'd154587
`define data_sz  			`conv1BiasSz + `conv1KernelSz + `imgSz

`define weight_base  	`conv1BiasSz
`define img_base  		`conv1KernelSz + `conv1BiasSz
`define out_base  		`data_sz

`define Wout   			64'd55
`define Hout  				64'd55
`define M  					64'd96
`define N  					64'd3
`define Ki  				64'd11
`define Kj  				64'd11

`define Tw  				64'd55//50//5
`define Th  				64'd55//25//5
`define Tm  				64'd8//3//2
`define Tn  				64'd2//3//2
`define Ti  				64'd11//5//3
`define Tj  				64'd11//5//3

`define S  					64'd4
`define pad  				0
`define Hin  				64'd227
`define Win  				64'd227

`define IFM_SIZE			(`Win * `Hin) 
`define KERNEL_SIZE		(`Ki * `Kj)
`define OFM_SIZE			(`Wout * `Hout)
`endif