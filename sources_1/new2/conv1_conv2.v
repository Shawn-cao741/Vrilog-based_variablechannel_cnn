`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 19:56:03
// Design Name: 
// Module Name: conv1_conv2
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


module conv1_conv2(

    input clk,
    input rst_n,
    input ena,enb,
    input wea,web,
    input [11:0]  addra,
    input [11:0]  addrb,
    input [7:0] data_0,
    input [7:0] data_1,
    input [7:0] data_2,
    input [7:0] data_3,
    output [7:0] datain0,
    output [7:0] datain1,
    output [7:0] datain2,
    output [7:0] datain3

    );


    conv1out_0 u_conv1out_0(
        .clka(clk),
        .clkb(clk),
        .wea(wea),
        .ena(ena),
        .web(web),
        .enb(enb),
        .addra(addra),
        .addrb(addrb),
        .dina(data_0),
        .doutb(datain0)
    );
    conv1out_1 u_conv1out_1(
        .clka(clk),
        .clkb(clk),
        .wea(wea),
        .ena(ena),
        .web(web),
        .enb(enb),
        .addra(addra),
        .addrb(addrb),
        .dina(data_1),
        .doutb(datain1)
    );
    conv1out_2 u_conv1out_2(
        .clka(clk),
        .clkb(clk),
        .wea(wea),
        .ena(ena),
        .web(web),
        .enb(enb),
        .addra(addra),
        .addrb(addrb),
        .dina(data_2),
        .doutb(datain2)
    );
    conv1out_3 u_conv1out_3(
        .clka(clk),
        .clkb(clk),
        .wea(wea),
        .ena(ena),
        .web(web),
        .enb(enb),
        .addra(addra),
        .addrb(addrb),
        .dina(data_3),
        .doutb(datain3)
    );


   
endmodule
