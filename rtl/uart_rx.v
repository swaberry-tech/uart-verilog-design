module uart_rx#(
    parameter CLK_FREQ  = 50_000_000, //50 MHz Clk
    parameter BAUD_RATE = 115_200     // Baud rate 
)(
    input clk ,
    input rst_n ,
    input baud_tick ,
    
    input rx ,

    output reg [7:0] rx_data,
    output reg rx_done
);
    reg [1:0] state ;
    reg [7:0] shift_reg ;
    reg [2:0] bit_counter ;
    reg [15:0] counter ;

    localparam IDLE = 2'b00 ;
    localparam START = 2'b01 ;
    localparam DATA = 2'b10 ;
    localparam STOP = 2'b11 ; 
    localparam integer BAUD_COUNT = CLK_FREQ / BAUD_RATE ;

    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            state <= IDLE ;
            rx_data <= 8'b0 ;
            shift_reg <= 8'b0 ;
            bit_counter <= 3'd0 ;
            rx_done <= 1'b0 ;
            counter <= 16'd0 ;
        end

        else begin 
            rx_done <= 1'b0 ;

            case (state) 

                IDLE : begin 
                    bit_counter <= 3'd0;
                    counter <= 16'd0 ; 

                    if (!rx) state <= START ;
                end

                START : begin 
                    if(counter == (BAUD_COUNT/2) - 1) begin 
                        counter <= 16'd0 ;
                        if(!rx) state <= DATA ;
                        else state <= IDLE ;
                    end
                   else counter <= counter + 1'b1 ;
                end

                DATA : begin 
                    if(count == BAUD_COUNT - 1) begin
                        counter <= 16'd0 ; 
                        shift_reg [bit_counter] <= rx ;
                        if(bit_counter == 3'd7) begin
                            bit_counter <= 3'd0 ;
                            state <= STOP ;
                        end
                        else bit_counter <= bit_counter + 1'b1 ;  
                    end
                    else counter <= counter + 1'b1 ;
                end 

                 STOP : begin 
                    if(counter == BAUD_COUNT - 1 ) begin 
                        counter <= 16'd0 ;
                        if(rx) begin 
                            rx_data <= shift_reg;
                            rx_done <= 1'b1;
                        end
                        state <= IDLE;
                        else counter <= counter + 1'b1 ;
                    end
                end
            endcase
        end
    end

endmodule