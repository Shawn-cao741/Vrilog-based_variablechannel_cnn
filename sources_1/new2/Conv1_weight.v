`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 18:16:39
// Design Name: 
// Module Name: Conv1_weight
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


module Conv1_weight#(
    parameter kernel_size = 6'd32,
    parameter parameter_w = kernel_size*4,//4个卷积核
    parameter weight_width = 4'd8,
    parameter weight_length = 8'd128
)(
    input           				clk,
	input           				rst_n,
	input           				valid,
	output           				c1_w_en,
	output [weight_width*4-1 : 0] 	c1_w
    );


    //读权值
    wire 	[weight_width-1 : 0] 		w_dout;
	wire	 	[weight_width-1 : 0] 		weight[0:parameter_w-1];
	wire		[7:0] 					addra_w;
	reg 		[7:0]					cnt_addra;
	
	reg								weight_flag;
	reg	 	[weight_width-1 : 0] 		Multiply_weight[0:3];
	reg		[5:0]					cnt_weight32;

	wire								en; 
	wire							en_r;
	reg								en_r1;

	assign en = en_r1;
	
	assign  en_r = (weight_flag && (cnt_addra<8'd128))?1'b1:1'b0;

	always@(posedge clk or negedge rst_n)begin 
		if(!rst_n)begin 
			en_r1 <= 1'b0;
		end
		else if(en_r) begin 
			en_r1<= en_r;
		end
		else begin 
			en_r1 <= en_r1;
		end
	end///////////////////////////////////

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
		else if(cnt_addra == 8'd129)
			cnt_addra <= cnt_addra;
		else if(weight_flag)
			cnt_addra <= cnt_addra + 1'd1;
		else
			cnt_addra <= cnt_addra;
	end

    assign addra_w = cnt_addra; 

    conv1weight u_conv1weight (
    		.clka(clk),    // input wire clka
    		.ena(en_r),      // input wire ena
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
	
	assign  c1_w_en = (weight_flag && (cnt_addra==8'd129) && (cnt_weight32 < 6'd32))? 1'b1:1'b0;
	reg c1_w_en_r;
	wire c1_w_en_r2;
	assign c1_w_en_r2 = (cnt_weight32<6'd33)?c1_w_en_r:1'b0;

	always@(posedge clk or negedge rst_n)begin 
		if(!rst_n)begin 
			c1_w_en_r<=1'b0;
		end
		else if(c1_w_en)begin 
			c1_w_en_r<=1'b1;
		end
		else begin 
			c1_w_en_r<=c1_w_en_r;
		end
	end



    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)		  
			cnt_weight32 <= 6'd0;
		else if(cnt_weight32 == 6'd33)
			cnt_weight32 <= cnt_weight32;
		else if(c1_w_en_r2)
			cnt_weight32 <= cnt_weight32 + 1'b1;
	end

    //将权值通过4个变量依次输出到Multiply_adder中,4个卷积核
	genvar m_w;
	generate 
		for(m_w=0; m_w< 4; m_w=m_w+1)
		begin:Multiply_weight_n
			always@(posedge clk or negedge rst_n)begin
				if(!rst_n)			
					Multiply_weight[m_w] <= 8'd0;
				else if(c1_w_en_r2&&(cnt_weight32<32))
					Multiply_weight[m_w] <= weight[m_w*32+cnt_weight32];
				else
					Multiply_weight[m_w] <= Multiply_weight[m_w];
			end
		end
	endgenerate

    assign c1_w = {Multiply_weight[3],Multiply_weight[2],Multiply_weight[1],Multiply_weight[0]};
    //4个32并行的读

endmodule
