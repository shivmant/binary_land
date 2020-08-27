`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2020 18:10:46
// Design Name: 
// Module Name: map_ctl_unit
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


module map_ctl_unit(
input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [23:0] hero_x_pos, 
    input wire [23:0] hero_y_pos,
    input wire [599:0] map,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [11:0] wall_x_pos, 
    output reg [11:0] wall_y_pos,
    output wire [7:0] collision,
    output reg [23:0] score_out
    );
    
    
    reg [11:0] rgb_out_nxt;
    reg [11:0] block_x_pos, block_y_pos, block_x_pos_nxt, block_y_pos_nxt;
    reg [11:0] wall_x_pos_nxt, wall_y_pos_nxt;
    reg [149:0] picked, picked_nxt;
    wire [3:0] type;
    reg [7:0] detection, detection_nxt;
    reg [23:0] score_out_nxt;
    reg [1:0] state, state_nxt;
    
    localparam BLANK = 4'b0000,      
               WALL = 4'b0001,                     
               COIN = 4'b0010,
               POWERUP = 4'b0011;
                   
    localparam SQUARE_SIDE = 60;
    
    localparam BLACK = 12'h0_0_0,
               GREY = 12'h8_8_8,
               BROWN = 12'h6_3_0,
               BLUE = 12'h0_1_c,
               RED = 12'hf_0_0;
               
     localparam IDLE = 2'b00,      
                PICK_UP = 2'b01,                     
                COLLISION = 2'b10,
                INIT = 2'b11;       
//     initial
//     begin
//        picked_nxt = 0;
//        score_out = 0;
//     end   
    always @(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            hcount_out <= 0;
            hsync_out  <= 0;
            hblnk_out  <= 0;
            vcount_out <= 0;
            vsync_out  <= 0;
            vblnk_out  <= 0;
            rgb_out    <= 0;
            block_x_pos <= 0;
            block_y_pos <= 0;
            wall_x_pos <= 0;
            wall_y_pos <= 0;
            picked <= 0;
            detection <= 0;
            state <= INIT;
            //score_out <= 0;
        end
        else
        begin
            hcount_out <= hcount_in;
            hsync_out  <= hsync_in;
            hblnk_out  <= hblnk_in;
            vcount_out <= vcount_in;
            vsync_out  <= vsync_in; 
            vblnk_out  <= vblnk_in; 
            rgb_out    <= rgb_out_nxt;
            block_x_pos <= block_x_pos_nxt;
            block_y_pos <= block_y_pos_nxt;
            wall_x_pos <= wall_x_pos_nxt;
            wall_y_pos <= wall_y_pos_nxt;
            picked <= picked_nxt;
            detection <= detection_nxt;
            state <= state_nxt;
            score_out <= score_out_nxt;
        end
    end    
        
    always @*
    begin
        if((hero_x_pos[11:0] <= wall_x_pos + SQUARE_SIDE + 1)&&(hero_x_pos[11:0] + SQUARE_SIDE - 1 > wall_x_pos  - 1)&&(hero_y_pos[11:0] <= wall_y_pos + SQUARE_SIDE)&&(hero_y_pos[11:0] + SQUARE_SIDE >= wall_y_pos))
        begin
            if((hero_x_pos[11:0] - 1 >= wall_x_pos)&&(hero_y_pos[11:0] <= wall_y_pos + SQUARE_SIDE - 1)&&(hero_y_pos[11:0] + SQUARE_SIDE > wall_y_pos + 1))        //LEFT
                detection_nxt[0] = 1;//4'b0001;
            else detection_nxt[0] = 0;
            if((hero_x_pos[11:0] + 1 <= wall_x_pos)&&(hero_y_pos[11:0] <= wall_y_pos + SQUARE_SIDE - 1)&&(hero_y_pos[11:0] + SQUARE_SIDE > wall_y_pos + 1))        //RIGHT
                detection_nxt[1] = 1;//4'b0010;
            else detection_nxt[1] = 0;    
            if((hero_y_pos[11:0] - 1 <= wall_y_pos)&&(hero_x_pos[11:0] <= wall_x_pos + SQUARE_SIDE)&&(hero_x_pos[11:0] + SQUARE_SIDE - 1> wall_x_pos))             //DOWN
                detection_nxt[2] = 1;//4'b0100;
            else detection_nxt[2] = 0;
            if((hero_y_pos[11:0] + 1 >= wall_y_pos)&&(hero_x_pos[11:0] <= wall_x_pos + SQUARE_SIDE)&&(hero_x_pos[11:0] + SQUARE_SIDE - 1> wall_x_pos))             //UP
                detection_nxt[3] = 1;//4'b1000;
            else detection_nxt[3] = 0;
        end
        else
            detection_nxt[3:0] = 4'b0000;
        if((hero_x_pos[23:12] <= wall_x_pos + SQUARE_SIDE + 1)&&(hero_x_pos[23:12] + SQUARE_SIDE - 1 > wall_x_pos  - 1)&&(hero_y_pos[23:12] <= wall_y_pos + SQUARE_SIDE)&&(hero_y_pos[23:12] + SQUARE_SIDE >= wall_y_pos))
         begin
             if((hero_x_pos[23:12] - 1 >= wall_x_pos)&&(hero_y_pos[23:12] <= wall_y_pos + SQUARE_SIDE - 1)&&(hero_y_pos[23:12] + SQUARE_SIDE > wall_y_pos + 1))        //LEFT
                 detection_nxt[4] = 1;//4'b0001;
             else detection_nxt[4] = 0;
             if((hero_x_pos[23:12] + 1 <= wall_x_pos)&&(hero_y_pos[23:12] <= wall_y_pos + SQUARE_SIDE - 1)&&(hero_y_pos[23:12] + SQUARE_SIDE > wall_y_pos + 1))        //RIGHT
                 detection_nxt[5] = 1;//4'b0010;
             else detection_nxt[5] = 0;    
             if((hero_y_pos[23:12] - 1 <= wall_y_pos)&&(hero_x_pos[23:12] <= wall_x_pos + SQUARE_SIDE)&&(hero_x_pos[23:12] + SQUARE_SIDE - 1> wall_x_pos))             //DOWN
                 detection_nxt[6] = 1;//4'b0100;
             else detection_nxt[6] = 0;
             if((hero_y_pos[23:12] + 1 >= wall_y_pos)&&(hero_x_pos[23:12] <= wall_x_pos + SQUARE_SIDE)&&(hero_x_pos[23:12] + SQUARE_SIDE - 1> wall_x_pos))             //UP
                 detection_nxt[7] = 1;//4'b1000;
             else detection_nxt[7] = 0;
         end
         else
             detection_nxt[7:4] = 4'b0000; 
        wall_x_pos_nxt = 7;
        wall_y_pos_nxt = 0;    
        if((vcount_in >= 108 && vcount_in < 708) && (hcount_in >= 61 && hcount_in < 961))
        begin
            block_x_pos_nxt = (hcount_in-61)/60;
            block_y_pos_nxt = (vcount_in-108)/60;
        end
        else
        begin
            block_x_pos_nxt = 7;    //always map[block_x_pos + block_y_pos*15] = 0
            block_y_pos_nxt = 0;
        end                                                                                                                                                                          
        case(type)
            BLANK:
            begin
                rgb_out_nxt = rgb_in;
            end
            WALL:
            begin
                rgb_out_nxt = BROWN;
                wall_x_pos_nxt = block_x_pos*60+61;
                wall_y_pos_nxt = block_y_pos*60+108;
            end
            COIN:
            begin
                if((vcount_in >= block_y_pos*60+108 + 15 && vcount_in < block_y_pos*60+108 + 45) && (hcount_in >= block_x_pos*60+61 + 15 && hcount_in < block_x_pos*60+61 + 45)&&!picked[block_x_pos + block_y_pos*15])
                    rgb_out_nxt = 12'hf_f_f;
                else
                    rgb_out_nxt = rgb_in;
            end
            POWERUP:
            begin
                if((vcount_in >= block_y_pos*60+108 + 15 && vcount_in < block_y_pos*60+108 + 45) && (hcount_in >= block_x_pos*60+61 + 15 && hcount_in < block_x_pos*60+61 + 45)&&!picked[block_x_pos + block_y_pos*15])
                    rgb_out_nxt = 12'h0_f_f;
                else
                    rgb_out_nxt = rgb_in;
            end
        endcase
        case(state)
            INIT:
            begin
                picked_nxt = 0;
            end
            IDLE:
            begin
                if(((block_x_pos*60+61 + 15 <= hero_x_pos[11:0] + SQUARE_SIDE + 1)
                &&(block_x_pos*60+61 + 45 - 1 > hero_x_pos[11:0] - 1)
                &&(block_y_pos*60+108 + 15 <= hero_y_pos[11:0] + SQUARE_SIDE)
                &&(block_y_pos*60+108 + 45 >=hero_y_pos[11:0])
                &&!picked[block_x_pos + block_y_pos*15])
                ||
                ((block_x_pos*60+61 + 15 <= hero_x_pos[23:12] + SQUARE_SIDE + 1)
                &&(block_x_pos*60+61 + 45 - 1 > hero_x_pos[23:12] - 1)
                &&(block_y_pos*60+108 + 15 <= hero_y_pos[23:12] + SQUARE_SIDE)
                &&(block_y_pos*60+108 + 45 >=hero_y_pos[23:12])
                &&!picked[block_x_pos + block_y_pos*15])
                &&(type != BLANK)&&(type != WALL))
                    state_nxt = PICK_UP;
                else
                    state_nxt = IDLE;
            end
            PICK_UP:
            begin
                picked_nxt[block_x_pos + block_y_pos*15] = 1;
                case(type)
                    COIN:
                    begin
                        score_out_nxt = score_out + 100;       //z przypisaniem nieblokujacym nie dziala prawidlowo
                    end
                    POWERUP:
                    begin
                        score_out_nxt = score_out + 500;       //z przypisaniem nieblokujacym nie dziala prawidlowo
                    end
                endcase
                state_nxt = IDLE; 
            end
        endcase                                                                                                                                              
    end
    
    assign type[0] = map[(block_x_pos + block_y_pos*15)*4];
    assign type[1] = map[(block_x_pos + block_y_pos*15)*4+1];
    assign type[2] = map[(block_x_pos + block_y_pos*15)*4+2];
    assign type[3] = map[(block_x_pos + block_y_pos*15)*4+3];
    
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
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz, 1200000   
        collision_holder4(.clk(clk), .rst(rst),              
        .signal_in(detection[4]), .signal_out(collision[4]));
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz            
        collision_holder5(.clk(clk), .rst(rst),              
        .signal_in(detection[5]), .signal_out(collision[5]));
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz            
        collision_holder6(.clk(clk), .rst(rst),              
        .signal_in(detection[6]), .signal_out(collision[6]));
    holder #(.HOLD_TIME(1200000))//1350 dla 10MHz            
        collision_holder7(.clk(clk), .rst(rst),              
        .signal_in(detection[7]), .signal_out(collision[7]));
    
endmodule