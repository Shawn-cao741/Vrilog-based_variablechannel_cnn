`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 10:47:45
// Design Name: 
// Module Name: Multiply_conv2
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


module Multiply_conv2#(
    parameter kernel_size = 3'd3,
    parameter data_width = 4'd8,
    parameter weight_width = 4'd8,
    parameter bias_width = 4'd8, 
    parameter feature_width = 5'd17)
    (
        input 					clk,
        input 					rst_n,
        input					weight_en,
        input					Multiply_en,
        input [weight_width-1: 0]	weight,
        input [14: 0]		data_in,
        output [29: 0]	data_out,
        output                  conv_end2


    );

    wire signed [weight_width-1:0]  weight_mult[0:kernel_size-1];//用来存储一个卷积核的32个权重
    reg			[2:0]				weight_count;//有32个权重值，数33次时给flag赋值
	reg								weight_count_flag;
    reg  data_count_flag;               
    reg [2:0] data_count;

    wire signed  	[14: 0]		data_in_r [ 0:kernel_size-1];//输入数据

    wire								en_flag;

    wire  signed 	[29: 0]				data_out_1[ 0: 1];
    wire  signed     [29:0]                   data_out_2;
    wire  signed	[29:0]				data_out_r;

    wire signed  	[29: 0]				multiply[0: kernel_size];//相乘一次，变为16位数，加上符号位，3个17位数
    
    reg cnt_mul;//乘法计数

    //权重存储使能
    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			weight_count_flag <= 1'b0;
		else if(weight_en)
			weight_count_flag <= 1'b1;
        else if(weight_count==3'd4)
            weight_count_flag<=1'b0;
		else 
			weight_count_flag <= weight_count_flag;
	end
    //权重存储计数
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            weight_count<=3'b0;
        else if(weight_count==3'd4)
            weight_count<=weight_count;
        else if(weight_count_flag==1'b1)
            weight_count<=weight_count+1'b1;
        else
            weight_count<=weight_count;
    end

    //数据存储使能
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            data_count_flag<=1'b0;
        end
        else if((weight_en||Multiply_en)&&data_count<3'd3)begin 
            data_count_flag<=1'b1;
        end
        else begin 
            data_count_flag<=1'b0;
        end
    end
    //数据存储计数
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            data_count<=3'd0;
        end
        else if((data_count_flag)&&(data_count<3'd3))begin 
            data_count<=data_count +1'b1;
        end 
        else begin 
            data_count<= 1'b0;
        end
    end

    //////////////////////用32个时钟把权重和数据进行存储
    //存储权重
    genvar i;
    generate
        for(i=0;i<kernel_size;i=i+1)
        begin:weight_n
            assign weight_mult[i] = ((i==weight_count-1)&&(weight_count_flag==1'b1))?weight:weight_mult[i];
        end
    endgenerate

    //读数据
    genvar j;
    generate
            for(j=0;j<kernel_size;j=j+1)begin:data_in_n
                assign data_in_r[j] = ((j==data_count-1)&&(data_count_flag==1'b1))?data_in:data_in_r[j];
            end
    endgenerate

    assign en_flag = (data_count==3'd3)?1'b1:1'b0;

    genvar k;
    generate
        for(k=0;k<kernel_size;k=k+1)begin: Multiply_n
           assign multiply[k] = (en_flag)?(data_in_r[k]*weight_mult[k]):0;
        end
    endgenerate

    assign conv_end2 = (data_count==3'd3)?1'b1:1'b0;


    assign multiply[3] = 17'd0;
    genvar do;
	generate 
		for(do=0;do<2;do=do+1)
		begin:data_out_1_n
				assign	data_out_1[do] = multiply[do] + multiply[do+2'd2];
		end
	endgenerate

	assign data_out_2 = data_out_1[1] + data_out_1[0];
    assign data_out_r=(en_flag)?data_out_2:data_out_r;

    assign data_out = data_out_r;


endmodule
