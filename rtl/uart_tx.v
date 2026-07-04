module tranx (
    input clk,
    input rst_n,
    input baud_tick,

    input [7:0] tx_data,
    input tx_start,

    output reg tx,
    output reg tx_busy
);
    reg [1:0] state ;
    reg [7:0] shift_reg ;
   
endmodule