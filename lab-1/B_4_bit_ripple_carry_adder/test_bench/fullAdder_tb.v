`timescale 1ps/1ps
`include "adder4.v"

module adder4_tb;
  reg a[3:0],b[3:0],ci;
  wire sum[3:0],cout;
  adder4 uut(ai, bi, ci, sum, cout);
  initial 
  begin 
    $dumpfile("adder4.vcd");
    $dumpvars(0,adder4);
    reg [8:0] pal ;
    for(pal = 0; pal < 512; pal = pal + 1)
    begin
      {a,b,ci} <= pal;
      #50;
    end
    $display("Test Complete");
  end

endmodule