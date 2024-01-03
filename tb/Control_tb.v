
// shows basic operation of the PIC8259A interrupt handling
module PIC8259A_tb;
reg [7:0] globalBus;
wire [7:0] globalBusWire;
assign globalBusWire = globalBus;

reg [7:0] IRBus = 8'b00000000;
reg A0;
reg CS = 1'b1;
reg WR = 1'b1;
reg RD = 1'b1;
reg INTA = 1'b1;
wire INT;

PIC8259A pic8259A(
    .VCC(1'b1),
    .A0(A0),
    .INTA(INTA),
    .IRBus(IRBus),
    .INT(INT),
    .SPEN(1'b1),
    .CS(CS),
    .WR(WR),
    .RD(RD),
    .DBus(globalBusWire),
    .GND(1'b0)
);

initial begin
    CS = 1'b0;
    WR = 1'b0;
    // ICW1
    globalBus <= 8'b00010011;
    A0 <= 1'b0;
    #10
    A0 <= 1'b1;
    // ICW2
    globalBus <= 8'b11011000;
    #10;
    A0 <= 1'b1;
    // ICW4
    globalBus <= 8'b00000011;
    #10;

    // OCW1
    A0 <= 1'b1;
    globalBus <= 8'b00000001; // bit 0 is masked
    #10;
    // OCW2
    A0 <= 1'b0;
    globalBus <= 8'b01000000;
    #10;
    // OCW3
    A0 <= 1'b0;
    globalBus <= 8'b00001000; // last two bits are for read status
    #1;
    CS <= 1'b1;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;

    // trigger interrupt
    #10;
    IRBus <= 8'b10001001;
    #50;
    // reset mask to test programmability
    CS <= 1'b0;
    WR <= 1'b0;
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
    #1;
    CS <= 1'b1;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;
end

always @(posedge INT) begin
    #5;
    // acknowledge interrupt pulse 1
    INTA <= 1'b0;
    #5;
    INTA <= 1'b1;
    #5;
    // acknowledge interrupt pulse 2
    INTA <= 1'b0;
    RD <= 1'b0;
    CS <= 1'b0;
    #5;
    INTA <= 1'b1;
    RD <= 1'b1;
    CS <= 1'b1;
end
endmodule

// test level triggerring
module PIC8259A_tb_level_trigger;
reg [7:0] globalBus;
wire [7:0] globalBusWire;
assign globalBusWire = globalBus;

reg [7:0] IRBus = 8'b00000000;
reg A0;
reg CS = 1'b1;
reg WR = 1'b1;
reg RD = 1'b1;
reg INTA = 1'b1;
wire INT;

PIC8259A pic8259A(
    .VCC(1'b1),
    .A0(A0),
    .INTA(INTA),
    .IRBus(IRBus),
    .INT(INT),
    .SPEN(1'b1),
    .CS(CS),
    .WR(WR),
    .RD(RD),
    .DBus(globalBusWire),
    .GND(1'b0)
);

initial begin
    CS = 1'b0;
    WR = 1'b0;
    // ICW1
    globalBus <= 8'b00011011;
    A0 <= 1'b0;
    #10
    A0 <= 1'b1;
    // ICW2
    globalBus <= 8'b11011000;
    #10;
    A0 <= 1'b1;
    // ICW4
    globalBus <= 8'b00000011;
    #10;

    // OCW1
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
    #10;
    // OCW2
    A0 <= 1'b0;
    globalBus <= 8'b01000000;
    #10;
    // OCW3
    A0 <= 1'b0;
    globalBus <= 8'b00001000; // last two bits are for read status
    #1;
    CS <= 1'b1;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;

    // trigger interrupt
    #10;
    IRBus <= 8'b00000001;
end

always @(posedge INT) begin
    #5;
    // acknowledge interrupt pulse 1
    INTA <= 1'b0;
    #5;
    INTA <= 1'b1;
    #5;
    // acknowledge interrupt pulse 2
    INTA <= 1'b0;
    RD <= 1'b0;
    CS <= 1'b0;
    #5;
    IRBus <= 8'b00000000; // reset interrupt since it is level triggered
    INTA <= 1'b1;
    RD <= 1'b1;
    CS <= 1'b1;
end
endmodule

// test when interrupt is lowered too soon
module PIC8259A_tb_too_soon;
reg [7:0] globalBus;
wire [7:0] globalBusWire;
assign globalBusWire = globalBus;

reg [7:0] IRBus = 8'b00000000;
reg A0;
reg CS = 1'b1;
reg WR = 1'b1;
reg RD = 1'b1;
reg INTA = 1'b1;
wire INT;

PIC8259A pic8259A(
    .VCC(1'b1),
    .A0(A0),
    .INTA(INTA),
    .IRBus(IRBus),
    .INT(INT),
    .SPEN(1'b1),
    .CS(CS),
    .WR(WR),
    .RD(RD),
    .DBus(globalBusWire),
    .GND(1'b0)
);

initial begin
    CS = 1'b0;
    WR = 1'b0;
    // ICW1
    globalBus <= 8'b00011011;
    A0 <= 1'b0;
    #10
    A0 <= 1'b1;
    // ICW2
    globalBus <= 8'b11011000;
    #10;
    A0 <= 1'b1;
    // ICW4
    globalBus <= 8'b00000011;
    #10;

    // OCW1
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
    #10;
    // OCW2
    A0 <= 1'b0;
    globalBus <= 8'b01000000;
    #10;
    // OCW3
    A0 <= 1'b0;
    globalBus <= 8'b00001000; // last two bits are for read status
    #1;
    CS <= 1'b1;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;

    // trigger interrupt
    #10;
    IRBus <= 8'b00000001;
end

always @(posedge INT) begin
    #5;
    // acknowledge interrupt pulse 1
    INTA <= 1'b0;
    #5;
    INTA <= 1'b1;
    IRBus <= 8'b00000000; // reset interrupt since it is level triggered
    #5;
    // acknowledge interrupt pulse 2
    INTA <= 1'b0;
    RD <= 1'b0;
    CS <= 1'b0;
    #5;
    INTA <= 1'b1;
    RD <= 1'b1;
    CS <= 1'b1;
end
endmodule

// test read status
module PIC8259A_tb_read_status;
reg [7:0] globalBus;
wire [7:0] globalBusWire;
assign globalBusWire = globalBus;

reg [7:0] IRBus = 8'b00000000;
reg A0;
reg CS = 1'b1;
reg WR = 1'b1;
reg RD = 1'b1;
reg INTA = 1'b1;
wire INT;

PIC8259A pic8259A(
    .VCC(1'b1),
    .A0(A0),
    .INTA(INTA),
    .IRBus(IRBus),
    .INT(INT),
    .SPEN(1'b1),
    .CS(CS),
    .WR(WR),
    .RD(RD),
    .DBus(globalBusWire),
    .GND(1'b0)
);

initial begin
    CS = 1'b0;
    WR = 1'b0;
    // ICW1
    globalBus <= 8'b00010011;
    A0 <= 1'b0;
    #10
    A0 <= 1'b1;
    // ICW2
    globalBus <= 8'b11011000;
    #10;
    A0 <= 1'b1;
    // ICW4
    globalBus <= 8'b00000011;
    #10;

    // OCW1
    A0 <= 1'b1;
    globalBus <= 8'b00000001; // bit 0 is masked
    #10;
    // OCW2
    A0 <= 1'b0;
    globalBus <= 8'b01000000;
    #10;
    // OCW3
    A0 <= 1'b0;
    globalBus <= 8'b00001000; // last two bits are for read status
    #1;
    CS <= 1'b1;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;

    // trigger interrupt
    #10;
    IRBus <= 8'b10001001;

    // send OCW3 to read status
    #2;
    CS <= 1'b0;
    WR <= 1'b0;
    A0 <= 1'b0;
    globalBus <= 8'b00001010; // Read IRR
    #1;
    RD <= 1'b0;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;
    #1;
    RD <= 1'b1;
    CS <= 1'b1;
    WR <= 1'b1;
end

always @(posedge INT) begin
    #5;
    // acknowledge interrupt pulse 1
    INTA <= 1'b0;
    #5;
    INTA <= 1'b1;
    #5;
    // send OCW3 to read status
    #2;
    CS <= 1'b0;
    WR <= 1'b0;
    A0 <= 1'b0;
    globalBus <= 8'b00001011; // Read ISR
    #1;
    RD <= 1'b0;
    WR <= 1'b1;
    globalBus <= 8'bzzzzzzzz;
    #1;
    WR <= 1'b1;
    CS <= 1'b1;
    RD <= 1'b1;
    #5;
    // acknowledge interrupt pulse 2
    INTA <= 1'b0;
    RD <= 1'b0;
    CS <= 1'b0;
    #5;
    INTA <= 1'b1;
    RD <= 1'b1;
    CS <= 1'b1;
end
endmodule
