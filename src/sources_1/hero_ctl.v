`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2020 14:50:16
// Design Name: 
// Module Name: hero_ctl
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


module hero_ctl(
    input wire clk,
    input wire rst,
    input wire up,
    input wire left,
    input wire right,
    input wire down,
    input wire center,
    input wire collision,
    output reg [11:0] x_pos,
    output reg [11:0] y_pos
    );
    
    localparam IDLE = 3'b000,
               NO_MOVING = 3'b001,
               MOVING_UP = 3'b010,
               MOVING_LEFT = 3'b011,
               MOVING_RIGHT = 3'b100,
               MOVING_DOWN = 3'b101,
               ATTACKING = 3'b110;
               
    localparam SQUARE_SIDE = 60;
    
    reg [11:0] x_pos_nxt, y_pos_nxt;
    reg [2:0] state, state_nxt;
    
    initial
    begin
        x_pos = 512;
        y_pos = 300;
    end
    
    always @(posedge clk or posedge rst)
        if(rst)
        begin
            x_pos <= 512;
            y_pos <= 300;
            state <= IDLE;
        end
        else
        begin
            
            x_pos <= x_pos_nxt;
            y_pos <= y_pos_nxt;
            state <= state_nxt;
        end
    
    always @*
    begin
        case(state)
            IDLE:
            begin
                x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;
                if(up)
                    state_nxt = MOVING_UP;
                else if(left)
                    state_nxt = MOVING_LEFT;
                else if(right)
                    state_nxt = MOVING_RIGHT;
                else if(down)
                    state_nxt = MOVING_DOWN;
                else if(center)
                    state_nxt = ATTACKING;
                else
                    state_nxt = IDLE;
            end
            NO_MOVING:
            begin
            end
            MOVING_UP:
            begin
                if(y_pos - 1 >= 108 && !collision)
               begin                     
                    y_pos_nxt = y_pos - 1;
                    x_pos_nxt = x_pos;    
                end                       
                else
                    y_pos_nxt = y_pos;
                state_nxt = IDLE;
            end
            MOVING_LEFT:
            begin
                if(x_pos - 1 >= 62 && !collision)
                begin                     
                    x_pos_nxt = x_pos - 1;
                    y_pos_nxt = y_pos;    
                end                       
                else
                    x_pos_nxt = x_pos;
                state_nxt = IDLE;     
            end
            MOVING_RIGHT:
            begin
                if(x_pos + 1 <= 962 - SQUARE_SIDE && !collision)
                begin
                    x_pos_nxt = x_pos + 1;
                    y_pos_nxt = y_pos;
                end
                else
                    x_pos_nxt = x_pos;
                state_nxt = IDLE;     
            end
            MOVING_DOWN:
            begin
                if(y_pos + 1 <= 708 - SQUARE_SIDE && !collision)
                begin                     
                    y_pos_nxt = y_pos + 1;
                    x_pos_nxt = x_pos;    
                end                       
                else
                    y_pos_nxt = y_pos;
                state_nxt = IDLE;
            end
            ATTACKING:
            begin
                state_nxt = IDLE;
            end          
        endcase
    end
    
endmodule
