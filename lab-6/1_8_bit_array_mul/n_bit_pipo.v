module n_bit_pipo #(
    parameter N = 8
) (
    input clk, clr, load,
    input [N-1:0] d,
    output reg [N-1:0] q
);
    
    always @(posedge clk or posedge clr) begin
        if(clr)
            q <= 'b0;
        else if(load)
            q <= d;
        else
            q <= q;
    end


endmodule