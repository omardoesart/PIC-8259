module Priority_resolver(
  input autoRotateMode,      // auto rotate mode
  input [7:0] irr,            // interrupt request register // 7 6 5 4 ........
  input [7:0] imr,            // interrupt mask register
  output reg[2:0] highestPriority  // the highest priority interrupt location
);
  wire [7:0] maskedIRR;
  reg dataHighImpedance;
  reg  [2:0] highestPriorityPos;

  assign maskedIRR = irr & (~imr);

  always @(maskedIRR) begin
    highestPriorityPos = 3'b000;

    if(highestPriority == 0) begin
      highestPriorityPos = 7;
    end 
    else begin
      highestPriorityPos = highestPriority - 1;
    end
  end

  integer i;
  // fully nested mode
  always @(maskedIRR) begin
    for (i = 7; i >= 0; i = i - 1) begin
      if (maskedIRR[i] && (~autoRotateMode || dataHighImpedance)) begin
        highestPriority = i;
        if (~dataHighImpedance)
          dataHighImpedance = 0;
      end
    end
  end

  // get the highest priority interrupt while taking into account the
  // value of highestPriorityPos
  // start the loop from highestPriorityPos + 1 to 7 and then from 0 to highestPriorityPos
  // this way we will get the highest priority interrupt
  always @(maskedIRR) begin
    for (i = highestPriorityPos + 1; i <= 7; i = i + 1) begin
      if (maskedIRR[i] && autoRotateMode) begin
        highestPriority = i;
        dataHighImpedance = 0;
      end
    end
    for (i = 0; i <= highestPriorityPos; i = i + 1) begin
      if (maskedIRR[i] && autoRotateMode) begin
        highestPriority = i;
        dataHighImpedance = 0;
      end
    end
  end

  always @(maskedIRR) begin
    if(~|maskedIRR) begin
      highestPriority = 3'bzzz;
      dataHighImpedance = 1;
    end
  end

endmodule
