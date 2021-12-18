module part2(Clock, Reset_b, Data, Function, ALUout);
    input Clock;
    input Reset_b;
    input [3:0] Data;
    input [2:0] Function;
    output reg [7:0] ALUout;
    
    wire [3:0] A = Data;
    wire [3:0] B;
    wire [4:0] regsum;
    wire [7:0] regmult;
    assign regsum = A + B;
    assign regmult = A * B;

    wire [4:0] FA_out;
    wire [3:0] carry;
	adder_4bit adder(.a(A),.b(B),.c_in(1'b0),.s(FA_out[3:0]),.c_out(carry[3:0]));
    assign FA_out[4] = carry[3];

    always @(posedge Clock)
        begin
            if (Reset_b == 1'b0)
                ALUout <= 8'b00000000;
            else
                case (Function)
                    3'b000: ALUout <= {3'b000, FA_out[4:0]};
                    3'b001: ALUout <= {3'b000, regsum};
                    3'b010: ALUout <= {{4{B[3]}}, B};
                    3'b011: ALUout <= {7'b0000000, |{A,B}}; // | is reudction to 1 bit
                    3'b100: ALUout <= {7'b0000000, &{A,B}}; // & is reduction to 1 bit
                    3'b101: ALUout <= B<<A;
                    3'b110: ALUout <= {regmult};
                    3'b111: ALUout <= ALUout;
                    default: ALUout <= 8'b00000000;     
                endcase
        end
    assign B = ALUout[3:0];
endmodule

// part 3 from lab 3 (OLD)
// module part3(A, B, Function, ALUout);
//     input [3:0] A;
//     input [3:0] B;
//     input [2:0] Function;
//     output reg [7:0] ALUout;

//     wire [4:0]FA_out;

//     part2 adder(
//         .a(A),
//         .b(B),
//         .c_in(1'b0),
//         .s(FA_out[3:0]),
//         .c_out(FA_out[4])
//     );

//     wire [4:0] regsum;
//     assign regsum = A + B;
//     assign regmult = A * B;
//     // combinational: always @(*)
//     // sequential: always @(inputs...)

//     always @(*)
//     begin
//         case (Function)
//             3'b000: ALUout = {3'b000, FA_out[4:0]};
//             3'b001: ALUout = {3'b000, regsum};
//             3'b010: ALUout = {{4{B[3]}}, B};
//             3'b011: ALUout = {7'b0000000, |{A,B}}; // | is reudction to 1 bit
//             3'b100: ALUout = {7'b0000000, &{A,B}}; // & is reduction to 1 bit
//             3'b101: ALUout = B<<A;
//             3'b110: ALUout = {regmult};
//             3'b111:
//             default: ALUout = 8'b00000000;

            
//         endcase
//     end
// endmodule

module adder_4bit(a, b, c_in, s, c_out);
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
