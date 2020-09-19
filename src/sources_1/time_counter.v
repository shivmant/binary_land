`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2020 23:29:41
// Design Name: 
// Module Name: time_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module time_counter
    #(parameter INIT_TIME = 60) //initial time number in seconds
    (
    input wire clk,
    input wire rst,
    input wire [9:0] lvl,
    output reg [11:0] counter,
    output reg time_out
    );
    
    reg [9:0] lvl_buf, lvl_buf_nxt;
    reg [11:0] counter_nxt;
    wire clk_div;
    reg time_out_nxt;
    
    always @(posedge clk_div, posedge rst)
    begin
        if(rst)
        begin
            counter <= INIT_TIME;
            time_out <= 0;
            lvl_buf <= lvl;
        end
        else
        begin
            counter <= counter_nxt;
            time_out <= time_out_nxt;
            lvl_buf <= lvl_buf_nxt;
        end
    end
    
    always @*
    begin
        if(lvl != lvl_buf)
        begin
            counter_nxt = INIT_TIME;
            lvl_buf_nxt = lvl;
        end
        else
        begin
            counter_nxt = counter - 1;
            if(counter == 0)
            begin
                counter_nxt = INIT_TIME;
                time_out_nxt = 1;
            end
            else
                time_out_nxt = 0;
        end
            
    end
        
    clk_divider
    #(.FREQ(1))
     my_clk_divider_timer(
      .clk100MHz(clk),
      .rst(rst),
      .clk_div(clk_div)
    );    
        
endmodule
