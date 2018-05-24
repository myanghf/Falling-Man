`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2017 14:52:36
// Design Name: 
// Module Name: game
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


module game(
    input CLOCK, bSTART, bLEFT, bRIGHT, bFAST, bSLOW, [15:0]sw,
    output [15:0] LED
    );
    
    reg clockCur = 0;
    reg [1:0]speed = 2'b00;
    reg direction;
    reg [15:0] wall;
    reg active= 1'b0;
    reg over = 1'b0;
    reg [15:0] ledPos = 16'h380;
    
    wire START, LEFT, RIGHT, FAST, SLOW;
    wire clock40, clock1, clock4, clock8;
    wire [15:0]ledBlink;
    
    //Clock Divider
//    slow_clock_40 CL1(CLOCK, clock40);
//    slow_clock_1 CL2(CLOCK, clock1);
//    slow_clock_4 CL3(CLOCK, clock4);
//    slow_clock_8 CL4(CLOCK, clock8);
    clock_divider CLK40(CLOCK, 21'b0001_0000_0000_0000_0000_0000, clock40);
    clock_divider CLK4 (CLOCK, 24'b0000_1000_0000_0000_0000_0000_0000, clock4);
    clock_divider CLK1 (CLOCK, 25'b0001_0000_0000_0000_0000_0000_0000, clock1);
    clock_divider CLK8 (CLOCK, 23'b0000_0100_0000_0000_0000_0000_0000, clock8);
    
    //Debouncing
    my_single_pulse DB1(clock40, bSTART, START);
    my_single_pulse DB2(clock40, bLEFT, LEFT);
    my_single_pulse DB3(clock40, bRIGHT, RIGHT);
    my_single_pulse DB4(clock40, bFAST, FAST);
    my_single_pulse DB5(clock40, bSLOW, SLOW);
    
    //Logic Control
    always @ (posedge clock40) begin
        if (START) begin active <= 1'b1; end
        if (LEFT) begin direction <= 1'b1; end
        if (RIGHT) begin direction <= 1'b0; end
        if (FAST) begin speed <= speed + 2'b01; end
        if (SLOW) begin speed <= speed - 2'b01; end
        if (speed == 2'b00) begin clockCur <= clock1; end
        if (speed == 2'b01) begin clockCur <= clock4; end
        if (speed == 2'b10) begin clockCur <= clock8; end
        if (speed == 2'b11) begin speed <= 2'b00; end
        if (ledPos == 16'b1100000000000000 || ledPos == 16'b0000000000000011) begin over <= 1'b1; end
        if ((sw & ledPos) != 16'b0) begin over<= 1'b1; end
    end
        
    //Moving Left & Right
    always @ (posedge clockCur) begin
        if (active) begin ledPos <= direction ? (ledPos << 1) : (ledPos >> 1); end
    end
    
    //Ending the Game
    blinky EG(clock4, ledBlink);
    assign LED = over ? ledBlink : ledPos;
        
endmodule
