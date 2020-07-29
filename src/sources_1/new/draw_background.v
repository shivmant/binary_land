`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2020 19:55:37
// Design Name: 
// Module Name: draw_background
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


module draw_background(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_out_nxt;
    
    localparam BLACK = 12'h0_0_0;
    localparam GREY = 12'h8_8_8;
    localparam BROWN = 12'h6_3_0;   
        
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
        end
    end    
        
    always @(*)
    begin
        if (vblnk_in || hblnk_in)
            rgb_out_nxt = BLACK; 
        else
        begin
            // Active display, top edge, make a yellow line.
            //if (vcount_in == 0) rgb_out_nxt = 12'hf_f_0;
            // Active display, bottom edge, make a red line.
            //else if (vcount_in == 767) rgb_out_nxt = 12'hf_0_0;
            // Active display, left edge, make a green line.
            //else if (hcount_in == 0) rgb_out_nxt = 12'h0_f_0;
            // Active display, right edge, make a blue line.
            //else if (hcount_in == 1023) rgb_out_nxt = 12'h0_0_f;
            
            if((vcount_in >= 48 && vcount_in < 108) && (hcount_in >= 2 && hcount_in < 1022))            //TOP WALL
                rgb_out_nxt = BROWN;
            else if((vcount_in >= 708 && vcount_in < 768) && (hcount_in >= 2 && hcount_in < 1022))      //BOTTOM WALL
                rgb_out_nxt = BROWN;
            else if((vcount_in >= 108 && vcount_in < 708) && (hcount_in >= 2 && hcount_in < 62))        //LEFT WALL
                rgb_out_nxt = BROWN;
            else if((vcount_in >= 108 && vcount_in < 708) && (hcount_in >= 962 && hcount_in < 1022))    //RIGHT WALL
                rgb_out_nxt = BROWN;
            else if((vcount_in >= 108 && vcount_in < 708) && (hcount_in >= 62 && hcount_in < 962))      //BACKGROUND
                rgb_out_nxt = GREY;
            else rgb_out_nxt = BLACK;
        end 
    end
endmodule
