`timescale 1ns/1ps

module baud_gen_tb;

    reg clk;
    reg rst_n;
    wire baud_tick;
    integer clk_count;

    initial begin
        $dumpfile ("waves/baud.vcd");
        $dumpvars (0,baud_gen_tb);
    end

    baud_gen dut (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick)
    );

    //Clock generated 20ns period
    initial begin 
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // Reset sequence
    initial begin
        $display("Simulation Started");
        rst_n = 1'b0;
        clk_count = 0;
        #100;
        rst_n = 1'b1;
        #50000;
        $display("Simulation Finished");
        $finish;
    end

     always @(posedge clk) begin

        if (!rst_n) begin
            clk_count <= 0;
        end
        else begin

            if (baud_tick) begin

                $display("Baud Tick at time %0t ns after %0d clocks",
                         $time, clk_count);

                // Expected count = 433
                // Tick occurs on the next clock
                if (clk_count == 433)
                    $display("PASS");
                else
                    $display("FAIL: Expected 433, Got %0d", clk_count);

                clk_count <= 0;
            end
            else begin
                clk_count <= clk_count + 1;
            end

        end

    end
endmodule