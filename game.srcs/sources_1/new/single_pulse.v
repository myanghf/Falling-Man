`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 02:18:35 PM
// Design Name: 
// Module Name: my_single_pulse
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


module my_single_pulse(
    input CLOCK, PUSH, output PULSE 
    );
    
    wire Q1, Q2;
    my_dff pc1(CLOCK, PUSH, Q1);
    my_dff pc2(CLOCK, Q1, Q2);
    
    assign PULSE = Q1 & ~Q2;
    
endmodule
