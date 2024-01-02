
module Priority_resolver_tb;

  reg autoRotateMode;
  reg [7:0] irr, imr;
  wire [7:0]maskedIRR = irr & (~imr);
  wire [2:0] highestPriority;


  // Instantiate the Priority_resolver module
  Priority_resolver dut (
    .autoRotateMode(autoRotateMode),
    .irr(irr),
    .imr(imr),
    .highestPriority(highestPriority)
  );

  // Stimulus and test cases
  initial begin
    // Test case 1: Priority on IR7
    autoRotateMode = 0;
    irr = 8'b10000000;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 2: Priority on IR3
    irr = 8'b00001000;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 3: Priority on IR5
    irr = 8'b00100000;
    imr = 8'b11011111;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 4: Priority on IR2
    irr = 8'b00000100;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 5: No priority, all interrupts masked
    irr = 8'b11001100;
    imr = 8'b11111111;
    #10;
    $display("Priority ISR: %b", highestPriority);
    
    // Test case 6: All interrupts are high
    irr = 8'b11111111;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 7: Priority on IR1
    irr = 8'b11010010;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    #10;
    autoRotateMode = 1;
    irr = 8'b10000000;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 2: Priority on IR3
    irr = 8'b00001000;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 3: Priority on IR5
    irr = 8'b00100000;
    imr = 8'b11011111;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 4: Priority on IR2
    irr = 8'b00000100;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 5: No priority, all interrupts masked
    irr = 8'b11001100;
    imr = 8'b11111111;
    #10;
    $display("Priority ISR: %b", highestPriority);
    
    // Test case 6: All interrupts are high
    irr = 8'b11111111;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

    // Test case 7: Priority on IR7
    irr = 8'b11010010;
    imr = 8'b00000000;
    #10;
    $display("Priority ISR: %b", highestPriority);

  end
endmodule

    