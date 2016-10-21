//A
//
module toSevenSeg (in, out);
input [3 : 0] in;
output reg [6 : 0] out; // out format is {g, f, e, d, c, b, a}
always @(in)
	case (in)
		4'h0: out = 7'b1000000; // 0
		4'h1: out = 7'b1111001; // 1
		4'h2: out = 7'b0100100; // 2
		4'h3: out = 7'b0110000; // 3
		4'h4: out = 7'b0011001; // 4
		4'h5: out = 7'b0010010; // 5
		4'h6: out = 7'b0000010; // 6
		4'h7: out = 7'b1111000; // 7
		4'h8: out = 7'b0000000; // 8
		4'h9: out = 7'b0011000; // 9
		4'hA: out = 7'b0001000; // A
		4'hB: out = 7'b0000011; // B
		4'hC: out = 7'b1000110; // C
		4'hD: out = 7'b0100001; // D
		4'hE: out = 7'b0000110; // E
		4'hF: out = 7'b0001110; // F
		
	endcase
endmodule 