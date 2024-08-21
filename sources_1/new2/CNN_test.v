`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/21 10:56:06
// Design Name: 
// Module Name: CNN_test
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


module CNN_test#(
    parameter data_length = 10'd512,
    parameter data_width = 4'd8,
    parameter weight_width  = 4'd8,
    parameter bias_width = 4'd8,
    parameter feature_width = 5'd16
)(
    input clk,
    input rst_n,
    input valid,
    input w_en,
    input[5:0] num,
    input[10:0] bramaddre,
   //output [7:0] data_in_fc1,
  
    output conv2_end,
    output [7:0] data_out
    );

    wire [weight_width*4-1:0] c1_w;
    wire [bias_width-1:0] c1_b;
    wire [bias_width-1:0] c2_b;
    wire c1_w_en,c1_b_en,c2_w_en,c2_b_en;
    wire valid_conv1;
    wire [data_width-1:0] conv1_in_data;
    wire [8*4-1:0] conv1_out_data;
    wire [12:0]conv_time;

    wire conv_end;
    wire conv1_end;

    wire conv1_out_start,conv1_out_end,conv1_out_valid;

    wire [weight_width*16-1:0] c2_w0;
    wire [weight_width*16-1:0] c2_w1;
    wire [weight_width*16-1:0] c2_w2;
    wire [weight_width*16-1:0] c2_w3;

    //第一层输出到的双口ram
    wire ena,enb,wea,web;
    wire [11:0] addra;
    wire [11:0] addrb;
    wire [7:0] data_0;
    wire [7:0] data_1;
    wire [7:0] data_2;
    wire [7:0] data_3;

    wire [data_width-1:0] datain0;
    wire [data_width-1:0] datain1;
    wire [data_width-1:0] datain2;
    wire [data_width-1:0] datain3;
    assign web = 0;
    //第二层输出到双口ram
    wire ena2,enb2,wea2,web2;
    wire [10:0] addra2;
    wire [10:0] addrb2;
    wire [7:0] data2_0;
    wire [7:0] data2_1;
    wire [7:0] data2_2;
    wire [7:0] data2_3;
    wire [7:0] data2_4;
    wire [7:0] data2_5;
    wire [7:0] data2_6;
    wire [7:0] data2_7;
    wire [7:0] data2_8;
    wire [7:0] data2_9;
    wire [7:0] data2_10;
    wire [7:0] data2_11;
    wire [7:0] data2_12;
    wire [7:0] data2_13;
    wire [7:0] data2_14;
    wire [7:0] data2_15;

    wire [data_width-1:0] datain20;
    wire [data_width-1:0] datain21;
    wire [data_width-1:0] datain22;
    wire [data_width-1:0] datain23;
    wire [data_width-1:0] datain24;
    wire [data_width-1:0] datain25;
    wire [data_width-1:0] datain26;
    wire [data_width-1:0] datain27;
    wire [data_width-1:0] datain28;
    wire [data_width-1:0] datain29;
    wire [data_width-1:0] datain210;
    wire [data_width-1:0] datain211;
    wire [data_width-1:0] datain212;
    wire [data_width-1:0] datain213;
    wire [data_width-1:0] datain214;
    wire [data_width-1:0] datain215;
    assign web2 = 0;


    wire [8*16-1:0] conv2_out_data;
    wire conv_end2;



    Data_input u_Data_input(
        .clk(clk),
        .rst_n(rst_n),
        .c1_w_en(c1_w_en),
        .valid(valid),
        .conv_end(conv_end),
        .out_valid(conv1_out_valid),
        .conv_time(conv_time),
        .valid_conv1(valid_conv1), 
        .data_in_conv1(conv1_in_data)
    );

    Conv1 u_Conv1(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(conv1_in_data),
        .valid(valid_conv1),
        .c1_b_en(c1_b_en),
        .c1_b(c1_b),
        .c1_w_en(c1_w_en),
        .c1_w(c1_w),
        .conv_time(conv_time),
        .conv_end(conv_end),
        .conv1_end(conv1_end),
        .dataout(conv1_out_data),
        .out_start(conv1_out_start),
        .out_end(conv1_out_end),
        .out_valid(conv1_out_valid)
    );

    Conv1_weight u_Conv1_weight(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .c1_w_en(c1_w_en),
        .c1_w(c1_w)

    );

    Conv1_bias u_Conv1_bias(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .c1_b_en(c1_b_en),
        .c1_b(c1_b)
    );

    Conv1_outdata u_Conv1_outdata(
        .clk(clk),
        .rst_n(rst_n),
        .conv_end(conv_end),//每一次卷积结束后就把数据存储到bram�?
        .conv1_output(conv1_out_data),

        .wea(wea),
        .ena(ena),
        .addra(addra),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3)
    );

    ///////////第二�?

    conv1_conv2 u_conv1_conv2(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .enb(enb),
        .wea(wea),
        .web(web),
        .addra(addra),
        .addrb(addrb),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),

        .datain0(datain0),
        .datain1(datain1),
        .datain2(datain2),
        .datain3(datain3)
        

    );


    Conv2_bias u_Conv2_bias(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .c2_b_en(c2_b_en),
        .c2_b(c2_b)
    );

    Conv2_weight u_Conv2_weight(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .conv1_end(conv1_end),
        .c2_w_en(c2_w_en),
        .c2_w0(c2_w0),
        .c2_w1(c2_w1),
        .c2_w2(c2_w2),
        .c2_w3(c2_w3)
    );


    Conv2 u_Conv2(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .conv1_end(conv1_end),
        .c2_b_en(c2_b_en),
        .c2_w_en(c2_w_en),
        .c2_w0(c2_w0),
        .c2_w1(c2_w1),
        .c2_w2(c2_w2),
        .c2_w3(c2_w3),
        .c2_b(c2_b),
        .datain0(datain0),
        .datain1(datain1),
        .datain2(datain2),
        .datain3(datain3),
        
        .enb(enb),
        .addrb(addrb),
        .conv_end2(conv_end2),
        .conv2_end(conv2_end),
        .conv2_output(conv2_out_data)


    );

    Conv2_outdata u_Conv2_outdata(
        .conv_end2(conv_end2),
        .clk(clk),
        .rst_n(rst_n),
        .conv2_output(conv2_out_data),

        .wea2(wea2),
        .ena2(ena2),
        .addra2(addra2),
     
        
        
        .data2_0(data2_0),
        .data2_1(data2_1),
        .data2_2(data2_2),
        .data2_3(data2_3),
        .data2_4(data2_4),
        .data2_5(data2_5),
        .data2_6(data2_6),
        .data2_7(data2_7),
        .data2_8(data2_8),
        .data2_9(data2_9),
        .data2_10(data2_10),
        .data2_11(data2_11),
        .data2_12(data2_12),
        .data2_13(data2_13),
        .data2_14(data2_14),
        .data2_15(data2_15)
    );

    conv2_fc1 u_conv2_fc1(
        .clk(clk),
        .rst_n(rst_n),
        .ena2(ena2),
        .enb2(w_en),
        .wea2(wea2),
        .web2(web2),
        .addra2(addra2),
         .addrb2(bramaddre),

        .data2_0(data2_0),
        .data2_1(data2_1),
        .data2_2(data2_2),
        .data2_3(data2_3),
        .data2_4(data2_4),
        .data2_5(data2_5),
        .data2_6(data2_6),
        .data2_7(data2_7),
        .data2_8(data2_8),
        .data2_9(data2_9),
        .data2_10(data2_10),
        .data2_11(data2_11),
        .data2_12(data2_12),
        .data2_13(data2_13),
        .data2_14(data2_14),
        .data2_15(data2_15),
       

        .datain20(datain20),
        .datain21(datain21),
        .datain22(datain22),
        .datain23(datain23),
        .datain24(datain24),
        .datain25(datain25),
        .datain26(datain26),
        .datain27(datain27),
        .datain28(datain28),
        .datain29(datain29),
        .datain210(datain210),
        .datain211(datain211),
        .datain212(datain212),
        .datain213(datain213),
        .datain214(datain214),
        .datain215(datain215)

    );
    
    wire [7:0] data_out_arry[0:15];
    
    assign data_out_arry[0]=datain20;
    assign data_out_arry[1]=datain21;
    assign data_out_arry[2]=datain22;
    assign data_out_arry[3]=datain23;
    assign data_out_arry[4]=datain24;
    assign data_out_arry[5]=datain25;
    assign data_out_arry[6]=datain26;
    assign data_out_arry[7]=datain27;
    assign data_out_arry[8]=datain28;
    assign data_out_arry[9]=datain29;
    assign data_out_arry[10]=datain210;
    assign data_out_arry[11]=datain211;
    assign data_out_arry[12]=datain212;
    assign data_out_arry[13]=datain213;
    assign data_out_arry[14]=datain214;
    assign data_out_arry[15]=datain215;
    
    assign data_out = data_out_arry[num];
    
     




endmodule
