// (c) 2025 IIT Dharwad
// Top file for Lattice ICE40 UP5K MDP evaluation Board

module top(
	//input osc_clk, 
	//input PB_2,
	output wire led_r
	);


wire osc_clk; 

SB_HFOSC u_hfosc (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(osc_clk)
	);

led_blink led0(
    	.clk (osc_clk),      // 50 MHz clock input
    	.rst_n (1'b1),    // Active-low reset
    	.led (led_r)       // LED output
);

endmodule
