`timescale 1ns / 1ps

module ping_pong_led_tb;

    // Testbench signals
    reg clk;
    wire led1, led2;
    
    // Instantiate the Device Under Test (DUT)
    ping_pong_led #(
        .COUNTER_MAX(11)  // Use smaller counter for faster simulation (12 cycles instead of 12M)
    ) dut (
        .clk(clk),
        .led1(led1),
        .led2(led2)
    );
    
    // Clock generation (12 MHz = 83.33ns period)
    initial begin
        clk = 0;
        forever #41.67 clk = ~clk;  // 83.33ns / 2 = 41.67ns
    end
    
    // Test stimulus
    initial begin
        $display("Starting ping_pong_led testbench");
        $display("Time\tLED1\tLED2");
        $monitor("%0d\t%b\t%b", $time, led1, led2);
        
        // Run simulation for several LED toggles
        #2000;
        
        $display("Testbench completed");
        $finish;
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("ping_pong_led.vcd");
        $dumpvars(0, ping_pong_led_tb);
    end

endmodule