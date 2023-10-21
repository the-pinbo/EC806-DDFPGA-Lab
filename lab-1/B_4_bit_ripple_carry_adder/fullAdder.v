module fullAdder(input a,b,cin, output sum,cout);
  // Data flow model of full adder
  assign sum = a^b^cin;
  assign cout = (a&b)|(a&cin)|(b&cin);
endmodule