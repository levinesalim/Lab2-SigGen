module sigdelay #(
    parameter   A_WIDTH = 9,
                D_WIDTH = 8
)(
    //interface signals
    input logic         clk,        //clock
    input logic         rst,        //reset
    input logic         wr_en,         //enable
    input logic         rd_en,
    input logic         en,
    input logic [A_WIDTH-1:0] incr,     //increment for addr counter
    input logic [D_WIDTH-1:0] mic_signal,
    input logic [A_WIDTH-1:0] offset, //including this, otherwise the rotary will not do a phase difference in sinegen_tb, for vbdValue() (this function changes the rotary)
    output logic [D_WIDTH-1:0] delayed_signal,     //output data
);
    logic   [A_WIDTH-1:0]       address;    //interconnect wire
    logic   [A_WIDTH-1:0]       address_offset; //this now has 7 bits
    assign address_offset = address - offset; //using this so there can be a phase difference 

counter addrCounter (
    .clk (clk),
    .rst (rst),
    .en (en),
    .incr (incr),
    .count (address)
);

ram sigDelay (
    .clk (clk),
    .wr_en (wr_en),
    .rd_en (rd_en),
    .wr_addr (address),      //this is inserted in to help with
    .rd_addr (address_offset),
    .din (mic_signal),
    .dout (delayed_signal)
);

endmodule
