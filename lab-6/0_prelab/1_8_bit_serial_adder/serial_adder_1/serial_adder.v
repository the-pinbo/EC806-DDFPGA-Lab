module serial_adder #(
    parameter N = 8
) (
    input wire clk, rstn, start,
    input wire [N-1:0] a, b,
    output wire [N-1:0] sum,
    output carry,
    output reg done
);
    wire [N-1:0] sum_internal;
    reg shift, load;
    wire [N-1:0] rega, regb;
    wire regc;
    wire dff_in, dff_out;
    reg [$clog2(N)-1:0] count_q, count_d;

    // module instantiations
    shiftReg A(clk, rstn, shift, load, a, 1'b0, rega);
    shiftReg B(clk, rstn, shift, load, b, 1'b0, regb);
    shiftReg Sum(clk, rstn, shift, load, {N{1'b0}}, regc, sum_internal);
    fullAdder C(rega[0], regb[0], dff_out, regc, dff_in);
    dff D(clk, rstn, dff_in, dff_out);
    reg [1:0] cur_state, nxt_state;

    localparam S0=2'b00, S1=2'b01, S2=2'b10, S3 =2'b11;
    assign sum = (done == 1) ? sum_internal : 'bz;
    assign carry = (done == 1) ? dff_out : 'bz;

    always @(posedge clk or negedge rstn) begin
        if (rstn==0) 
            begin
            cur_state <= S0; 
            count_q <= 0;
            end
        else
            begin
            cur_state <= nxt_state; 
            count_q <= count_d;
            end
    end

    always @(*) begin
        nxt_state = cur_state;
        shift = 0;
        load = 0;
        done = 0;
        count_d = count_q;
        case (cur_state)
            S0: begin if (start == 1) nxt_state = S1; end
            S1: begin load = 1; count_d = N-1; nxt_state = S2; end
            S2: begin shift = 1; count_d = count_q - 1; if (count_q == 0) nxt_state = S3; end
            S3: begin
                done = 1; 
                if (start == 0) nxt_state = S0;
                end  
            default: nxt_state = S0;
        endcase
    end
endmodule

// Shift reg
module shiftReg #(
    parameter N = 8
) (
    input clk, rstn, shift, load, 
    input[N-1:0] data_in, 
    input lin, 
    output[N-1:0] data_out
);
    reg [N-1:0] o_reg;
    always @(posedge clk) begin 
        if (!rstn) 
            o_reg <= 0;
        else if (load)
            o_reg <= data_in;
        else if (shift)
            o_reg <= {lin, o_reg[N-1:1]};
    end
    assign data_out = o_reg;
endmodule


// D flip flop
module dff( input clk, rstn, data_in, output data_out );
    reg o_reg;
    always @(posedge clk) begin 
        if (!rstn) 
            o_reg <= 0;
        else
            o_reg <= data_in;
    end
    assign data_out = o_reg;
endmodule


// Full Adder
module fullAdder( input a, b, cin, output sum, cout );
    assign sum = a^b^cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule