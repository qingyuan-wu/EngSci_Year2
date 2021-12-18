module mux2to1(x,y,s,m);
    input x,y,s;
    output m;
    wire first_out, second_out, third_out;
    v7404 u0(
        .pin1(s),
        .pin2(first_out)
    );
    v7408 u1(
        .pin1(first_out),
        .pin2(x),
        .pin3(second_out),

        .pin4(s),
        .pin5(y),
        .pin6(third_out)
    );
    v7432 u2(
        .pin1(second_out),
        .pin2(third_out),
        .pin3(m)
    );
endmodule

// 6 inverters 74LS04/05
module v7404 (pin1, pin3, pin5, pin9, pin11, pin13,
            pin2, pin4, pin6, pin8, pin10, pin12);
    input pin1, pin3, pin5, pin9, pin11, pin13;
    output pin2, pin4, pin6, pin8, pin10, pin12;
    assign pin2 = ~pin1;
    assign pin4 = ~pin3;
    assign pin6 = ~pin5;
    assign pin8 = ~pin9;
    assign pin10 = ~pin11;
    assign pin12 = ~pin13;
endmodule

// 4 AND gates 7408
module v7408 (pin1, pin3, pin5, pin9, pin11, pin13,
            pin2, pin4, pin6, pin8, pin10, pin12);
    input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
    output pin3, pin6, pin8, pin11;
    assign pin3 = pin1 & pin2;
    assign pin6 = pin4 & pin5;
    assign pin8 = pin9 & pin10;
    assign pin11 = pin12 & pin13;
endmodule

// 7432 4 OR gates
module v7432 (pin1, pin3, pin5, pin9, pin11, pin13,
            pin2, pin4, pin6, pin8, pin10, pin12);
    input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
    output pin3, pin6, pin8, pin11;
    assign pin3 = pin1 | pin2;
    assign pin6 = pin4 | pin5;
    assign pin8 = pin9 | pin10;
    assign pin11 = pin12 | pin13;    
endmodule