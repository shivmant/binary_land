`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2020 16:58:15
// Design Name: 
// Module Name: holder
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


module holder
#(parameter HOLD_TIME = 1)
(
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg signal_out
    );
    
    localparam IDLE = 1'b0, HOLD = 1'b1;
    
    reg signal_out_nxt;
    reg [25:0] counter, counter_nxt;
    reg state, state_nxt;
    
    initial
    begin
        state <= IDLE;
    end
    
    always @(posedge clk or posedge rst)
    begin                             
        if(rst)                       
        begin
            signal_out <= 0;
            counter <= 0;
            state <= IDLE;
        end
        else
        begin
            signal_out <= signal_out_nxt;
            counter <= counter_nxt;
            state <= state_nxt;
        end                           
    end
    
    always @*
    begin
        counter_nxt = counter;
        case(state) 
            IDLE:
            begin
                signal_out_nxt = signal_in;
                if(signal_in)
                begin
                    counter_nxt = 0;
                    state_nxt = HOLD;
                end
                else
                begin
                    state_nxt = IDLE;
                end
            end
            HOLD:
            begin
                signal_out_nxt = 1;
                if(counter == HOLD_TIME - 1)
                begin
                    state_nxt = IDLE;
                end
                else
                begin
                    if(signal_in)
                        counter_nxt = 0;
                    else
                        counter_nxt = counter + 1;
                    state_nxt = HOLD;
                end
            end
        endcase
    end
    
endmodule
