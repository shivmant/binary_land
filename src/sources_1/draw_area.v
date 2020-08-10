`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2020 14:33:57
// Design Name: 
// Module Name: draw_area
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


module draw_area(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [15*10-1:0] map,
    input wire [11:0] hero_x_pos,
    input wire [11:0] hero_y_pos,
    
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [11:0] wall_x_pos, 
    output reg [11:0] wall_y_pos,
    output reg [3:0]collision
    );
    
    
    reg [11:0] rgb_out_nxt;
    reg [0:5] hcounter, hcounter_nxt, vcounter, vcounter_nxt;
    reg [11:0] block_x_pos, block_y_pos;
    reg [11:0] block_x_pos_nxt, block_y_pos_nxt;
    reg [11:0] wall_x_pos_nxt, wall_y_pos_nxt;
    
    localparam SQUARE_SIDE = 60;
    
    localparam BLACK = 12'h0_0_0,
               GREY = 12'h8_8_8,
               BROWN = 12'h6_3_0,
               BLUE = 12'h0_1_c,
               RED = 12'hf_0_0;
       
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
            
        end
    end    
        
    always @(*)
    begin
        if((vcount_in >= 108 && vcount_in < 708) && (hcount_in >= 61 && hcount_in < 961))
        begin
            block_x_pos_nxt = (hcount_in-61)/60;
            block_y_pos_nxt = (vcount_in-108)/60;
        end
        else
        begin
            block_x_pos_nxt = 0;    //dowolny  blok map[block_x_pos + block_y_pos*15] = 0
            block_y_pos_nxt = 0;
        end                                             
        if (vblnk_in || hblnk_in)
            rgb_out_nxt = BLACK; 
        else
        begin                                                                                                                                 
            case(map[block_x_pos + block_y_pos*15])
            0:
            begin
                rgb_out_nxt = rgb_in;
                wall_x_pos_nxt = 0;
                wall_y_pos_nxt = 0;
            end
            1:
            begin
                rgb_out_nxt = RED;
                wall_x_pos_nxt = block_x_pos*60+61;
                wall_y_pos_nxt = block_y_pos*60+108;
            end
            endcase                                                                                                
        end                                                                                                                                              
    end
    
endmodule
