`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/21 16:13:53
// Design Name: 
// Module Name: fc1tofc2bram
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


module structure2_fc1tofc2bram(
input clk,//时钟
input rst_n,
input fc1en,//fc1的写使能
input fc2en,//fc2的读使能
input [13:0]fc1dataaddrin_r,//fc1写的地址输入，
input[13:0]fc2dataaddr,//fc2读的地址输入
input[17:0]fc1datain,
output[17:0]fc2dataout
    );
      
//reg [13:0]  dataaddr;
//always@(posedge clk or negedge rst_n )
//begin
// if(!rst_n)
// begin
//    dataaddr<=13'd0; 
// end
//else if(fc1en==1&&fc2en==0)
//begin
//        dataaddr<=fc1dataaddrin_r;
//end
//else if(fc1en==0&&fc2en==1)
//begin
//dataaddr<=fc2dataaddr;
//end
//else
//dataaddr<=dataaddr;
//end
        //将数据存入到fc1output中，并在fc2中读取
    structure2_fc1tofc2dualport    structure2_fc1tofc2dualport(
    .clka(clk),
    .ena( 1),//读使能在fc2模块
    .wea(fc1en),
    .addra(fc1dataaddrin_r),
    .dina(fc1datain),
    .clkb(clk),
    .web(0),
    .enb(fc2en),
    .addrb(fc2dataaddr),
    .doutb(fc2dataout)    //读出在fc2模块
    );
endmodule
