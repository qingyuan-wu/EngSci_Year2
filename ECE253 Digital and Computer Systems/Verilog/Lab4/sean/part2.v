module part2(Clock, Reset_b, Data, Function, ALUout);
	input Clock;
	input Reset_b;
	input [3:0] Data;
	input [2:0] Function;
	output reg [7:0] ALUout;
	
	wire [3:0] A;
	wire [3:0] B;
	assign A = Data;
	assign B = ALUout[3:0];

	wire [4:0] regsum;
	wire [7:0] regprod;
	assign regsum = A+B;
	assign regprod = A*B;
	
	wire [4:0] fasum;
	part2a fa(
		.a(A),
		.b(B),
		.c_in(1'b0),
		.s(fasum[3:0]),
		.c_out(fasum[4]));

	always@(posedge Clock)
	begin
		if(Reset_b == 0)
			ALUout = 8'b00000000;
		else
			case(Function)
				3'b000: ALUout = {3'b000, fasum};
				3'b000: ALUout = {3'b000, regsum};
				3'b000: ALUout = {{4{B[3]}}, B};
				3'b000: ALUout = {7'b0000000, |{A,B}};
				3'b000: ALUout = {7'b0000000, &{A,B}};
				3'b000: ALUout = {4'b0000, B} << A;
				3'b000: ALUout = regprod;
				3'b000: ALUout = ALUout;
				default: ALUout = 8'b00000000;
			endcase
	end
endmodule


module part2a(a, b, c_in, s, c_out);
    input [3:0] a;
    input [3:0] b;
    input c_in; 
    output [3:0] s;
    output c_out;

    wire wire1, wire2, wire3;

    full_adder u0(a[0], b[0], c_in, s[0], wire1);
    full_adder u1(a[1], b[1], wire1, s[1], wire2);
    full_adder u2(a[2], b[2], wire2, s[2], wire3);
    full_adder u3(a[3], b[3], wire3, s[3], c_out);
endmodule

module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;
    assign s = (a^b) ^ c_in;
    assign c_out = (a & b) | (c_in & a) | (c_in & b);
endmodule