`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 14:58:37
// Design Name: 
// Module Name: draw_attack_rect
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


module draw_attack_rect
#(parameter COLOR = 12'hf_f_f)
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
    input wire [23:0] x_pos, 
    input wire [23:0] y_pos, 
    input wire direction,
    
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
    localparam WIDTH = 40,
               HEIGHT = 20;
        
    always @(posedge clk)
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
            if(direction)
                if (((hcount_in >= x_pos[11:0])&(hcount_in < (x_pos[11:0] + WIDTH))&(vcount_in >= y_pos[11:0])&(vcount_in < (y_pos[11:0] + HEIGHT)))
                ||((hcount_in >= x_pos[23:12])&(hcount_in < (x_pos[23:12] + WIDTH))&(vcount_in >= y_pos[23:12])&(vcount_in < (y_pos[23:12] + HEIGHT)))) 
                    rgb_out_nxt <= COLOR;
                else
                    rgb_out_nxt <= rgb_in;  
            else
                if (((hcount_in >= x_pos[11:0])&(hcount_in < (x_pos[11:0] + HEIGHT))&(vcount_in >= y_pos[11:0])&(vcount_in < (y_pos[11:0] + WIDTH)))
                ||((hcount_in >= x_pos[23:12])&(hcount_in < (x_pos[23:12] + HEIGHT))&(vcount_in >= y_pos[23:12])&(vcount_in < (y_pos[23:12] + WIDTH)))) 
                    rgb_out_nxt <= COLOR;
                else
                    rgb_out_nxt <= rgb_in; 
        end 
    end
    
endmodule
