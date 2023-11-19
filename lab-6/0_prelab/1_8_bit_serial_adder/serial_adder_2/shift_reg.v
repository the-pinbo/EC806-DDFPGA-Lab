module shift_reg
#(
    parameter N = 8
)(
    input clk, load, data_in_msb, 
    input[N-1:0] data_in_bus, 
    output reg [N-1:0] data_out_bus
);

    always@(posedge clk) begin
        if(load)
            data_out_bus <= data_in_bus;
        else begin
            data_out_bus <= {data_in_msb, data_out_bus[N-1:1]};
        end
    end

endmodule