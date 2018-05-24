`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2017 14:59:54
// Design Name: 
// Module Name: slow_clock_1
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


module slow_clock_1(
    input CLOCK, output reg slow_clock = 0
    );
    
    reg [24:0] COUNT = 25'b0;

    always @ (posedge CLOCK) begin
        COUNT <= COUNT + 1;
        slow_clock <= ( COUNT == 25'b0) ? ~slow_clock : slow_clock ;
    end

endmodule 