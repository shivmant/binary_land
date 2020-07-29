`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2020 19:03:49
// Design Name: 
// Module Name: draw_object
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


module draw_object
#(parameter COLOR = 12'h0_1_c) //BLUE
(
    input wire clk,
    input wire rst,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] x_pos, 
    input wire [11:0] y_pos, 
    
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_out_nxt;
    
    localparam SQUARE_SIDE = 60;
    localparam BLACK = 12'h0_0_0;
    localparam BLUE = 12'h0_1_c;
        
    always @(posedge clk or posedge rst)
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
        
    always @*
    begin
        if (vblnk_in || hblnk_in)
            rgb_out_nxt <= BLACK; 
        else
        begin
            if ((hcount_in >= x_pos)&(hcount_in < (x_pos + SQUARE_SIDE))&(vcount_in >= y_pos)&(vcount_in < (y_pos + SQUARE_SIDE))) rgb_out_nxt <= COLOR;
                    else rgb_out_nxt <= rgb_in;  
        end 
    end
    
endmodule
