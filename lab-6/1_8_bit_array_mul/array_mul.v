`include "n_bit_array_mul.v"
`include "n_bit_pipo.v"

module array_mul #(
    parameter N = 8
) (
    input[N-1:0] data_in,
    input load_a, load_b, clk, clr,
    output[2*N-1:0] product
);
    wire[N-1:0] a,b;
    n_bit_pipo #(.N(N)) pipo_a(.clk(clk), .clr(clr), .load(load_a), .d(data_in), .q(a)),
        pipo_b(.clk(clk), .clr(clr), .load(load_b), .d(data_in), .q(b));
    wire[2*N-1:0] w_product;
    n_bit_array_mul #(.N(N)) mul(a,b,w_product);
    n_bit_pipo #(.N(2*N)) pipo_out(.clk(clk), .clr(clr), .load(1'b1), .d(w_product), .q(product));

endmodule