`timescale 1ns / 1ps
`include "highest_256.v"

module highest256_tb;
  parameter t_PERIOD =100;
  reg clk, reset_n, data, start, ready;
  reg [15:0] new_value;
  wire taken, valid;
  wire [15:0] largest;

  integer data_file_in,scan_file; 

  highest_256 uut(clk, reset_n, start, ready, new_value,taken, valid,largest);

  //clock generation

  initial
  begin
      clk =0; reset_n =0; data =0; start =0; ready=0;
      #150 reset_n = 1;
      #200 start = 1;
      
      data_file_in = $fopen("./input_data.txt", "r");   
  end

  initial
      forever #(t_PERIOD/2) clk <= ~clk;

  always @(posedge taken) 
    begin  
      ready = 0;
      #t_PERIOD;
      if (!$feof(data_file_in))
        begin
          scan_file = $fscanf(data_file_in, "%h\n", new_value);
          ready = 1;
      end
      //  else 
      //    $finish;
    end
        
  always @(valid)   
    begin
      if (valid ==1)
          begin
          $fclose(data_file_in);
          $finish;	
        end
    end

  initial begin
    $dumpfile("highest256.vcd");
    $dumpvars(0, highest256_tb);
  end

endmodule
