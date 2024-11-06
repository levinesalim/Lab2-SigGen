//This is a top-level module - it will include counter.sv and rom.sv
//This is from Lecture 4 Slide 16

module sinegen #(
    parameter   A_WIDTH = 8,
                D_WIDTH = 8
)(
    //interface signals
    input logic         clk,        //clock
    input logic         rst,        //reset
    input logic         en,         //enable
    input logic [D_WIDTH-1:0] incr,     //increment for addr counter
    input logic [D_WIDTH-1:0] phase_offset, //including this, otherwise the rotary will not do a phase difference in sinegen_tb, for vbdValue() (this function changes the rotary)
    output logic [D_WIDTH-1:0] dout1,     //output data
    output logic [D_WIDTH-1:0] dout2
);
    logic   [A_WIDTH-1:0]       address;    //interconnect wire
    logic   [A_WIDTH-1:0]       address_offset; //this now has 7 bits

    assign address_offset = address + phase_offset; //using this so there can be a phase difference 

counter addrCounter (
    .clk (clk),
    .rst (rst),
    .en (en),
    .incr (incr),
    .count (address)
);

rom sineRom (
    .clk (clk),
    .addr1 (address),
    .addr2 (address_offset),
    .phase (phase_offset),      //this is inserted in to help with
    .dout1 (dout1),
    .dout2 (dout2)
);

endmodule
