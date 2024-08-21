`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/22 19:30:48
// Design Name: 
// Module Name: read
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


module read(clk,en,global_rst,indata,endread,outdata);
parameter width=8;
parameter length=32;
//input wire clk;
//input wire clk;
input wire clk;
input wire [width-1:0] indata;
input wire global_rst;
input wire en;//en要和bram的en一致
output wire endread;
output wire [width*length-1:0] outdata;

reg [31:0] counter;
reg [width*length-1:0] outreg;
//reg  [width-1:0] indatareg;
reg end1;


always @(posedge clk)begin
if(global_rst)begin
 end1<=0;counter<=0;end
else if(en)begin
//if(indata!=indatareg)begin
//indatareg<=indata;

counter<=counter+1;
outreg[width*(counter-1) +: 8]<=indata;
//indatareg<=indata;
//outreg[width*counter +: 8]<=indata;
///同步数据和weight同步进入需要修改

if(counter==length)begin
    end1<=1;
  end
  end
 else if (!en) begin
 end1<=0;counter<=0;
 end
end

 
 //assign outdata=end1?outreg:0;
 //修改
assign outdata=end1?outreg:0;
assign endread=end1;
endmodule
