// instantiate so it works on the FGPA
module hex_display(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, KEY);
    input [7:0] SW; //A = SW[7:4], B = SW[3:0]
    input [2:0] KEY; //Function
    output [9:0] LEDR; //display ALUout
    output [6:0] HEX0; //B
    output [6:0] HEX1; //0
    output [6:0] HEX2; //A
    output [6:0] HEX3; //0
    output [6:0] HEX4; //ALUout[3:0]
    output [6:0] HEX5; //ALUout[7:4]

    wire [7:0] out; //[7:4] in HEX5, [3:0] in HEX4
    part3 adder(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .Function(KEY[2:0]),
        .ALUout(LEDR[7:0]))
    );

    //display of A
    hex_decoder u2(.c(SW[7:4]), .display(HEX2));
    //display of B
    hex_decoder u0(.c(SW[3:0]), .display(HEX0));
    //display 0
    hex_decoder u1(.c(4'b0000),.display(HEX1));
    //display 0
    hex_decoder u3(.c(4'b0000), .display(HEX3));

    //sums/other outputs from ALUout:
    hex_decoder u4(.c(out[3:0]), .display(HEX4));
    hex_decoder u5(.c(out[7:4]), .display(HEX5));
endmodule

module hex_decoder(c, display);
    input [3:0] c;
    output [6:0] display;

    assign display[0] = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & c[2] & ~c[1] & ~c[0]
                         | c[3] & ~c[2] & c[1] & c[0] | c[3] & c[2] & ~c[1] & c[0];

    assign display[1] = ~c[3] & c[2] & ~c[1] & c[0] | ~c[3] & c[2] & c[1] & ~c[0]
                         | c[3] & ~c[2] & c[1] & c[0] | c[3] & c[2] & ~c[1] & ~c[0] 
                         | c[3] & c[2] & c[1] & ~c[0] | c[3] & c[2] & c[1] & c[0];

    assign display[2] = ~c[3] & ~c[2] & c[1] & ~c[0] | c[3] & c[2] & ~c[1] & ~c[0]
                         | c[3] & c[2] & c[1] & ~c[0] | c[3] & c[2] & c[1] & c[0];

    assign display[3] = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & c[2] & ~c[1] & ~c[0]
                         | ~c[3] & c[2] & c[1] & c[0] | c[3] & ~c[2] & c[1] & ~c[0] 
                         | c[3] & c[2] & c[1] & c[0];

    assign display[4] = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & ~c[2] & c[1] & c[0]
                         | ~c[3] & c[2] & ~c[1] & ~c[0] | ~c[3] & c[2] & ~c[1] & c[0] 
                         | ~c[3] & c[2] & c[1] & c[0] | c[3] & ~c[2] & ~c[1] & c[0];

    assign display[5] = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & ~c[2] & c[1] & ~c[0]
                         | ~c[3] & ~c[2] & c[1] & c[0] | ~c[3] & c[2] & c[1] & c[0] 
                         | c[3] & c[2] & ~c[1] & c[0];

    assign display[6] = ~c[3] & ~c[2] & ~c[1] & ~c[0] | ~c[3] & ~c[2] & ~c[1] & c[0]
                         | ~c[3] & c[2] & c[1] & c[0] | c[3] & c[2] & ~c[1] & ~c[0];
endmodule

module part3(A, B, Function, ALUout);
    input [3:0] A;
    input [3:0] B;
    input [2:0] Function;
    output reg [7:0] ALUout;

    wire [4:0]FA_out;

    part2 adder(
        .a(A),
        .b(B),
        .c_in(1'b0),
        .s(FA_out[3:0]),
        .c_out(FA_out[4])
    );

    wire [4:0] regsum;
    assign regsum = A + B;
    // combinational: always @(*)
    // sequential: always @(inputs...)

    always @(*)
    begin
        case (Function)
            3'b000: ALUout = {3'b000, FA_out[4:0]};
            3'b001: ALUout = {3'b000, regsum};
            3'b010: ALUout = {{4{B[3]}}, B};
            3'b011: ALUout = {7'b0000000, |{A,B}}; // | is reudction to 1 bit
            3'b100: ALUout = {7'b0000000, &{A,B}}; // & is reduction to 1 bit
            3'b101: ALUout = {A,B};
            default: ALUout = 8'b00000000;
        endcase
    end
endmodule

module part2(a, b, c_in, s, c_out);
    // 2 4-bit inputs
    // must write these declarations in multi-line apparently
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