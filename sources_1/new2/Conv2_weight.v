`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 16:12:54
// Design Name: 
// Module Name: Conv2_weight
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


module Conv2_weight#(
    parameter weight_width = 4'd8,
    parameter kernel_size = 2'd3,
    parameter input_channel = 3'd4,
    parameter parameter_w = kernel_size*input_channel*16
)(
    input clk,
    input clk_x4,
    input rst_n,
    input valid,
    input conv1_end,//第一层卷积结束
    output c2_w_en,
    output [weight_width*16-1:0] c2_w0,
    output [weight_width*16-1:0] c2_w1,
    output [weight_width*16-1:0] c2_w2,
    output [weight_width*16-1:0] c2_w3
    );

    //读权值
    wire 	[weight_width-1 : 0] 		w_dout;
	wire	 	[weight_width-1 : 0] 		weight[0:parameter_w-1];
	wire		[7:0] 					addra_w;
	reg 		[7:0]					cnt_addra;

    reg								weight_flag;
    wire                            en;
    reg             [2:0]                cnt_weight3;    

    reg [7:0] Multiply_weight0[0:15] ;          
    reg [7:0] Multiply_weight1[0:15] ;   
    reg [7:0] Multiply_weight2[0:15] ;   
    reg [7:0] Multiply_weight3[0:15] ;    

    assign en = (weight_flag && (cnt_addra<8'd192))?1'b1:1'b0;

    always@(*)begin
		if(!rst_n)
			weight_flag <= 1'd0;
		else if(valid)
			weight_flag <= 1'd1;
		else
			weight_flag <= weight_flag;
	end
			
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_addra <= 7'd0;
		else if(cnt_addra == 8'd193)
			cnt_addra <= cnt_addra;
		else if(weight_flag)
			cnt_addra <= cnt_addra + 1'd1;
		else
			cnt_addra <= cnt_addra;
	end

    assign addra_w = cnt_addra;

    conv2weight u_conv2weight (
    		.clka(clk),    // input wire clka
    		.ena(en),      // input wire ena
    		.addra(addra_w),  // input wire [7 : 0] addra
    		.douta(w_dout)  // output wire [7 : 0] douta
    );

    //weight,
    genvar w_i;
    generate 
        for(w_i=0;w_i<parameter_w;w_i=w_i+1)
        begin:weight_i
            assign weight[w_i] = (weight_flag && (addra_w-1)==w_i) ? w_dout: weight[w_i];
        end
    endgenerate

    assign c2_w_en  =  (weight_flag && (cnt_addra==8'd193) && (cnt_weight3 < 3'd3)&&(conv1_end))? 1'b1:1'b0;
    reg c2_w_en_r;
	wire c2_w_en_r2;
	assign c2_w_en_r2 = (cnt_weight3<3'd4)?c2_w_en_r:1'b0;

    always@(posedge clk or negedge rst_n)begin 
		if(!rst_n)begin 
			c2_w_en_r<=1'b0;
		end
		else if(c2_w_en)begin 
			c2_w_en_r<=1'b1;
		end
		else begin 
			c2_w_en_r<=c2_w_en_r;
		end
	end
    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)		  
			cnt_weight3 <= 3'd0;
		else if(cnt_weight3 == 3'd4)
			cnt_weight3 <= cnt_weight3;
		else if(c2_w_en_r2)
			cnt_weight3 <= cnt_weight3 + 1'b1;
	end

    //通过16个变量输出权重
    genvar m_w0;
    generate 
        for(m_w0=0; m_w0< 16; m_w0=m_w0+1)
		begin:Multiply_weight_n0
			always@(posedge clk or negedge rst_n)begin
				if(!rst_n)			
					Multiply_weight0[m_w0] <= 8'd0;
				else if(c2_w_en_r2&&(cnt_weight3<3))
					Multiply_weight0[m_w0] <= weight[m_w0*12+cnt_weight3];
				else
					Multiply_weight0[m_w0] <= Multiply_weight0[m_w0];
			end
		end
    endgenerate

    genvar m_w1;
    generate 
        for(m_w1=0; m_w1< 16; m_w1=m_w1+1)
		begin:Multiply_weight_n1
			always@(posedge clk or negedge rst_n)begin
				if(!rst_n)			
					Multiply_weight1[m_w1] <= 8'd0;
				else if(c2_w_en_r2&&(cnt_weight3<3))
					Multiply_weight1[m_w1] <= weight[3+m_w1*12+cnt_weight3];
				else
					Multiply_weight1[m_w1] <= Multiply_weight1[m_w1];
			end
		end
    endgenerate

    genvar m_w2;
    generate 
        for(m_w2=0; m_w2< 16; m_w2=m_w2+1)
		begin:Multiply_weight_n2
			always@(posedge clk or negedge rst_n)begin
				if(!rst_n)			
					Multiply_weight2[m_w2] <= 8'd0;
				else if(c2_w_en_r2&&(cnt_weight3<3))
					Multiply_weight2[m_w2] <= weight[6+m_w2*12+cnt_weight3];
				else
					Multiply_weight2[m_w2] <= Multiply_weight2[m_w2];
			end
		end
    endgenerate

    genvar m_w3;
    generate 
        for(m_w3=0; m_w3< 16; m_w3=m_w3+1)
		begin:Multiply_weight_n3
			always@(posedge clk or negedge rst_n)begin
				if(!rst_n)			
					Multiply_weight3[m_w3] <= 8'd0;
				else if(c2_w_en_r2&&(cnt_weight3<3))
					Multiply_weight3[m_w3] <= weight[9+m_w3*12+cnt_weight3];
				else
					Multiply_weight3[m_w3] <= Multiply_weight3[m_w3];
			end
		end
    endgenerate

    assign c2_w0 = {Multiply_weight0[15],Multiply_weight0[14],Multiply_weight0[13],Multiply_weight0[12],Multiply_weight0[11],Multiply_weight0[10],
    Multiply_weight0[9],Multiply_weight0[8],Multiply_weight0[7],Multiply_weight0[6],Multiply_weight0[5],Multiply_weight0[4],Multiply_weight0[3],
    Multiply_weight0[2],Multiply_weight0[1],Multiply_weight0[0]};
    
    assign c2_w1 = {Multiply_weight1[15],Multiply_weight1[14],Multiply_weight1[13],Multiply_weight1[12],Multiply_weight1[11],Multiply_weight1[10],
    Multiply_weight1[9],Multiply_weight1[8],Multiply_weight1[7],Multiply_weight1[6],Multiply_weight1[5],Multiply_weight1[4],Multiply_weight1[3],
    Multiply_weight1[2],Multiply_weight1[1],Multiply_weight1[0]};

    assign c2_w2 = {Multiply_weight2[15],Multiply_weight2[14],Multiply_weight2[13],Multiply_weight2[12],Multiply_weight2[11],Multiply_weight2[10],
    Multiply_weight2[9],Multiply_weight2[8],Multiply_weight2[7],Multiply_weight2[6],Multiply_weight2[5],Multiply_weight2[4],Multiply_weight2[3],
    Multiply_weight2[2],Multiply_weight2[1],Multiply_weight2[0]};

    assign c2_w3 = {Multiply_weight3[15],Multiply_weight3[14],Multiply_weight3[13],Multiply_weight3[12],Multiply_weight3[11],Multiply_weight3[10],
    Multiply_weight3[9],Multiply_weight3[8],Multiply_weight3[7],Multiply_weight3[6],Multiply_weight3[5],Multiply_weight3[4],Multiply_weight3[3],
    Multiply_weight3[2],Multiply_weight3[1],Multiply_weight3[0]};

endmodule
