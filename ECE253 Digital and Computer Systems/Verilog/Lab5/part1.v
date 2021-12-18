module part1(Clock, Enable, Clear_b, CounterValue);
    input Enable, Clock, Clear_b;
    output [7:0] CounterValue;
    wire q0 = Enable;
    wire q1 = q0 & CounterValue[0];
    wire q2 = q1 & CounterValue[1];
    wire q3 = q2 & CounterValue[2];
    wire q4 = q3 & CounterValue[3];
    wire q5 = q4 & CounterValue[4];
    wire q6 = q5 & CounterValue[5];
    wire q7 = q6 & CounterValue[6];

    T_FF T0(.Clock(Clock), .T(q0), .Q(CounterValue[0]), .reset(Clear_b));
    T_FF T1(.Clock(Clock), .T(q1), .Q(CounterValue[1]), .reset(Clear_b));
    T_FF T2(.Clock(Clock), .T(q2), .Q(CounterValue[2]), .reset(Clear_b));
    T_FF T3(.Clock(Clock), .T(q3), .Q(CounterValue[3]), .reset(Clear_b));
    T_FF T4(.Clock(Clock), .T(q4), .Q(CounterValue[4]), .reset(Clear_b));
    T_FF T5(.Clock(Clock), .T(q5), .Q(CounterValue[5]), .reset(Clear_b));
    T_FF T6(.Clock(Clock), .T(q6), .Q(CounterValue[6]), .reset(Clear_b));
    T_FF T7(.Clock(Clock), .T(q7), .Q(CounterValue[7]), .reset(Clear_b));
endmodule

module T_FF(Clock, T, Q, reset);
    input Clock, T, reset;
    output reg Q;
    
    always @(posedge Clock, negedge reset)
    begin
        if (!reset)
            Q <= 1'b0;
        else if (!T)
            Q <= Q;
        else
            Q <= ~Q;
    end
endmodule