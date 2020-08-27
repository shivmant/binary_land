`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2020 15:08:02
// Design Name: 
// Module Name: info_panel
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


module info_panel(
    input wire clk,
    input wire [7:0] char_xy,
    input wire [23:0] score,
    input wire [23:0] score_req,
    output reg [6:0] char_code
    );
    
    wire [3:0] score_bcd0, score_bcd1, score_bcd2, score_bcd3, score_bcd4, score_bcd5;
    wire [3:0] score_req_bcd0, score_req_bcd1, score_req_bcd2, score_req_bcd3, score_req_bcd4, score_req_bcd5; 
    
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
            8'h0a: char_code = score_bcd5+48; //MSB
            8'h0b: char_code = score_bcd4+48; //
            8'h0c: char_code = score_bcd3+48; //
            8'h0d: char_code = score_bcd2+48; //
            8'h0e: char_code = score_bcd1+48; //
            8'h0f: char_code = score_bcd0+48; //LSB
            
            8'h10: char_code = 7'h53; //S
            8'h11: char_code = 7'h43; //C
            8'h12: char_code = 7'h4f; //O
            8'h13: char_code = 7'h52; //R
            8'h14: char_code = 7'h45; //E
            8'h15: char_code = 7'h00; //
            8'h16: char_code = 7'h52; //R
            8'h17: char_code = 7'h45; //E
            8'h18: char_code = 7'h51; //Q
            8'h19: char_code = 7'h3a; //:
            8'h1a: char_code = score_req_bcd5+48; //MSB
            8'h1b: char_code = score_req_bcd4+48; //
            8'h1c: char_code = score_req_bcd3+48; //
            8'h1d: char_code = score_req_bcd2+48; //
            8'h1e: char_code = score_req_bcd1+48; //
            8'h1f: char_code = score_req_bcd0+48; //LSB
            
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
            8'h2c: char_code = 7'h00; // 
            8'h2d: char_code = 7'h00; // 
            8'h2e: char_code = 7'h00; // 
            8'h2f: char_code = 7'h00; // 
        endcase
    
    bin2bcd score_bin2bcd
    (
        .bin (score),
        .bcd0(score_bcd0),
        .bcd1(score_bcd1),
        .bcd2(score_bcd2),
        .bcd3(score_bcd3),
        .bcd4(score_bcd4),
        .bcd5(score_bcd5)
    );
    
    bin2bcd score_req_bin2bcd
    (
        .bin (score_req),
        .bcd0(score_req_bcd0),
        .bcd1(score_req_bcd1),
        .bcd2(score_req_bcd2),
        .bcd3(score_req_bcd3),
        .bcd4(score_req_bcd4),
        .bcd5(score_req_bcd5)
    );
    
endmodule
