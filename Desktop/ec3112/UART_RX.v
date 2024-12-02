module UART_RX(
    input clk,
    input rst,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

    parameter BAUD_RATE = 9600;
    parameter CLK_FREQ = 100000000; // Adjust based on your clock frequency
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [15:0] bit_timer;
    reg [3:0] bit_index;
    reg [7:0] data;
    reg receiving;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_done <= 0;
            bit_index <= 0;
            bit_timer <= 0;
            receiving <= 0;
        end else begin
            if (!receiving && !rx) begin
                receiving <= 1;
                bit_timer <= 0;
                bit_index <= 0;
            end else if (receiving) begin
                if (bit_timer == BIT_PERIOD / 2) begin
                    bit_timer <= 0;
                    if (bit_index < 8) begin
                        data[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                    end else if (bit_index == 8) begin
                        rx_data <= data;
                        rx_done <= 1;
                        receiving <= 0;
                    end
                end else begin
                    bit_timer <= bit_timer + 1;
                end
            end else begin
                rx_done <= 0;
            end
        end
    end
endmodule
