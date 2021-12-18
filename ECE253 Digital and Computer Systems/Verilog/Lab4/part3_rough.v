module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, DataIN, Q);
    input clock, reset, ParallelLoadn, ASRight, RotateRight;
    input [7:0] DataIn;
    output reg[7:0] Q;
    wire datato_dff, LoadLeft, loadn;
    wire [7:0] D;
    assign LoadLeft = RotateRight;
    assign loadn = ParallelLoadn;
    assign D = DataIn;

    mux2to1 M1(
        .y(rotatedata),
        .x(D[7]),
        .s(parallel_loadn),
        .m(datato_dff)
    );
    flipflop F0(
        .d(datato_dff),
        .q(out_Q),
        .clock(clock),
        .reset(reset)
    );
endmodule

module mux2to1(y,x,s,m);
    input y,x,s;
    output m;
    assign m = ~s&x | s&y;
endmodule

module flipflop(d, q, clock, reset);
    input d, clock, reset;
    output q;
    always@(posedge clock)
        if(reset == 1'b1)
            q <= d;
        else
            q <= 0;    
endmodule