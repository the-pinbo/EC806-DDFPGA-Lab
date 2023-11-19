`include "serial_adder.v"
`timescale 1ns/1ns

module serial_adder_tb;

    reg clk, rst;
    reg [7:0] a, b;
    reg start;
    wire [7:0] sum;
    wire carry;
    wire done;

    serial_adder UUT(clk, rst, start, a, b, sum, carry, done);

    always begin
        clk = 0;
        forever clk = #5 ~clk;
    end

    always begin
        #0 rst = 1;
        #5 rst = 0; start = 1;
        #10 a = 8'b0011; rst = 1; b = 8'b0111;
        #10 start = 0;
        #100;
        $finish;
    end

    initial begin
        $dumpfile("serial_adder_tb.vcd");
        $dumpvars(0, serial_adder_tb);
    end

    always @(done) 
    if (done ==1)
    #100 $finish;
endmodule