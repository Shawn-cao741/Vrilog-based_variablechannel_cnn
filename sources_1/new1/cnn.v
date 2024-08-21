`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 14:51:34
// Design Name: 
// Module Name: cnn
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
// 5.27日志：需要把第一层的数据补位输入第二层
//////////////////////////////////////////////////////////////////////////////////


module cnn(
input wire clk,
input wire global_rst,
input wire cal_start,
//input wire mode,
output wire end_cnn,
output wire[7:0]  data_outm21,
output wire [7:0]data_outm22,
output wire [7:0] data_outm23,
output wire  [7:0]data_outm24,
output wire[7:0]  data_outm25,
output wire [7:0] data_outm26,
output wire [7:0] data_outm27,
output wire [7:0] data_outm28,
output wire [10:0] outcount2,
output wire valid_out
//output wire 
    );
////////////////////////////// cnn1参数
   wire end_conlay1; 
   wire valid_conv1;
   wire [11:0] outcount1;
   wire [7:0] data_outm12;
   wire [7:0] data_outm13;
   wire [7:0] data_outm11;
   wire [7:0] data_outm14;
   reg write_valid=0;
 ////////////////////////////// cnn2参数   
 
 wire end_conlay2;
 wire valid_conv2;
 
//wire[23:0]  data_outm21;
//wire [23:0]data_outm22;
//wire [23:0] data_outm23;
//wire  [23:0]data_outm24;
//wire[23:0]  data_outm25;
//wire [23:0] data_outm26;
//wire [23:0] data_outm27;
//wire  [23:0]data_outm28;
//wire[23:0]  data_outm29;
//wire [23:0] data_outm210;
//wire [23:0] data_outm211;
//wire  [23:0]data_outm212;
//wire[23:0]  data_outm213;
//wire [23:0] data_outm214;
//wire [23:0] data_outm215;
//wire  [23:0]data_outm216;
 
wire [7:0]data_inm21;
wire [7:0]data_inm22;
wire [7:0]data_inm23; 
wire [7:0]data_inm24;
 wire readytostart2;
 wire [11:0] readdatalayer2addr;
 wire  flag;
 
// wire cal_start2;
// assign cal_start2=cal_start?end_conlay1:0;
 
    
    cnnlayer1#(21504,32,8,61,2562,4) cnn1(
   .clk(clk),
 .global_rst(global_rst),
 .cal_start(cal_start),
//output wire [7:0] convlay1_dataout,
.end_conlay1(end_conlay1),
.valid_conv(valid_conv1) ,
.outcount1(outcount1),
.data_outm1(data_outm11),
.data_outm2(data_outm12),
.data_outm3(data_outm13),
.data_outm4(data_outm14)   
    );
    ////////////////////////////////////////////////////////
 always@(negedge clk or negedge valid_conv1)
 begin
 if (valid_conv1!=1)
 write_valid<=0;
 else 
 write_valid<=1;
 end
    
 assign flag =(outcount1>=2500)?1:0;  
    
    
    
    
 cnn1tocnn2bram cnnbm(
 .clk(clk),
//.write_start(write_valid),
///////////////////////////////////////////
.write_start(1),
.write_valid(write_valid),
.read_start(ready2),
.writeaddr1(outcount1),
.readaddr(readdatalayer2addr),
.data_inm1(data_outm11),
.data_inm2(data_outm12),
.data_inm3(data_outm13),
.data_inm4(data_outm14),
.data_outm1(data_inm21),
.data_outm2(data_inm22),
.data_outm3(data_inm23),
.data_outm4(data_inm24)
 );   
 
 
 wire [16:0] data_in2rec1;
 wire [16:0] data_in2rec2;
 wire [16:0] data_in2rec3;
 wire [16:0] data_in2rec4;
 
// assign data_in2rec1={{1{data_inm21[7]}},data_inm21[6:0],5'b0};
// assign data_in2rec2={{1{data_inm22[7]}},data_inm22[6:0],5'b0};
// assign data_in2rec3={{1{data_inm23[7]}},data_inm23[6:0],5'b0};
// assign data_in2rec4={{1{data_inm24[7]}},data_inm24[6:0],5'b0};
 assign data_in2rec1=data_inm21*512;
 assign data_in2rec2=data_inm22*512;
 assign data_in2rec3=data_inm23*512;
 assign data_in2rec4=data_inm24*512;
 
    
cnnlayer2 cnn2(
.clk(clk),
.global_rst(global_rst),
.cal_start(cal_start),
.flag(flag),
.activationlayer21(data_in2rec1),
.activationlayer22(data_in2rec2),
.activationlayer23(data_in2rec3),
.activationlayer24(data_in2rec4),
.end_conlay2(end_conlay2),
.valid_conv2(valid_conv2),
.outcount2( outcount2),
.data_outm1(data_outm21),
.data_outm2(data_outm22),
.data_outm3(data_outm23),
.data_outm4(data_outm24),
.data_outm5(data_outm25),
.data_outm6(data_outm26),
.data_outm7(data_outm27),
.data_outm8(data_outm28),
//.data_outm9(data_outm29),
//.data_outm10(data_outm210),
//.data_outm11(data_outm211),
//.data_outm12(data_outm212),
//.data_outm13(data_outm213),
//.data_outm14(data_outm214),
//.data_outm15(data_outm215),
//.data_outm16(data_outm216),
.readytostart2(ready2),
.addract(readdatalayer2addr)
    );    
    
    assign end_cnn=end_conlay2;
    assign valid_out=valid_conv2;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
