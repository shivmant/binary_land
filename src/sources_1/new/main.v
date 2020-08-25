`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2020 16:52:37
// Design Name: 
// Module Name: main
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


module main(
    input wire clk,
    input wire rst,
    input wire btnCenter,
    input wire btnUp,
    input wire btnLeft,
    input wire btnRight,
    input wire btnDown,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror,
    output wire [3:0] led
    );
    
    // CLOCK
    
    wire locked;
    wire pclk, clk100MHz, pclk_div;
    
    ODDR pclk_oddr (
        .Q(pclk_mirror),
        .C(pclk),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R(1'b0),
        .S(1'b0)
    );
      
    clk_generator my_clk_generator (   
        .clk(clk),
        .reset(rst),
        .clk65MHz(pclk),
        .clk100MHz(clk100MHz),
        .locked(locked)
    );
    
    clk_divider
      #(.FREQ(200))
       my_clk_divider(
        .clk100MHz(clk100MHz),
        .rst(rst),
        .clk_div(pclk_div)
      );
    
    //MODULES
    
    wire [11:0] x_pos_hero, y_pos_hero, block_x_pos, block_y_pos, attack_x_pos, attack_y_pos;
    wire [3:0] collision, collision_holded;
    
    wire [10:0] vcount_out_timing, hcount_out_timing;
    wire vsync_out_timing, hsync_out_timing;
    wire vblnk_out_timing, hblnk_out_timing;
    
    wire [10:0] vcount_out_background, hcount_out_background;
    wire vsync_out_background, hsync_out_background;
    wire vblnk_out_background, hblnk_out_background;
    wire [11:0] rgb_out_background;
    
    wire [10:0] vcount_out_goal, hcount_out_goal;
    wire vsync_out_goal, hsync_out_goal;
    wire vblnk_out_goal, hblnk_out_goal;
    wire [11:0] rgb_out_goal;
    
    wire [10:0] vcount_out_wall, hcount_out_wall;
    wire vsync_out_wall, hsync_out_wall;
    wire vblnk_out_wall, hblnk_out_wall;
    wire [11:0] rgb_out_wall;
   
    wire [10:0] vcount_out_pickup, hcount_out_pickup;
    wire vsync_out_pickup, hsync_out_pickup;
    wire vblnk_out_pickup, hblnk_out_pickup;
    wire [11:0] rgb_out_pickup;
    
    wire [10:0] vcount_out_hero, hcount_out_hero;
    wire vsync_out_hero, hsync_out_hero;
    wire vblnk_out_hero, hblnk_out_hero;
    wire [11:0] rgb_out_hero;
    
    wire [10:0] vcount_out_attack, hcount_out_attack;
    wire vsync_out_attack, hsync_out_attack;
    wire vblnk_out_attack, hblnk_out_attack;
    wire [11:0] rgb_out_attack;
    
    wire [599:0] map;
    wire [3:0] level;
    wire hero_rst;
    wire test;
    
    vga_timing my_vga_timing (
        .vcount(vcount_out_timing),
        .vsync(vsync_out_timing),
        .vblnk(vblnk_out_timing),
        .hcount(hcount_out_timing),
        .hsync(hsync_out_timing),
        .hblnk(hblnk_out_timing),
        .pclk(pclk),
        .rst(rst)
    );
    
    draw_background my_background (
        .clk(pclk),
        .rst(rst),
        .hcount_in(hcount_out_timing),
        .hsync_in(hsync_out_timing),
        .hblnk_in(hblnk_out_timing),
        .vcount_in(vcount_out_timing),
        .vsync_in(vsync_out_timing),
        .vblnk_in(vblnk_out_timing),
        .hcount_out(hcount_out_background),
        .hsync_out(hsync_out_background),
        .hblnk_out(hblnk_out_background),
        .vcount_out(vcount_out_background),
        .vsync_out(vsync_out_background),
        .vblnk_out(vblnk_out_background),
        .rgb_out(rgb_out_background)
    );
    
    level_management_unit my_level_management_unit (
        .clk(pclk),
        .rst(rst),
        .points(0),
        .hero_x_pos(x_pos_hero),
        .hero_y_pos(y_pos_hero),
        .level(level),
        .hero_rst(hero_rst)
    );
    
    draw_object #(.COLOR(12'hf_0_0)) goal (
            .clk(pclk),
            .rst(rst),
            .hcount_in(hcount_out_background),
            .hsync_in(hsync_out_background),
            .hblnk_in(hblnk_out_background),
            .vcount_in(vcount_out_background),
            .vsync_in(vsync_out_background),
            .vblnk_in(vblnk_out_background),
            .rgb_in(rgb_out_background),
            .x_pos(481),
            .y_pos(108),
            .hcount_out(hcount_out_goal),
            .hsync_out(hsync_out_goal),
            .hblnk_out(hblnk_out_goal),
            .vcount_out(vcount_out_goal),
            .vsync_out(vsync_out_goal),
            .vblnk_out(vblnk_out_goal),
            .rgb_out(rgb_out_goal)
        );
    
    map_rom my_rom (                 
        .clk(pclk),                  
        .level(level),                   
        .map(map)                    
    );                               
                                     
    draw_area my_area (              
        .clk(pclk),                  
        .rst(rst),                   
        .hcount_in(hcount_out_goal),  
        .hsync_in(hsync_out_goal),    
        .hblnk_in(hblnk_out_goal),    
        .vcount_in(vcount_out_goal),  
        .vsync_in(vsync_out_goal),    
        .vblnk_in(vblnk_out_goal),    
        .rgb_in(rgb_out_goal),  
        .hero_x_pos(x_pos_hero),  
        .hero_y_pos(y_pos_hero),      
        .map(map),                    
        .hcount_out(hcount_out_pickup),
        .hsync_out(hsync_out_pickup),  
        .hblnk_out(hblnk_out_pickup),  
        .vcount_out(vcount_out_pickup),
        .vsync_out(vsync_out_pickup),  
        .vblnk_out(vblnk_out_pickup),  
        .rgb_out(rgb_out_pickup),      
        .wall_x_pos(block_x_pos),    
        .wall_y_pos(block_y_pos), 
        .collision(collision)       
    );  
    
//    pickups_rom pickup_rom (
//        .clk(pclk),
//        .level(level),
//        .pickup(pickup)
//    );
    
//    pickups_management_unit my_pickups_unit (              
//        .clk(pclk),                  
//        .rst(rst),                   
//        .hcount_in(hcount_out_wall),  
//        .hsync_in(hsync_out_wall),    
//        .hblnk_in(hblnk_out_wall),    
//        .vcount_in(vcount_out_wall),  
//        .vsync_in(vsync_out_wall),    
//        .vblnk_in(vblnk_out_wall),    
//        .rgb_in(rgb_out_wall),        
//        .hero_x_pos(x_pos_hero),  
//        .hero_y_pos(y_pos_hero),
//        .pickup(pickup),               
//        .hcount_out(hcount_out_pickup),
//        .hsync_out(hsync_out_pickup),  
//        .hblnk_out(hblnk_out_pickup),  
//        .vcount_out(vcount_out_pickup),
//        .vsync_out(vsync_out_pickup),  
//        .vblnk_out(vblnk_out_pickup),  
//        .rgb_out(rgb_out_pickup),
//        .test(test)
//    );                                     
    
    hero_ctl my_hero_ctl (
        .clk(pclk),
        .clk_div(pclk_div),
        .rst(rst|hero_rst),
        .up(btnUp),
        .left(btnLeft),
        .right(btnRight),
        .down(btnDown),
        .center(btnCenter),
        .block_x_pos(block_x_pos),
        .block_y_pos(block_y_pos),
        .collision(collision),
        .x_pos(x_pos_hero),
        .y_pos(y_pos_hero)
//        .x_pos_attack(attack_x_pos),
//        .y_pos_attack(attack_y_pos)
    );
    
    draw_object hero (
        .clk(pclk),
        .rst(rst),
        .hcount_in(hcount_out_pickup),
        .hsync_in(hsync_out_pickup),
        .hblnk_in(hblnk_out_pickup),
        .vcount_in(vcount_out_pickup),
        .vsync_in(vsync_out_pickup),
        .vblnk_in(vblnk_out_pickup),
        .rgb_in(rgb_out_pickup),
        .x_pos(x_pos_hero),
        .y_pos(y_pos_hero),
        .hcount_out(hcount_out_hero),
        .hsync_out(hsync_out_hero),
        .hblnk_out(hblnk_out_hero),
        .vcount_out(vcount_out_hero),
        .vsync_out(vsync_out_hero),
        .vblnk_out(vblnk_out_hero),
        .rgb_out(rgb_out_hero)
    );
    
//    draw_object #(.COLOR(12'hf_f_f),.WIDTH(20),.HEIGHT(40)) attack (
//        .clk(pclk),
//        .rst(rst),
//        .hcount_in(hcount_out_hero),
//        .hsync_in(hsync_out_hero),
//        .hblnk_in(hblnk_out_hero),
//        .vcount_in(vcount_out_hero),
//        .vsync_in(vsync_out_hero),
//        .vblnk_in(vblnk_out_hero),
//        .rgb_in(rgb_out_hero),
//        .x_pos(attack_x_pos),
//        .y_pos(attack_y_pos),
//        .hcount_out(hcount_out_attack),
//        .hsync_out(hsync_out_attack),
//        .hblnk_out(hblnk_out_attack),
//        .vcount_out(vcount_out_attack),
//        .vsync_out(vsync_out_attack),
//        .vblnk_out(vblnk_out_attack),
//        .rgb_out(rgb_out_attack)
//    );
    
    assign hs = hsync_out_hero;
    assign vs = vsync_out_hero;
    assign r = rgb_out_hero [11:8];
    assign g = rgb_out_hero [7:4];
    assign b = rgb_out_hero [3:0];
    
    assign led[0] = test;
 
endmodule
