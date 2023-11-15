`include "n_bit_array_mul.v"

module array_mul_tb;

    parameter N = 4;

    reg[N-1:0] a, b;
    wire[2*N-1:0] product;
    reg[2*N-1:0] expected_product;
    n_bit_array_mul #(.N(N)) uut(a,b,product);

    initial begin
        $display("array mul");
        $monitor("a=%b b=%b product=%b",a,b,product);
        $dumpfile("array_mul.vcd");
        $dumpvars(0,array_mul_tb);
    end

    task test_case(input [N-1:0] in1, in2);
    begin
        expected_product = in1*in2;
        a = in1;
        #5
        b = in2;
        #5
        #100;
        // Check the result
        if (product != expected_product)
            $display("Test failed: %d * %d = %d (expected %d)", a, b, product, expected_product);
        else
            $display("Test passed: %d * %d = %d", a, b, product);
    end
endtask
    integer i;
    initial begin
        for(i = 0; i<(2**(N))**2;i = i + 1)begin
            test_case(i[2*N-1:N],i[N-1:0]);
        end
    end

endmodule