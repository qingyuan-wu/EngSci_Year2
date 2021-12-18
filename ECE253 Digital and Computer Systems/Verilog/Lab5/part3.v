module part3(ClockIn, Resetn, Start, Letter, DotDashOut);
    input ClockIn, Resetn, Start;
    input [2:0] Letter;
    
    output reg DotDashOut;
    reg [11:0] Sequence;
    reg [11:0] cur_Sequence;

    reg [7:0] Counter; //8 bits count from 250 to 0; 2^8 = 256
    wire Enable;
    assign Enable = (Counter == 8'b00000000)?1:0;

    always @(*)
    begin
        case (Letter)
            3'b000: Sequence = 12'b101110000000; //A
            3'b001: Sequence = 12'b111010101000; //B
            3'b010: Sequence = 12'b111010111010; //C
            3'b011: Sequence = 12'b111010100000; //D
            3'b100: Sequence = 12'b100000000000; //E
            3'b101: Sequence = 12'b101011101000; //F
            3'b110: Sequence = 12'b111011101000; //G
            3'b111: Sequence = 12'b101010100000; //H
            default: Sequence = 0;
        endcase
    end

    always @(posedge ClockIn, negedge Resetn)
    begin
        if (!Resetn) begin
            DotDashOut <= 1'b0;
            Counter <= 8'd249;
        end

        if (Start)
        begin
            cur_Sequence <= Sequence;
            Counter <= 8'd249;
        end

        else if (Counter == 0)
        begin
            Counter <= 8'd249;
            DotDashOut <= cur_Sequence[11];
            cur_Sequence <= {cur_Sequence[10:0], cur_Sequence[11]};
        end

        else
            Counter <= Counter - 1;
    end
endmodule