`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2020 13:15:26
// Design Name: 
// Module Name: score_management_unit
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


module score_management_unit(
    input wire clk,
    input wire [7:0] char_xy,
    input wire score_ascii,
    output reg [6:0] char_code
    );
    
    always @*
        case(char_xy)
            8'h00: char_code = 7'h53; //S
            8'h01: char_code = 7'h43; //C
            8'h02: char_code = 7'h4f; //O
            8'h03: char_code = 7'h52; //R
            8'h04: char_code = 7'h45; //E
            8'h05: char_code = 7'h3a; //:
            8'h06: char_code = 7'h00; //
            8'h07: char_code = 7'h00; //
            8'h08: char_code = 7'h00; //
            8'h09: char_code = 7'h00; //
            8'h0a: char_code = 7'h00; //
            8'h0b: char_code = 7'h00; //
            
            8'h10: char_code = 7'h00; //T
            8'h11: char_code = 7'h00; //I
            8'h12: char_code = 7'h00; //M
            8'h13: char_code = 7'h00; //E
            8'h14: char_code = 7'h00; //
            8'h15: char_code = 7'h00; //L
            8'h16: char_code = 7'h00; //E
            8'h17: char_code = 7'h00; //F
            8'h18: char_code = 7'h00; //T
            8'h19: char_code = 7'h00; //
            8'h1a: char_code = 7'h00; //
            8'h1b: char_code = 7'h00; //
            
            8'h20: char_code = 7'h00; //
            8'h21: char_code = 7'h00; //
            8'h22: char_code = 7'h00; //
            8'h23: char_code = 7'h00; //
            8'h24: char_code = 7'h00; //
            8'h25: char_code = 7'h00; //
            8'h26: char_code = 7'h00; //
            8'h27: char_code = 7'h00; //
            8'h28: char_code = 7'h00; //
            8'h29: char_code = 7'h00; //
            8'h2a: char_code = 7'h00; //
            8'h2b: char_code = 7'h00; //
        endcase
    
endmodule
