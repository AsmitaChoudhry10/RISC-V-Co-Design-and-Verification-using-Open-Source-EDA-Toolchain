module top (
    input  wire osc_clk,   // 12 MHz oscillator clock
    output wire LED_1,     // LED 1 on pin B1
    output wire LED_2      // LED 2 on pin F2
);

    // Instantiate the ping_pong_led module
    ping_pong_led #(
        .COUNTER_MAX(12_000_000 - 1)  // 1 second at 12 MHz
    ) ping_pong_inst (
        .clk(osc_clk),
        .led1(LED_1),
        .led2(LED_2)
    );

endmodule