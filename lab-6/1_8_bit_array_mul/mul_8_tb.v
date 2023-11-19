`timescale 1ns/1ns

`include "mul_8.v"

module mul_8_tb;

    parameter N = 8;
    parameter CLK_PERIOD = 100;

    reg[N-1:0] data_in;
    reg load_a, load_b, clk, clr;
    wire[2*N-1:0] product;
    reg[2*N-1:0] expected_product;

    mul_8 uut(.data_in(data_in), .load_a(load_a), .load_b(load_b), .clk(clk), .clr(clr), .product(product));

    initial begin
        clr = 1; load_a = 0; load_b = 0;
        $display("mul_8");
        $dumpfile("mul_8.vcd");
        $dumpvars(0,mul_8_tb);
    end

    // clock generation
    initial
        forever #(CLK_PERIOD/2) clk <= ~clk;
        

    task test_case(input [N-1:0] in1, in2);
    begin
        expected_product = in1*in2;
        #10;

        clr = 0; 
        load_a = 1; data_in = in1;
        #100

        load_a = 0;
        load_b = 1; data_in = in2;
        #100

        load_b = 0; data_in = 'bz;
        #100

        // Check the result
        if (product != expected_product)
            $display("Test failed: %d * %d = %d (expected %d)", in1, in2, product, expected_product);
        else
            $display("Test passed: %d * %d = %d", in1, in2, product);
    end
endtask
    integer i;
    initial begin
        clk = 0;
        // for(i = 0; i<(2**(N))**2;i = i + 1)begin
        //     test_case(i[2*N-1:N],i[N-1:0]);
        // end
        test_case('HFF,'HFE);
        $finish;
    end

endmodule