`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2020 15:18:04
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
    input  wire [23:0] bin,
    output reg  [3:0]  bcd0,    //LSB
    output reg  [3:0]  bcd1,
    output reg  [3:0]  bcd2,
    output reg  [3:0]  bcd3,
    output reg  [3:0]  bcd4,
    output reg  [3:0]  bcd5     //MSB
);
    reg [23:0] bincounter;
    integer i;
    
    always @(bin)
    begin
        bcd0 = 0;
        bcd1 = 0;
        bcd2 = 0;
        bcd3 = 0;
        bcd4 = 0;
        bcd5 = 0;
        bincounter=bin;
    
    for ( i = 23; i >= 0; i = i - 1 )
    begin
        if( bcd0 > 4 ) bcd0 = bcd0 + 3;
        if( bcd1 > 4 ) bcd1 = bcd1 + 3;
        if( bcd2 > 4 ) bcd2 = bcd2 + 3;
        if( bcd3 > 4 ) bcd3 = bcd3 + 3;
        if( bcd4 > 4 ) bcd4 = bcd4 + 3;
        if( bcd5 > 4 ) bcd5 = bcd5 + 3;
        { bcd5[3:0], bcd4[3:0], bcd3[3:0], bcd2[3:0], bcd1[3:0], bcd0[3:0] } =
        { bcd5[2:0], bcd4[3:0], bcd3[3:0], bcd2[3:0], bcd1[3:0], bcd0[3:0],bincounter[i] };
    end
    
    end

endmodule
