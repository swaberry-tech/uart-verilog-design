module baud_gen #(
    parameter CLK_FREQ  = 50_000_000, //50 MHz Clk
    parameter BAUD_RATE = 115_200     // Baud rate 
)(
    input  wire clk,
    input  wire rst_n,
    output reg  baud_tick
);

    // Number of clock cycles per baud period
    localparam integer BAUD_COUNT = CLK_FREQ / BAUD_RATE;

    // Counter
    reg [15:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter   <= 16'd0;
            baud_tick <= 1'b0;
        end
        else begin
            if (counter == BAUD_COUNT - 1) begin
                counter   <= 16'd0;
                baud_tick <= 1'b1;   // Pulse for one clock cycle
            end
            else begin
                counter   <= counter + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule