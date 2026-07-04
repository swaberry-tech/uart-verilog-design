module tranx (
    input clk,
    input rst_n,
    input baud_tick,

    input [7:0] tx_data,
    input tx_start,

    output reg tx,
    output reg tx_busy
);

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_counter;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            tx          <= 1'b1;      // UART line is idle high
            tx_busy     <= 1'b0;
            shift_reg   <= 8'b0;
            bit_counter <= 3'b0;
        end

        else if (baud_tick) begin
            case (state)

                //--------------------------------------------------
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;

                    if (tx_start) begin
                        shift_reg   <= tx_data;
                        bit_counter <= 3'd0;
                        tx_busy     <= 1'b1;
                        state       <= START;
                    end
                end

                //--------------------------------------------------
                START: begin
                    tx <= 1'b0;            // Start bit
                    state <= DATA;
                end

                //--------------------------------------------------
                DATA: begin
                    tx <= shift_reg[0];    // Send LSB first
                    shift_reg <= shift_reg >> 1;

                    if (bit_counter == 3'd7)
                        state <= STOP;
                    else
                        bit_counter <= bit_counter + 1;
                end

                //--------------------------------------------------
                STOP: begin
                    tx <= 1'b1;            // Stop bit
                    tx_busy <= 1'b0;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule