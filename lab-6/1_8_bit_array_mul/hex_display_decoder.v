module hex_display_decoder(
    input[3:0] hex_num,
    output reg[7:0] segment
);
    always @(*) begin
        case (hex_num)
            4'b0000: segment = 8'b00000011;  //a,b,c,d,e,f,g,dot (zero)
            4'b0001: segment = 8'b10011111;  //one
            4'b0010: segment = 8'b00100101;  //two
            4'b0011: segment = 8'b00001101;  //three
            4'b0100: segment = 8'b10011001;  //four
            4'b0101: segment = 8'b01001001;  //five
            4'b0110: segment = 8'b01000001;  //six
            4'b0111: segment = 8'b00011111;  //seven
            4'b1000: segment = 8'b00000001;  //eight
            4'b1001: segment = 8'b00001001;  //nine
            4'b1010: segment = 8'b00010001;  //A
            4'b1011: segment = 8'b11000001;  //B
            4'b1100: segment = 8'b01100011;  //C
            4'b1101: segment = 8'b10000101;  //D
            4'b1110: segment = 8'b01100001;  //E
            4'b1111: segment = 8'b01110001;  //F
        endcase
    end
endmodule