`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 19:39:12
// Design Name: 
// Module Name: search
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: s
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module search#(
parameter num1=9'd480,                 //第一层神经元数
parameter bram1=5'd16,                //寄存器个数
parameter num2=8'd240,                //第二层神经元数
parameter bram2=4'd8,                     //寄存器个数
parameter info=5'd30
)(
//input W_en,
input [14:0]dataaddr,
input mode,
output [4:0]bramnum,
output [10:0]bramaddr
 );

wire [5:0]bramnum;
wire [10:0]bramaddr;
assign bramnum=(mode==1)?(dataaddr-(dataaddr/num1)*num1)/info:(dataaddr-(dataaddr/num2)*num2)/info;
assign bramaddr=(mode==1)?(((dataaddr/num1)*info)+(dataaddr-(dataaddr/num1)*num1-((dataaddr-(dataaddr/num1)*num1)/info)*info)):(((dataaddr/num2)*info)+(dataaddr-(dataaddr/num2)*num2-((dataaddr-(dataaddr/num2)*num2)/info)*info));
//dataaddr/num1代表第几个消息，反应了应该在寄存器的第几个三十里面找
//(dataaddr-i*num)/info代表存在哪一个寄存器
//dataaddr-i*num-j*info就是位置

//          i1=dataaddr/num1;
//          i2=dataaddr/num2;
//          j1=(dataaddr-i1*num1)/info;
//          j2=(dataaddr-i2*num2)/info;
//          z1=dataaddr-i1*num1-j1*info;
//          z2=dataaddr-i2*num2-j2*info;
//          end
//          if(mode)
//          begin
//              bramnum=j1;
//              bramaddr=i1*info+z1;
//          end
//          else
//          begin
//              bramnum=j2;
//              bramaddr=i2*info+z2;
//          end


endmodule
