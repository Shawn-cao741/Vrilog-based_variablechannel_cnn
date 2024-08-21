`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 21:02:55
// Design Name: 
// Module Name: Multiply_adder
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


module Multiply_adder#(
    parameter kernel_size = 6'd32,
    parameter data_length = 10'd512,
    parameter data_width = 4'd8,
    parameter weight_width = 4'd8,
    parameter bias_width = 4'd8, 
    parameter strides = 4'd8,
    parameter feature_width = 5'd17
)(
    input 					clk,
	input 					rst_n,
	input					weight_en,
	input					Multiply_en,
	input [weight_width-1: 0]	weight,
	input [bias_width-1: 0]		bias,
	input [data_width-1: 0]		data_in,
	output [7: 0]	data_out,

    output [weight_width*3-1:0] weight_mul_debug,
    output [data_width*3-1:0] data_in_r_debug,
    output                      en_flag_debug,
    output weight_count_flag_debug,
    output [5:0] weight_count_debug,
    output [5:0] data_count_debug,
    output       data_count_flag_debug,

    output                  conv_end,
	output					out_start,
	output					out_end,
	output					out_valid

    );
    //存储权重

    wire signed [weight_width-1:0]  weight_mult[0:kernel_size-1];//用来存储�?个卷积核�?32个权�?
    reg			[5:0]				weight_count;//�?32个权重�?�，�?33次时给flag赋�??
	reg								weight_count_flag;
    reg  data_count_flag;               
    reg [5:0] data_count;
    wire signed [bias_width-1:0] bais_add;//用来存储�?个卷积核的偏�?

    wire [3:0] kernel_count;//用来计数4个卷积核

    wire signed  	[data_width-1: 0]		data_in_r [ 0:kernel_size-1];//输入数据

    wire								en_flag;




    wire  signed 	[16: 0]				data_out_1[ 0:15];
	wire  signed 	[16: 0]				data_out_2[ 0:7];
	wire  signed 	[16: 0]				data_out_3[ 0: 3];
	wire  signed 	[16: 0]				data_out_4[ 0: 1];
	wire  signed  	[16: 0]				data_out_5;
    wire  signed	[16:0]				data_out_r;//输出,先设置为16位，�?后需要从16位中截出8�?

    wire signed  	[16: 0]				multiply[0: kernel_size-1];//相乘�?次，变为16位数�?32�?16位数
    reg signed      [16:0] max;
    
    reg cnt_mul;//乘法计数

    ///Debug
    assign weight_mul_debug = {weight_mult[0],weight_mult[1],weight_mult[31]};
    assign data_in_r_debug =  {data_in_r[0],data_in_r[1],data_in_r[31]};
    assign weight_count_debug = weight_count;
    assign weight_count_flag_debug = weight_count_flag;
    assign en_flag_debug = en_flag;
    assign data_count_debug = data_count;
    assign data_count_flag_debug = data_count_flag;

    //权重存储使能
    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			weight_count_flag <= 1'b0;
		else if(weight_en)
			weight_count_flag <= 1'b1;
        else if(weight_count==6'd33)
            weight_count_flag<=1'b0;
		else 
			weight_count_flag <= weight_count_flag;
	end
    //权重存储计数
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            weight_count<=6'b0;
        else if(weight_count==6'd33)
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
        else if((weight_en||Multiply_en)&&data_count<6'd32)begin 
            data_count_flag<=1'b1;
        end
        else begin 
            data_count_flag<=1'b0;
        end
    end
    //数据存储计数
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            data_count<=7'd0;
        end
        else if((data_count_flag)&&(data_count<6'd32))begin 
            data_count<=data_count +1'b1;
        end 
        else begin 
            data_count<= 1'b0;
        end
    end


///////////////////////�?32个时钟把权重和数据进行存�?
    //存储权重
    genvar i;
    generate
        for(i=0;i<kernel_size;i=i+1)
        begin:weight_n
            assign weight_mult[i] = ((i==weight_count-1)&&(weight_count_flag==1'b1))?weight:weight_mult[i];
        end
    endgenerate

    //读数�?
    genvar j;
    generate
            for(j=0;j<kernel_size;j=j+1)begin:data_in_n
                assign data_in_r[j] = ((j==data_count-1)&&(data_count_flag==1'b1))?data_in:data_in_r[j];
            end
    endgenerate
    //存偏�?
    assign bais_add = bias;


    //乘法使能
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //数据和权重都进了32个后变为1
    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         en_flag<=1'b0;
    //     end
    //     else if(data_count==6'd32) begin 
    //         en_flag<=Multiply_en;
    //     end
    //     else begin 
    //         en_flag<=1'b0;
    //     end
    // end

    assign en_flag = (data_count==6'd32)?1'b1:1'b0;

    // //乘法计数,32次乘�?
    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         cnt_mul<= 1'b0;
    //     end
    //     else if(cnt_mul==6'd33)begin 
    //         cnt_mul <= cnt_mul;
    //     end
    //     else if(en_flag) begin 
    //         cnt_mul<=cnt_mul + 6'd1;
    //     end
    //     else begin 
    //         cnt_mul <=  6'd0;
    //     end
    // end

    

    genvar k;
    generate
        for(k=0;k<kernel_size;k=k+1)begin: Multiply_n
           assign multiply[k] = (en_flag)?(data_in_r[k]*weight_mult[k]):0;
        end
    endgenerate


    //assign out_start = (en_flag)?1'b1:1'b0;
    //assign out_end = (en_flag)?1'b1:1'b0;
    assign conv_end = (data_count==6'd32)?1'b1:1'b0;
    
    
    //add
    //分开加，不能�?次直接把32个加�?起，两两相加32->16->8->4->2->1
    genvar do1;
	generate 
		for(do1=0;do1<16;do1=do1+1)
		begin:data_out_1_n
			assign data_out_1[do1] = multiply[do1] + multiply[do1+4'd16];
		end
	endgenerate
	
	genvar do2;
	generate 
		for(do2=0;do2<8;do2=do2+1)
		begin:data_out_2_n
			assign	data_out_2[do2] = data_out_1[do2] + data_out_1[do2+4'd8];
		end
	endgenerate
	

	genvar do3;
	generate 
		for(do3=0;do3<4;do3=do3+1)
		begin:data_out_3_n
			assign data_out_3[do3] = data_out_2[do3] + data_out_2[do3+3'd4];
		end
	endgenerate
	
	  
	genvar do4;
	generate 
		for(do4=0;do4<2;do4=do4+1)
		begin:data_out_4_n
				assign	data_out_4[do4] = data_out_3[do4] + data_out_3[do4+2'd2];
		end
	endgenerate

	assign data_out_5 = data_out_4[1] + data_out_4[0] + bais_add;

    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)
	// 		data_out_r <= 20'd0;
	// 	else if(cnt_mul == 5'd32)
	// 		data_out_r <= data_out_5;
    // end

    assign data_out_r=(en_flag)?data_out_5:data_out_r;

    //�?活函数，判读�?高位�?1还是�?0，最高位�?0就保留数据，�?高位�?1就记�?0
	assign data_out   = (data_out_r[16]==1'b0)? {1'b0,data_out_r[15:9]}:17'b0;//截位

    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            max<=8'd0;
        end
        else if(data_out_r>max)begin 
            max <= data_out_r;
        end
        else begin 
            max <= max;
        end
    end

endmodule

