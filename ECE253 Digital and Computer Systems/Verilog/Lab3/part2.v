module part2(a, b, c_in, s, c_out);
    // 2 4-bit inputs
    // must write these declarations in multi line apparently
    input [3:0] a;
    input [3:0] b;
    input c_in; 

    output [3:0] s;
    output [3:0] c_out; //4-bit sum and 1-bit carry out

    //wire c_out0, c_out1, c_out2; //carry out becomes carry in

    full_adder u0(
      .a(a[0]),
      .b(b[0]),
      .c_in(c_in),
      .s(s[0]),
      .c_out(c_out[0])
    );
    full_adder u1(
      .a(a[1]),
      .b(b[1]),
      .c_in(c_out[0]),
      .s(s[1]),
      .c_out(c_out[1])
    );
    full_adder u2(
      .a(a[2]),
      .b(b[2]),
      .c_in(c_out[1]),
      .s(s[2]),
      .c_out(c_out[2])
    );
    full_adder u3(
      .a(a[3]),
      .b(b[3]),
      .c_in(c_out[2]),
      .s(s[3]),
      .c_out(c_out[3]) //final carry out
    );
endmodule

module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;
    assign s = (a^b) ^ c_in;
    assign c_out = a^b ? c_in : b;
endmodule