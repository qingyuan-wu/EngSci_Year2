module FSM(w, clock, resetn, z);
    input w, clock, resetn;
    output z;
    reg y[2:1];
    reg Y[2:1];
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;

    always @(w, y)
    begin
        case (y)
            A: Y = (w?) B : A;
            B: Y = (w?) B : C;
            C: Y = (w?) D : A;
            D: Y = (w?) B : C;
        endcase
    end

    always @(posedge clock)
    begin
        if (!resetn) y <= 2'b00;
        else
            y <= Y;
    end

    assign z = (y==D);

endmodule

module FSM_oneHot(w, clock, resetn, z);
    input w, clock, resetn;
    output z;
    reg y[2:1];
    reg Y[2:1];
    parameter A=4'b0000, B=4'b0100, C=4'b0010, D=4'b0001;

    always @(w, y)
    begin
        case (y)
            A: Y = (w?) B : A;
            B: Y = (w?) B : C;
            C: Y = (w?) D : A;
            D: Y = (w?) B : C;
            default Y = 4'bxxxx;
        endcase
    end

    always @(posedge clock)
    begin
        if (!resetn) y <= 2'b00;
        else
            y <= Y;
    end

    assign z = (y==D);

endmodule

module FSM_shift(w, clock, resetn, z);
    input w, clock, resetn;
    output z;
    reg y[3:1];
    always @(posedge clock)
    begin
        if (!resetn) y <= 3'b000;
        else begin
            //non-blocking assignment (simultaneous)
            y[1] <= y[2];
            y[2] <= y[3];
            y[3] <= w;
        end
    end

    assign z = y[3] & ~y[2] & y[1];

endmodule