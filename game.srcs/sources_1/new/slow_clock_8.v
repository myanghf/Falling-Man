`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2017 18:26:57
// Design Name: 
// Module Name: slow_clock_8
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


module slow_clock_8(
    input CLOCK, output reg slow_clock = 0
    );
    
    reg [22:0] COUNT = 23'b0;

    always @ (posedge CLOCK) begin
        COUNT <= COUNT + 1;
        slow_clock <= ( COUNT == 23'b0) ? ~slow_clock : slow_clock ;
    end

endmodule 