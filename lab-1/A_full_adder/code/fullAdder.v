module fullAdder(
  ai,
  bi,
  ci,
  sum,
  cout
);
  // Structural model of the full adder
  input ai,bi,ci;
  output sum,cout;
  wire t1,t2,t3;
  xor(sum,ai,bi,ci);
  and(t1,ai,bi);
  and(t2,ai,ci);
  and(t3,ci,bi);
  or(cout,t1,t2,t3);
  
endmodule