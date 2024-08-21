`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 15:58:24
// Design Name: 
// Module Name: Data_input
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


module Data_input(
    input           		clk,
	input           		rst_n,
	input           		valid,
    input                   c1_w_en,//权重准备好后再加数据
    input           [12:0]conv_time,
    input                   out_valid,
    input                   conv_end,
	output           		valid_conv1,
	output	[7 : 0] 		data_in_conv1
    );

    reg [14:0] cnt_addra;
    wire [14:0] addra;


    //reg data_ready1;
    //reg data_ready2;
    reg data_ready = 1'b0;
    //assign data_ready = data_ready1&&data_ready2;

    wire cnt32_flag;

    wire        valid_conv1_r;
    reg			valid_conv1_r1;
	//reg			valid_conv1_r2;

    reg [5:0] cnt_32;

    reg     [5:0]    skip_data_end = 6'd0;

    always@(posedge cnt32_flag or negedge conv_end)begin 
        if(!rst_n)begin 
            data_ready <= 1'b0;
        end
        else if(cnt32_flag) begin 
            data_ready <= 1'b0;
        end
        else begin 
            data_ready <= 1'b1;
        end
    end

    // always@(posedge cnt32_flag)begin 
    //     if(!rst_n)begin 
    //         data_ready2 <=1'b1;
    //     end
    //     else begin 
    //         data_ready2 <= 1'b0;
    //     end
    // end

    // always@(negedge conv_end)begin 
    //     if(!rst_n)begin 
    //         data_ready <= 1'b0;
    //     end
    //     else begin 
    //         data_ready <= 1'b1;
    //     end
    // end

    // always@(posedge cnt32_flag)begin 
    //     if(!rst_n)begin 
    //         data_ready <=1'b0;
    //     end
    //     else begin 
    //         data_ready <= 1'b0;
    //     end
    // end

    wire first_conv;
    assign first_conv = (valid&&(cnt_addra<16'd21504)&&c1_w_en&&(cnt_32<6'd32))?1'b1:1'b0;


    assign addra=cnt_addra;
    assign valid_conv1_r=(conv_time<13'd1)?first_conv:data_ready;
    assign valid_conv1=valid_conv1_r1;

  

    //延迟一拍（延迟一个时钟周期）
    always@(posedge clk or negedge rst_n)begin
    		if(!rst_n)begin
    		valid_conv1_r1 <= 1'd0;
			//valid_conv1_r2 <= 1'd0;
		end
    		else begin
    		valid_conv1_r1 <= valid_conv1_r;
			//valid_conv1_r2 <= valid_conv1_r1;
		end
    end

    //count 32
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            cnt_32 <= 0;
        else if(!valid)
            cnt_32 <= 0;
        else if((valid_conv1_r1)&&(cnt_32<6'd32))
            cnt_32 <= cnt_32 + 1'd1;
        else
            cnt_32<=1'b0;
    end
    assign cnt32_flag = (cnt_32==6'd32)?1'b1:1'b0;

    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         skip_data_end <= 6'd0;
    //     end
    //     else begin 
    //         skip_data_end <= skip_data_end;
    //     end
    // end
    

    always@(posedge data_ready)begin 
        if(!rst_n)begin 
            skip_data_end <= 0;
        end
        else if(((conv_time%61)==0)&&(conv_time>13'd0)) begin 
            skip_data_end <= skip_data_end +6'd1;
        end
        else begin 
            skip_data_end <= skip_data_end;
        end
    end
//     always @(posedge clk or negedge rst_n or posedge data_ready) begin
//     if (!rst_n) begin
//         skip_data_end <= 6'd0;
//     end else if (data_ready) begin
//         if (((conv_time % 61) == 0) && (conv_time > 13'd0)) begin
//             skip_data_end <= skip_data_end + 6'd1;
//         end
//     end
// end


    // always@(posedge data_ready)begin 
    //     if(!rst_n)begin 
    //         cnt_addra<=16'd0;
    //     end
    //     else begin 
    //         cnt_addra <= (conv_time+skip_data_end*3)*8;//跳过每一个数据的最后那几个数
    //     end
    // end

    // always@(posedge clk or negedge rst_n)begin
    //     if(!rst_n)
    //         cnt_addra <= 16'd0;
    //     else if(cnt_addra== 16'd21504)
    //         cnt_addra <= cnt_addra;
    //     else if((valid_conv1_r1)&&(cnt_32<32))
    //         cnt_addra <= cnt_addra + 1'b1;
    //     else
    //         cnt_addra<=cnt_addra;
    // end
    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_addra <= 16'd0;
    end else if (data_ready && !last_data_ready) begin
        // 根据 data_ready 信号的上升沿更新 cnt_addra
        cnt_addra <= (conv_time + skip_data_end * 3) * 8;
    end else if (valid_conv1_r1 && (cnt_32 < 32)) begin
        // 在 valid_conv1_r1 有效且 cnt_32 小于 32 时，增加 cnt_addra
        cnt_addra <= cnt_addra + 1'b1;
    end
    end

    // 用于记录上一个 data_ready 信号状态
    reg last_data_ready;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_data_ready <= 1'b0;
        end else begin
            last_data_ready <= data_ready;
        end
    end

  

    inputdata u_inputdata(
        .clka(clk),    // input wire clka
		.ena(valid_conv1_r),      // input wire ena
		.addra(addra),  // input wire [15 : 0] addra
		.douta(data_in_conv1)  // output wire [7 : 0] douta
    );

endmodule
