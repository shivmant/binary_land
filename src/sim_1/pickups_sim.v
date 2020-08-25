`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2020 14:19:30
// Design Name: 
// Module Name: pickups_sim
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


module pickups_sim;

reg clk;
reg clk_div, right;
//wire pclk_mirror;
//wire vs, hs;
wire [10:0] vcount_in, hcount_in;
wire vsync_in, hsync_in;
wire vblnk_in, hblnk_in;
   
wire [10:0] vcount_out, hcount_out;
wire vsync_out, hsync_out;
wire vblnk_out, hblnk_out;
wire [11:0] rgb_out;

//wire [11:0] block_x_pos, block_y_pos;
//wire [11:0] x_pos_hero, y_pos_hero;
//reg [11:0] pickup [4:0];


vga_timing my_vga_timing (
    .vcount(vcount_in),
    .vsync(vsync_in),
    .vblnk(vblnk_in),
    .hcount(hcount_in),
    .hsync(hsync_in),
    .hblnk(hblnk_in),
    .pclk(clk),
    .rst(1'b0)
);

    pickups_management_unit my_pickups_unit (              
        .clk(clk),                  
        .rst(1'b0),                   
        .hcount_in(hcount_in),  
        .hsync_in(hsync_in),    
        .hblnk_in(hblnk_in),    
        .vcount_in(vcount_in),  
        .vsync_in(vsync_in),    
        .vblnk_in(vblnk_in),    
        .rgb_in(12'h000),        
        .hero_x_pos(12'h000),  
        .hero_y_pos(12'h000),               
        .hcount_out(hcount_out),
        .hsync_out(hsync_out),  
        .hblnk_out(hblnk_out),  
        .vcount_out(vcount_out),
        .vsync_out(vsync_out),  
        .vblnk_out(vblnk_out),  
        .rgb_out(rgb_out)
    );  

//hero_ctl my_hero_ctl (
//    .clk(clk),
//    .clk_div(clk_div), 
//    .rst(1'b0),
//    .up(1'b0),
//    .left(1'b0),
//    .right(right),
//    .down(1'b0),
//    .center(1'b0),
//    .block_x_pos(block_x_pos),
//    .block_y_pos(block_y_pos),
//    .collision(collision),
//    .x_pos(x_pos_hero),
//    .y_pos(y_pos_hero)
//);

always
begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
end

//always
//    begin
//        clk_div = 1'b0;
//        #100000;
//        clk_div = 1'b1;
//        #100000;
//    end

//always
//        begin
//            right = 1'b0;
//            #5000000;
//            right = 1'b1;
//            #300000;
//        end 

endmodule
