`timescale 1ns / 1ps

module highest_256(
  input clk, reset_n, start, ready,
  input [15:0] new_value,
  output reg taken, valid,
  output reg [15:0] largest
);
  parameter MAX_LENGTH = 8;
  localparam S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5 =3'b101, S6 =3'b110;
  reg [2:0] cp_fsm_d, cp_fsm_q;
  reg [15:0] cur_val_d, cur_val_q, hi_val_d, hi_val_q;
  reg [8:0] count_d, count_q;

  //Control path state transition 
  always @(posedge clk or negedge reset_n)begin
    if (reset_n==0) 
      cp_fsm_q <= S0; 
    else
      cp_fsm_q <= cp_fsm_d; 
  end

  // Control path NSD and OD
  always @(posedge clk) begin
    cp_fsm_d = cp_fsm_q; taken = 1'b0; valid = 1'b0;
      case (cp_fsm_q)
          S0: begin taken = 1'b1; if (start == 1'b1) cp_fsm_d = S1; end
          S1: begin cp_fsm_d = S2;  end
          S2: if (ready == 1'b1) cp_fsm_d = S3;
          S3: begin 
                taken = 1'b1; 
                if (new_value > hi_val_q) cp_fsm_d = S4; else cp_fsm_d = S5;
              end
          S4: cp_fsm_d = S5;
          S5: if (count_q > (MAX_LENGTH-1))  cp_fsm_d = S6; else cp_fsm_d = S2;
          S6: begin
                valid = 1'b1; 
                if (start == 1'b0) cp_fsm_d = S0;
              end  
          default: cp_fsm_d = S0;
      endcase
  end

  // data path operations
  always @(*) begin
    hi_val_d = hi_val_q; cur_val_d = cur_val_q; count_d = count_q; largest = {16{1'b0}};
    
    if (cp_fsm_q == S1) begin hi_val_d = {16{1'b0}}; count_d = {9{1'b0}}; end
    if (cp_fsm_q == S3) begin cur_val_d = new_value; end
    if (cp_fsm_q == S4) begin hi_val_d = cur_val_q; end
    if (cp_fsm_q == S5) begin count_d = count_q + 1; end
    if (cp_fsm_q == S6) begin largest = hi_val_q; end
      
  end

  // data path register update
  always @(posedge clk or negedge reset_n) begin
    if (reset_n==0) 
    begin
      count_q <= {9{1'b0}}; 
      hi_val_q <= {16{1'b0}}; 
    end
    else
    begin
      count_q <= count_d;
      cur_val_q <= cur_val_d;
      hi_val_q <= hi_val_d; 
    end
  end
endmodule
