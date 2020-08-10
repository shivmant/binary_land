`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2020 17:05:58
// Design Name: 
// Module Name: map_rom
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


module map_rom(
    input wire clk,
    input wire [1:0] level,
    output reg [15*10-1:0] map
    );
    
    reg [149:0] rom [2:0];
    
    initial $readmemb("map.mem", rom);
    always @(posedge clk)
        map <= rom[level];
    
endmodule
