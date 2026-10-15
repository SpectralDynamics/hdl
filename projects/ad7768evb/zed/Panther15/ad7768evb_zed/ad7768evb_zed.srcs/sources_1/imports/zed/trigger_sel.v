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


module trigger_sel(
    input wire trig_pos,
    input wire trig_neg,
    input wire square,
    input wire slope,
    output reg trig_out
    );
    
    always @ (*) begin
        if (slope == 1'b1) begin
            trig_out = (trig_pos || (square && trig_neg));
        end else begin
            trig_out = !(trig_pos || (square && trig_neg));
        end
  end
                
    
    
    
    
    
    
    
    
    
    
endmodule
