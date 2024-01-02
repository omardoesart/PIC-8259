module ISR (
    input [2:0] highestPriority,      // Input priority signal
    input [7:0] AddressBase,          // Input address base signal coming from the ICW2 T7-T3 pins
    input INTA,                       // Input active low signal
    input currentPulse,               // Input signal indicating current pulse
    output reg [7:0] currentAddress    // Output address signal
);
/*
Documentation

This module, named ISR (Interrupt Service Routine), is designed to generate the current address based on the highest priority interrupt and the address base signal. It is suitable for use in a PIC8259A-like interrupt controller.

Inputs:
    highestPriority: A 3-bit input representing the highest priority interrupt signal.
    AddressBase: An 8-bit input representing the address base signal coming from the ICW2 T7-T3 pins.
    INTA: An input active low signal indicating the acknowledgment of an interrupt request.
    currentPulse: An input signal indicating the current pulse in the interrupt acknowledgment cycle.

Outputs:
    currentAddress: An 8-bit output representing the current address generated by the ISR.

Behavior:
    - At the positive edge of the INTA signal, the module updates the currentAddress based on the current pulse.
    - If it is the end of the first pulse (currentPulse == 0), the module saves the highest priority interrupt by combining it with the AddressBase.
    - If it is the end of the second pulse, the module resets the current address to an undefined state (8'bzzzzzzzz).
*/

    always @(posedge INTA) begin
        // If this is the end of the first pulse, save the highest priority
        if (currentPulse === 0) begin
            currentAddress <= AddressBase | highestPriority;
        end else begin
            // If this is the end of the second pulse, reset the current address
            currentAddress <= 8'bzzzzzzzz;
        end
    end
    
endmodule
