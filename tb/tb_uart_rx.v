`timescale 1ns/1ps

module uart_rx_tb;

    parameter CLK_FREQ  = 50000000;
    parameter BAUD_RATE = 115200;

    localparam CLK_PERIOD = 20;                         // 50 MHz
    localparam BIT_TIME   = 1000000000 / BAUD_RATE;     // ns

    reg clk;
    reg rst_n;
    reg rx;

    wire [7:0] rx_data;
    wire rx_done;

    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    //-----------------------------
    // Clock generation
    //-----------------------------
    always #(CLK_PERIOD/2) clk = ~clk;

    //-----------------------------
    // UART transmit task
    //-----------------------------
    task uart_send_byte;
        input [7:0] data;
        integer i;
        begin

            // Start bit
            rx = 0;
            #(BIT_TIME);

            // Data bits (LSB first)
            for(i=0;i<8;i=i+1) begin
                rx = data[i];
                #(BIT_TIME);
            end

            // Stop bit
            rx = 1;
            #(BIT_TIME);

        end
    endtask

    //-----------------------------
    // Test sequence
    //-----------------------------
    initial begin

        $dumpfile("waves/uart_rx.vcd");
        $dumpvars(0,uart_rx_tb);

        clk = 0;
        rst_n = 0;
        rx = 1;          // UART idle

        #100;

        rst_n = 1;

        #1000;

        uart_send_byte(8'hA5);

        #20000;

        uart_send_byte(8'h3C);

        #30000;

        $finish;

    end

    //-----------------------------
    // Monitor
    //-----------------------------
    initial begin
        $monitor("Time=%0t rx=%b rx_done=%b rx_data=%h",
                 $time, rx, rx_done, rx_data);
    end

endmodule