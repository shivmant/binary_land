`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2020 14:13:16
// Design Name: 
// Module Name: collision_sim
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


module collision_sim;

    reg clk;
    reg clk_div, right;
    //wire pclk_mirror;
    //wire vs, hs;
    wire [10:0] vcount_in, hcount_in;
    wire vsync_in, hsync_in;
    wire vblnk_in, hblnk_in;
       
    wire [10:0] vcount_out, hcount_out;
    wire vsync_out, hsync_out;
    wire vblnk_out, hblnk_out;
    wire [11:0] rgb_out;
    
    wire [11:0] block_x_pos, block_y_pos;
    wire [11:0] x_pos_hero, y_pos_hero;
    wire [149:0] map = 150'b000000000000000_000000000000000_000000000000000_000000000000000_000000000000000_001100000001100_001000000000100_001000000000100_000000000000000_000000000000000;
    wire [3:0] collision;
    
    vga_timing my_vga_timing (
        .vcount(vcount_in),
        .vsync(vsync_in),
        .vblnk(vblnk_in),
        .hcount(hcount_in),
        .hsync(hsync_in),
        .hblnk(hblnk_in),
        .pclk(clk),
        .rst(1'b0)
    );
    
    draw_area my_area (        
        .clk(clk),                       
        .rst(1'b0),                         
        .hcount_in(hcount_in),     
        .hsync_in(hsync_in),       
        .hblnk_in(hblnk_in),       
        .vcount_in(vcount_in),     
        .vsync_in(vsync_in),       
        .vblnk_in(vblnk_in),
        .rgb_in(12'h8_8_8),     
        .map(map),  
        .hero_x_pos(1'b0),
        .hero_y_pos(1'b0), 
        .hcount_out(hcount_out),
        .hsync_out(hsync_out),  
        .hblnk_out(hblnk_out),  
        .vcount_out(vcount_out),
        .vsync_out(vsync_out),  
        .vblnk_out(vblnk_out),  
        .rgb_out(rgb_out),
        .wall_x_pos(block_x_pos),
        .wall_y_pos(block_y_pos)   
        //.collision(collision)  
    );
    
    hero_ctl my_hero_ctl (
        .clk(clk),
        .clk_div(clk_div), 
        .rst(1'b0),
        .up(1'b0),
        .left(1'b0),
        .right(right),
        .down(1'b0),
        .center(1'b0),
        .block_x_pos(block_x_pos),
        .block_y_pos(block_y_pos),
        .collision(collision),
        .x_pos(x_pos_hero),
        .y_pos(y_pos_hero)
    );
    
//    clk_divider
//          #(.FREQ(200))
//           my_clk_divider(
//            .clk100MHz(clk),
//            .rst(0),
//            .clk_div(clk_div)
//          );
    
    always
    begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end
    
//always
//    begin
//        clk_div = 1'b0;
//        #100000;
//        clk_div = 1'b1;
//        #100000;
//    end
    
//always
//        begin
//            right = 1'b0;
//            #5000000;
//            right = 1'b1;
//            #300000;
//        end 
endmodule
