module part3(Clock, Resetn, Go, Divisor, Dividend, Quotient, Remainder);
    input Clock;
    input Resetn;
    input Go;
    input [3:0] Divisor;
    input [3:0] Dividend;
    reg [3:0] div; //dividend -> quotient
    reg [4:0] A;
    reg [3:0] counter; //count to 4

    output reg [4:0] Remainder;
    output reg [3:0] Quotient;

    reg [2:0] current_state, next_state;

    localparam  S_LOAD_A        = 3'd0,
                CHECK_COUNTER   = 3'd5,
                S_CYCLE_0       = 3'd1,
                S_CYCLE_1       = 3'd2,
                S_CYCLE_2       = 3'd3,
                S_CYCLE_3       = 3'd4;

    // Next state logic aka our state table
    always@(*)
    begin: state_flow
        case (current_state)
            S_LOAD_A: next_state = Go ? CHECK_COUNTER : S_LOAD_A;
            CHECK_COUNTER: next_state = (counter == 4'b0100) ? S_CYCLE_3 : S_CYCLE_0;
            S_CYCLE_0: next_state = S_CYCLE_1;
            S_CYCLE_1: next_state = (A[4] == 0) ? CHECK_COUNTER : S_CYCLE_2;
            S_CYCLE_2: next_state = CHECK_COUNTER;
            S_CYCLE_3: next_state = S_CYCLE_3;
            default: next_state = S_LOAD_A;
        endcase
    end // state_table

    always @(*)
    begin: states
        case (current_state)
            S_LOAD_A: begin
                A = 5'b0;
                Remainder = 5'b0;
                Quotient = 4'b0;
                div = Dividend;
                counter = 4'b0000;
            end
            S_CYCLE_0: begin // shift left
                A = {A[3:0], div[3]};
                div = {div[2:0], 1'b0};
                counter = counter + 1;
            end
            S_CYCLE_1: begin
                A = A - Divisor;
                div[0] = ~A[4];
            end
            S_CYCLE_2: begin
                A = A + Divisor;
                
            end
            S_CYCLE_3: begin
                Quotient = div;
                Remainder = A;
            end
        endcase
    end

    always@(posedge Clock)
    begin: state_FFs
        if(!Resetn)
            current_state <= S_LOAD_A;
        else
            current_state <= next_state;
    end // state_FFS
endmodule