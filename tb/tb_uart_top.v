`timescale 1ns/1ps

module uart_top_tb;

parameter CLK_FREQ  = 50_000_000;
parameter BAUD_RATE = 115200;

reg clk;
reg rst_n;

// TRANSMITTER
reg tx_start;
reg [7:0] tx_data;
wire tx_busy;
wire tx;

// RECEIVER
wire rx;
wire [7:0] rx_data;
wire rx_done;

// Loopback connection
assign rx = tx;

// DUT
uart_top #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) dut (

    .clk(clk),
    .rst_n(rst_n),

    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_busy(tx_busy),
    .tx(tx),

    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

// Dump waveform
initial begin
    $dumpfile("waves/uart_top.vcd");
    $dumpvars(0, uart_top_tb);
end

// 50 MHz clock
always #10 clk = ~clk;

// Test
initial begin

    clk = 0;
    rst_n = 0;
    tx_start = 0;
    tx_data = 8'h00;

    #100;
    rst_n = 1;

    // Send A5
    @(posedge clk);
    tx_data = 8'hA5;
    tx_start = 1;

    @(posedge clk);
    tx_start = 0;

    wait(rx_done);

    if (rx_data == 8'hA5)
        $display("PASS: Received A5");
    else
        $display("FAIL: Expected A5, Got %h", rx_data);

    wait(!tx_busy);

    // Send 3C
    @(posedge clk);
    tx_data = 8'h3C;
    tx_start = 1;

    @(posedge clk);
    tx_start = 0;

    wait(rx_done);
 
     if (rx_data == 8'h3C)
        $display("PASS: Received 3C");
    else
        $display("FAIL: Expected 3C, Got %h", rx_data);

    #1000;

    $finish;

end

endmodule