module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input clock, reset, ParallelLoadn, RotateRight, ASRight;
	input [7:0] Data_IN;
	output [7:0] Q;

	wire wire71, wire72, wire73;

	mux2to1 mux71(.x(Q[0]), .y(Q[7]), .s(ASRight), .m(wire71));
	mux2to1 mux72(.x(Q[6]), .y(wire71), .s(RotateRight), .m(wire72));
	mux2to1 mux73(.x(Data_IN[7]), .y(wire72), .s(ParallelLoadn), .m(wire73));
	FF ff7(.d(wire73), .q(Q[7]), .clock(clock), .reset(reset));
	
	wire wire61, wire62; 

	mux2to1 mux61(.x(Q[5]), .y(Q[7]), .s(RotateRight), .m(wire61));
	mux2to1 mux62(.x(Data_IN[6]), .y(wire61), .s(ParallelLoadn), .m(wire62));
	FF ff6(.d(wire62), .q(Q[6]), .clock(clock), .reset(reset));

	wire wire51, wire52;
	mux2to1 mux51(.x(Q[4]), .y(Q[6]), .s(RotateRight), .m(wire51));
	mux2to1 mux52(.x(Data_IN[5]), .y(wire51), .s(ParallelLoadn), .m(wire52));
	FF ff5(.d(wire52), .q(Q[5]), .clock(clock), .reset(reset));

	wire wire41, wire42;
	mux2to1 mux41(.x(Q[3]), .y(Q[5]), .s(RotateRight), .m(wire41));
	mux2to1 mux42(.x(Data_IN[4]), .y(wire41), .s(ParallelLoadn), .m(wire42));
	FF ff4(.d(wire42), .q(Q[4]), .clock(clock), .reset(reset));

	wire wire31, wire32;
	mux2to1 mux31(.x(Q[2]), .y(Q[4]), .s(RotateRight), .m(wire31));
	mux2to1 mux32(.x(Data_IN[3]), .y(wire31), .s(ParallelLoadn), .m(wire32));
	FF ff3(.d(wire32), .q(Q[3]), .clock(clock), .reset(reset));

	wire wire21, wire22;
	mux2to1 mux21(.x(Q[1]), .y(Q[3]), .s(RotateRight), .m(wire21));
	mux2to1 mux22(.x(Data_IN[2]), .y(wire21), .s(ParallelLoadn), .m(wire22));
	FF ff2(.d(wire22), .q(Q[2]), .clock(clock), .reset(reset));

	wire wire11, wire12;
	mux2to1 mux11(.x(Q[0]), .y(Q[2]), .s(RotateRight), .m(wire11));
	mux2to1 mux12(.x(Data_IN[1]), .y(wire11), .s(ParallelLoadn), .m(wire12));
	FF ff1(.d(wire12), .q(Q[1]), .clock(clock), .reset(reset));

	wire wire01, wire02;
	mux2to1 mux01(.x(Q[7]), .y(Q[1]), .s(RotateRight), .m(wire01));
	mux2to1 mux02(.x(Data_IN[0]), .y(wire01), .s(ParallelLoadn), .m(wire02));
	FF ff0(.d(wire02), .q(Q[0]), .clock(clock), .reset(reset));
	

endmodule

module mux2to1(x,y,s,m);
	input x,y,s;
	output m;
	assign m = s & y | ~s & x;
endmodule

module FF(d, q, clock, reset);
	input d, clock, reset;
	output reg q;
	always@(posedge clock)
	begin
		if(reset == 1'b1)
			q<=0;
		else
			q<=d;
	end
endmodule
	