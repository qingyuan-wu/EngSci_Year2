module part3(Clock, Resetn, Go, Divisor, Dividend, Quotient, Remainder);

    input Clock;
    input Resetn;
    input Go;
    input [4:0] Divisor
    input [3:0] Dividend;
    reg [4:0] A;
    output [4:0] Remainder;
    output [3:0] Quotient;

    // lots of wires to connect our datapath and control
    wire ld_A, ld_dividend, ld_divisor;
    wire ld_alu_out, select_a, select_b;
    wire [1:0] alu_op;

    control C0(
        .clk(Clock),
        .resetn(Resetn),
        
        .go(Go),
        
        .ld_alu_out(ld_alu_out), 
        .ld_d(ld_dividend),
        .ld_r(ld_divisor),
        .select_a(select_a),
        .select_b(select_b), 

        .alu_op(alu_op)
    );

    datapath D0(
        .clk(Clock),
        .resetn(Resetn),

        .ld_alu_out(ld_alu_out), 
        .ld_d(ld_dividend),
        .ld_r(ld_divisor),
        .select_a(select_a),
        .select_b(select_b),

        .alu_op(alu_op),

        .data_in(DataIn),
        .out_quotient(Quotient),
        .out_remainder(Remainder)
    );
                
 endmodule             
                

module control(
    input clk,
    input resetn,
    input go,
    input add,

    output reg  ld_A, ld_d, ld_r,
    output reg  ld_alu_out_a, ld_alu_out_d, select_a, select_b,

    output reg [1:0] alu_op
    );

    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_A        = 5'd0,
                S_LOAD_A_WAIT   = 5'd1,
                S_LOAD_D       = 5'd2,
                S_LOAD_D_WAIT   = 5'd3,
                S_LOAD_R = 5'd4;
                S_LOAD_R_WAIT = 5'd5;
                S_CYCLE_0       = 5'd6,
                S_CYCLE_1       = 5'd7,
                S_CYCLE_2       = 5'd8,
                S_CYCLE_3       = 5'd9,
    // ld_r == divisor, ld_d == dividend

    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_A: next_state = go ? S_LOAD_A_WAIT : S_LOAD_A; // Loop in current state until value is input
                S_LOAD_A_WAIT: next_state = go ? S_LOAD_A_WAIT : S_LOAD_DIVIDEND; // Loop in current state until go signal goes low
                S_LOAD_D: next_state = go ? S_LOAD_D_WAIT : S_LOAD_D; // Loop in current state until value is input
                S_LOAD_D_WAIT: next_state = go ? S_LOAD_D_WAIT : S_LOAD_R; // Loop in current state until go signal goes low
                S_LOAD_R: next_state = go ? S_LOAD_R : S_LOAD_R_WAIT;
                S_LOAD_R_WAIT: next_state = go ? S_LOAD_R_WAIT : S_CYCLE_0;
                S_CYCLE_0: next_state = S_CYCLE_1;
                S_CYCLE_1: next_state = add ? S_CYCLE_2 : S_LOAD_A;
                S_CYCLE_2: next_state = S_LOAD_A;
                
            default:     next_state = S_LOAD_A;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_alu_out_a = 1'b0;
        ld_alu_out_d = 1'b0;
        ld_a = 1'b0;
        ld_d = 1'b0;
        ld_r = 1'b0;
        alu_op = 2'b0;

        case (current_state)
            S_LOAD_A: begin
                ld_a = 1'b1;
                end
            S_LOAD_D: begin
                ld_d = 1'b1;
                end
            S_LOAD_R: begin
                ld_r = 1'b1;
                end
            S_CYCLE_0: begin
                alu_op = 2'b10; //shift operator
                select_a = 1'b0;
                select_b = 1'b1;
                ld_alu_out_a = 1'b1; //load shifted results
                ld_alu_out_d = 1'b1; //load shifted results
            end
            S_CYCLE_1: begin
                select_a = 1'b0; // select reg A
                select_b = 1'b0; // select divisor, ld_r
                alu_op = 2'b01; //subtract: A - R
                ld_alu_out_a = 1'b1;
            end
            S_CYCLE_2: begin
                select_a = 1'b0; // select reg A
                select_b = 1'b0; // select divisor, ld_r
                alu_op = 2'b00; //add: A + R
                ld_alu_out_a = 1'b1;
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_A;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [8:0] data_in,
    input ld_alu_out, 

    input ld_a, ld_d, ld_r,
    input select_a, select_b,
    input ld_results,
    input alu_op, 
    input select_a, select_b,
    output reg [3:0] out_quotient,
    output reg [4:0] out_remainder
    );
    //     input clk,
    // input resetn,
    // input go,
    // input add,

    // output reg  ld_A, ld_d, ld_r,
    // output reg  ld_alu_out_a, ld_alu_out_d, select_a, select_b,

    // output reg [1:0] alu_op

    // input registers
    reg [8:0] a, r, d;

    // output of the alu
    reg [8:0] alu_out;
    // alu input muxes
    reg [8:0] alu_a, alu_b;
    
    // Registers a, b, c, x with respective input logic
    always@(posedge clk) begin
        if(!resetn) begin
            a <= 8'b0; 
            b <= 8'b0; 
            c <= 8'b0; 
            x <= 8'b0; 
        end
        else begin
            if(ld_a)
                a <= ld_alu_out_a ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_b)
                d <= ld_alu_out_d ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_r)
                r <= data_in;
        end
    end
 
    // Output result register
    always@(posedge clk) begin
        if(!resetn) begin
            data_result <= 8'b0; 
        end
        else 
            if(ld_results)
                out_quotient <= alu_out[3:0];
                out_remainder <= alu_out[8:4];
    end

    // The ALU input multiplexers
    always @(*)
    begin
        case (select_a)
            2'd0:
                alu_a = a;
            2'd1:
                alu_a = r;

            default: alu_a = 8'b0;
        endcase

        case (alu_select_b)
            2'd0:
                alu_b = r;
            2'd1:
                alu_b = d;
            default: alu_b = 8'b0;
        endcase
    end

    // The ALU 
    always @(*)
    begin : ALU
        case (alu_op)
            2'b00: begin
                   alu_out = alu_a + alu_b; //performs addition
               end
            2'b01: begin
                   alu_out = alu_a - alu_b; //performs subtraction
                   q[0] = ~alu_out[4];
                   if alu_out[4] == 1'b10  
                    add = 1'b1;
               end
            2'b10: begin //shift
                alu_a = {alu_a[4:1], alu_b[3]};
                alu_b = {alu_b[3:1], 1'b0};
            end
            default: alu_out = 8'b0;
        endcase
    end
    
endmodule
