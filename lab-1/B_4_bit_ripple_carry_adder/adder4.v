module adder4 (input [3:0] A, input [3:0] B, input Ci, output [3:0] S, output Co);
  wire C [3:1];
  `include "fullAdder.v"
  fullAdder
    ufa1(.a(A[0]), .b(B[0]), .cin(Ci), .sum(S[0]), .cout(C[1])),
    ufa2(A[1], B[1], C[1], S[1], C[2]),
    ufa3(A[2], B[2], C[2], S[2], C[3]),
    ufa4(A[3], B[3], C[3], S[3], Co);
endmodule