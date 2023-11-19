//`include "n_bit_array_mul.v"
//`include "n_bit_pipo.v"
//`include "hex_display_decoder.v"

module mul_8(
    input[N-1:0] data_in,
    input load_a, load_b, clk, clr_n,
    output[27:0] segment,
    output[N-1:0] data_out,
    output[2*N-1:0] product
);
    localparam N = 8;
	 wire clr;
	 assign clr = ~clr_n;
    wire[N-1:0] a,b;
    n_bit_pipo #(.N(N)) pipo_a(.clk(clk), .clr(clr), .load(load_a), .d(data_in), .q(a)),
        pipo_b(.clk(clk), .clr(clr), .load(load_b), .d(data_in), .q(b));
    wire[2*N-1:0] w_product;
    n_bit_array_mul #(.N(N)) mul(a,b,w_product);
    n_bit_pipo #(.N(2*N)) pipo_out(.clk(clk), .clr(clr), .load(1'b1), .d(w_product), .q(product));

    // assign data_out to display the values in the registers
    assign data_out = (load_a?a:(load_b?b:8'bz));
	//  assign data_out = data_in;

    hex_display_decoder display_1(.hex_num(product[3:0]), .segment(segment[6:0])),
        display_2(.hex_num(product[7:4]), .segment(segment[13:7])),
        display_3(.hex_num(product[11:8]), .segment(segment[20:14])),
        display_4(.hex_num(product[15:12]), .segment(segment[27:21]));
		//   display_3(.hex_num(data_in[3:0]), .segment(segment[20:14])),
        // display_4(.hex_num(data_in[7:4]), .segment(segment[27:21]));
		  
		  
    
endmodule