#include "verilated.h"
#include "verilated_vcd_c.h"
//added Vsinegen and changed every Vcounter name into Vsinegen
#include "Vsinegen.h"
#include "vbuddy.cpp"

//defining values
#define MAX_SIM_CYC 1000000     //defines the maximum number of simulation clock cyles 
#define ADDRESS_WIDTH 8         //defines the number of bits used to represent addresses in the simulation
#define ROM_SZ 256              //defines the size of the ROM, 256 states it can hold 256 entries

int main(int argc, char **argv, char **env){
    int simcyc;      //simulation clock count for a full cycle
    int tick;    //each clk cycle has 2 ticks for two edges

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vsinegen* top = new Vsinegen;
    //init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("sinegen.vcd");

    //init Vbuddy
    //open and initialises Vbuddy connection
    //port path is in vbuddy.cfg
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 2: Sine Wave");

    //initialise simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->incr = 1;
    top->en = 1;    //enabling the operation of the sine wave generator hence create sine waves

    //run simulation for many clock cycles
    //for loop simulates the clock cycles of the system, each iteration is ONE full clock cycle
    for(simcyc=0; simcyc < MAX_SIM_CYC; simcyc++){
        //dump variables into VCD file and toggle clock
        //for loop runs simulation twice (one for rising edge, other for falling edge)
        for(tick=0; tick<2; tick++){
            //dumps current state of the simulation into VCD file (can be opened on GTKWave)
            tfp->dump (2*simcyc+tick);
            //for tick = 0, clock goes 0 to 1
            //for tick = 1, clock goes 1 to 0
            top->clk = !top->clk;
            top->eval ();
        }
        
        //the value from the rotary on Vbuddy board is sent back to incr
        top->incr = vbdValue();
        //we use dout because we mentioned it in sinegen.sv, it is a variable for outputting
        vbdPlot(int(top->dout), 0, 255);    //plotting on Vbuddy
        vbdCycle(simcyc); //Report the cycle count on bottom right of TFT screen

        if ((Verilated::gotFinish())  || (vbdGetkey()=='q'))
            exit(0);    //... exit if finish of 'q' is pressed

    }

    vbdClose();     //++++ House keeping the Vbuddy
    tfp->close();
    exit(0);
}
