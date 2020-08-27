`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2020 13:34:43
// Design Name: 
// Module Name: char_display
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


module char_display
    #(parameter X_POS = 0, Y_POS = 0)
    (
    input wire pclk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [7:0] char_pixels,    //rom
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output wire [7:0] char_xy,
    output wire [3:0] char_line
    );
    
    localparam RECT_WIDTH = 128;    //8*16
    localparam RECT_HEIGHT = 48;   //16*3
    localparam CHAR_COLOR = 12'hf_f_f;
    
    reg [11:0] rgb_out_nxt;
    wire [10:0] hcount_rect, vcount_rect;
    
    always @(posedge pclk or posedge rst)
        if(rst)
        begin
            hcount_out <= 0;
            hsync_out <= 0;
            hblnk_out <= 0;
            vcount_out <= 0;
            vsync_out <= 0;
            vblnk_out <= 0;
            rgb_out <= 0;
        end
        else
        begin
            hcount_out <= hcount_in;
            hsync_out <= hsync_in;
            hblnk_out <= hblnk_in;
            vcount_out <= vcount_in;
            vsync_out <= vsync_in;
            vblnk_out <= vblnk_in;
            rgb_out <= rgb_out_nxt;    
        end
    
    assign char_line = vcount_rect[3:0];
    assign hcount_rect = hcount_in - X_POS;
    assign vcount_rect = vcount_in - Y_POS;
    assign char_xy = {vcount_rect[7:4],hcount_rect[6:3]};
        
    always @*
    begin
        if((hcount_in >= X_POS)&(hcount_in < (X_POS + RECT_WIDTH))&(vcount_in >= Y_POS)&(vcount_in < (Y_POS + RECT_HEIGHT))&(char_pixels[8'b10000000-hcount_in[7:0]- X_POS]))
            rgb_out_nxt <= CHAR_COLOR;
        else 
            rgb_out_nxt <= rgb_in;
    end
    
endmodule
