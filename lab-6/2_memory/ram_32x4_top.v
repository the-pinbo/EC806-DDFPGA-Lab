module ram_32x4_top(
	input clk,
	input [4:0]address,
	input [3:0]data_in,
	input write,
	output [6:0] segment_addr_4_4, segment_addr_3_0, segment_data_in, segment_data_out
);
	
	wire [3:0] data_out;
	ram32x4 ram (address, clk, data_in, write, data_out);
	hex_display_decoder decode_addr_4_4 ({3'b0,address[4]}, segment_addr_4_4),
		decode_addr_3_0 (address[3:0], segment_addr_3_0),
		decode_data_in (data_in, segment_data_in),
		decode_data_out (data_out, segment_data_out);
	
endmodule