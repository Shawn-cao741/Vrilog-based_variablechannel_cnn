`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 12:03:13
// Design Name: 
// Module Name: Conv2_outdata
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


module Conv2_outdata(
    input conv_end2,
    input clk,rst_n,
    input [127:0] conv2_output,

    output wea2,ena2,
    output [10:0] addra2,
    output [7:0] data2_0,
    output [7:0] data2_1,
    output [7:0] data2_2,
    output [7:0] data2_3,
    output [7:0] data2_4,
    output [7:0] data2_5,
    output [7:0] data2_6,
    output [7:0] data2_7,
    output [7:0] data2_8,
    output [7:0] data2_9,
    output [7:0] data2_10,
    output [7:0] data2_11,
    output [7:0] data2_12,
    output [7:0] data2_13,
    output [7:0] data2_14,
    output [7:0] data2_15

    );

    reg [10:0] cnt_addra = 11'd0;
    reg w_en;
    reg e_en;

    reg w_en_r;
    reg e_en_r;

    assign data2_0 = conv2_output[8*1-1:8*0];
    assign data2_1 = conv2_output[8*2-1:8*1];
    assign data2_2 = conv2_output[8*3-1:8*2];
    assign data2_3 = conv2_output[8*4-1:8*3];
    assign data2_4 = conv2_output[8*5-1:8*4];
    assign data2_5 = conv2_output[8*6-1:8*5];
    assign data2_6 = conv2_output[8*7-1:8*6];
    assign data2_7 = conv2_output[8*8-1:8*7];
    assign data2_8 = conv2_output[8*9-1:8*8];
    assign data2_9 = conv2_output[8*10-1:8*9];
    assign data2_10 = conv2_output[8*11-1:8*10];
    assign data2_11 = conv2_output[8*12-1:8*11];
    assign data2_12 = conv2_output[8*13-1:8*12];
    assign data2_13 = conv2_output[8*14-1:8*13];
    assign data2_14 = conv2_output[8*15-1:8*14];
    assign data2_15 = conv2_output[8*16-1:8*15];


    assign wea2 = w_en;
    assign ena2 = e_en;

     //地址
    always@(posedge conv_end2)begin 
        if(!rst_n)begin 
            cnt_addra <= 11'd0;
        end
        else if (cnt_addra<11'd1260)begin 
            cnt_addra <= cnt_addra + 1'd1;
        end
        else begin 
            cnt_addra <= cnt_addra;
        end
    end

    always@(posedge conv_end2)begin 
        if(!rst_n)begin 
            w_en <= 1'b0;
            e_en<= 1'b0;
        end
        else if(cnt_addra<11'd1259)begin 
            w_en <= 1'b1;
            e_en <= 1'b1;
        end
        else begin 
            w_en <= 1'b0;
            e_en <= 1'b0;
        end
    end
    assign addra2 = cnt_addra - 11'd1;


endmodule
