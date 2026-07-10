module uart_top #(
    parameter CLK_FREQ = 50_000_000 , //50 MHz
    parameter BAUD_RATE = 115_200 
) (
    input clk ,
    input rst_n,
    
    //TRANSMITTER 
    input tx_start ,
    input [7:0] tx_data ,
    output tx_busy ,
    output tx ,

    //RECEIVER 
    input rx ,
    output [7:0] rx_data,
    output rx_done
);

wire baud_tick ;

    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_generator (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick)
    );

    uart_tx transmitter (
         .clk(clk),
         .rst_n(rst_n),
         .baud_tick(baud_tick),

         .tx_start(tx_start),
         .tx_data(tx_data),

         .tx(tx),
         .tx_busy(tx_busy)
    );

    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) receiver (

        .clk(clk),
        .rst_n(rst_n),

        .rx(rx),

        .rx_data(rx_data),
        .rx_done(rx_done)
);

endmodule