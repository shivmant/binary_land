`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2020 11:28:06
// Design Name: 
// Module Name: wall
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


module wall(
    input wire clk,
    input wire rst,
    input wire [11:0] hero_x_pos,
    input wire [11:0] hero_y_pos,
    
    output reg [3:0]collision,
    //block
    output reg [11:0] block_x_pos,
    output reg [11:0] block_y_pos   
    //input rom
    );
    
    localparam SQUARE_SIDE = 60;
    
    reg [3:0]collision_nxt;
    reg [14:0]rom[9:0];
    reg [0:5] hcounter, hcounter_nxt, vcounter, vcounter_nxt;
    reg [11:0] block_x_pos_nxt, block_y_pos_nxt;
    
    initial
    begin
        rom[1][1]=1;
        rom[1][2]=1;
        rom[2][1]=1;
        rom[3][5]=1;
    end
    
    always @(posedge clk or posedge rst)
     begin                             
        if(rst)                       
        begin
            collision <= 0;
            hcounter <= 0;
            vcounter <= 0;
            block_x_pos <= 0;
            block_y_pos <= 0;
        end
        else
        begin
            collision <= collision_nxt;
            hcounter <= hcounter_nxt;
            vcounter <= vcounter_nxt;
            block_x_pos <= block_x_pos_nxt;
            block_y_pos <= block_y_pos_nxt;
        end                           
    end                               
    
    always @*
    begin
    //block_x_pos_nxt = 62+60;
    //block_y_pos_nxt = 108+60;
        if((hero_x_pos <= block_x_pos + SQUARE_SIDE)&&(hero_x_pos + SQUARE_SIDE >= block_x_pos)&&(hero_y_pos <= block_y_pos + SQUARE_SIDE)&&(hero_y_pos + SQUARE_SIDE >= block_y_pos))         //LEFT
            collision_nxt = 3'b001;
        else if(hero_x_pos + SQUARE_SIDE >= block_x_pos)    //RIGHT
            collision_nxt = 3'b010;
        else if(hero_y_pos <= block_y_pos + SQUARE_SIDE)    //UP
            collision_nxt = 3'b011;
        else if(hero_y_pos + SQUARE_SIDE >= block_y_pos)    //DOWN
            collision_nxt = 3'b100;
        else
            collision_nxt = 3'b000;
        if(hcounter == 14)
        begin
            hcounter_nxt = 0;
            if(vcounter == 9)
                vcounter_nxt = 0;
            else
                vcounter_nxt = vcounter + 1;
        end
        else
            hcounter_nxt = hcounter + 1;
        if(rom[hcounter][vcounter])
        begin
            block_x_pos_nxt = 62 + (SQUARE_SIDE * hcounter);
            block_y_pos_nxt = 108 + (SQUARE_SIDE * vcounter);
        end
        //else
            //block_x_pos_nxt = 
           // block_y_pos_nxt = 
    end
    
endmodule
