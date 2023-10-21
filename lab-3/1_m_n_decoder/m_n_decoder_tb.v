`timescale 1ps/1ps
`include "m_n_decoder.v"

module m_n_decoder_tb;
    parameter M = 4;
    reg[M-1:0] data_in;
    reg en;
    wire[2**M-1:0] data_out; 
    m_n_decoder #(.M(M)) dut(.data_in(data_in), .en(en), .data_out(data_out));
    
    integer i;
    initial begin
        for(i = 0; i<1<<(M+1); i=i+1)begin
            {en,data_in} <= i;
            #50;
        end
    end

    initial begin
        $display("M:N Decoder");
        $monitor("At time %t, en=%b, data_in=%b, data_out=%b\n",$time, en, data_in, data_out);
        $dumpfile("m_n_decoder.vcd");
        $dumpvars(0,m_n_decoder_tb);
    end
endmodule
