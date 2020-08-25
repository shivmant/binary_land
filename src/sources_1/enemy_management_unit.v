`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 16:49:44
// Design Name: 
// Module Name: enemy_management_unit
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


module enemy_management_unit(
    input wire clk,
    input wire rst,
    input wire [11:0] rom,
    output reg [11:0] x_pos,
    output reg [11:0] y_pos
    );
    
    localparam IDLE = 3'b000,                         
               SPAWN = 3'b001;
                                                                                            
    reg [2:0] state, state_nxt;                   
    reg [11:0] x_pos_nxt, y_pos_nxt;                          
                                                    
    always @(posedge clk or posedge rst)            
        if(rst)                                     
        begin                                       
            //level <= 0;                             
            //hero_rst <= 0;                          
            state <= IDLE;                        
        end                                         
        else                                        
        begin                                       
            //level <= level_nxt;                     
            //hero_rst <= hero_rst_nxt;               
            state <= state_nxt;                   
        end                                         
                                                    
    always @(*)                                     
    begin                                                                                    
        case(state)                               
            IDLE:                                 
            begin
                
            end                                   
            SPAWN:                               
            begin
            end
            
        endcase                                   
    end                                             
    
endmodule
