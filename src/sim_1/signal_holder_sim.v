`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2020 17:41:49
// Design Name: 
// Module Name: signal_holder_sim
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


module signal_holder_sim;

reg clk;
reg rst;
reg [0:3] signal_in;
wire [0:3] signal_out;
wire test;

holder #(.HOLD_TIME(0))
    collision_holder(
        .clk(clk),
        .rst(0),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    
    always
    begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end  
    
    initial
    begin
    #2
    rst = 1;
    #10
    rst = 0;
    #60
    signal_in[2] = 1;
    #3
    signal_in[2] = 0;
    end  
endmodule
