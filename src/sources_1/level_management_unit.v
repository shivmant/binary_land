`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 15:51:51
// Design Name: 
// Module Name: level_management_unit
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
    
module level_management_unit(                             
    input wire clk,                                 
    input wire rst,                                 
    input wire [23:0] score,                       
    input wire [23:0] hero_x_pos,                   
    input wire [23:0] hero_y_pos,                   
    output reg [3:0] level,                         
    output reg hero_rst,
    output reg [23:0] score_req                            
    );                                                                     
                                                                      
    reg [3:0] level_nxt;                            
    reg hero_rst_nxt; 
    reg [23:0] score_req_nxt;                              
                                                    
    always @(posedge clk or posedge rst)            
        if(rst)                                     
        begin                                       
            level <= 0;                             
            hero_rst <= 0;
            score_req <= score + 1000;                                               
        end                                         
        else                                        
        begin                                       
            level <= level_nxt;                     
            hero_rst <= hero_rst_nxt; 
            score_req <= score_req_nxt;                                  
        end                                         
                                                    
    always @(*)                                     
    begin                                           
        if((hero_x_pos[11:0] == 482)&&(hero_y_pos[11:0] == 108)&&(hero_x_pos[23:12] == 482)&&(hero_y_pos[23:12] == 108)&&(score >= score_req))
        begin                                       
            level_nxt = level + 1;                  
            hero_rst_nxt = 1;
            score_req_nxt = score + 1000;                         
        end                                         
        else                                        
        begin
            score_req_nxt = score_req;                                      
            level_nxt = level;                      
            hero_rst_nxt = 0;                       
        end                                                              
    end                                        
                                                    
endmodule                                           
