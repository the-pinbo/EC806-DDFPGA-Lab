`include "shift_reg.v"
`include "full_adder.v"
`include "d_ff.v"

module serial_adder #(
    parameter N = 8
) (
    input[N-1:0] data_in_a, data_in_b,
    input clk, start, load,
    output[N-1:0] sum
);
    wire w_sum_i;
    wire[N-1:0] w_a_sum, w_b;
    shift_reg #(.N(8)) reg_a_sum(.clk(clk), .load(load_a), .data_in_msb(w_sum_i), .data_in_bus(data_in_a), .data_out_bus(w_a_sum)),
        reg_b_sum(.clk(clk), .load(load_b), .data_in_msb(w_b[0]), .data_in_bus(data_in_b), .data_out_bus(w_b));
    wire w_cout_i, w_cin_i;
    d_ff d(.data_in(w_cin_i), .clk(clk), .reset_n(reset_n), .q(w_cout_i));
    full_adder fa(.in_1(w_a_sum[0]), .in_2(w_b[0]), .carry_in(w_cin_i), .carry_out(w_cout_i), .sum(w_sum_i));

endmodule