`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 15:35:42
// Design Name: 
// Module Name: Conv1_bias
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


module Conv1_bias#(
    parameter bias_width = 4'd8
)(
    input           		clk,
	input           		rst_n,
	input           		valid,
	output           		c1_b_en,
	output [bias_width-1: 0]	c1_b
    );

    reg				en_r;
    reg				en_r2;
    wire [bias_width-1: 0]		bias_out;
	reg [2: 0] 		num_n;
	reg [2: 0] 		num_n_r;

    assign c1_b_en = (num_n <=3'd5)? en_r:1'b0;

    //拖一拍？
    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			en_r <= 1'b0;
			en_r2 <= 1'b0;
		end
		else	begin
			en_r2 <= valid;
			en_r <= en_r2;
		end
    end

    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)      			
			num_n_r <= 3'd0;
		else if(num_n_r >3'd4)  
			num_n_r <= num_n_r;
		else if(valid)
			num_n_r <= num_n_r + 1'b1;
	end

    always@(posedge clk or negedge rst_n)begin
		if(!rst_n)      			
			num_n <= 3'd0;
		else
			num_n <= num_n_r;
	end

    conv1bias u_conv1bias(
    		.clka(clk),    // input wire clka
    		.ena(valid),      // input wire ena
    		.addra(num_n),  // input wire [1 : 0] addra
    		.douta(bias_out)  // output wire [7 : 0] douta
    	);
    	
    	assign c1_b = bias_out;




endmodule
