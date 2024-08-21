`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2018 17:54:31
// Design Name: 
// Module Name: relu
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


module relu(
    input wire en,
    input wire [23:0] din_relu,
    output  wire [23:0] dout_relu
    );
assign dout_relu = ((en==1)&&din_relu[23] == 0)? din_relu : 0;
endmodule
