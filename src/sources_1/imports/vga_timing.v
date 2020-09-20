// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output reg [10:0] vcount = 0,
  output wire vsync,
  output wire vblnk,
  output reg [10:0] hcount = 0,
  output wire hsync,
  output wire hblnk,
  input wire clk,
  input wire rst
  );
  
    // 1024x768
    localparam HOR_TOTAL_TIME = 1344;
    localparam HOR_ADDR_TIME = 1024;
    localparam HOR_SYNC_START = 1048;
    localparam HOR_SYNC_TIME = 136;
    localparam VER_TOTAL_TIME = 806;
    localparam VER_ADDR_TIME = 768;
    localparam VER_SYNC_START = 771;
    localparam VER_SYNC_TIME = 6;

  // Describe the actual circuit for the assignment.
  // using a 40 MHz pixel clock per VESA spec.
    
    assign hblnk = (hcount >= HOR_ADDR_TIME);
    assign vblnk = (vcount >= VER_ADDR_TIME);
    assign hsync = ((hcount >= HOR_SYNC_START) && (hcount < (HOR_SYNC_START + HOR_SYNC_TIME)));
    assign vsync = ((vcount >= VER_SYNC_START) && (vcount < (VER_SYNC_START + VER_SYNC_TIME)));

    reg [10:0] vcount_nxt;
    reg [10:0] hcount_nxt; 
    
    always @(posedge clk) 
    begin
        if(rst)
        begin
            hcount <= 0;
            vcount <= 0;        
        end
        else 
        begin
            hcount <= hcount_nxt;
            vcount <= vcount_nxt;
        end
    end
    
    always @* 
    begin
        if((hcount < HOR_TOTAL_TIME - 1) && (vcount < VER_TOTAL_TIME - 1))
            begin
                hcount_nxt = hcount + 1;
                vcount_nxt = vcount;
            end     
        else
        begin
            if((vcount < VER_TOTAL_TIME - 1) && (hcount == HOR_TOTAL_TIME - 1)) 
            begin
                hcount_nxt = 0;
                vcount_nxt = vcount + 1;
            end
            else
            begin
                hcount_nxt = 0;
                vcount_nxt = 0;
            end
        end
    end
     
endmodule
