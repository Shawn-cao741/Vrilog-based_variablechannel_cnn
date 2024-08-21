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
parameter fc1_num = 10'd480,      //ȫ���Ӳ�һ��Ԫ����Ϊ480��������64��
parameter fc2_num = 10'd64,
parameter weight_widht = 8'd8,
parameter data_widht = 4'd8)
(
input valid,                    //Ϊ1ʱ��ʼ����
input clk,
input rst_n,
input mode,
//λ��Ҫ�޸�
input [7:0] data,

//----------------------------------���Խӿ�-----------------------------------------//
//output[17:0]data_1_test,     
//output[17:0]data_out_r3_test,
//output[data_widht-1:0] data_out,
output[7:0] data_out,
//------------------------------------------------------------------------------------//
output W_en,                       //�����ʹ��
output [14:0 ]dataaddra,              //�������ַ
output out_en_r,                   //���дʹ��
output[13:0]       dataaddrin_r,//���д��ַ
output reg finish                     //�����ź���Ϊ0�����������㻹δ��������Ϊ1�������������������ź���Ϊ��һ���valid�źţ�Ϊһ��ʼ��ram'�ж����ź�


    );
    reg signed [40:0]max_middle;
    reg signed [40:0]min_middle;
    reg signed [40:0]max_result;
    reg  signed [40:0]min_result;
    wire  out_en_r_r;
    wire out_en;
    wire out_en_r;
    reg                            notfirsttime;        //out_enӦ����һ���غϵ���һ�غϵĿ�ʼ��1��ʹ����ӣ���һ������û��ǰһ���̹ʲ���һ������hard to explain
    reg [12:0]                  count_test;
  	//reg		[9: 0]				cnt_data;		
   wire     signed[7: 0]	data;
	//reg		signed [data_widht-1: 0]	buffer_in		[0:fc1_num-1];		//����512�����ݵ�buffer
	reg							W_en;			//Ȩ�ض�ȡʹ��
	reg							valid_r,valid_r2;	
	wire	[17: 0]				addra;			//Ȩ��ֵ��ram�ĵ�ַ��ȡ
	wire    [14:0]                dataaddra;//�ź���ram�ĵ�ַ��ȡ
	
	reg		[9: 0]				addra_512,addra_512_r;	//ÿ��ȡһ������+1
	//reg      [5:0]                addra_42,addra_42_r;
	reg		[ 6: 0]				cnt_128,cnt_128_r;		//ÿ480Ȩֵ���������+1�����������Ϊ479ʱ����ʾfc1���Ӳ�������
	reg      [5:0]                cnt_42,cnt42_r;
	wire  signed	[7: 0]				fc1_weight;			//�����Ȩֵ
	wire  signed	[7:0]				fc1_bias;			//ƫ��
	wire						    bias_en;			//ƫ�õ�ʹ��
	
	reg  dataen;                                    //�źŶ�ȡʹ��
	
	reg 						       W_en_r;
	wire						  data_out_r_en;		//�жϳ����Ƿ�Ϊ0
	wire						  last;			//W_enʹ����Ҳ˵����fc���ݴ����꣬��������ж�Ϊ���һ�����ֵ
	reg							  last_r,last_r2;	//Ϊlast���̵�
	wire	[16:0]			data_out_r;		//��˺����ֵ����0ֱ���������Ϊ0��
	
	wire	signed [35:0]			data_out_r2;		//��Ը����ķ���
	reg		signed [35: 0]			data_out_r3;		//��1000��data_out_r2�ĺ�
	reg		signed [35: 0]			data_1;		       //���data_out_r3�ټ���ƫ��֮���Ϊ���ֵ  
	
	reg[13:0]        dataaddrin;
	reg[13:0]       dataaddrin_r;
 	//assign data_1_test=data_1;
	//assign data_out_r3_test=data_out_r3;
	//���data_
    ///////////////////////////
	////////////bias��weight/////////////
	////////////////////////////////////
	//����ram
//inputdata inputdata_u(
//.clka (clk),
//.ena( W_en),                                           //��Ȩ�ص�ʹ�ܺͶ����ݵ�ʹ�ܵĳ���ʱ����һ�µ�
//.addra(dataaddra),                              //��ȡ���ĵ�ַ
//.douta(data)
//);



assign dataaddra=cnt_42*fc1_num+addra_512;

	//bram�ж�ȡ
	structure1_fc1bias  structure2_fc1_bias_u(
		.clk			(clk),
		.rst_n			(rst_n),
		.en			(bias_en),
		.data_out		(fc1_bias)   //��ȡƫ��
	    );
	//ƫ��ʹ���źţ�Ҫ�ڶ�ȡ512��Ȩ��֮ǰ��ƫ�ö����������Ϊ�ڶ���256ʱ������ƫ��
	assign bias_en = (addra_512 == 10'd240||addra_512 == 10'd241)? 1'd1:1'd0;//��bias����Чʱ���ӳ�һ��ʱ������
	//bram�ж�ȡ
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
//    		//cnt_data��0�ӵ�512
//    		/////////////////////////////////////////////////////////////////////////��δ������㣬��������ɺ�Ӧ�ö��źŽ��й��㣬�Ա㽫��һ��512�����ֶ���
//    	end

    	

