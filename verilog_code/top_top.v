module top_top(

    input btn0,
    input btn1,
    input clk,
    input RxD,
    input [3:0] transform,
    input darken_factor,
    output TxD,
    output TxD_debug,
    output transmit_debug,
    output button_debug
);
    wire [7:0] data;      // Data received from the receiver
    reg [7:0] data2;      // Data after transformation
    reg [6:0] darken;
//    reg [7:0] buffer [0:2];
    //reg [1:0] count;
//    reg [1:0] send_count;
//    reg [7:0] byte_to_send;
//    reg tx_en;
    
 
    // Data transformation logic
    always @ (posedge clk) begin
//    if(data == 255) count <= count;
//    else if(data == 0) count <= count;
//    else if(count == 2'b11) count <= 0;
//    else count <= count + 1;
       case (darken_factor)
       
       1'b0: darken <= 50;
       1'b1: darken <= 75;
       
       endcase
       
        
        case(transform)
            4'b0001: data2 <= data;                
            4'b0010: data2 <= (data + darken <= 255 ? data + darken : 255);  // Add 50 to data
            4'b0100: data2 <= (data - darken >= 0 ? data - darken : 0);      // Subtract 50 from data
            4'b1000: data2 <= 255 - data;           // Invert the data 
            
        endcase
//        case(count)
//            2'b01: data2 <= data;
//            2'b10: data2 <= 0;
//            2'b11: data2 <= 0;
//        endcase
          
    end

    
//    // Transmitter module
    top transmit1 (
        .sw(data2),  
        .btn0(btn0), 
        .btn1(btn1), 
        .clk(clk), 
        .TxD(TxD), 
        .TxD_debug(TxD_debug), 
        .transmit_debug(transmit_debug), 
        .button_debug(button_debug)
    );

    // Receiver module
    receiver r1 (
        .clk(clk), 
        .reset(btn0), 
        .RxD(RxD), 
        .RxData(data)  // Data received through RxD
    );
    
endmodule
