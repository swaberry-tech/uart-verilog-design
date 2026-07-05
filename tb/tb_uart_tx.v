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

    // Baud Generator
    baud_gen u_baud (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick)
    );

    // UART Transmitter
    uart_tx u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // 50 MHz Clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Waveforms
    initial begin
        $dumpfile("waves/uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
    end

    // Test sequence
    initial begin

        rst_n = 0;
        tx_start = 0;
        tx_data = 8'h00;

        #100;
        rst_n = 1;

        #200;

        // First byte
        tx_data = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(tx_busy);
        wait(!tx_busy);

        #500;

        // Second byte
        tx_data = 8'h3C;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(tx_busy);
        wait(!tx_busy);

        #1000;

        $display("Simulation Finished");
        $finish;
    end

    // Monitor
    initial begin
        $display("---------------------------------------------");
        $display("Time\tBusy\tTX\tData");
        $display("---------------------------------------------");

        $monitor("%0t\t%b\t%b\t%h",
                 $time,
                 tx_busy,
                 tx,
                 tx_data);
    end

endmodule