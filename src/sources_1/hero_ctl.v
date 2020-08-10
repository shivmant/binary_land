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
    input wire clk_div,
    input wire rst,
    input wire up,
    input wire left,
    input wire right,
    input wire down,
    input wire center,
    input wire [11:0] block_x_pos,
    input wire [11:0] block_y_pos,
    output wire [3:0] collision,
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
    wire [11:0] block_x_pos_h, block_y_pos_v;
    reg [2:0] state, state_nxt;
    reg [3:0] detection, detection_nxt;
    reg [20:0] counter, counter_nxt;
    
    //assign block_x_pos_h = block_x_pos*60+61;
    //assign block_y_pos_v = block_y_pos*60+108;
    holder #(.HOLD_TIME(200), .BITS(4))//1350 dla 10MHz
        collision_holder(
            .clk(clk),
            .rst(rst),
            .signal_in(detection),
            .signal_out(collision)
        );
    
    initial
    begin
        x_pos = 512;//512;
        y_pos = 300;//300;
        //x_pos_nxt = 512;//512;182
        //y_pos_nxt = 300;//300;230
    end
    
    always @(posedge clk or posedge rst)
        if(rst)
        begin

            detection <= 0;
            counter <= 0;
        end
        else
        begin

            detection <= detection_nxt;
            counter <= counter_nxt;
        end
        
    always @(posedge clk_div or posedge rst)
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
        if((x_pos <= block_x_pos + SQUARE_SIDE)&&(x_pos + SQUARE_SIDE >= block_x_pos)&&(y_pos <= block_y_pos + SQUARE_SIDE)&&(y_pos + SQUARE_SIDE >= block_y_pos)) 
            detection_nxt = 3'b001;
        else
            detection_nxt = 0;
//        if((x_pos <= block_x_pos + SQUARE_SIDE)&&(x_pos > block_x_pos))         //LEFT
//            collision_nxt = 4'b0001;
//        else if((x_pos + SQUARE_SIDE >= block_x_pos)&&(x_pos + SQUARE_SIDE < block_x_pos + SQUARE_SIDE))    //RIGHT
//            collision_nxt = 4'b0010;
//        else if(y_pos <= block_y_pos + SQUARE_SIDE)    //UP
//            collision_nxt = 4'b0100;
//        else if(y_pos + SQUARE_SIDE >= block_y_pos)    //DOWN
//            collision_nxt = 4'b1000;
//        else
//            collision_nxt = 4'b0000;
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
                if(y_pos - 1 >= 108)
                begin                     
                    y_pos_nxt = y_pos - 1;   
                end                       
                else
                    y_pos_nxt = y_pos;
                x_pos_nxt = x_pos; 
                state_nxt = IDLE;
            end
            MOVING_LEFT:
            begin
                if(x_pos - 1 >= 62)
                begin                     
                    x_pos_nxt = x_pos - 1;  
                end                       
                else
                    x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;
                state_nxt = IDLE;     
            end
            MOVING_RIGHT:
            begin
                if(x_pos + 1 <= 962)
                begin
                    x_pos_nxt = x_pos + 1;
                end
                else
                    x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;    
                state_nxt = IDLE;     
            end
            MOVING_DOWN:
            begin
                if(y_pos + 1 <= 708)
                begin                     
                    y_pos_nxt = y_pos + 1;  
                end                       
                else
                    y_pos_nxt = y_pos;
                x_pos_nxt = x_pos; 
                state_nxt = IDLE;
            end
            ATTACKING:
            begin
                state_nxt = IDLE;
            end          
        endcase
    end
    
endmodule
