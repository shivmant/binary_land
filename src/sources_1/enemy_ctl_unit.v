`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 30.08.2020 10:57:07
// Design Name: 
// Module Name: enemy_ctl_unit
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


module enemy_ctl_unit(
    input wire clk,
    input wire rst,
    input wire level_rst,
    input wire [23:0] hero_x_pos, 
    input wire [23:0] hero_y_pos,
    input wire [23:0] hero_attack_x_pos,
    input wire [23:0] hero_attack_y_pos,
    input wire attack_direction,
    input wire [23:0] score_in,
    
    output reg [11:0] x_pos,
    output reg [11:0] y_pos,
    output reg player_collision,
    output reg [23:0] score_out
    );
    
    localparam IDLE         = 3'b000,
               MOVING_UP    = 3'b001,
               MOVING_LEFT  = 3'b010,
               MOVING_RIGHT = 3'b011,
               MOVING_DOWN  = 3'b100,
               ELIMINATED   = 3'b101,
               INIT         = 3'b110;

    localparam MOVING_TIME = 60,
               IDLE_TIME   = 20;
    
    localparam SQUARE_SIDE   = 60,
               ATTACK_WIDTH  = 40,
               ATTACK_HEIGHT = 20;
    
    reg [11:0] x_pos_nxt, y_pos_nxt;
    reg [2:0] state, state_nxt;
    reg [20:0] counter, counter_nxt;
    wire up, left, down, right;
    reg player_collision_nxt;
    reg [2:0] rand_num, rand_num_nxt;
    wire [4:0] lfsr_out;
    reg [12:0] seed;
    reg cEnable, cEnable_nxt;
    reg eliminated, eliminated_nxt;
    reg [23:0] score_out_nxt;
    wire clk_div;
       
    always @(posedge clk_div)
        if(rst|level_rst)
        begin
            x_pos <= 542;
            y_pos <= 108;
            player_collision <= 0;
            counter <=0;
            rand_num <= 0;
            seed <= 0;
            cEnable <= 0;
            eliminated <= 0;
            score_out <= 0;
            state <= IDLE;
        end
        else
        begin
            x_pos <= x_pos_nxt;
            y_pos <= y_pos_nxt;
            player_collision <= player_collision_nxt;
            counter <= counter_nxt;
            rand_num <= rand_num_nxt;
            seed <= hero_x_pos[11:0]-hero_y_pos[23:12]+y_pos;
            cEnable <= cEnable_nxt;
            eliminated <= eliminated_nxt;
            score_out <= score_out_nxt;
            state <= state_nxt;
        end
    
    always @*
    begin
        rand_num_nxt = rand_num;
        player_collision_nxt = player_collision;
        x_pos_nxt = x_pos;
        y_pos_nxt = y_pos;
        if(((hero_x_pos[11:0] < x_pos + SQUARE_SIDE)&&(hero_x_pos[11:0] + SQUARE_SIDE - 1 > x_pos)&&(hero_y_pos[11:0] <= y_pos + SQUARE_SIDE - 1)&&(hero_y_pos[11:0] + SQUARE_SIDE >= y_pos + 1))
        ||((hero_x_pos[23:12] < x_pos + SQUARE_SIDE)&&(hero_x_pos[23:12] + SQUARE_SIDE - 1 > x_pos)&&(hero_y_pos[23:12] <= y_pos + SQUARE_SIDE - 1)&&(hero_y_pos[23:12] + SQUARE_SIDE >= y_pos + 1)))
            player_collision_nxt = 1;
        else
            player_collision_nxt = 0;
            
        if(attack_direction)
            if (((x_pos + SQUARE_SIDE - 1 > hero_attack_x_pos[11:0])&&(x_pos < (hero_attack_x_pos[11:0] + ATTACK_WIDTH))&&(y_pos + SQUARE_SIDE >= hero_attack_y_pos[11:0] + 1)&&(y_pos <= (hero_attack_y_pos[11:0] + ATTACK_HEIGHT -1)))
            ||((x_pos + SQUARE_SIDE - 1 > hero_attack_x_pos[23:12])&&(x_pos < (hero_attack_x_pos[23:12] + ATTACK_WIDTH))&&(y_pos + SQUARE_SIDE >= hero_attack_y_pos[23:12] + 1)&&(y_pos <= (hero_attack_y_pos[23:12] + ATTACK_HEIGHT -1))))     
            begin    
                score_out_nxt = score_in + 200;
                eliminated_nxt = 1;
            end
            else
            begin
                score_out_nxt = score_in;
                eliminated_nxt = 0;
            end
        else
            if (((x_pos + SQUARE_SIDE - 1 > hero_attack_x_pos[11:0])&&(x_pos < (hero_attack_x_pos[11:0] + ATTACK_HEIGHT))&&(y_pos + SQUARE_SIDE >= hero_attack_y_pos[11:0] + 1)&&(y_pos <= (hero_attack_y_pos[11:0] + ATTACK_WIDTH -1)))
            ||((x_pos + SQUARE_SIDE - 1 > hero_attack_x_pos[23:12])&&(x_pos < (hero_attack_x_pos[23:12] + ATTACK_HEIGHT))&&(y_pos + SQUARE_SIDE >= hero_attack_y_pos[23:12] + 1)&&(y_pos <= (hero_attack_y_pos[23:12] + ATTACK_WIDTH -1)))) 
            begin   
                score_out_nxt = score_in + 200;
                eliminated_nxt = 1;
            end
            else 
            begin
                score_out_nxt = score_in;                                                                                                                                                                                                                             
                eliminated_nxt = 0;
            end
        case(state)
            IDLE:
            begin
                rand_num_nxt = lfsr_out%5;
                if(counter < IDLE_TIME)
                begin
                    cEnable_nxt = 1;
                    state_nxt = IDLE;                
                    counter_nxt = counter + 1;
                end
                else
                begin
                    cEnable_nxt = 0;
                    counter_nxt = 0;
                    if(eliminated)
                        state_nxt = ELIMINATED;
                    else
                        case(rand_num)
                            0: state_nxt = MOVING_UP;
                            1: state_nxt = MOVING_LEFT;
                            2: state_nxt = MOVING_RIGHT;
                            3: state_nxt = MOVING_DOWN;
                            4: state_nxt = IDLE;
                            default: state_nxt = IDLE;
                        endcase                                                                                                                                                                                                                       
                end           
            end
            MOVING_UP:
            begin
                if(eliminated)              
                    state_nxt = ELIMINATED;
                else                        
                    if(counter < MOVING_TIME) 
                    begin
                        if(y_pos - 1 >= 108)                  
                            y_pos_nxt = y_pos - 1;                       
                        else
                            y_pos_nxt = y_pos;
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
                if(eliminated)              
                    state_nxt = ELIMINATED;
                else                        
                    if(counter < MOVING_TIME) 
                    begin
                        if(x_pos - 1 >= 62)                    
                            x_pos_nxt = x_pos - 1;                      
                        else
                            x_pos_nxt = x_pos;
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
                if(eliminated)              
                    state_nxt = ELIMINATED;
                else                        
                    if(counter < MOVING_TIME)
                    begin                    
                        if(x_pos + SQUARE_SIDE + 1 <= 962)
                            x_pos_nxt = x_pos + 1;
                        else
                            x_pos_nxt = x_pos; 
                        counter_nxt = counter + 1;
                        state_nxt = MOVING_RIGHT;
                    end                  
                    else                 
                    begin                
                        counter_nxt = 0; 
                        state_nxt = IDLE;
                    end                    
            end
            MOVING_DOWN:
            begin
                if(eliminated)              
                    state_nxt = ELIMINATED;
                else                        
                    if(counter < MOVING_TIME)
                    begin                    
                        if(y_pos + SQUARE_SIDE + 1 <= 708)                  
                            y_pos_nxt = y_pos + 1;                       
                        else
                            y_pos_nxt = y_pos;
                        counter_nxt = counter + 1;
                        state_nxt = MOVING_DOWN;
                    end                  
                    else                 
                    begin                
                        counter_nxt = 0; 
                        state_nxt = IDLE;
                    end                   
            end
            ELIMINATED:
            begin
                eliminated_nxt = 0;
                x_pos_nxt = 1025;
                y_pos_nxt = 0;
                state_nxt = ELIMINATED;
            end
        endcase
    end
    
    lfsr #(.width(5))
        (
            .cout(lfsr_out),
            .CE(cEnable),
            .CLK(clk),
            .SCLR(rst),
            .seed(seed)
        );
            
    clk_divider        
    #(.FREQ(150))      
     my_clk_divider(   
      .clk100MHz(clk), 
      .rst(),       
      .clk_div(clk_div)
    ); 
                    
endmodule