//    	//��512λ���ݶ���fifo�У����һ��ȫ�������㣬������������fifo����ӭ�ӵڶ���512�����ݣ�����Ҫ42��
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
    
    //W_enΪ��Ȩ��ʹ��
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			W_en <= 1'd0;
	//��ѭ����64���Ҷ�����64�εĵ�480λʱ����������30720��Ȩ�ض�ȡ���
		else if((cnt_42==species-1)&&(cnt_128 == (fc2_num-1) && addra_512 == (fc1_num-1)))
			W_en <= 1'd0;
			//������һ�ֺ������Ϊ0��������Ӧ�ã���һ��512λ��ѭ����ʼʱ��Ҫ��W_en��λΪ1
		else	if(valid&&(cnt_42!=species-1)&&(mode==1))
			W_en <= 1'd1;              //��δ����42��ѭ����һֱ��Ȩ��
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
			cnt_42 <= cnt_42;              //�������
      
			//��ÿ��Сѭ�����ʱ��cnt_42+1��
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
		//��ɵ�һ�������������ص�0λ�ÿ�ʼ�ڶ���������ļ��㣻
		else if(cnt_128 == (fc2_num-1) && addra_512 == (fc1_num-1))
		     begin
		     cnt_128<=0;	
		     notfirsttime<=1;//Ϊ1�����ǵ�һ��ѭ���ĵ�һ�ζ��Ǻ���41��ѭ���ص��ĵ�һ�Σ�
		     end
		else if(cnt_128 == (fc2_num-1))
			cnt_128 <= cnt_128;

			//��ÿ��Сѭ�����ʱ��cnt_128+1��
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
	
	
    	//��ȡ��Ȩ�صĵ�ַ����
    	assign addra = cnt_128 * fc1_num + addra_512;
    	
    	
    	
    	
    	//ʹ�ܵ��ӳ�
    	always@(posedge clk or negedge rst_n)begin
    		if(!rst_n)
    			W_en_r <= 1'd0;
    		else
    			W_en_r <= W_en;
    	end
    	
  //�˷�����  	      
//    //���data_out_r3�ټ���ƫ��֮���Ϊ���ֵ 
//    	assign data_out_r_en = W_en_r && !(buffer_in[addra_512_r]==8'd0||fc1_weight[15:0]==8'd0);//�жϺ����Ƿ���Ҫ�˷���
//    	//��W_en_rΪ�ߣ��棩ʱ������buffer_in[addra_5 12_r]��fc1_weight[15:0]�е��κ�һ����Ϊ0ʱ��data_out_r_enΪ�ߣ��棩��
//    	//���buffer_in[addra_512_r]��fc1_weight[15:0]�����κ�һ��Ϊ0��data_out_r_en��Ϊ�ͣ��٣������º����ĳ˷�����������У��������ᱻʹ�ã���
//    	assign data_out_r = (data_out_r_en)? ({fc1_weight[7],16'd0}+fc1_weight[15:0]*buffer_in[addra_512_r]):17'd0;//��˺����ֵ����0ֱ���������Ϊ0��  
//    	//��data_out_r_enΪ�ߣ��棩ʱ��ִ�г˷�����fc1_weight[15:0] * buffer_in[addra_512_r]��ע���������buffer_in[addra_480_r]��32λ����fc1_weight[15:0]��16λ����
//    	//{fc1_weight[16],63'd0}����Ϊ�˱�֤����λ���ֲ���
//    	assign data_out_r2 = (data_out_r[16])?{1'd1,~data_out_r[14:0]+1}:data_out_r[15:0];
//    	//��Ϊ���������䲹��
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
    
    //out_en�����ؾͱ�֤�����Ѿ��ɹ����
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
	
	//out_en�ź��ӳ�3�ĺ���޸ĵ�ַ������data����д��λ��
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
		
	//dataaddr_r��dataaddr�Ӻ�һ�ģ���ֹд�뵽ram�Ĵ���λ��
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
	       else if((dataaddrin_r==((fc2_num*species)-1))&&(!out_en)&&(!out_en_r))//��֤
	           begin
	                   finish<=1'b1;
	           end
	       else
	            begin
	                   finish<=finish;
	              end
	       end
	//	relu��
	//                     0  ��x<0��
	//��f��x��={
	//                     x    (x>0 )
	//��48λΪ0����Ϊ���������Ϊx��48λΪ1�����Ϊ0
	assign	data_out = (data_1[35])? 8'd0:data_1[32:25];//��β����ʵ����Ҫ���ݿ��ܵ����ֵ���н�λ
	//��outen��������Ȩ�������ݵĳ˻�����ƫ�ã�Ӧ������һ�ֵ�һ�����ݺ͵�һ��Ȩ�����֮ǰ��ɸĲ������������һ��ѭ��û����һ�Σ����������ӡ�
	assign 	out_en = ((addra_512>10'd0 && addra_512<10'd3 && ((cnt_128>7'd0)||(notfirsttime))) || last)?1'd1:1'd0;
    //out_en���������ʹ�ܣ���������һ�������������
    assign 	out_en_r = ((addra_512>10'd2 && addra_512<10'd8 && ((cnt_128>7'd0)||(notfirsttime))) || last)?1'd1:1'd0;
   //out

    
    

    
endmodule

