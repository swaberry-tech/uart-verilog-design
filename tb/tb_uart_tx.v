`timescale 1ns/1ps

module uart_tx_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg tx_start;
    reg [7:0] tx_data;

    // Outputs
    wire baud_tick;
    wire tx;
    wire tx_busy;

    // Instantiate Baud Generator
    baud_gen u_baud (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick)
    );

    // Instantiate UART Transmitter
    tranx u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Waveform dump
    initial begin
        $dumpfile("waves/uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
    end

    // Stimulus
    initial begin

        rst_n = 0;
        tx_start = 0;
        tx_data = 8'h00;

        #100;
        rst_n = 1;

        // Wait a little after reset
        #200;

        // Transmit first byte
        tx_data = 8'hA5;      // 10100101
        tx_start = 1;

        #20;                  // One clock pulse
        tx_start = 0;

        // Wait until transmission finishes
        wait(tx_busy == 0);

        #500;

        // Transmit another byte
        tx_data = 8'h3C;      // 00111100
        tx_start = 1;

        #20;
        tx_start = 0;

        wait(tx_busy == 0);

        #1000;

        $display("Simulation Finished");
        $finish;

    end

    // Monitor signals
    initial begin
        $display("------------------------------------------------------");
        $display("Time\tState\tBusy\tTX\tData");
        $display("------------------------------------------------------");

        $monitor("%0t\t%d\t%b\t%b\t%h",
                 $time,
                 dut.state,
                 tx_busy,
                 tx,
                 tx_data);
    end

endmodule