module ping_pong_led #(
    // Parameters for timing
    // 12 MHz clock, 1 second = 12,000,000 cycles
    parameter COUNTER_MAX = 12_000_000 - 1
) (
    input  wire clk,      // 12 MHz clock input
    output reg  led1,     // LED 1 output
    output reg  led2      // LED 2 output
);
    
    // Counter for timing
    reg [23:0] counter;
    reg        led_state;  // 0 = LED1 on, LED2 off; 1 = LED1 off, LED2 on
    
    // Initialize outputs
    initial begin
        counter = 0;
        led_state = 0;
        led1 = 1'b1;  // LED1 starts ON (active high)
        led2 = 1'b0;  // LED2 starts OFF
    end
    
    // Main logic
    always @(posedge clk) begin
        if (counter >= COUNTER_MAX) begin
            // Reset counter and toggle LED state
            counter <= 0;
            led_state <= ~led_state;
            
            // Update LEDs based on state
            if (led_state) begin
                led1 <= 1'b0;  // Turn off LED1
                led2 <= 1'b1;  // Turn on LED2
            end else begin
                led1 <= 1'b1;  // Turn on LED1
                led2 <= 1'b0;  // Turn off LED2
            end
        end else begin
            // Increment counter
            counter <= counter + 1;
        end
    end

endmodule