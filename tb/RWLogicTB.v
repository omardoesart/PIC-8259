`include"RWLogic"

module RWLogicTB;
reg [7:0] globalBus;
reg A0;
reg CS = 1'b1;
reg WR = 1'b1;
reg RD = 1'b1;
wire [7:0] ICW1;
wire [7:0] ICW2;
wire [7:0] ICW3;
wire [7:0] ICW4;
wire [7:0] OCW1;
wire [7:0] OCW2;
wire [7:0] OCW3;
wire [3:0] ICWFlags;

RWLogic rwLogic(
.globalBus(globalBus),
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
.ICWFlags(ICWFlags)
);

initial begin
    CS = 1'b0;
    WR = 1'b0;
    globalBus <= 8'b00010001;
    A0 <= 1'b0;
    #10
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
    #10
    A0 <= 1'b1;
    globalBus <= 8'b00000001;
    #10;
    A0 <= 1'b1;
    globalBus <= 8'b00100001;
    #10;
    // now all the ICW registers should be set
    // now we can test the OCW registers
    // start with OCW2 to show that they aren't ordered
    A0 <= 1'b0;
    globalBus <= 8'b00000000;
    #10;
    A0 <= 1'b0;
    globalBus <= 8'b00001001;
    #10;
    A0 <= 1'b0;
    globalBus <= 8'b00000001;
    #10;
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
end
endmodule

module NoIC4RWLogicTB;
reg [7:0] globalBus;
reg A0;
reg CS = 1'b1;
reg WR = 1'b1;
reg RD = 1'b1;
wire [7:0] ICW1;
wire [7:0] ICW2;
wire [7:0] ICW3;
wire [7:0] ICW4;
wire [7:0] OCW1;
wire [7:0] OCW2;
wire [7:0] OCW3;
wire [3:0] ICWFlags;

RWLogic rwLogic(
.globalBus(globalBus),
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
.ICWFlags(ICWFlags)
);

initial begin
    CS = 1'b0;
    WR = 1'b0;
    globalBus <= 8'b00010000;
    A0 <= 1'b0;
    #10
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
    #10
    A0 <= 1'b1;
    globalBus <= 8'b00000001;
    #10;
    // now all the ICW registers should be set
    // now we can test the OCW registers
    // start with OCW2 to show that they aren't ordered
    A0 <= 1'b0;
    globalBus <= 8'b00000000;
    #10;
    A0 <= 1'b0;
    globalBus <= 8'b00001001;
    #10;
    A0 <= 1'b0;
    globalBus <= 8'b00000001;
    #10;
    A0 <= 1'b1;
    globalBus <= 8'b00000000;
end
endmodule