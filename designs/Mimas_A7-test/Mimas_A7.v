module mimas_a7 (
    input wire clk,
    output wire led
);

    reg [26:0] counter = 27'd0;

    always @(posedge clk) begin
        counter <= counter + 1'b1;
    end

    assign led = counter[26];

endmodule
