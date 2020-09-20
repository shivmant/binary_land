`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2020 16:52:37
// Design Name: 
// Module Name: top
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


module top(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror
    );
    
    // CLOCK
    
    wire locked;
    wire pclk, clk100MHz, clk50MHz;
    
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
        .clk100MHz(clk100MHz),
        .clk65MHz(pclk),
        .clk50MHz(clk50MHz),
        .locked(locked)
    );
      
    //MODULES
    wire [11:0] x_pos_enemy, y_pos_enemy;
    
    wire [23:0] x_pos_attack, y_pos_attack;
    wire [23:0] x_pos_hero, y_pos_hero;    
    wire [7:0] collision;                  
    wire player_collision;                 
    
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
                                                                  
    wire [10:0] vcount_out_hero_mirror, hcount_out_hero_mirror;   
    wire vsync_out_hero_mirror, hsync_out_hero_mirror;            
    wire vblnk_out_hero_mirror, hblnk_out_hero_mirror;            
    wire [11:0] rgb_out_hero_mirror;                              
                                                                  
    wire [10:0] vcount_out_enemy, hcount_out_enemy;               
    wire vsync_out_enemy, hsync_out_enemy;                        
    wire vblnk_out_enemy, hblnk_out_enemy;                        
    wire [11:0] rgb_out_enemy;                                                                                                                       
    
    wire [10:0] vcount_out_attack, hcount_out_attack; 
    wire vsync_out_attack, hsync_out_attack;          
    wire vblnk_out_attack, hblnk_out_attack;          
    wire [11:0] rgb_out_attack;                       
                                                      
    wire [10:0] vcount_out_score, hcount_out_score;   
    wire vsync_out_score, hsync_out_score;            
    wire vblnk_out_score, hblnk_out_score;            
    wire [11:0] rgb_out_score;                        
    
    wire [599:0] map;
    wire [9:0] level;
    wire [11:0] time_count;
    wire level_rst;
    wire time_out;
    wire [7:0] char_pixels;
    wire [10:0] addr_char;
    wire [7:0] char_xy;
    wire attack_dir;
    wire add_time;
    wire [23:0] score_map, score_req, score_time, score_enemy;
    
    // UART
    wire [7:0] uart_button;
    wire move_attack, move_up, move_left, move_right, move_down; 
     
    vga_timing my_vga_timing (
        .vcount(vcount_out_timing),
        .vsync(vsync_out_timing),
        .vblnk(vblnk_out_timing),
        .hcount(hcount_out_timing),
        .hsync(hsync_out_timing),
        .hblnk(hblnk_out_timing),
        .clk(pclk),
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
        .score(score_enemy),
        .hero_x_pos(x_pos_hero),
        .hero_y_pos(y_pos_hero),
        .level(level),
        .hero_rst(level_rst),
        .score_req(score_req)
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
        .x_pos(482),
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
                                     
    map_ctl_unit my_area (              
        .clk(pclk),                    
        .rst(rst),                     
        .next_level(level_rst|time_out|player_collision),                   
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
        .collision(collision),         
        .score_out(score_map),
        .add_time(add_time)       
    );                                 
    
    hero_ctl my_hero_ctl (           
        .clk(clk100MHz),              
        .rst(rst|level_rst|time_out|player_collision),         
        .up(move_up),                  
        .left(move_left),              
        .right(move_right),            
        .down(move_down),              
        .center(move_attack),          
        .collision(collision),       
        .x_pos(x_pos_hero),          
        .y_pos(y_pos_hero),          
        .x_pos_attack(x_pos_attack), 
        .y_pos_attack(y_pos_attack), 
        .attack_direction(attack_dir)
    );                               
    
    draw_object #(.COLOR(12'hf_0_f))
    hero_mirror (
        .clk(pclk),
        .rst(rst),
        .hcount_in(hcount_out_pickup),
        .hsync_in(hsync_out_pickup),
        .hblnk_in(hblnk_out_pickup),
        .vcount_in(vcount_out_pickup),
        .vsync_in(vsync_out_pickup),
        .vblnk_in(vblnk_out_pickup),
        .rgb_in(rgb_out_pickup),
        .x_pos(x_pos_hero[23:12]),
        .y_pos(y_pos_hero[23:12]),
        .hcount_out(hcount_out_hero_mirror),
        .hsync_out(hsync_out_hero_mirror),
        .hblnk_out(hblnk_out_hero_mirror),
        .vcount_out(vcount_out_hero_mirror),
        .vsync_out(vsync_out_hero_mirror),
        .vblnk_out(vblnk_out_hero_mirror),
        .rgb_out(rgb_out_hero_mirror)
    );
    
    draw_object #(.COLOR(12'h0_1_c))
    hero (
        .clk(pclk),
        .rst(rst),
        .hcount_in(hcount_out_hero_mirror),
        .hsync_in(hsync_out_hero_mirror),
        .hblnk_in(hblnk_out_hero_mirror),
        .vcount_in(vcount_out_hero_mirror),
        .vsync_in(vsync_out_hero_mirror),
        .vblnk_in(vblnk_out_hero_mirror),
        .rgb_in(rgb_out_hero_mirror),
        .x_pos(x_pos_hero[11:0]),
        .y_pos(y_pos_hero[11:0]),
        .hcount_out(hcount_out_hero),
        .hsync_out(hsync_out_hero),
        .hblnk_out(hblnk_out_hero),
        .vcount_out(vcount_out_hero),
        .vsync_out(vsync_out_hero),
        .vblnk_out(vblnk_out_hero),
        .rgb_out(rgb_out_hero)
    );
    
    draw_attack_rect #(.COLOR(12'hf_f_f)) attack (    
        .clk(pclk),                              
        .rst(rst),                               
        .hcount_in(hcount_out_hero),             
        .hsync_in(hsync_out_hero),               
        .hblnk_in(hblnk_out_hero),               
        .vcount_in(vcount_out_hero),             
        .vsync_in(vsync_out_hero),               
        .vblnk_in(vblnk_out_hero),               
        .rgb_in(rgb_out_hero),                   
        .x_pos(x_pos_attack),                    
        .y_pos(y_pos_attack),                    
        .direction(attack_dir),                  
        .hcount_out(hcount_out_attack),          
        .hsync_out(hsync_out_attack),            
        .hblnk_out(hblnk_out_attack),            
        .vcount_out(vcount_out_attack),          
        .vsync_out(vsync_out_attack),            
        .vblnk_out(vblnk_out_attack),            
        .rgb_out(rgb_out_attack)                 
    );                                           
    
    enemy_ctl_unit my_enemy_ctl (           
        .clk(clk100MHz),                     
        .rst(rst), 
        .level_rst(level_rst|time_out|player_collision),                                  
        .hero_x_pos(x_pos_hero),            
        .hero_y_pos(y_pos_hero),            
        .hero_attack_x_pos(x_pos_attack),   
        .hero_attack_y_pos(y_pos_attack),   
        .attack_direction(attack_dir),      
        .score_in(score_map),               
        .x_pos(x_pos_enemy),                
        .y_pos(y_pos_enemy),                
        .player_collision(player_collision),
        .score_out(score_enemy)             
    );                                      
    
    draw_object #(.COLOR(12'h3_0_0))   
    enemy (                            
        .clk(pclk),                    
        .rst(rst),                     
        .hcount_in(hcount_out_attack), 
        .hsync_in(hsync_out_attack),   
        .hblnk_in(hblnk_out_attack),   
        .vcount_in(vcount_out_attack), 
        .vsync_in(vsync_out_attack),   
        .vblnk_in(vblnk_out_attack),   
        .rgb_in(rgb_out_attack),       
        .x_pos(x_pos_enemy),           
        .y_pos(y_pos_enemy),           
        .hcount_out(hcount_out_enemy), 
        .hsync_out(hsync_out_enemy),   
        .hblnk_out(hblnk_out_enemy),   
        .vcount_out(vcount_out_enemy), 
        .vsync_out(vsync_out_enemy),   
        .vblnk_out(vblnk_out_enemy),   
        .rgb_out(rgb_out_enemy)        
    );                                 
    
    char_display 
    #(.X_POS(0), .Y_POS(0))
    score_display (
        .pclk(pclk),
        .rst(rst),
        .hcount_in(hcount_out_enemy),
        .hsync_in(hsync_out_enemy),
        .hblnk_in(hblnk_out_enemy),
        .vcount_in(vcount_out_enemy),
        .vsync_in(vsync_out_enemy),
        .vblnk_in(vblnk_out_enemy),
        .rgb_in(rgb_out_enemy),
        .char_pixels(char_pixels),
        .hcount_out(hcount_out_score),
        .hsync_out(hsync_out_score),
        .hblnk_out(hblnk_out_score),
        .vcount_out(vcount_out_score),
        .vsync_out(vsync_out_score),
        .vblnk_out(vblnk_out_score),
        .rgb_out(rgb_out_score),
        .char_xy(char_xy),
        .char_line(addr_char[3:0])
    );
  
    font_rom my_font_rom (
        .clk(pclk),
        .addr(addr_char),
        .char_line_pixels(char_pixels)
    );
    
    time_counter
        #(.INIT_TIME(60))
        my_time_counter(
        .clk(clk100MHz),
        .rst(rst),
        .lvl(level),
        .add_time(add_time),
        .counter(time_count),
        .time_out(time_out)
    );
    
    info_panel my_panel (
        .char_xy(char_xy),
        .score(score_enemy),
        .score_req(score_req),
        .timer(time_count),
        .char_code(addr_char[10:4])
    );
    
    uart_communication my_uart (
        .clk(clk50MHz),
        .rst(rst),
        .rx(rx),
        .uart_data(uart_button)
    );
    
    uart_decode my_uart_decode (
        .clk(clk100MHz),
        .rst(rst),
        .uart_data(uart_button),
        .btnAttack(move_attack),
        .btnUp(move_up),
        .btnLeft(move_left),
        .btnRight(move_right),
        .btnDown(move_down)
    );
    
    assign hs = hsync_out_score;
    assign vs = vsync_out_score;
    assign r = rgb_out_score [11:8];
    assign g = rgb_out_score [7:4];
    assign b = rgb_out_score [3:0];
 
endmodule
