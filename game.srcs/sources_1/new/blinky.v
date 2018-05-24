`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2017 00:13:50
// Design Name: 
// Module Name: blinky
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


module blinky(
    input CLOCK,
    output reg [15:0]LED= 16'b1111111111111111
    );
    
    reg COUNT;
     
    always @ (posedge CLOCK) begin
        COUNT <= COUNT +1;
        LED <= (COUNT == 0) ? 16'b1111111111111111 : 16'b0000000000000000; 
    end
    
endmodule