module ISR_tb;

reg [2:0] highestPriority;
reg INTA;
reg currentPulse;
wire [7:0] currentAddress;

ISR ISR(
    .highestPriority(highestPriority),
    .AddressBase(8'b00100000),
    .INTA(INTA),
    .currentPulse(currentPulse),
    .currentAddress(currentAddress)
);

initial begin
  highestPriority = 3'bzzz;
  INTA = 1'b1;
  #10;
  INTA = 1'b0;
  currentPulse = 1'b0;
  highestPriority = 3'b010;
  #10;
  INTA = 1'b1;
  #10;
  INTA = 1'b0;
  currentPulse = 1'b1;
  #10;
  INTA = 1'b1;
end

endmodule