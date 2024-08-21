`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 12:02:14
// Design Name: 
// Module Name: conv2_fc1
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


module conv2_fc1(

    input clk,
    input rst_n,
    input ena2,
   // input enb20,enb21,enb22,enb23,enb24,enb25,enb26,enb27,enb28,enb29,enb210,enb211,enb212,enb213,enb214,enb215,
    input enb2,
    input wea2,web2,
    input [10:0]  addra2,
    input [10:0]  addrb2,
    input [7:0] data2_0,
    input [7:0] data2_1,
    input [7:0] data2_2,
    input [7:0] data2_3,
    input [7:0] data2_4,
    input [7:0] data2_5,
    input [7:0] data2_6,
    input [7:0] data2_7,
    input [7:0] data2_8,
    input [7:0] data2_9,
    input [7:0] data2_10,
    input [7:0] data2_11,
    input [7:0] data2_12,
    input [7:0] data2_13,
    input [7:0] data2_14,
    input [7:0] data2_15,

    output [7:0] datain20,
    output [7:0] datain21,
    output [7:0] datain22,
    output [7:0] datain23,
    output [7:0] datain24,
    output [7:0] datain25,
    output [7:0] datain26,
    output [7:0] datain27,
    output [7:0] datain28,
    output [7:0] datain29,
    output [7:0] datain210,
    output [7:0] datain211,
    output [7:0] datain212,
    output [7:0] datain213,
    output [7:0] datain214,
    output [7:0] datain215,

    output [7:0] data_in_fc1

    );


    conv2out_0 u_conv2out_0(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_0),
        .doutb(datain20)
    );

    conv2out_1 u_conv2out_1(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_1),
        .doutb(datain21)
    );

    conv2out_2 u_conv2out_2(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_2),
        .doutb(datain22)
    );

    conv2out_3 u_conv2out_3(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_3),
        .doutb(datain23)
    );

    conv2out_4 u_conv2out_4(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_4),
        .doutb(datain24)
    );

    conv2out_5 u_conv2out_5(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_5),
        .doutb(datain25)
    );

    conv2out_6 u_conv2out_6(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_6),
        .doutb(datain26)
    );

    conv2out_7 u_conv2out_7(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_7),
        .doutb(datain27)
    );

    conv2out_8 u_conv2out_8(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_8),
        .doutb(datain28)
    );

    conv2out_9 u_conv2out_9(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_9),
        .doutb(datain29)
    );

    conv2out_10 u_conv2out_10(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_10),
        .doutb(datain210)
    );

    conv2out_11 u_conv2out_11(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_11),
        .doutb(datain211)
    );

    conv2out_12 u_conv2out_12(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_12),
        .doutb(datain212)
    );

    conv2out_13 u_conv2out_13(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_13),
        .doutb(datain213)
    );

    conv2out_14 u_conv2out_14(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_14),
        .doutb(datain214)
    );

    conv2out_15 u_conv2out_15(
        .clka(clk),
        .clkb(clk),
        .wea(wea2),
        .ena(ena2),
        .web(web2),
        .enb(enb2),
        .addra(addra2),
        .addrb(addrb2),
        .dina(data2_15),
        .doutb(datain215)
    );


endmodule
