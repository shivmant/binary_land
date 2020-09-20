module uart_communication
   (
    input wire clk, 
    input wire rst,
    input wire rx,
    output wire [7:0] uart_data
   );
   
   wire [7:0] rec_data;
   reg [7:0] buff, buff_nxt;
   wire enable;
   
   always @(posedge clk)
   begin
       if(rst)
       begin
           buff <= 0;
       end
       else
       begin
           buff <= buff_nxt;
       end
   end
   
   always @*
   begin
       if(enable)
           buff_nxt = rec_data;
       else
           buff_nxt = 0;
   end
   
   uart uart_unit
   (.clk(clk), .reset(rst), .rx(rx),
    .r_data(rec_data), .rx_done_tick(enable));
   
    holder #(.HOLD_TIME(1000000))
        collision_holder0(.clk(clk), .rst(rst),
        .signal_in(buff[0]), .signal_out(uart_data[0]));
    holder #(.HOLD_TIME(1000000))
        collision_holder1(.clk(clk), .rst(rst),         
        .signal_in(buff[1]), .signal_out(uart_data[1]));
    holder #(.HOLD_TIME(1000000))
        collision_holder2(.clk(clk), .rst(rst),         
        .signal_in(buff[2]), .signal_out(uart_data[2]));
    holder #(.HOLD_TIME(1000000))
        collision_holder3(.clk(clk), .rst(rst),         
        .signal_in(buff[3]), .signal_out(uart_data[3]));
    holder #(.HOLD_TIME(1000000)) 
        collision_holder4(.clk(clk), .rst(rst),              
        .signal_in(buff[4]), .signal_out(uart_data[4]));
    holder #(.HOLD_TIME(1000000))           
        collision_holder5(.clk(clk), .rst(rst),              
        .signal_in(buff[5]), .signal_out(uart_data[5]));
    holder #(.HOLD_TIME(1000000))          
        collision_holder6(.clk(clk), .rst(rst),              
        .signal_in(buff[6]), .signal_out(uart_data[6]));
    holder #(.HOLD_TIME(1000000))           
        collision_holder7(.clk(clk), .rst(rst),              
        .signal_in(buff[7]), .signal_out(uart_data[7]));
    
endmodule
