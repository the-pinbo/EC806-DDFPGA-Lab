module Timer (
    input clk, reset,
    output reg TS, TLH, TLN
);

    reg [31:0] counter; // 32-bit counter

    // Assuming the clock frequency is 1Hz (one tick per second)
    parameter TS_VALUE = 5; // 5 seconds
    parameter TLH_VALUE = 60; // 60 seconds
    parameter TLN_VALUE = 20; // 20 seconds

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 32'b0;
            TS <= 1'b0;
            TLH <= 1'b0;
            TLN <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == TS_VALUE) begin
                TS <= 1'b1;
            end else if (counter == TLH_VALUE) begin
                TLH <= 1'b1;
            end else if (counter == TLN_VALUE) begin
                TLN <= 1'b1;
                counter <= 32'b0; // Reset the counter after TLN_VALUE seconds
            end else begin
                TS <= 1'b0;
                TLH <= 1'b0;
                TLN <= 1'b0;
            end
        end
    end

endmodule