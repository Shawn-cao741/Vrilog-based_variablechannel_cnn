`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 21:16:37
// Design Name: 
// Module Name: Conv2
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


module Conv2#(
    parameter data_width = 4'd8,
    parameter weight_width = 4'd8,
    parameter bias_width = 4'd8,
    parameter kernel_size = 3'd3,
    parameter feature_width = 5'd20,
    parameter data_length = 12'd2562//61x42
)(
    input clk,
    input rst_n,
    input valid,
    input conv1_end,
    input c2_b_en,c2_w_en,
    input [weight_width*16-1:0] c2_w0,
    input [weight_width*16-1:0] c2_w1,
    input [weight_width*16-1:0] c2_w2,
    input [weight_width*16-1:0] c2_w3,
    input [bias_width:0] c2_b,
    input [data_width-1:0] datain0,
    input [data_width-1:0] datain1,
    input [data_width-1:0] datain2,
    input [data_width-1:0] datain3,

    output [11:0]addrb,
    output enb,

    
    output [data_width*16-1:0] conv2_output,
    output conv2_end,
    output conv_end2


    );

    wire conv_end2;//每次卷积结束的信�?
    wire conv2_end;//第二层卷积结束的信号

    

    wire [30*16-1:0] dataout0;
    wire [30*16-1:0] dataout1;
    wire [30*16-1:0] dataout2;
    wire [30*16-1:0] dataout3;

    wire signed [7:0] bias [0:15];

    wire signed [29:0] channel0_out [0:15];
    wire signed [29:0] channel1_out [0:15];
    wire signed [29:0] channel2_out [0:15];
    wire signed [29:0] channel3_out [0:15];

    wire signed [29:0] Conv2_out_17[0:15];
    wire signed [7:0] Conv2_out_8[0:15];


    reg [4:0] bias_count;

    reg [11:0] cnt_addra;
    //wire [11:0] addrb;
    assign enb = valid_conv2;

    reg signed [29:0] max;

    


    reg data_ready = 1'b0;

    wire cnt3_flag;

    wire        valid_conv2_r;
    reg			valid_conv2_r1;
	//reg			valid_conv2_r2;
    wire        valid_conv2;

    reg [2:0] cnt_3;

    reg     [5:0]    skip_data_end = 6'd0;
    wire  [10:0] conv_time;//�?多有1260次卷�?

    // //每结束一次卷积，在conv_end2的下降沿，将data_ready�?1
    // always@(negedge conv_end2)begin 
    //     if(!rst_n)begin 
    //         data_ready <= 1'b0;
    //     end
    //     else begin 
    //         data_ready <= 1'b1;
    //     end
    // end

    // //在计数满3后，又将data_ready�?0
    // always@(posedge cnt3_flag)begin 
    //     if(!rst_n)begin 
    //         data_ready <=1'b0;
    //     end
    //     else begin 
    //         data_ready <= 1'b0;
    //     end
    // end

    always@(posedge cnt3_flag or negedge conv_end2)begin 
        if(!rst_n)begin 
            data_ready <= 1'b0;
        end
        else if(cnt3_flag) begin 
            data_ready <= 1'b0;
        end
        else begin 
            data_ready <= 1'b1;
        end
    end

    //看是不是第一次卷积，第一次卷积权重和数据�?起进，从第二次开始就每次只进数据，不进权重�??
    wire first_conv;
    assign first_conv = (valid&&(cnt_addra<data_length)&&c2_w_en&&(cnt_3<3'd3)&&conv1_end)?1'b1:1'b0;
    
    assign addrb=cnt_addra;
    assign valid_conv2_r=(conv_time<11'd1)?first_conv:data_ready;
    assign valid_conv2 = valid_conv2_r1;

    //延迟�?拍（延迟�?个时钟周期）
    always@(posedge clk or negedge rst_n)begin
    		if(!rst_n)begin
    		valid_conv2_r1 <= 1'd0;
		end
    		else begin
    		valid_conv2_r1 <= valid_conv2_r;
		end
    end

    //count 3
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            cnt_3 <= 0;
        else if(!valid)
            cnt_3 <= 0;
        else if((valid_conv2)&&(cnt_3<3'd3))
            cnt_3 <= cnt_3 + 1'd1;
        else
            cnt_3<=1'b0;
    end
    assign cnt3_flag = (cnt_3==3'd3)?1'b1:1'b0;

    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         skip_data_end <= 6'd0;
    //     end
    //     else begin 
    //         skip_data_end <= skip_data_end;
    //     end
    // end

    //当data_ready来的时�?�，先判断是不是都一个数据的末尾了，每个数据会做30次卷积，�?以看conv_time�?30取余
    always@(posedge data_ready)begin 
        if(!rst_n)begin 
            skip_data_end <= 0;
        end
        else if(((conv_time%30)==0)&&(conv_time>11'd0)) begin 
            skip_data_end <= skip_data_end +6'd1;
        end
        else begin 
            skip_data_end <= skip_data_end;
        end
    end

    // always@(posedge data_ready)begin 
    //     if(!rst_n)begin 
    //         cnt_addra<=12'd0;
    //     end
    //     else begin 
    //         cnt_addra <= conv_time*2+skip_data_end;//跳过每一个数据的�?后那几个�?
    //     end
    // end

    // //计算取出数据的地�?
    // always@(posedge clk or negedge rst_n)begin
    //     if(!rst_n)
    //         cnt_addra <= 12'd0;
    //     else if(cnt_addra== 12'd2562)
    //         cnt_addra <= cnt_addra;
    //     else if((valid_conv2)&&(cnt_3<3))
    //         cnt_addra <= cnt_addra + 1'b1;
    //     else
    //         cnt_addra<=cnt_addra;
    // end
    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_addra <= 12'd0;
    end else if (data_ready && !last_data_ready) begin
        // 根据 data_ready 信号的上升沿更新 cnt_addra
        cnt_addra <= conv_time*2+skip_data_end;
    end else if (valid_conv2 && (cnt_3 < 3)) begin
        // �? valid_conv1_r1 有效�? cnt_32 小于 32 时，增加 cnt_addra
        cnt_addra <= cnt_addra + 1'b1;
    end
    end

    // 用于记录上一�? data_ready 信号状�??
    reg last_data_ready;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_data_ready <= 1'b0;
        end else begin
            last_data_ready <= data_ready;
        end
    end

    //////////////////////////////////////////////////以上/////////数据就出来了/////////////////////////////////////////
    //////////�?要写�?个卷积模块，然后在这个卷积模块中例化16个新的，用于第二层卷积的Multiply_adder，然后再例化4个这样的卷积模块�?

    Conv2_0 u_Conv2_0(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(datain0),
        .valid(valid_conv2),
        .c2_w_en(c2_w_en),
        .c2_w(c2_w0),
        // input c2_b_en,
        // input [bias_width-1:0] c2_b,bias 在外面给

        .dataout(dataout0),
        .conv_time(conv_time),
        .conv_end2(conv_end2),//代表每次卷积结束
        .conv2_end(conv2_end)//代表第一层卷积结束，42个数据全部卷�?
    );

    Conv2_1 u_Conv2_1(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(datain1),
        .valid(valid_conv2),
        .c2_w_en(c2_w_en),
        .c2_w(c2_w1),
        // input c2_b_en,
        // input [bias_width-1:0] c2_b,bias 在外面给

        .dataout(dataout1)
        // .conv_time(conv_time),
        // .conv_end2(conv_end2),//代表每次卷积结束
        // .conv2_end//代表第一层卷积结束，42个数据全部卷�?
    );

    Conv2_2 u_Conv2_2(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(datain2),
        .valid(valid_conv2),
        .c2_w_en(c2_w_en),
        .c2_w(c2_w2),
        // input c2_b_en,
        // input [bias_width-1:0] c2_b,bias 在外面给

        .dataout(dataout2)
        // .conv_time(conv_time),
        // .conv_end2(conv_end2),//代表每次卷积结束
        // .conv2_end//代表第一层卷积结束，42个数据全部卷�?
    );

    Conv2_3 u_Conv2_3(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(datain3),
        .valid(valid_conv2),
        .c2_w_en(c2_w_en),
        .c2_w(c2_w3),
        // input c2_b_en,
        // input [bias_width-1:0] c2_b,bias 在外面给

        .dataout(dataout3)
        // .conv_time(conv_time),
        // .conv_end2(conv_end2),//代表每次卷积结束
        // .conv2_end//代表第一层卷积结束，42个数据全部卷�?
    );


    //存输出结�?
    genvar c0o;
    generate 
        for(c0o=0;c0o<16;c0o=c0o+1)
        begin: channel0_output_data 
            assign channel0_out[c0o] = dataout0[30*(c0o+1)-1:30*c0o];
        end
    endgenerate

     genvar c1o;
    generate 
        for(c1o=0;c1o<16;c1o=c1o+1)
        begin: channel1_output_data 
            assign channel1_out[c1o] = dataout1[30*(c1o+1)-1:30*c1o];
        end
    endgenerate

     genvar c2o;
    generate 
        for(c2o=0;c2o<16;c2o=c2o+1)
        begin: channel2_output_data 
            assign channel2_out[c2o] = dataout2[30*(c2o+1)-1:30*c2o];
        end
    endgenerate

     genvar c3o;
    generate 
        for(c3o=0;c3o<16;c3o=c3o+1)
        begin: channel3_output_data 
            assign channel3_out[c3o] = dataout3[30*(c3o+1)-1:30*c3o];
        end
    endgenerate

    /////////////////////////读偏�?
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            bias_count<=5'd0; 
        end
        else if((c2_b_en)&&(bias_count<5'd17))begin 
            bias_count<=bias_count +1'd1;
        end
        else begin 
            bias_count <= bias_count;
        end
    end

    genvar n;
    generate 
		for(n=0;n<16;n=n+1)
		begin:datab
			assign bias[n] = ((c2_b_en)&&(n==bias_count-1))?c2_b:bias[n];
		end
	endgenerate
    
    ///////////数据和偏置相�?
    genvar cv2o17;
    generate 
        for(cv2o17=0;cv2o17<16;cv2o17=cv2o17+1)
        begin: add_output_data_17bit
            assign Conv2_out_17[cv2o17] = channel0_out[cv2o17] + channel1_out[cv2o17] + channel2_out[cv2o17] + channel3_out[cv2o17] + bias[cv2o17];
        end
    endgenerate

    genvar cv2o8;
    generate 
        for(cv2o8=0;cv2o8<16;cv2o8=cv2o8+1)
        begin: add_output_data_8bit
            // assign Conv2_out_8[cv2o8] = (Conv2_out_17[cv2o8][17]==1'b0)?{1'b0,Conv2_out_17[cv2o8][12],Conv2_out_17[cv2o8][11],
            // Conv2_out_17[cv2o8][10],Conv2_out_17[cv2o8][9],Conv2_out_17[cv2o8][8],Conv2_out_17[cv2o8][7],Conv2_out_17[cv2o8][6]}:8'd0;
            assign Conv2_out_8[cv2o8] = (Conv2_out_17[cv2o8][29]==1'b0)?{1'b0,Conv2_out_17[cv2o8][24:18]}:8'd0;
        end
    endgenerate

   assign conv2_output = {Conv2_out_8[15],Conv2_out_8[14],Conv2_out_8[13],Conv2_out_8[12],Conv2_out_8[11],Conv2_out_8[10],Conv2_out_8[9],Conv2_out_8[8],
    Conv2_out_8[7],Conv2_out_8[6],Conv2_out_8[5],Conv2_out_8[4],Conv2_out_8[3],Conv2_out_8[2],Conv2_out_8[1],Conv2_out_8[0]} ;

    //求最大�?�，用于截位
    genvar maxc;
    generate 
        for(maxc=0;maxc<16;maxc = maxc +1)
        begin: Find_max
            always@(posedge clk or negedge rst_n)begin
                if(!rst_n)begin 
                    max <= 30'd0;
                end
                else if(Conv2_out_17[maxc]>max)begin 
                        max <= Conv2_out_17[maxc];
                end
                else begin 
                    max <= max;
                end
             end
        end
    endgenerate


endmodule
