`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 15:30:43
// Design Name: 
// Module Name: relucutto8
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


module relucutto8(
 input wire en,
    input wire [31:0] din_relu,
    output  wire [7:0] dout_relu,
    output  wire  [4:0] cut
    );
assign dout_relu = ((en==1)&&din_relu[31] == 0)? {din_relu[31],din_relu[22:16]} : 0;
assign cut=5'd16;
endmodule