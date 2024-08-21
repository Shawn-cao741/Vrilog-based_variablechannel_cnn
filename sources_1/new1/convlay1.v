`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 15:44:33
// Design Name: 
// Module Name: convlay1
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


module convlay1(clk,ce,global_rst,data_out1,end_mod);
     parameter n = 10'd512;     // activation map size->input size
    parameter k = 9'd32;     // kernel size 
    //parameter p = 9'h002;
    parameter step = 8;
    parameter outlen=9'd61;
    parameter channelnb=9'd4;
    input clk,global_rst,ce;
    //input [15:0] activation;
   // input wire [7:0]weight1;
 output wire [8*outlen-1:0] data_out1;
 output wire end_mod;
    wire [15:0] conv_op;
    wire valid_conv;
    wire relu_op;
    wire [7:0] weight1;
    wire [8*k-1:0]weight;
    wire [7:0]activation1;
    wire [8*n-1:0]activation;
    wire  [7:0] bias1;
    wire  [7:0] bias;
   
    conv1weight conv1weight1(
    .clka(clk),
    .ena(ce), 
    .addra(),
    .douta(weight1)
  );
    
inputdata inputdata1(
    .clka(clk),
    .ena(ce), 
    .addra(),
    .douta(activation1)
  );
  
  conv1bias conv1bias1(
    .clka(clk),
    .ena(ce), 
    .addra(),
    .douta(bias1)
  );
    
    generate
	genvar l,a;
	for(l=0;l<k;l=l+1)
	begin
        assign weight[8*l +: 8] = weight1; 		
	end	
endgenerate

generate
	genvar z,b;
	for(z=0;z<n;z=z+1)
	begin
        assign activation [8*z +: 8]  = activation1;
	end	
endgenerate


    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
   
endmodule
