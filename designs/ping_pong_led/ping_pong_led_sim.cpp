#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vping_pong_led.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    // Create instance of our module with small counter for simulation
    Vping_pong_led* dut = new Vping_pong_led;
    
    // Initialize VCD tracing
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace(tfp, 99);
    tfp->open("ping_pong_led.vcd");
    
    // Initialize signals
    dut->clk = 0;
    
    // Simulation parameters
    const int SIM_TIME = 100;  // Number of clock cycles to simulate
    int time_counter = 0;
    
    std::cout << "Starting ping_pong_led simulation..." << std::endl;
    std::cout << "Time\tCLK\tLED1\tLED2" << std::endl;
    
    // Run simulation
    for (int i = 0; i < SIM_TIME * 2; i++) {
        // Toggle clock
        dut->clk = !dut->clk;
        
        // Evaluate model
        dut->eval();
        
        // Write trace
        tfp->dump(time_counter++);
        
        // Print status every few cycles (on rising edge)
        if (dut->clk && (i % 4 == 0)) {
            std::cout << time_counter << "\t" 
                      << (int)dut->clk << "\t"
                      << (int)dut->led1 << "\t"
                      << (int)dut->led2 << std::endl;
        }
        
        // Check for finish conditions
        if (Verilated::gotFinish()) break;
    }
    
    // Clean up
    tfp->close();
    delete dut;
    delete tfp;
    
    std::cout << "Simulation completed. VCD file generated: ping_pong_led.vcd" << std::endl;
    std::cout << "Note: This simulation uses the full 12M counter, so LEDs won't toggle in this short sim." << std::endl;
    std::cout << "To see LED toggling, check the hardware build or modify COUNTER_MAX parameter." << std::endl;
    
    return 0;
}