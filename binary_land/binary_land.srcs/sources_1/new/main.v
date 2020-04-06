`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2020 16:52:37
// Design Name: 
// Module Name: main
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


module main(
    input wire clk,
    input wire rst,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror
    );
    
    // CLOCK
    
    wire locked;
    wire pclk;
    
    ODDR pclk_oddr (
        .Q(pclk_mirror),
        .C(pclk),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R(1'b0),
        .S(1'b0)
    );
      
    clk_wiz_0 my_clk_wiz_0 (        
        .clk65MHz(pclk),
        .reset(rst),
        .locked(locked),
        .clk_in1(clk)
    );
    
    //MODULES
    
    wire [10:0] vcount_out_timing, hcount_out_timing;
    wire vsync_out_timing, hsync_out_timing;
    wire vblnk_out_timing, hblnk_out_timing;
    
    wire [10:0] vcount_out_background, hcount_out_background;
    wire vsync_out_background, hsync_out_background;
    wire vblnk_out_background, hblnk_out_background;
    wire [11:0] rgb_out_background;
    
    wire [10:0] vcount_out_obj, hcount_out_obj;
    wire vsync_out_obj, hsync_out_obj;
    wire vblnk_out_obj, hblnk_out_obj;
    wire [11:0] rgb_out_obj;
    
    vga_timing my_vga_timing (
        .vcount(vcount_out_timing),
        .vsync(vsync_out_timing),
        .vblnk(vblnk_out_timing),
        .hcount(hcount_out_timing),
        .hsync(hsync_out_timing),
        .hblnk(hblnk_out_timing),
        .pclk(pclk),
        .rst(rst)
    );
    
    draw_background my_background (
        .hcount_in(hcount_out_timing),
        .hsync_in(hsync_out_timing),
        .hblnk_in(hblnk_out_timing),
        .vcount_in(vcount_out_timing),
        .vsync_in(vsync_out_timing),
        .vblnk_in(vblnk_out_timing),
        .clk(pclk),
        .rst(rst),
        .hcount_out(hcount_out_background),
        .hsync_out(hsync_out_background),
        .hblnk_out(hblnk_out_background),
        .vcount_out(vcount_out_background),
        .vsync_out(vsync_out_background),
        .vblnk_out(vblnk_out_background),
        .rgb_out(rgb_out_background)
    );
    
    draw_object my_object_square (
        .clk(pclk),
        .rst(rst),
        .hcount_in(hcount_out_background),
        .hsync_in(hsync_out_background),
        .hblnk_in(hblnk_out_background),
        .vcount_in(vcount_out_background),
        .vsync_in(vsync_out_background),
        .vblnk_in(vblnk_out_background),
        .rgb_in(rgb_out_background),
        .hcount_out(hcount_out_obj),
        .hsync_out(hsync_out_obj),
        .hblnk_out(hblnk_out_obj),
        .vcount_out(vcount_out_obj),
        .vsync_out(vsync_out_obj),
        .vblnk_out(vblnk_out_obj),
        .rgb_out(rgb_out_obj)
    );
    
    assign hs = hsync_out_obj;
    assign vs = vsync_out_obj;
    assign r = rgb_out_obj [11:8];
    assign g = rgb_out_obj [7:4];
    assign b = rgb_out_obj [3:0];
 
endmodule
