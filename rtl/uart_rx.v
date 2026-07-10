module uart_rx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input clk,
    input rst_n,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_done
);

    localparam integer BAUD_COUNT = CLK_FREQ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_counter;
    reg [15:0] baud_counter;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            state        <= IDLE;
            shift_reg    <= 8'd0;
            rx_data      <= 8'd0;
            bit_counter  <= 3'd0;
            baud_counter <= 16'd0;
            rx_done      <= 1'b0;
        end

        else begin

            // Default
            rx_done <= 1'b0;

            case (state)

            IDLE: begin
                baud_counter <= 16'd0;
                bit_counter  <= 3'd0;

                if (!rx)
                    state <= START;
            end

            START: begin

                if (baud_counter == (BAUD_COUNT/2)-1) begin

                    baud_counter <= 16'd0;

                    if (!rx)
                        state <= DATA;
                    else
                        state <= IDLE;

                end
                else
                    baud_counter <= baud_counter + 1'b1;

            end

            DATA: begin

                if (baud_counter == BAUD_COUNT-1) begin

                    baud_counter <= 16'd0;

                    shift_reg[bit_counter] <= rx;

                    if (bit_counter == 3'd7) begin
                        bit_counter <= 3'd0;
                        state <= STOP;
                    end
                    else begin
                        bit_counter <= bit_counter + 1'b1;
                    end

                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end

            end
            
            STOP: begin

                if (baud_counter == BAUD_COUNT-1) begin

                    baud_counter <= 16'd0;

                    if (rx) begin
                        rx_data <= shift_reg;
                        rx_done <= 1'b1;
                    end

                    state <= IDLE;

                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end

            end

            default:
                state <= IDLE;

            endcase

        end

    end

endmodule

