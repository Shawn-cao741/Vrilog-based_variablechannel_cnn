`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 19:07:05
// Design Name: 
// Module Name: Conv1
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


module Conv1#(
    parameter kernel_size = 6'd32,
    parameter parameter_w = kernel_size*4,
    parameter weight_width = 4'd8,
    parameter data_width = 4'd8,
    parameter bias_width = 4'd8,
    parameter feature_width = 5'd16
)(
    input clk,
    input rst_n,
    input [data_width-1:0] data_in,
    input valid,
    input c1_w_en,
    input [weight_width*4-1:0] c1_w,
    input c1_b_en,
    input [bias_width-1:0] c1_b,

    output [8*4-1:0] dataout,
    output [12:0] conv_time,
    output          conv_end,//代表每次卷积结束
    output          conv1_end,//代表第一层卷积结束，42个数据全部卷完
    output out_start,
    output out_end,
    output out_valid

    );

    //reg [data_width-1:0] buffer[0:kernel_size-1];
    reg valid_conv1_r;
    //reg [9:0] cnt_data;
    //reg [9:0] cnt_data_r;
    reg [5:0] cnt_mul_data;
    wire cnt32_flag;
    reg [12:0] conv_time_r;//61x42次
    //reg [3:0] stride_cnt;
    reg [2:0] bias_count;

    wire [data_width-1:0] data_r_n;

    wire [bias_width-1:0] data_bias[0:3];
    wire [weight_width-1:0] Multiply_weight[0:3];

    wire        Multiply_adder_en;
    wire [7:0] out_conv1 [0:3];

    wire out_start_r[0:3];
    wire out_end_r[0:3];
    wire out_valid_r [0:3];
    wire valid_conv1;

    //reg  continue_conv_en;//用于接下来的卷积
    //reg [2:0] delay_count;//用于产生延迟

    wire    conv_end_n [0:3];
    

    ////////////////////////////////////////////////////Debug signal
    wire [weight_width*3-1:0]weight_mul_debug;
    wire [data_width*3-1:0]data_in_r_debug;
    wire [5:0] weight_count_debug;
    wire [5:0] data_count_debug;
    wire weight_count_flag_debug;
    wire en_flag_debug;
    wire data_count_flag_debug;

    assign valid_conv1 = (conv_time==0)?(((cnt_mul_data<kernel_size)&&(cnt32_flag==0)&&(c1_w_en))?valid:1'b0):valid;
    assign conv_time = conv_time_r;
    
    //判断最大位对不对
    reg [7:0]max0;
    reg [7:0]max1;
    reg [7:0]max2;
    reg [7:0]max3;

    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			valid_conv1_r  <= 1'b0;
		end
		else begin
			valid_conv1_r  <= valid_conv1;
		end
	end

    //valid_cpnv1_r比valid_conv1慢一拍

    assign cnt32_flag = (cnt_mul_data==kernel_size)?1'b1:1'b0;
    //当计算了32个数后，给cnt32_flag置1
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            cnt_mul_data <= 6'd0;
            
        end
        else if(cnt_mul_data==kernel_size)begin 
            cnt_mul_data <= 6'd0;
          
        end
        else if((Multiply_adder_en)&&(cnt_mul_data<kernel_size))begin 
            cnt_mul_data <= cnt_mul_data + 1'b1;
        end
        else begin 
            cnt_mul_data <= 6'd0;
        end
    end

    //计算这是第几次卷积，计数32次后，计数加一，算完512个数，需要做61次，即输出为61，要算42个数据，所以为42x61=2562
    always@(negedge clk or negedge rst_n )begin 
        if(!rst_n)begin 
            conv_time_r <= 6'd0;
        end
        else if(conv_end&&(conv_time<13'd2562))begin 
            conv_time_r <= conv_time_r + 1'b1;
        end
        else begin 
            conv_time_r <= conv_time_r;
        end
    end

    assign data_r_n = data_in;

    //读偏置
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            bias_count<=3'd0; 
        end
        else if((c1_b_en)&&(bias_count<3'd5))begin 
            bias_count<=bias_count +1'd1;
        end
        else begin 
            bias_count <= bias_count;
        end
    end

    genvar n;
    generate 
		for(n=0;n<4;n=n+1)
		begin:datab
			assign data_bias[n] = ((c1_b_en)&&(n==bias_count-1))?c1_b:data_bias[n];
		end
	endgenerate

    //读取权值

    assign Multiply_weight[0] = c1_w[weight_width*1-1:weight_width*0];
    assign Multiply_weight[1] = c1_w[weight_width*2-1:weight_width*1];
    assign Multiply_weight[2] = c1_w[weight_width*3-1:weight_width*2];
    assign Multiply_weight[3] = c1_w[weight_width*4-1:weight_width*3];

    //cnt_data大于1时就可以开始做乘法了
    //assign Multiply_adder_en = (cnt_data>10'd1)? valid_conv1_r:1'b0;
    assign Multiply_adder_en = valid_conv1_r;

    // Multiply_adder u_Multiply_adder(
	// 			.clk			(clk),
	// 			.rst_n		(rst_n),
	// 			.weight_en	(c1_w_en),
	// 			.Multiply_en	(Multiply_adder_en),
	// 			.weight 		(Multiply_weight[3]),
	// 			.bias 		(data_bias[3]),
	// 			.data_in		(data_r_n),
	// 			.data_out		(out_conv1[3]),
	// 			.out_start	(out_start_r[3]),
	// 			.out_end		(out_end_r[3]),
	// 			.out_valid	(out_valid_r[3]),

    //             .conv_end(conv_end_n[3]),

    //             .data_count_debug(data_count_debug),
    //             .weight_count_debug(weight_count_debug),
    //             .weight_count_flag_debug(weight_count_flag_debug),
    //             .weight_mul_debug(weight_mul_debug),
    //             .data_in_r_debug(data_in_r_debug),
    //             .en_flag_debug(en_flag_debug),
    //             .data_count_flag_debug(data_count_flag_debug)
	// 		);

    genvar ma_n;
	generate 
		for(ma_n=0; ma_n< 4; ma_n=ma_n+1)
		begin:Multiply_adder
			Multiply_adder n(
				.clk			(clk),
				.rst_n		(rst_n),
				.weight_en	(c1_w_en),
				.Multiply_en	(Multiply_adder_en),
				.weight 		(Multiply_weight[ma_n]),
				.bias 		(data_bias[ma_n]),
				.data_in		(data_r_n),
				.data_out		(out_conv1[ma_n]),
				.out_start	(out_start_r[ma_n]),
				.out_end		(out_end_r[ma_n]),
				.out_valid	(out_valid_r[ma_n]),
                .conv_end    (conv_end_n[ma_n])

                // .weight_count_debug(weight_count_debug),
                // .weight_count_flag_debug(weight_count_flag_debug),
                // .weight_mul_debug(weight_mul_debug),
                // .data_in_r_debug(data_in_r_debug),
                // .en_flag_debug(en_flag_debug)
			);
		end
	endgenerate

    //当计数到2561时，将conv1_end置1
    
    reg [12:0] conv1_end_r;

    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            conv1_end_r<= 1'b0;
        end
        else begin 
            conv1_end_r <= conv1_end_r;
        end
    end

    always@(posedge conv_end)begin 
        if(!rst_n)begin 
            conv1_end_r <= 1'b0;
        end
        else if (conv_time==13'd2562)begin 
            conv1_end_r <= 1'b1;
        end
        else begin 
            conv1_end_r <= conv1_end_r;
        end
    end
    
    assign conv_end = (conv_time<13'd2563)?conv_end_n[3]:1'b0;
    
    //assign conv1_end = (conv_time==13'd2562)?1'b1:1'b0;
    assign conv1_end = conv1_end_r;


    //  assign out_conv1[2] = 0;
    //  assign out_conv1[1] = 0;
    //  assign out_conv1[0] = 0;

    assign dataout = (!conv1_end)?{out_conv1[3],out_conv1[2],out_conv1[1],out_conv1[0]}:0;
	//assign out_start = out_start_r[0];
	//assign out_end = out_end_r[0];
	assign out_valid = out_valid_r[3];


    //找最大值
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            max0<=8'd0;
        end
        else if(out_conv1[0]>max0)begin 
            max0 <= out_conv1[0];
        end
        else begin 
            max0 <= max0;
        end
    end
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            max1<=8'd0;
        end
        else if(out_conv1[1]>max1)begin 
            max1 <= out_conv1[1];
        end
        else begin 
            max1 <= max1;
        end
    end
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            max2<=8'd0;
        end
        else if(out_conv1[2]>max2)begin 
            max2 <= out_conv1[2];
        end
        else begin 
            max2 <= max2;
        end
    end
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            max3<=8'd0;
        end
        else if(out_conv1[3]>max3)begin 
            max3 <= out_conv1[3];
        end
        else begin 
            max3 <= max3;
        end
    end

    //第一次卷积结束后继续下面的卷积
    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         continue_conv_cnt <=2'd0;
    //     end
    //     else if ((out_valid)&&(continue_conv_cnt<2'd4))begin 
    //         continue_conv_cnt <= continue_conv_cnt + 2'd1;
    //     end
    //     else begin 
    //         continue_conv_cnt<=2'd0;
    //     end
    // end
    
endmodule
