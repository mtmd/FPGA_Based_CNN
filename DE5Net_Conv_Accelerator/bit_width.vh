`ifndef _bit_width_vh_
`define _bit_width_vh_

`define DATA_WIDTH 16
`define RAM_ADR_W 25

`define IFM_ADR_W 16	// size = 227 * 227
`define OFM_ADR_W 12 // size = 55 * 55
`define WGHT_ADR_W 7 // size = 11 * 11


`define M_IDX_SZ 8 // M < 256 * Tm
`define N_IDX_SZ 8 // N < 256 * Tn

`define WGHT_CNTR_W 8 //`KERNEL_SIZE * `Tn = 242
`endif


