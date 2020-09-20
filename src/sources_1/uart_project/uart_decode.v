`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2020 17:58:34
// Design Name: 
// Module Name: uart_decode
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


module uart_decode(
    input  wire clk,
    input  wire rst,
    input  wire [7:0] uart_data,
    output reg btnAttack,
    output reg btnUp,
    output reg btnLeft,
    output reg btnRight,
    output reg btnDown
    );
    
    reg btnAttack_nxt, btnUp_nxt, btnLeft_nxt, btnRight_nxt, btnDown_nxt;
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            btnAttack <= 0;
            btnUp     <= 0;
            btnLeft   <= 0;
            btnRight  <= 0;
            btnDown   <= 0;
        end
        else
        begin
            btnAttack <= btnAttack_nxt;
            btnUp     <= btnUp_nxt;
            btnLeft   <= btnLeft_nxt;
            btnRight  <= btnRight_nxt;
            btnDown   <= btnDown_nxt;       
        end    
    end
    
    always @*
    begin
            if(uart_data == 8'h77) //w
                btnUp_nxt = 1;
            else if(uart_data == 8'h73) //s
                btnDown_nxt = 1;
            else if(uart_data == 8'h61) //a
                btnLeft_nxt = 1;
            else if(uart_data == 8'h64) //d
                btnRight_nxt = 1;
            else if(uart_data == 8'h20) //spacja
                btnAttack_nxt = 1;
            else
            begin
                btnAttack_nxt = 0;
                btnUp_nxt     = 0;
                btnLeft_nxt   = 0;
                btnRight_nxt  = 0;
                btnDown_nxt   = 0;
            end
    end
endmodule
