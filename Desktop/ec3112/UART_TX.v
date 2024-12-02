module UART_TX(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);

    parameter BAUD_RATE = 9600;
    parameter CLK_FREQ = 100000000; // Adjust based on your clock frequency
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [3:0] bit_index;
    reg [15:0] bit_timer;
    reg [7:0] data;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1; // Idle state for UART
            tx_busy <= 0;
            bit_index <= 0;
            bit_timer <= 0;
            sending <= 0;
        end else if (tx_start && !sending) begin
            data <= tx_data;
            sending <= 1;
            tx_busy <= 1;
            bit_index <= 0;
            bit_timer <= 0;
            tx <= 0; // Start bit
        end else if (sending) begin
            if (bit_timer == BIT_PERIOD - 1) begin
                bit_timer <= 0;
                if (bit_index < 8) begin
                    tx <= data[bit_index];
                    bit_index <= bit_index + 1;
                end else if (bit_index == 8) begin
                    tx <= 1; // Stop bit
                    bit_index <= bit_index + 1;
                end else begin
                    sending <= 0;
                    tx_busy <= 0;
                    tx <= 1; // Idle state
                end
            end else begin
                bit_timer <= bit_timer + 1;
            end
        end
    end
endmodule
