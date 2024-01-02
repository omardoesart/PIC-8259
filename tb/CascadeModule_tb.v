module CascadeModule_tb;
    // create one master and two slaves on port 0 and 3
    reg [2:0]currentSlave; // indicate which slave is currently causing the interrupt
    reg interruptExists; // indicate if there is an interrupt
    wire [2:0]CAS;
    wire Address_Write_Enable_Master;
    wire Address_Write_Enable_Slave0;
    wire Address_Write_Enable_Slave3;

    CascadeModule Master(
        .SP(1'b1),
        .SNGL(1'b0),
        .ICW3(8'b00001001),
        .Interrupt_Location(currentSlave),
        .interruptExists(interruptExists),
        .CAS(CAS),
        .Address_Write_Enable(Address_Write_Enable_Master)
    );
    
    CascadeModule Slave0(
        .SP(1'b0),
        .SNGL(1'b0),
        .ICW3(8'b00000000),
        .Interrupt_Location(3'b000),
        .interruptExists(1'b1),
        .CAS(CAS),
        .Address_Write_Enable(Address_Write_Enable_Slave0)
    );

    CascadeModule Slave3(
        .SP(1'b0),
        .SNGL(1'b0),
        .ICW3(8'b00000011),
        .Interrupt_Location(3'b011),
        .interruptExists(1'b1),
        .CAS(CAS),
        .Address_Write_Enable(Address_Write_Enable_Slave3)
    );

    initial begin
        currentSlave = 3'bz;
        interruptExists = 1'b0;
        $monitor("When the current active slave(Interrupt_Location) is: %b\nthe Address write enabled flags are -> Master: %b, Slave0: %b, Slave3: %b, CAS: %b\n", 
            currentSlave,
            Address_Write_Enable_Master, 
            Address_Write_Enable_Slave0, 
            Address_Write_Enable_Slave3, 
            CAS
        );
        #10;
        interruptExists = 1'b1;
        currentSlave = 3'b000;
        #10;
        currentSlave = 3'b011;
        #10;
        currentSlave = 3'b001;
        #10;
        currentSlave = 3'bz;
        interruptExists = 1'b0;
    end

endmodule
