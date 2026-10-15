`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2024 01:24:02 PM
// Design Name: 
// Module Name: StartGen
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


module StartGen(
  input  clk,
  input rst_n,
  input enable,
  output reg strtpuls
);

reg [6:0] count;
reg enable_ole; // stores previous value of enable
reg pulse_en;  // pulse enable when edge of enable occurs 

/*
initial
begin
  count <= 4'b0000;
  strtpuls <= 1'b0;
  pulse_en <= 1'b0;
  enable_ole <= 1'b0;
end
*/

always @(posedge clk)
  if (~rst_n)
    begin
      count <= 0;
      strtpuls <= 1'b0;
      pulse_en <= 1'b0;
      enable_ole <= 1'b0; 
    end
  else
    begin
    if (enable > enable_ole)  // edge detected
      pulse_en <= 1'b1;  // ready for pulse
    if (pulse_en)
      begin
        strtpuls <= 1'b1;
        // if (count == 7'b0000100)   // 8 equals 80ns, we use 4 for 40ns
        if (count == 7'b0000010)   // 8 equals 80ns, we use 2 for 20ns
          begin
            strtpuls <= 1'b0;
            count <= 0; 
            pulse_en <= 1'b0;
          end
        else
          count <= count + 1; 
      end
    else
      begin
        count <= 0;
        enable_ole <= enable;
      end
    end
  
endmodule


