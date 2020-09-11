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
    output reg [23:0] score_out
    );
    
    reg [9:0] lvl_nxt;
    
    initial
    begin
        counter = INIT_TIME;
    end
    
    always @(posedge clk, posedge rst)
    begin
        if(rst)
            counter = 12'b0;
        else
        begin
            counter = counter - 1;
            if(lvl != lvl_nxt)
            begin
                score_out = counter * 10;
                counter = INIT_TIME;
                lvl_nxt = lvl;
            end
        end
    end   
endmodule
