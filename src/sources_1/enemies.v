`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:08:35
// Design Name: 
// Module Name: enemies
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


module enemies(
        input wire clk,
        input wire rst,
        
        input wire [23:0] hero_x_pos, 
        input wire [23:0] hero_y_pos,
        input wire [23:0] hero_attack_x_pos,
        input wire [23:0] hero_attack_y_pos,
        input wire attack_direction,
        
        input wire [10:0] vcount_in,
        input wire vsync_in,
        input wire vblnk_in,
        input wire [10:0] hcount_in,
        input wire hsync_in,
        input wire hblnk_in,
        input wire [11:0] rgb_in,
        input wire [11:0] x_pos, 
        input wire [11:0] y_pos,
        
//        output reg [11:0] x_pos,
//        output reg [11:0] y_pos,
        output reg player_collision,
        output reg eliminated,
        
        output reg [10:0] vcount_out,
        output reg vsync_out,
        output reg vblnk_out,
        output reg [10:0] hcount_out,
        output reg hsync_out,
        output reg hblnk_out,
        output reg [11:0] rgb_out
    );
    
    
    
    
    
endmodule
