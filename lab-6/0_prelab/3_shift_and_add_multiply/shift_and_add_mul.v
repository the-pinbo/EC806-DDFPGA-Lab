module shift_and_add_mul #(
    parameter N = 8
) (
    input[N-1:0] data_in_a, data_in_b,
    input start, reset, clk,
    output[2*N-1:0] data_out, output reg done
);

    // Define state constants 
    localparam [2:0] IDLE = 'b000,
                 LOAD = 'b001,
                 COMPUTE = 'b010,
                 COMPARE = 'b110,
                 DONE = 'b011;

    // State and data registers
    reg[2:0] present_state = IDLE, next_state = IDLE;
    reg[N-1:0] reg_a, reg_b; 
    reg[2*N-1:0] reg_p;
    assign data_out = reg_p;

    reg eqz;

    // Present state register logic
    always @(posedge clk) begin: L_PRESENT_STATE_REGISTER
        if(reset) begin
            present_state <= IDLE;
        end else begin
            present_state <= next_state;
        end
    end

    // Next state logic
    always@(*) begin:L_NEXT_STATE_LOGIC
        casex(present_state)
            IDLE: next_state = start?LOAD:IDLE;
            // Load A and B from data_in
            LOAD: next_state = COMPARE;
            // Compare and see if equal to zeor
            COMPARE: next_state = eqz?DONE:COMPUTE;
            // Perform computations and update P, A, B
            COMPUTE: next_state = COMPARE;
            DONE: next_state = start?LOAD:DONE; 
            default: next_state = IDLE;
        endcase
    end

    // Data path combinational logic
    always@(*) begin: L_DATA_PATH_LOGIC
        casex(present_state)
            LOAD: begin
                reg_a = data_in_a;
                reg_b = data_in_b;
                reg_p = 'b0;
            end
            COMPUTE: begin
                reg_p = reg_p + reg_a;
                reg_b = reg_b - 'b1;
            end
            COMPARE: begin
                eqz = (reg_b == 0);
            end
            DONE: begin
                done = 'b1;
            end
            default: begin
                reg_a = 'b0; reg_b = 'b0;
                done = 'b0;
            end
        endcase
    end

endmodule