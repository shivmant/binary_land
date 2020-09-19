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
        input wire pclk,
        input wire rst,
        
        input wire [23:0] hero_x_pos, 
        input wire [23:0] hero_y_pos,
        input wire [23:0] hero_attack_x_pos,
        input wire [23:0] hero_attack_y_pos,
        input wire attack_direction,
        input wire [23:0] score_in,
        
        input wire [10:0] vcount_in,
        input wire vsync_in,
        input wire vblnk_in,
        input wire [10:0] hcount_in,
        input wire hsync_in,
        input wire hblnk_in,
        input wire [11:0] rgb_in,

        output wire player_collision,  
        output wire [23:0] score_out,
        
        output wire [10:0] vcount_out,
        output wire vsync_out,
        output wire vblnk_out,
        output wire [10:0] hcount_out,
        output wire hsync_out,
        output wire hblnk_out,
        output wire [11:0] rgb_out
    );
    
    wire [11:0] x_pos_enemy0, y_pos_enemy0;
    wire [11:0] x_pos_enemy1, y_pos_enemy1;
    wire [11:0] x_pos_enemy2, y_pos_enemy2;
    wire [11:0] x_pos_enemy3, y_pos_enemy3;
    wire [11:0] x_pos_enemy4, y_pos_enemy4;
    
    wire [23:0] score1, score2, score3, score4;
    wire [10:0] vcount_out_enemy0, hcount_out_enemy0;               
    wire vsync_out_enemy0, hsync_out_enemy0;                        
    wire vblnk_out_enemy0, hblnk_out_enemy0;                        
    wire [11:0] rgb_out_enemy0;
    
    wire [10:0] vcount_out_enemy1, hcount_out_enemy1;               
    wire vsync_out_enemy1, hsync_out_enemy1;                        
    wire vblnk_out_enemy1, hblnk_out_enemy1;                        
    wire [11:0] rgb_out_enemy1;
    wire [10:0] vcount_out_enemy2, hcount_out_enemy2;               
    wire vsync_out_enemy2, hsync_out_enemy2;                        
    wire vblnk_out_enemy2, hblnk_out_enemy2;                        
    wire [11:0] rgb_out_enemy2;
    wire [10:0] vcount_out_enemy3, hcount_out_enemy3;               
    wire vsync_out_enemy3, hsync_out_enemy3;                        
    wire vblnk_out_enemy3, hblnk_out_enemy3;                        
    wire [11:0] rgb_out_enemy3;
    
    wire player_collision0, player_collision1, player_collision2, player_collision3, player_collision4;
    
    enemy_ctl_unit my_enemy_ctl0 (           
        .clk(clk),                     
        .rst(rst),                                   
        .hero_x_pos(hero_x_pos),            
        .hero_y_pos(hero_y_pos),            
        .hero_attack_x_pos(hero_attack_x_pos),   
        .hero_attack_y_pos(hero_attack_y_pos),   
        .attack_direction(attack_direction),      
        .score_in(score_in),               
        .x_pos(x_pos_enemy0),                
        .y_pos(y_pos_enemy0),                
        .player_collision(player_collision0),
        .score_out(score1)             
    );  
    
    draw_object #(.COLOR(12'h3_0_0))   
    enemy0 (                            
        .clk(pclk),                    
        .rst(rst),                     
        .hcount_in(hcount_in), 
        .hsync_in(hsync_in),   
        .hblnk_in(hblnk_in),   
        .vcount_in(vcount_in), 
        .vsync_in(vsync_in),   
        .vblnk_in(vblnk_in),   
        .rgb_in(rgb_in),       
        .x_pos(x_pos_enemy0),           
        .y_pos(y_pos_enemy0),           
        .hcount_out(hcount_out_enemy0), 
        .hsync_out(hsync_out_enemy0),   
        .hblnk_out(hblnk_out_enemy0),   
        .vcount_out(vcount_out_enemy0), 
        .vsync_out(vsync_out_enemy0),   
        .vblnk_out(vblnk_out_enemy0),   
        .rgb_out(rgb_out_enemy0)        
    );
    
    enemy_ctl_unit my_enemy_ctl1 (              
        .clk(clk),                              
        .rst(rst),                              
        .hero_x_pos(hero_x_pos),                
        .hero_y_pos(hero_y_pos),                
        .hero_attack_x_pos(hero_attack_x_pos),  
        .hero_attack_y_pos(hero_attack_y_pos),  
        .attack_direction(attack_direction),    
        .score_in(score1),                    
        .x_pos(x_pos_enemy1),                   
        .y_pos(y_pos_enemy1),                   
        .player_collision(player_collision1),    
        .score_out(score2)                      
    );                                          
                                                
    draw_object #(.COLOR(12'h3_0_0))            
    enemy1 (                                    
        .clk(pclk),                             
        .rst(rst),                              
        .hcount_in(hcount_out_enemy0),                  
        .hsync_in(hsync_out_enemy0),                    
        .hblnk_in(hblnk_out_enemy0),                    
        .vcount_in(vcount_out_enemy0),                  
        .vsync_in(vsync_out_enemy0),                    
        .vblnk_in(vblnk_out_enemy0),                    
        .rgb_in(rgb_out_enemy0),                        
        .x_pos(x_pos_enemy1),                   
        .y_pos(y_pos_enemy1),                   
        .hcount_out(hcount_out_enemy1),         
        .hsync_out(hsync_out_enemy1),           
        .hblnk_out(hblnk_out_enemy1),           
        .vcount_out(vcount_out_enemy1),         
        .vsync_out(vsync_out_enemy1),           
        .vblnk_out(vblnk_out_enemy1),           
        .rgb_out(rgb_out_enemy1)                
    ); 

    enemy_ctl_unit my_enemy_ctl2 (            
        .clk(clk),                            
        .rst(rst),                            
        .hero_x_pos(hero_x_pos),              
        .hero_y_pos(hero_y_pos),              
        .hero_attack_x_pos(hero_attack_x_pos),
        .hero_attack_y_pos(hero_attack_y_pos),
        .attack_direction(attack_direction),  
        .score_in(score2),                    
        .x_pos(x_pos_enemy2),                 
        .y_pos(y_pos_enemy2),                 
        .player_collision(player_collision2),  
        .score_out(score3)                    
    );                                        
                                              
    draw_object #(.COLOR(12'h3_0_0))          
    enemy2 (                                  
        .clk(pclk),                           
        .rst(rst),                            
        .hcount_in(hcount_out_enemy1),        
        .hsync_in(hsync_out_enemy1),          
        .hblnk_in(hblnk_out_enemy1),          
        .vcount_in(vcount_out_enemy1),        
        .vsync_in(vsync_out_enemy1),          
        .vblnk_in(vblnk_out_enemy1),          
        .rgb_in(rgb_out_enemy1),              
        .x_pos(x_pos_enemy2),                 
        .y_pos(y_pos_enemy2),                 
        .hcount_out(hcount_out_enemy2),       
        .hsync_out(hsync_out_enemy2),         
        .hblnk_out(hblnk_out_enemy2),         
        .vcount_out(vcount_out_enemy2),       
        .vsync_out(vsync_out_enemy2),         
        .vblnk_out(vblnk_out_enemy2),         
        .rgb_out(rgb_out_enemy2)              
    );                                        

    enemy_ctl_unit my_enemy_ctl3 (            
        .clk(clk),                            
        .rst(rst),                            
        .hero_x_pos(hero_x_pos),              
        .hero_y_pos(hero_y_pos),              
        .hero_attack_x_pos(hero_attack_x_pos),
        .hero_attack_y_pos(hero_attack_y_pos),
        .attack_direction(attack_direction),  
        .score_in(score3),                    
        .x_pos(x_pos_enemy3),                 
        .y_pos(y_pos_enemy3),                 
        .player_collision(player_collision3),  
        .score_out(score4)                    
    );                                        
                                              
    draw_object #(.COLOR(12'h3_0_0))          
    enemy3 (                                  
        .clk(pclk),                           
        .rst(rst),                            
        .hcount_in(hcount_out_enemy2),        
        .hsync_in(hsync_out_enemy2),          
        .hblnk_in(hblnk_out_enemy2),          
        .vcount_in(vcount_out_enemy2),        
        .vsync_in(vsync_out_enemy2),          
        .vblnk_in(vblnk_out_enemy2),          
        .rgb_in(rgb_out_enemy2),              
        .x_pos(x_pos_enemy3),                 
        .y_pos(y_pos_enemy3),                 
        .hcount_out(hcount_out_enemy3),       
        .hsync_out(hsync_out_enemy3),         
        .hblnk_out(hblnk_out_enemy3),         
        .vcount_out(vcount_out_enemy3),       
        .vsync_out(vsync_out_enemy3),         
        .vblnk_out(vblnk_out_enemy3),         
        .rgb_out(rgb_out_enemy3)              
    );                                        

    enemy_ctl_unit my_enemy_ctl4 (             
        .clk(clk),                             
        .rst(rst),                             
        .hero_x_pos(hero_x_pos),               
        .hero_y_pos(hero_y_pos),               
        .hero_attack_x_pos(hero_attack_x_pos), 
        .hero_attack_y_pos(hero_attack_y_pos), 
        .attack_direction(attack_direction),   
        .score_in(score4),                     
        .x_pos(x_pos_enemy4),                  
        .y_pos(y_pos_enemy4),                  
        .player_collision(player_collision4),   
        .score_out(score_out)                     
    );                                         
                                               
    draw_object #(.COLOR(12'h3_0_0))           
    enemy4 (                                   
        .clk(pclk),                            
        .rst(rst),                             
        .hcount_in(hcount_out_enemy3),         
        .hsync_in(hsync_out_enemy3),           
        .hblnk_in(hblnk_out_enemy3),           
        .vcount_in(vcount_out_enemy3),         
        .vsync_in(vsync_out_enemy3),           
        .vblnk_in(vblnk_out_enemy3),           
        .rgb_in(rgb_out_enemy3),               
        .x_pos(x_pos_enemy4),                  
        .y_pos(y_pos_enemy4),                  
        .hcount_out(hcount_out),        
        .hsync_out(hsync_out),          
        .hblnk_out(hblnk_out),          
        .vcount_out(vcount_out),        
        .vsync_out(vsync_out),          
        .vblnk_out(vblnk_out),          
        .rgb_out(rgb_out)               
    );                                                                                                                          
    
    assign player_collision = player_collision0|player_collision1|player_collision2|player_collision3|player_collision4;
    
endmodule
