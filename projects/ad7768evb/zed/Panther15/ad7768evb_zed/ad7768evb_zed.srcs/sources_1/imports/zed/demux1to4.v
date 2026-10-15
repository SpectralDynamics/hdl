`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2025 19:01:26
// Design Name: 
// Module Name: demux1to4
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


module demux1to4(
    input wire d_in,
    input wire [1:0] a,
    output reg y0,
    output reg y1,
    output reg y2,
    output reg y3
    );
    
    always @ (*) begin
        if (a == 2'b00)  begin
            y0 = d_in;
            y1 = 1'b1;
            y2 = 1'b1;
            y3 = 1'b1;
        end else if (a == 2'b01) begin
            y0 = 1'b1;
            y1 = d_in;
            y2 = 1'b1;
            y3 = 1'b1;
        end else if (a == 2'b10) begin
            y0 = 1'b1;
            y1 = 1'b1;
            y2 = d_in;
            y3 = 1'b1;
        end else begin
//        (end else if (a == 2'b11) begin)
            y0 = 1'b1;
            y1 = 1'b1;
            y2 = 1'b1;
            y3 = d_in;
        end
    end
                
    
    
    
    
    
    
    
    
    
    
endmodule
