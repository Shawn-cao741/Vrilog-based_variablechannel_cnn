`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/10 20:14:15
// Design Name: 
// Module Name: fc2_bias
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


module structure2_fc1bias(
	input			clk,
	input			rst_n,
	input			en,
	output	[7: 0]	data_out
    );
     
     reg	[7:0]	addra;
     wire	[7:0]	douta; 
     
     always@(negedge en or negedge rst_n)begin
     	if(!rst_n)
     		addra <= 7'd0;
     	else
     		addra <= addra + 1'd1;
     end 
     
	structure2_b_fc1  structure2_B_fc1_u (
        	  .clka(clk),    // input wire clka
        	  .ena(en),      // input wire ena
        	  .addra(addra),  // input wire [7 : 0] addra
        	  .douta(douta)  // output wire [16 : 0] douta
        	);
        	
      //bias已经是补码状况，不需要改变。
     assign data_out =douta;
     
endmodule
