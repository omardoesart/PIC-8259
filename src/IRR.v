module IRR (
    input reset,                   // Resets signal to initial state
    input LTIM,                    // Determines whether interrupts are edge or level-triggered
    input [7:0] IRBus,              // Vectorized input for interrupt signals
    input [2:0] highestPriority,   // Input signal indicating the highest priority interrupt
    input INTA,                    // Input active-low signal
    input currentPulse,            // Input signal indicating the current pulse
    output reg [7:0] irr            // Interrupt Request Register
);
/*
Documentation

This module represents the Interrupt Request Register (IRR) in a PIC8259A-like interrupt controller.

Inputs:
    reset: Resets the module to its initial state.
    LTIM: Determines whether interrupts are edge or level-triggered.
    IRBus: Vectorized input representing individual interrupt signals.
    highestPriority: Input signal indicating the highest priority interrupt.
    INTA: Input active-low signal.
    currentPulse: Input signal indicating the current pulse.

Outputs:
    irr: 8-bit output representing the Interrupt Request Register.

Behavior:
1. Edge-triggered Logic:
   - For each bit in IRBus, updates irr with the current value of the interrupt on the positive edge.

2. Level-triggered Logic:
   - Updates irr with the current values of the interrupt if LTIM is set.

3. Reset Logic:
   - Resets irr to all zeros when the reset signal is asserted.

4. INTA Handling:
   - Updates the corresponding bit in irr to 0 when currentPulse is 0 and interrupts are edge-triggered.

Usage:
   - Connect the inputs and observe the irr output to determine active interrupts.

*/

    // Edge-triggered logic...
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            always @(posedge IRBus[i]) begin
                if (!LTIM) begin
                    irr[i] <= IRBus[i];
                end
            end
        end
    endgenerate

    // Level-triggered logic...
    always @(IRBus) begin
        if (LTIM) begin
            irr <= IRBus;
        end
    end

    // Reset logic...
    always @(reset) begin
        if (reset) begin
            irr <= 8'b00000000;
        end
    end

    // INTA handling...
    always @(posedge INTA) begin
        if (currentPulse === 0 && ~LTIM) begin
            irr[highestPriority] <= 1'b0;
        end
    end
endmodule
