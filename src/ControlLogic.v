module PIC8259A(
    input VCC, // 5V power supply or 1 in simulation
    input A0, // address line 0 
    input INTA, // interrupt acknowledge
    input wire [7:0] IRBus, // interrupt request bus 
    output reg INT, // interrupt output 
    input SPEN, // Used for cascading and buffer control is ignored in this simulation
    inout wire [2:0] CASBus, // Cascade bus
    input CS, // chip select
    input WR, // write signal 
    input RD, // read signal 
    inout wire [7:0] DBus, // data bus 
    input GND // ground or 0 in simulation 
);

reg [7:0] DBusReg;
assign DBus = ~RD && ~CS ? DBusReg : 8'bz;

// internal signals
wire [7:0] ICW1;
wire [7:0] ICW2;
wire [7:0] ICW3;
wire [7:0] ICW4;
wire [7:0] OCW1;
wire [7:0] OCW2;
wire [7:0] OCW3;
wire shouldInitiateFlags;
wire [2:0] highestPriority;
reg currentPulse;
reg [1:0] shouldSendStatus; // 0: no, 1: ISR, 2: IRR, 3: IMR
wire [7:0] irr;

wire LTIM = ICW1[3];
wire writeEnabled = ~RD && ~CS;

always @(shouldInitiateFlags) begin
    if(shouldInitiateFlags) begin
        currentPulse <= 1'b0;
        INT <= 1'b0;
    end
end

RWLogic rwLogic(
    .globalBus(DBus),
    .A0(A0),
    .CS(CS),
    .WR(WR),
    .RD(RD),
    .ICW1(ICW1),
    .ICW2(ICW2),
    .ICW3(ICW3),
    .ICW4(ICW4),
    .OCW1(OCW1),
    .OCW2(OCW2),
    .OCW3(OCW3),
    .shouldInitiateFlags(shouldInitiateFlags)
);

IRR irrModule(
    .reset(shouldInitiateFlags),
    .LTIM(LTIM),
    .IRBus(IRBus),
    .highestPriority(highestPriority),
    .INTA(INTA),
    .currentPulse(currentPulse),
    .irr(irr)
);

Priority_resolver priority_resolver(
    .autoRotateMode(1'b0),
    .irr(irr),
    .imr(OCW1),
    .highestPriority(highestPriority)
);

wire [7:0] ISROutput;
ISR isr(
    .highestPriority(highestPriority),
    .AddressBase(ICW2),
    .INTA(INTA),
    .currentPulse(currentPulse),
    .currentAddress(ISROutput)
);

////////////////////// Handling Read Status //////////////////////

always @(OCW3) begin
    if(OCW3[0] && OCW3[1]) begin
        shouldSendStatus <= 2'b01;
    end else if(~OCW3[0] && OCW3[1]) begin
        shouldSendStatus <= 2'b10;
    end
end

// send status
always @(negedge RD) begin
    if(shouldSendStatus === 2'b01 && writeEnabled) begin
        case(ISROutput[2:0])
        // handling Difference in IS register between this implementation and the real PIC8259A
            3'b000: DBusReg <= 8'b00000000;
            3'b001: DBusReg <= 8'b00000010;
            3'b010: DBusReg <= 8'b00000100;
            3'b011: DBusReg <= 8'b00001000;
            3'b100: DBusReg <= 8'b00010000;
            3'b101: DBusReg <= 8'b00100000;
            3'b110: DBusReg <= 8'b01000000;
            3'b111: DBusReg <= 8'b10000000;
        endcase
    end else if(shouldSendStatus === 2'b10) begin
        DBusReg <= irr;
    end
end

////////////////////// Handling Interrupts //////////////////////

// set interrupt output
wire interruptExists = |(irr & ~OCW1);
always @(highestPriority or INT) begin
    if(~INT && interruptExists) begin
        INT <= 1'b1;
    end
end

// set current pulse
always @(posedge INTA) begin
    currentPulse <= ~currentPulse;
end

// reset interrupt output
always @(posedge INTA) begin
    if(currentPulse === 1) begin
        INT <= 1'b0;
        DBusReg <= 8'bzzzzzzzz;
    end
end

// send address to data bus
always @(negedge INTA) begin
    if(currentPulse === 1 && writeEnabled) begin
        if(interruptExists) begin
            DBusReg <= ISROutput;
        end else begin
            // make it look like interrupt is from pin 7, first 5 bits from ISR
            DBusReg <= {ISROutput[4:0], 3'b111};
        end
    end
end

endmodule
