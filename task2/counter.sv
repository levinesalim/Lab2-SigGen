//module must be the same as the text file
//this would increment the address
module counter #(
    parameter WIDTH = 8
)(
    //interface signals
    input logic         clk,    //clock
    input logic         rst,   //reset
    input logic         en,     //counter enable
    input logic  [WIDTH-1:0]    incr,
    output logic [WIDTH-1:0] count  //count output 
    //Number of bits is currently set to 8
);

//always_ff allows to specifies a clocked circuit
//posedge means the edge of 0 to 1
//Counts on the positive edge of the clock if enable (en) is 1
//Synchronously reset to 0 if rst is set to 1
always_ff @ (posedge clk)
    if (rst) count <= {WIDTH{1'b0}};
    else if (en)    count <= count + incr;
endmodule
