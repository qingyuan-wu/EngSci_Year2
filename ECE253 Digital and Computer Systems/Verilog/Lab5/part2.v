module part2(ClockIn, Reset, Speed, CounterValue);
    output reg [3:0] CounterValue;
    input ClockIn, Reset;
    input [1:0] Speed;

    wire Enable; //change to wire if put in another module
    
    reg [10:0] Divider;
    assign Enable = (Divider == 11'b00000000000)?1:0;

    // FrequencyDivider FD(.Clock(ClockIn), .Enable(Enable), .Speed(Speed));

    always @(posedge ClockIn) // triggered every time clock rises
    begin
        if (Reset) // active high
        begin
            CounterValue <= 4'b0000; // Counter is set to 0
            Divider <= 11'd0; // f = 500 Hz 
        end
        else
        begin
            Divider <= Divider - 1;
            if (Divider == 0)
            begin
                // Enable <= 1'b1;
                case (Speed)
                    2'b00: Divider <= 11'd0; // f = 500 Hz
                    2'b01: Divider <= 11'd500; // f = 1 Hz
                    2'b10: Divider <= 11'd1000; // f = 0.5 Hz
                    2'b11: Divider <= 11'd2000;
                endcase
            end
            if (Enable)
            begin
                if (CounterValue == 4'b1111) // when Counter is the maximum value
                    CounterValue <= 4'b0000; // Counter reset to 0
                else
                    CounterValue <= CounterValue + 1; // increment Counter
            end                 
        end
    end
endmodule

// NOT USED
module FrequencyDivider(Clock, Enable, Speed);
    reg [10:0] Counter;
    input [1:0] Speed;
    input Clock;
    output Enable;
    assign Enable = (Counter == 11'b00000000000)?1:0;

    always @(posedge Clock)
    begin
        Counter <= Counter - 1;
        if (Counter == 0)
        begin
            case (Speed)
                2'b00: Counter <= 0; // f = 500 Hz
                2'b01: Counter <= 11'd500; // f = 1 Hz
                2'b10: Counter <= 11'd1000; // f = 0.5 Hz
                2'b11: Counter <= 11'd2000;
            endcase
        end
    end
endmodule

