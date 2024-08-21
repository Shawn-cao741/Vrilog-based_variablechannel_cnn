`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/22 22:17:44
// Design Name: 
// Module Name: clk8
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


module clk8( 
input wire clk,
output wire clk8
    );

    reg [1:0] count;
    reg clk81;
    always @(posedge clk) begin
    if (count ==3 ) begin
        count <= 0;
        clk81 <= ~clk81;
    end
    else begin
        count <= count + 1;
    end
end
assign clk8=clk81;
endmodule
