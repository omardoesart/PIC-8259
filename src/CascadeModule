module CascadeModule(
    input SP, // 1 for master, 0 for slave
    input SNGL, // 1 for single, 0 for cascade
    input [7:0] ICW3, // master: port numbers of slaves, slave: interrupt location
    input [2:0] Interrupt_Location, // interrupt location with highest priority
    input interruptExists, // 1 if there is an interrupt
    inout [2:0] CAS, // current active slave
    output Address_Write_Enable // 1 if this module should write to the bus
);

wire isSingle = (SNGL == 1'b1);
wire isMaster = (SP == 1'b1);
assign Address_Write_Enable = isSingle | (isMaster & ~ICW3[Interrupt_Location]) | (~isMaster & (CAS == ICW3[2:0]));
reg [2:0] CAS_Reg;
assign CAS = isMaster ? CAS_Reg : 3'bz;

always @(Interrupt_Location) begin
    if(isMaster) begin
        CAS_Reg <= Interrupt_Location;
        if(~interruptExists) begin
            CAS_Reg <= 3'b111;
        end
    end
end

endmodule
