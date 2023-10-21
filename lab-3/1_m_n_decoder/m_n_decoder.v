module m_n_decoder #(
    parameter M = 2,
    N = 2**M
)(
    input[M-1:0] data_in,
    input en,
    output reg [N-1:0] data_out
);

    always @(data_in, en) begin
        if(!en)
            data_out = 'b0;
        else 
            data_out = 1<<data_in;
    end

endmodule