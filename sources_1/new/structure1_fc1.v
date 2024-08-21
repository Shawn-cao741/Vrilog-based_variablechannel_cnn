`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 20:33:40
// Design Name: 
// Module Name: 
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
module structure1_fc1
#(
parameter species=6'd42,
parameter fc1_num = 10'd480,      //全连接层一神经元个数为480，输出结果64个
parameter fc2_num = 10'd64,
parameter weight_widht = 8'd8,
parameter data_widht = 4'd8)
(
input valid,                    //为1时开始运算
input clk,
input rst_n,
input mode,
//位宽要修改
input [7:0] data,

//----------------------------------测试接口-----------------------------------------//
//output[17:0]data_1_test,     
//output[17:0]data_out_r3_test,
//output[data_widht-1:0] data_out,
output[7:0] data_out,
//------------------------------------------------------------------------------------//
output W_en,                       //输出读使能
output [14:0 ]dataaddra,              //输出读地址
output out_en_r,                   //输出写使能
output[13:0]       dataaddrin_r,//输出写地址
output reg finish                     //结束信号若为0则代表本层的运算还未结束，若为1则代表本层运算结束，该信号作为下一层的valid信号，为一则开始从ram'中读入信号


    );
    reg signed [40:0]max_middle;
    reg signed [40:0]min_middle;
    reg signed [40:0]max_result;
    reg  signed [40:0]min_result;
    wire  out_en_r_r;
    wire out_en;
    wire out_en_r;
    reg                            notfirsttime;        //out_en应该在一个回合的下一回合的开始置1，使得相加，第一次由于没有前一过程故不加一，……hard to explain
    reg [12:0]                  count_test;
  	//reg		[9: 0]				cnt_data;		
   wire     signed[7: 0]	data;
	//reg		signed [data_widht-1: 0]	buffer_in		[0:fc1_num-1];		//储存512个数据的buffer
	reg							W_en;			//权重读取使能
	reg							valid_r,valid_r2;	
	wire	[17: 0]				addra;			//权重值在ram的地址读取
	wire    [14:0]                dataaddra;//信号在ram的地址读取
	
	reg		[9: 0]				addra_512,addra_512_r;	//每读取一个进行+1
	//reg      [5:0]                addra_42,addra_42_r;
	reg		[ 6: 0]				cnt_128,cnt_128_r;		//每480权值的输出进行+1，当计数结果为479时，表示fc1连接层计算完毕
	reg      [5:0]                cnt_42,cnt42_r;
	wire  signed	[7: 0]				fc1_weight;			//输出的权值
	wire  signed	[7:0]				fc1_bias;			//偏置
	wire						    bias_en;			//偏置的使能
	
	reg  dataen;                                    //信号读取使能
	
	reg 						       W_en_r;
	wire						  data_out_r_en;		//判断乘数是否为0
	wire						  last;			//W_en使能完也说明该fc数据处理完，对其进行判断为最后一个输出值
	reg							  last_r,last_r2;	//为last做铺垫
	wire	[16:0]			data_out_r;		//相乘后的数值，有0直接输出得数为0；
	
	wire	signed [35:0]			data_out_r2;		//求对负数的反码
	reg		signed [35: 0]			data_out_r3;		//求1000个data_out_r2的和
	reg		signed [35: 0]			data_1;		       //最后data_out_r3再加上偏置之后就为输出值  
	
	reg[13:0]        dataaddrin;
	reg[13:0]       dataaddrin_r;
 	//assign data_1_test=data_1;
	//assign data_out_r3_test=data_out_r3;
	//最后data_
    ///////////////////////////
	////////////bias和weight/////////////
	////////////////////////////////////
	//例化ram
//inputdata inputdata_u(
//.clka (clk),
//.ena( W_en),                                           //读权重的使能和读数据的使能的持续时长是一致的
//.addra(dataaddra),                              //读取数的地址
//.douta(data)
//);



assign dataaddra=cnt_42*fc1_num+addra_512;

	//bram中读取
	structure1_fc1bias  structure2_fc1_bias_u(
		.clk			(clk),
		.rst_n			(rst_n),
		.en			(bias_en),
		.data_out		(fc1_bias)   //读取偏置
	    );
	//偏置使能信号，要在读取512个权重之前把偏置读出，现设计为在读到256时，读出偏置
	assign bias_en = (addra_512 == 10'd240||addra_512 == 10'd241)? 1'd1:1'd0;//将bias的有效时长延长一个时钟周期
	//bram中读取
	structure1_fc1weight structure2_W_fc1_u (
	  .clka(clk),    // input wire clka
	  .ena(W_en),      // input wire ena
	  .addra(addra),  // input wire [17 : 0] addra
	  .douta(fc1_weight)  // output wire [16 : 0] douta
	);
	
	/////////////////////////////////
	/////////////////////////////////
	/////////////////////////////////
    		
//    	always@(posedge clk or negedge rst_n)begin
//    		if(!rst_n)
//    			cnt_data <=10'd0;
//    		else  if(cnt_data==fc1_num)
//    		       cnt_data <=10'd0;
//    		else if(valid)
//    			cnt_data <= cnt_data + 1'd1;
//    		//cnt_data从0加到512
//    		/////////////////////////////////////////////////////////////////////////但未对其归零，在运算完成后应该对信号进行归零，以便将下一组512个数字读入
//    	end

    	

//    	//把512位数据读到fifo中，完成一轮全连接运算，当最后结果输出后，fifo清零迎接第二轮512个数据，共需要42次
//    	genvar i;
//    	generate 
//    		for(i=0; i< fc1_num; i=i+1)
//    		begin:data_in_rr
//			always@(posedge clk or negedge rst_n)begin
//				if(!rst_n)
//					buffer_in[i] <= 8'd0;
//				else if(valid && i == cnt_data)
//					buffer_in[i] <= data_in;
//			end 
//		end
//	endgenerate

	
    	
//	always@(posedge clk or negedge rst_n)begin
//		if(!rst_n)begin
//			valid_r <= 1'd0;
//			valid_r2 <= 1'd0;
//		end
//		else	begin
//			valid_r2 <= valid;
//			valid_r <= valid_r2;
//		end
//	end
    
    //W_en为读权重使能
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			W_en <= 1'd0;
	//当循环了64次且读到第64次的第480位时，代表所有30720个权重读取完毕
		else if((cnt_42==species-1)&&(cnt_128 == (fc2_num-1) && addra_512 == (fc1_num-1)))
			W_en <= 1'd0;
			//运算完一轮后就设置为0，理论上应该，下一个512位的循环开始时又要将W_en置位为1
		else	if(valid&&(cnt_42!=species-1)&&(mode==1))
			W_en <= 1'd1;              //若未读完42个循环则一直读权重
	end
	
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			addra_512 <= 18'd0;
		else if(addra_512 == (fc1_num-1))
			addra_512 <= 18'd0;
		else if(W_en)
			addra_512 <= addra_512 + 1'd1;
	end
	
		always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			addra_512_r <= 1'd0;
		else	
			addra_512_r <= addra_512;
	end
	
	
	
	always@(posedge clk or negedge rst_n)begin
//		if(!rst_n)
//			addra_42 <= 6'd0;
//		else if(addra_42 == (species-1))
//			addra_42 <= 6'd0;
//		else if(W_en)
//			addra_42 <= addra_42 + 1'd1;
   end
	
//	always@(posedge clk or negedge rst_n)begin
//		if(!rst_n)
//			addra_42_r <= 1'd0;
//		else	
//			addra_42_r <= addra_42;
//	end
	
  	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_42 <= 6'd0;
		else if(cnt_42 == (species-1))
			cnt_42 <= cnt_42;              //运算完成
      
			//当每个小循环完成时，cnt_42+1；
		else if(addra == ((fc1_num*fc2_num)-1))
			cnt_42 <= cnt_42 + 1'd1;
		else if(W_en)
			cnt_42 <= cnt_42;
	end  	
    	
    	
    	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
		begin
			cnt_128 <= 9'd0;
			notfirsttime<=1'b0;
		end
		//完成第一个样本的运算后回到0位置开始第二个样本点的计算；
		else if(cnt_128 == (fc2_num-1) && addra_512 == (fc1_num-1))
		     begin
		     cnt_128<=0;	
		     notfirsttime<=1;//为1代表不是第一个循环的第一次而是后面41次循环回到的第一次；
		     end
		else if(cnt_128 == (fc2_num-1))
			cnt_128 <= cnt_128;

			//当每个小循环完成时，cnt_128+1；
		else if(addra_512 == (fc1_num-1))
			cnt_128 <= cnt_128 + 1'd1;
		else if(W_en)
			cnt_128 <= cnt_128;
	end
    	
    	
    	
    	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_128_r <= 1'd0;
		else	
			cnt_128_r <= cnt_128;
	end
	
	
    	//读取的权重的地址计算
    	assign addra = cnt_128 * fc1_num + addra_512;
    	
    	
    	
    	
    	//使能的延迟
    	always@(posedge clk or negedge rst_n)begin
    		if(!rst_n)
    			W_en_r <= 1'd0;
    		else
    			W_en_r <= W_en;
    	end
    	
  //乘法部分  	      
//    //最后data_out_r3再加上偏置之后就为输出值 
//    	assign data_out_r_en = W_en_r && !(buffer_in[addra_512_r]==8'd0||fc1_weight[15:0]==8'd0);//判断后续是否需要乘法。
//    	//当W_en_r为高（真）时，并且buffer_in[addra_5 12_r]或fc1_weight[15:0]中的任何一个不为0时，data_out_r_en为高（真）。
//    	//如果buffer_in[addra_512_r]或fc1_weight[15:0]中有任何一个为0，data_out_r_en将为低（假），导致后续的乘法操作不会进行（或结果不会被使用）。
//    	assign data_out_r = (data_out_r_en)? ({fc1_weight[7],16'd0}+fc1_weight[15:0]*buffer_in[addra_512_r]):17'd0;//相乘后的数值，有0直接输出得数为0；  
//    	//当data_out_r_en为高（真）时，执行乘法操作fc1_weight[15:0] * buffer_in[addra_512_r]（注意这里假设buffer_in[addra_480_r]是32位，而fc1_weight[15:0]是16位）。
//    	//{fc1_weight[16],63'd0}这是为了保证符号位保持不变
//    	assign data_out_r2 = (data_out_r[16])?{1'd1,~data_out_r[14:0]+1}:data_out_r[15:0];
//    	//若为负数则求其补码
      assign data_out_r2 =(fc1_weight*data*262144);
    	
    	always@(negedge clk or negedge rst_n)begin
    		if(!rst_n)
    		begin
    			data_out_r3 <= 18'd0;
    			max_middle=21'b0;
    		    min_middle=21'b1;
    		end
    		else	if(W_en_r)begin
			if(addra_512 == 10'd1)                          
				data_out_r3 <= data_out_r2;
			else
				data_out_r3 <= data_out_r3 + data_out_r2;
				if(max_middle<data_out_r3)
				begin
				  max_middle<=data_out_r3;
				  end
				else
				 begin
				   max_middle<=max_middle;
				end
				if(min_middle>data_out_r3)
				begin
				  min_middle<=data_out_r3;
				  end
				else
				 begin
				   min_middle<=min_middle;
				end
		end
    	end
    	
    	
    	always@(posedge clk or negedge rst_n)begin
    		if(!rst_n)
    			last_r <= 1'd0;
    		else
    			last_r <= W_en_r;
    	end
    	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			last_r2 <= 1'd0;
		else
			last_r2 <= last_r;
	end 
    	
    	assign	last = last_r2 &(!W_en_r);
    
    //out_en上升沿就保证数据已经成功算出
	always@(posedge out_en or negedge rst_n)begin
		if(!rst_n)
		begin
//		    max_result=21'b0;
//    		min_result=21'b1;
			data_1 <= 16'd0;
			//////////////////////////////////////test////////////////////////
			//count_test<=13'd0;
			///////////////////////////////////////////////////////////////////
	    end
		else
			data_1 <= data_out_r3 + fc1_bias;
//			count_test=count_test+1'b1;
//			if(max_result<data_1)
//				begin
//				  max_result<=data_1;
//				  end
//				else
//				 begin
//				   max_result<=max_result;
//				end
//				if(min_result>data_1)
//				begin
//				  min_result<=data_1;
//				  end
//				else
//				 begin
//				   min_result<=min_result;
//				end
	end
	
	//out_en信号延迟3拍后才修改地址，避免data数据写错位置
	always@(negedge out_en_r or negedge rst_n)begin
		if(!rst_n)
		begin
				dataaddrin<=14'd0;  
	    end
	    else if(dataaddrin<fc2_num*species-1)
			begin
			     dataaddrin<=dataaddrin+1'b1;
			end
			else
			     dataaddrin<=dataaddrin;
	end
		
	//dataaddr_r是dataaddr延后一拍，防止写入到ram的错误位置
		always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
		begin
			dataaddrin_r<=14'd0;  
	    end
	    else
	           dataaddrin_r<=dataaddrin;
	    end
	
		always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
		  begin
			finish<=1'd0;  
	        end
	       else if((dataaddrin_r==((fc2_num*species)-1))&&(!out_en)&&(!out_en_r))//保证
	           begin
	                   finish<=1'b1;
	           end
	       else
	            begin
	                   finish<=finish;
	              end
	       end
	//	relu层
	//                     0  （x<0）
	//、f（x）={
	//                     x    (x>0 )
	//第48位为0代表为正数，输出为x，48位为1，输出为0
	assign	data_out = (data_1[35])? 8'd0:data_1[32:25];//截尾处理，实际需要根据可能的最大值进行截位
	//在outen的上升沿权重与数据的乘积加上偏置，应该在下一轮第一个数据和第一个权重相乘之前完成改操作，由于最后一次循环没有下一次，则在最后相加。
	assign 	out_en = ((addra_512>10'd0 && addra_512<10'd3 && ((cnt_128>7'd0)||(notfirsttime))) || last)?1'd1:1'd0;
    //out_en是数据输出使能，在上升沿一个数据完成运算
    assign 	out_en_r = ((addra_512>10'd2 && addra_512<10'd8 && ((cnt_128>7'd0)||(notfirsttime))) || last)?1'd1:1'd0;
   //out

    
    

    
endmodule

