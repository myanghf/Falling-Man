`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2017 14:54:32
// Design Name: 
// Module Name: slow_clock
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


module slow_clock_40(
    input CLOCK, output reg slow_clock = 0
    );
    
    reg [19:0] COUNT = 20'b0;

    always @ (posedge CLOCK) begin
        COUNT <= COUNT + 1;
        slow_clock <= ( COUNT == 20'b0) ? ~slow_clock : slow_clock ;
    end

endmodule 
