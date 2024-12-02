module ImageProcessing_UART(
    input clk,           // Clock signal
    input rst,           // Reset signal
    input uart_rx,       // UART receive pin
    output uart_tx,      // UART transmit pin
    output [7:0] led     // Optional LEDs for debugging
);

    // UART Signals
    wire [7:0] rx_data;
    wire rx_done;
    wire tx_busy;
    reg [7:0] tx_data;
    reg tx_start;

    // Internal Memory
    reg [7:0] image_memory [0:1023]; // Image buffer (adjust size as needed)
    reg [9:0] mem_address;           // Memory address pointer

    // State Encoding
    parameter IDLE     = 2'b00;
    parameter RECEIVE  = 2'b01;
    parameter PROCESS  = 2'b10;
    parameter TRANSMIT = 2'b11;

    reg [1:0] state; // State register

    integer i; // Loop counter for the PROCESS state
    wire clk_div; // Divided clock signal

    // Instantiate UART Receiver
    UART_RX uart_rx_inst (
        .clk(clk_div),
        .rst(rst),
        .rx(uart_rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Instantiate UART Transmitter
    UART_TX uart_tx_inst (
        .clk(clk_div),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(uart_tx),
        .tx_busy(tx_busy)
    );

   
clk_divider  clk_div_inst (
    .clk_in(clk),    // System clock
    .rst(rst),       // Reset signal
    .divided_clk(clk_div) // Divided clock
);
    // FSM for Image Processing
    always @(posedge clk_div or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            mem_address <= 0;
            tx_start <= 0;
        end else begin
            case (state)
                IDLE: begin
                    mem_address <= 0;
                    tx_start <= 0;
                    if (rx_done) state <= RECEIVE;
                end
                RECEIVE: begin
                    if (rx_done) begin
                        image_memory[mem_address] <= rx_data;
                        mem_address <= mem_address + 1;
                        if (mem_address == 1023) state <= PROCESS;
                    end
                end
                PROCESS: begin
                    for (i = 0; i < 1024; i = i + 1) begin
                       image_memory[i] <= 255 - image_memory[i]; // Example: Invert pixel values
                      
                    end
                    state <= TRANSMIT;
                end
                TRANSMIT: begin
                    if (!tx_busy) begin
                        tx_data <= image_memory[mem_address];
                        tx_start <= 1;
                        mem_address <= mem_address + 1;
                        if (mem_address == 1023) state <= IDLE;
                    end else begin
                        tx_start <= 0;
                    end
                end
            endcase
        end
    end

    // Debugging LEDs
    assign led = state; // Display current state on LEDs (optional)
endmodule
