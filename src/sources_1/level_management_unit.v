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
    input wire [10:0] points,                       
    input wire [11:0] hero_x_pos,                   
    input wire [11:0] hero_y_pos,                   
    output reg [3:0] level,                         
    output reg hero_rst                             
    );                                              
    localparam IDLE = 1'b0,                         
               CHANGE = 1'b1;                       
                                                    
    //reg [2:0] state, state_nxt;                   
    reg [3:0] level_nxt;                            
    reg hero_rst_nxt;                               
                                                    
    always @(posedge clk or posedge rst)            
        if(rst)                                     
        begin                                       
            level <= 0;                             
            hero_rst <= 0;                          
            //state <= IDLE;                        
        end                                         
        else                                        
        begin                                       
            level <= level_nxt;                     
            hero_rst <= hero_rst_nxt;               
            //state <= state_nxt;                   
        end                                         
                                                    
    always @(*)                                     
    begin                                           
        if((hero_x_pos == 481)&&(hero_y_pos == 108))
        begin                                       
            level_nxt = level + 1;                  
            hero_rst_nxt = 1;                       
        end                                         
        else                                        
        begin                                       
            level_nxt = level;                      
            hero_rst_nxt = 0;                       
        end                                         
//        case(state)                               
//            IDLE:                                 
//            begin                                 
//            end                                   
//            CHANGE:                               
//            begin                                 
                                                    
//            end                                   
//        endcase                                   
    end                                             
                                                    
endmodule                                           
