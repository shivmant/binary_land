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
//    output reg [11:0] x_pos_attack,
//    output reg [11:0] y_pos_attack
    );
    
    localparam IDLE = 3'b000,
               NO_MOVING = 3'b001,
               MOVING_UP = 3'b010,
               MOVING_LEFT = 3'b011,
               MOVING_RIGHT = 3'b100,
               MOVING_DOWN = 3'b101,
               ATTACKING = 3'b110;
               
    localparam SQUARE_SIDE = 60,
               ATTACK_WIDTH = 20,
               ATTACK_HEIGHT = 40;
    
    
    reg [11:0] x_pos_nxt, y_pos_nxt;
    wire [11:0] block_x_pos_h, block_y_pos_v;
    reg [2:0] state, state_nxt;
    reg [3:0] detection, detection_nxt;
    reg [20:0] counter, counter_nxt;
    //reg [11:0] x_pos_attack, y_pos_attack, 
//    reg [11:0] x_pos_attack_nxt, y_pos_attack_nxt;
//    reg [11:0] x_pos_attack_temp, y_pos_attack_temp, x_pos_attack_temp_nxt, y_pos_attack_temp_nxt;
    
    //assign block_x_pos_h = block_x_pos*60+61;
    //assign block_y_pos_v = block_y_pos*60+108;
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz, 1200000
        collision_holder0(.clk(clk), .rst(rst),
        .signal_in(detection[0]), .signal_out(collision[0]));
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz
        collision_holder1(.clk(clk), .rst(rst),         
        .signal_in(detection[1]), .signal_out(collision[1]));
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz
        collision_holder2(.clk(clk), .rst(rst),         
        .signal_in(detection[2]), .signal_out(collision[2]));
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz
        collision_holder3(.clk(clk), .rst(rst),         
        .signal_in(detection[3]), .signal_out(collision[3]));
    
    initial
    begin
        x_pos = 512;//512;
        y_pos = 230;//300;
        //x_pos_nxt = 182;//512;182
        //y_pos_nxt = 230;//300;230
        //state = IDLE;
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
//            x_pos_attack <= 0;
//            y_pos_attack <= 0;
//            x_pos_attack_temp <= 0;
//            y_pos_attack_temp <= 0;
        end
        else
        begin
            x_pos <= x_pos_nxt;
            y_pos <= y_pos_nxt;
            state <= state_nxt;
//            x_pos_attack <= x_pos_attack_nxt;
//            y_pos_attack <= y_pos_attack_nxt;
//            x_pos_attack_temp <= x_pos_attack_temp_nxt;
//            y_pos_attack_temp <= y_pos_attack_temp_nxt;
        end
    
    always @*
    begin
        if((x_pos <= block_x_pos + SQUARE_SIDE + 1)&&(x_pos + SQUARE_SIDE - 1 > block_x_pos  - 1)&&(y_pos <= block_y_pos + SQUARE_SIDE)&&(y_pos + SQUARE_SIDE >= block_y_pos))
        begin
            if((x_pos - 1 >= block_x_pos)&&(y_pos <= block_y_pos + SQUARE_SIDE - 1)&&(y_pos + SQUARE_SIDE > block_y_pos + 1))        //LEFT
                detection_nxt[0] = 1;//4'b0001;
            else detection_nxt[0] = 0;
            if((x_pos + 1 <= block_x_pos)&&(y_pos <= block_y_pos + SQUARE_SIDE - 1)&&(y_pos + SQUARE_SIDE > block_y_pos + 1))        //RIGHT
                detection_nxt[1] = 1;//4'b0010;
            else detection_nxt[1] = 0;    
            if((y_pos - 1 <= block_y_pos)&&(x_pos <= block_x_pos + SQUARE_SIDE)&&(x_pos + SQUARE_SIDE - 1> block_x_pos))             //DOWN
                detection_nxt[2] = 1;//4'b0100;
            else detection_nxt[2] = 0;
            if((y_pos + 1 >= block_y_pos)&&(x_pos <= block_x_pos + SQUARE_SIDE)&&(x_pos + SQUARE_SIDE - 1> block_x_pos))             //UP
                detection_nxt[3] = 1;//4'b1000;
            else detection_nxt[3] = 0;
        end
        else
            detection_nxt = 4'b0000;
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
                if(y_pos - 1 >= 108 && !collision[3])
                begin                     
                    y_pos_nxt = y_pos - 1;   
                end                       
                else
                    y_pos_nxt = y_pos;
                x_pos_nxt = x_pos; 
//                x_pos_attack_temp_nxt = x_pos + 20;
//                y_pos_attack_temp_nxt = y_pos - ATTACK_HEIGHT;
                state_nxt = IDLE;
            end
            MOVING_LEFT:
            begin
                if(x_pos - 1 >= 62 && !collision[0])
                begin                     
                    x_pos_nxt = x_pos - 1;  
                end                       
                else
                    x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;
//                x_pos_attack_temp_nxt = x_pos - ATTACK_HEIGHT;
//                y_pos_attack_temp_nxt = y_pos + 20;
                state_nxt = IDLE;     
            end
            MOVING_RIGHT:
            begin
                if(x_pos + 1 <= 962 && !collision[1])
                begin
                    x_pos_nxt = x_pos + 1;
                end
                else
                    x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;
//                x_pos_attack_temp_nxt = x_pos + SQUARE_SIDE;
//                y_pos_attack_temp_nxt = y_pos + 20;    
                state_nxt = IDLE;     
            end
            MOVING_DOWN:
            begin
                if(y_pos + 1 <= 708 && !collision[2])
                begin                     
                    y_pos_nxt = y_pos + 1;  
                end                       
                else
                    y_pos_nxt = y_pos;
                x_pos_nxt = x_pos;
//                x_pos_attack_temp_nxt = x_pos + 20;
//                y_pos_attack_temp_nxt = y_pos + SQUARE_SIDE;
                state_nxt = IDLE;
            end
            ATTACKING:
            begin
                x_pos_nxt = x_pos;
                y_pos_nxt = y_pos;
//                x_pos_attack_nxt = x_pos_attack_temp;
//                y_pos_attack_nxt = y_pos_attack_temp;                
//                if(counter == 10)
//                begin
//                    x_pos_attack_nxt = 0;
//                    y_pos_attack_nxt = 0;
//                    counter_nxt = 0;
                    state_nxt = IDLE;
//                end
//                else
//                begin
                    
//                    counter_nxt = counter + 1;
//                    state_nxt = ATTACKING;
//                end
            end          
        endcase
    end
    
endmodule
