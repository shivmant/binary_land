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


module draw_object(
    input wire clk,
    input wire rst,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_out_nxt;
    
    localparam SQUARE = 60;
    localparam X_POS = 200;
    localparam Y_POS = 200;
    localparam BLACK = 12'h0_0_0;
    localparam BLUE = 12'h0_1_c;
        
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
            hcount_out <= #2 hcount_in;
            hsync_out  <= #2 hsync_in;
            hblnk_out  <= #2 hblnk_in;
            vcount_out <= #2 vcount_in;
            vsync_out  <= #2 vsync_in; 
            vblnk_out  <= #2 vblnk_in; 
            rgb_out    <= #2 rgb_out_nxt;   
        end
    end    
        
    always @(*)
    begin
        if (vblnk_in || hblnk_in)
            rgb_out_nxt <= BLACK; 
        else
        begin
            if((vcount_in >= Y_POS) && (vcount_in < Y_POS + SQUARE) &&
               (hcount_in > X_POS) && (hcount_in < X_POS + SQUARE))
                rgb_out_nxt <= BLUE;
            else
                rgb_out_nxt <= rgb_in;      
        end 
    end
    
endmodule
