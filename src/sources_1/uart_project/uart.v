//Listing 8.4
module uart
   #( // Default setting:
      // 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
      parameter DBIT = 8,     // # data bits
                SB_TICK = 16, // # ticks for stop bits, 16/24/32
                              // for 1/1.5/2 stop bits
                DVSR = 163,   // baud rate divisor
                              // DVSR = 50M/(16*baud rate)
                DVSR_BIT = 8, // # bits of DVSR
                FIFO_W = 0    // # addr bits of FIFO
                              // # words in FIFO=2^FIFO_W
   )
   
   (
    input wire clk, reset,
    input wire  rx,
    input wire [7:0] w_data,
    output wire [7:0] r_data,
    output wire rx_done_tick
   );

   // signal declaration
   wire tick;

   //body
   mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
      (.clk(clk), .reset(reset), .q(), .max_tick(tick));

   uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
      (.clk(clk), .reset(reset), .rx(rx), .s_tick(tick),
       .rx_done_tick(rx_done_tick), .dout(r_data));

   fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit
      (.clk(clk), .reset(reset), .rd(tick),
       .wr(rx_done_tick), .w_data(r_data),
       .empty(), .full(), .r_data());

endmodule