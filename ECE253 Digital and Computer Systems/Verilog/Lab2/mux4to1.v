module mux4to1(LEDR, SW);
    input [9:0]SW;
    output [9:0]LEDR;
    
    wire first_out;
    wire second_out;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .f(first_out)
    );

    mux2to1 u2(
        .x(first_out),
        .y(second_out),
        .s(SW[8]),
        .f(LEDR[0])
    );

    mux2to1 u1(
        .x(SW[2]),
        .y(SW[3]),
        .s(SW[9]),
        .f(second_out)
    );
endmodule