// test both edge and level triggered
module IRR_tb;
    reg LTIM;
    reg [7:0] IRBus;
    reg reset;
    reg [2:0] highestPriority;
    reg INTA;
    reg currentPulse;
    wire [7:0] irr;

    // Instantiate the IRR module
    IRR dut (
        .LTIM(LTIM),
        .IRBus(IRBus),
        .irr(irr),
        .highestPriority(highestPriority),
        .INTA(INTA),
        .currentPulse(currentPulse),
        .reset(reset)
    );

    // Stimulus and test cases
    initial begin
        reset = 1;
        #1
        reset = 0;
        INTA = 1;
        currentPulse = 1;
        highestPriority = 3'b101;
        #1
        // Edge-triggered
        LTIM = 0;
        IRBus = 8'b00000001;
        #10
        IRBus = 8'b00000010;
        #10
        IRBus = 8'b00000100;
        #10
        IRBus = 8'b00001000;
        #10
        IRBus = 8'b00010000;
        #10
        IRBus = 8'b00100000;
        #5
        INTA = 0;
        #10
        IRBus = 8'b11000001;
        #10

        // Level-triggered
        LTIM = 1;
        IRBus = 8'b00000001;
        #10
        IRBus = 8'b00000010;
        #10
        IRBus = 8'b00000100;
        #10
        IRBus = 8'b00001000;
        #10
        IRBus = 8'b00010000;
        #10
        IRBus = 8'b00100000;
        #10
        IRBus = 8'b01000000;
        #10
        IRBus = 8'b10000000;
    end
endmodule