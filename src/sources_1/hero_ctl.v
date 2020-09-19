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
    input wire [7:0] collision,
    output reg [23:0] x_pos,
    output reg [23:0] y_pos,
    output reg [11:0] x_pos_attack_horizontal,
    output reg [11:0] y_pos_attack_horizontal,
    output reg [11:0] x_pos_attack_vertical,
    output reg [11:0] y_pos_attack_vertical
    );
    
    localparam IDLE = 3'b000,
               MOVING_UP = 3'b010,
               MOVING_LEFT = 3'b011,
               MOVING_RIGHT = 3'b100,
               MOVING_DOWN = 3'b101,
               ATTACKING = 3'b110;
               
    localparam SQUARE_SIDE = 60,
               ATTACK_WIDTH = 20,
               ATTACK_HEIGHT = 40;
               
    localparam MOVING_TIME = 60;           
    
    
    reg [23:0] x_pos_nxt, y_pos_nxt;
    reg [2:0] state, state_nxt;
    reg [20:0] counter, counter_nxt;
    reg [11:0] x_pos_attack_horizontal_nxt, y_pos_attack_horizontal_nxt;
    reg [11:0] x_pos_attack_vertical_nxt, y_pos_attack_vertical_nxt;
    reg [11:0] x_pos_attack_horizontal_temp, y_pos_attack_horizontal_temp;
    reg [11:0] x_pos_attack_vertical_temp, y_pos_attack_vertical_temp;
    
    always @(posedge clk or posedge rst)
        if(rst)
        begin
            x_pos[11:0] <= 542;
            y_pos[11:0] <= 648;
            x_pos[23:12] <= 422;
            y_pos[23:12] <= 648;
            counter <= 0;
            state <= IDLE;
        end
        else
        begin
            x_pos <= x_pos_nxt;
            y_pos <= y_pos_nxt;
            x_pos_attack_horizontal <= x_pos_attack_horizontal_nxt;
            y_pos_attack_horizontal <= y_pos_attack_horizontal_nxt;
            x_pos_attack_vertical <= x_pos_attack_vertical_nxt;
            y_pos_attack_vertical <= y_pos_attack_vertical_nxt;
            counter <= counter_nxt;
            state <= state_nxt;
        end
    
    always @*
    begin
        counter_nxt = counter;
        x_pos_nxt = x_pos;
        y_pos_nxt = y_pos;
        x_pos_attack_horizontal_nxt = x_pos_attack_horizontal;
        y_pos_attack_horizontal_nxt = y_pos_attack_horizontal;
        x_pos_attack_vertical_nxt = x_pos_attack_vertical;
        y_pos_attack_vertical_nxt = y_pos_attack_vertical;
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
            MOVING_UP:
            begin
                x_pos_attack_vertical_temp = x_pos + ATTACK_WIDTH;
                y_pos_attack_vertical_temp = y_pos - SQUARE_SIDE - ATTACK_HEIGHT;
                if(counter < MOVING_TIME) 
                begin
                    if(y_pos[11:0] - 1 >= 108 && !collision[3])                  
                        y_pos_nxt[11:0] = y_pos[11:0] - 1;                        
                    else
                        y_pos_nxt[11:0] = y_pos[11:0];
                    if(y_pos[23:12] - 1 >= 108 && !collision[7])                    
                        y_pos_nxt[23:12] = y_pos[23:12] - 1;                        
                    else
                        y_pos_nxt[23:12] = y_pos[23:12];
                    x_pos_nxt = x_pos; 
                    counter_nxt = counter + 1;
                    state_nxt = MOVING_UP;
                end
                else 
                begin
                    counter_nxt = 0;
                    state_nxt = IDLE;
                end
            end
            MOVING_LEFT:
            begin
                //x_pos_attack_horizontal_temp = x_pos - ATTACK_HEIGHT;
                //y_pos_attack_horizontal_temp = y_pos + ATTACK_WIDTH;
                if(counter < MOVING_TIME) 
                begin
                    if(x_pos[11:0] - 1 >= 62 && !collision[0])                    
                        x_pos_nxt[11:0] = x_pos[11:0] - 1;                       
                    else
                        x_pos_nxt[11:0] = x_pos[11:0];
                    if(x_pos[23:12] + SQUARE_SIDE + 1 <= 962 && !collision[5])
                        x_pos_nxt[23:12] = x_pos[23:12] + 1;
                    else
                        x_pos_nxt[23:12] = x_pos[23:12];
                    y_pos_nxt = y_pos;
                    counter_nxt = counter + 1;
                    state_nxt = MOVING_LEFT;
                end
                else 
                begin
                    counter_nxt = 0;
                    state_nxt = IDLE;
                end
            end
            MOVING_RIGHT:
            begin
                //x_pos_attack_horizontal_temp = x_pos + SQUARE_SIDE;
                //y_pos_attack_horizontal_temp = y_pos + ATTACK_WIDTH;
                if(counter < MOVING_TIME) 
                begin
                    if(x_pos[11:0] + SQUARE_SIDE + 1 <= 962 && !collision[1])
                        x_pos_nxt[11:0] = x_pos[11:0] + 1;
                    else
                        x_pos_nxt[11:0] = x_pos[11:0];
                    if(x_pos[23:12] - 1 >= 62 && !collision[4])               
                        x_pos_nxt[23:12] = x_pos[23:12] - 1;                       
                    else
                        x_pos_nxt[23:12] = x_pos[23:12];
                    y_pos_nxt = y_pos;
                    counter_nxt = counter + 1;
                    state_nxt = MOVING_RIGHT;
                end
                else begin
                    counter_nxt = 0;
                    state_nxt = IDLE;
                end
            end
            MOVING_DOWN:
            begin
                x_pos_attack_vertical_temp = x_pos + ATTACK_WIDTH;
                y_pos_attack_vertical_temp = y_pos + SQUARE_SIDE;
                if(counter < MOVING_TIME) 
                begin
                    if(y_pos[11:0] + SQUARE_SIDE + 1 <= 708 && !collision[2])                   
                        y_pos_nxt[11:0] = y_pos[11:0] + 1;                       
                    else
                        y_pos_nxt[11:0] = y_pos[11:0];
                    if(y_pos[23:12] + SQUARE_SIDE + 1 <= 708 && !collision[6])                    
                        y_pos_nxt[23:12] = y_pos[23:12] + 1;                       
                    else
                        y_pos_nxt[23:12] = y_pos[23:12];
                    x_pos_nxt = x_pos;
                    state_nxt = IDLE;
                    counter_nxt = counter + 1;
                    state_nxt = MOVING_DOWN;
                end
                else 
                begin
                    counter_nxt = 0;
                    state_nxt = IDLE;
                end
            end
            ATTACKING:
            begin
                x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;  
                x_pos_attack_horizontal_nxt = x_pos_attack_horizontal_temp;
                y_pos_attack_horizontal_nxt = y_pos_attack_horizontal_temp;
                x_pos_attack_vertical_nxt = x_pos_attack_vertical_temp;
                y_pos_attack_vertical_nxt = y_pos_attack_vertical_temp;              
                if(counter == 10)
                begin
                    x_pos_attack_horizontal_nxt = 200;
                    y_pos_attack_horizontal_nxt = 50;
                    x_pos_attack_vertical_nxt = 200;
                    y_pos_attack_vertical_nxt = 50;
                    counter_nxt = 0;
                    state_nxt = IDLE;
                end
                else
                begin
                    counter_nxt = counter + 1;
                    state_nxt = ATTACKING;
                end
            end          
        endcase
    end
    
endmodule
