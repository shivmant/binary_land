`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2020 14:30:03
// Design Name: 
// Module Name: testbench
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


module testbench;

reg clk;
reg rst;
wire [11:0] x_pos_enemy, y_pos_enemy;
wire [23:0] x_pos_hero, y_pos_hero;
wire coll;
wire [5:0] data;
//wire up, left, right, down;

//    enemy_ctl_unit my_enemy_ctl (
//        .clk(clk),
//        .rst(rst),
//        .collision(0),
//        .hero_x_pos(0),
//        .hero_y_pos(0),
//        .x_pos(x_pos_enemy),
//        .y_pos(y_pos_enemy),
//        .player_collision(coll)
//    );
    
    lfsr (
        .clk(clk),
        .rst(rst),
        .data(data)
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
    end
    
endmodule
