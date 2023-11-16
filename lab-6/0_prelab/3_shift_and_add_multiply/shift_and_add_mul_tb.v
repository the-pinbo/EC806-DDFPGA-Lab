`timescale 1ns / 1ps
`include "mul.v"
module shift_and_add_mul_tb();

    parameter N = 8;
    reg[N-1:0] data_in_a, data_in_b;
    reg start, reset, clk;
    wire[2*N-1:0] data_out;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    shift_and_add_mul #(N) uut (
        .data_in_a(data_in_a), 
        .data_in_b(data_in_b),
        .start(start), 
        .reset(reset), 
        .clk(clk),
        .data_out(data_out),
        .done(done)
    );

    // Generate clock with 10ns period
    initial begin
        clk = 0;
        repeat(40) #5 clk = ~clk;
    end

    initial begin
        $display("mul");
        $dumpfile("shift_and_add_mul.vcd");
        $dumpvars(0,shift_and_add_mul_tb);
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        reset = 1; start = 0;
        data_in_a = 0; data_in_b = 0;
        
        // Wait for global reset
        #100; 
        reset = 0;
        
        // Load inputs and start the module
        #10; 
        data_in_a = 8'd15; // Example input A
        data_in_b = 8'd3;  // Example input B
        start = 1;
        #10; 
        start = 0;

        // Wait for the operation to complete
        wait(done);
        
        // Check output
        #10;
        if (data_out === (data_in_a * data_in_b))
            $display("Test Passed. data_out = %d", data_out);
        else
            $display("Test Failed. data_out = %d, expected = %d", data_out, data_in_a * data_in_b);

        // Finish the simulation
        #50;
        $finish;
    end

    // Reset logic
    initial begin
        #300 reset = 1;
        #20 reset = 0;
    end

endmodule
