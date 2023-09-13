`timescale 1ps/1ps
`include "fullAdder.v"

module fullAdder_tb;
  reg ai,bi,ci;
  wire sum,cout;
  fullAdder uut(ai, bi, ci, sum, cout);
  initial 
  begin 
    $dumpfile("fullAdder.vcd");
    $dumpvars(0,fullAdder);
    reg [2:0] pal ;
    for(pal = 0; pal < 8; pal = pal + 1)
    begin
      {ai,bi,ci} <= pal;
      #50;
    end
    $display("Test Complete");
  end

endmodule