`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 16:49:56
// Design Name: 
// Module Name: fcc_connect
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


module fcc_connect(
input clk,
input rst_n,
input valid,
input mode,                                                          //选择重构模式           
input[7:0]fc1_data,                          //从卷积层输入的数据
output fc1_W_en,                            //第一层读使能
output[5:0]bramnum,
output [10:0]bramaddr,           
output [15:0]output_data,                                //输出二维向量
output output_vld                                              //每当模型输出一次，此信号拉高一个周期
    );
  
  wire [14:0] fc1_dataaddr;//第一层读地址

  ///////////////////////////////////////////////////////重构一网络/////////////////////////////////////////////////////
  wire [5:0]bramnum;
  wire[10:0]bramaddr;
  wire  structure1_fc1_W_en;
  wire structure2_fc1_W_en;
   wire[14:0] structure1_fc1_dataaddr;
    wire[14:0] structure2_fc1_dataaddr;
    wire[7:0]structure1_fc1_data_out;         //第一层全连接输出的数据
   wire[7:0]structure1_fc1_data;
    wire[7:0]structure2_fc1_data;
    //wire[17:0]structure1_fc1_data_1_test;  
   // wire[17:0]data_out_r3_test;
    
    //wire[7:0]structure1_fc2_data_out;         //第二层输出的数据
    //wire[26:0]data_1_test_2;  
    //wire[26:0]data_out_r3_test_2;
    
    wire structure1_fc1_writeen;                //第一层向structure1dualport的写使能信号
    wire[13:0]structure1_fc1_writeaddr;  //写地址
    
    //wire out_en_r_2;
    //wire[13:0]dataaddrin_r_2;
    
    wire structure1_fc2_W_en;                           //读使能
    wire[13:0]  structure1_fc2_Wdataaddra;  //读地址
    wire [7:0] structure1_fc2_data_in;            //读数据
    
    //wire W_en_3;
    //wire[13:0]  dataaddra_3;
    //wire [26:0] data_in_3;
    //reg[12:0]dataaddr;
    //wire fc1entofc2en;
   // reg[7:0]fc1datatofc2data;
    wire structure1_fc1tofc2;                                              //structurefc1完成信号
    //wire fc2tofc3;
    wire structure1_fc3finish;                                              //全部完成信号
    
    ///////////////////////////////////////////////////////重构二网络/////////////////////////////////////////////////////
      wire[7:0]structure2_fc1_data_out;         //第一层全连接输出的数据
   
    //wire[17:0]structure2_fc1_data_1_test;  
   // wire[17:0]data_out_r3_test;
    
    //wire[7:0]structure2_fc2_data_out;         //第二层输出的数据
    //wire[26:0]data_1_test_2;  
    //wire[26:0]data_out_r3_test_2;
    
    wire structure2_fc1_writeen;                //第一层向structure2dualport的写使能信号
    wire[13:0]structure2_fc1_writeaddr;  //写地址
    
    //wire out_en_r_2;
    //wire[13:0]dataaddrin_r_2;
    
    wire structure2_fc2_W_en;                           //读使能
    wire[13:0]  structure2_fc2_Wdataaddra;  //读地址
    wire [7:0] structure2_fc2_data_in;            //读数据
    
    //wire W_en_3;
    //wire[13:0]  dataaddra_3;
    //wire [26:0] data_in_3;
    //reg[12:0]dataaddr;
    //wire fc1entofc2en;
   // reg[7:0]fc1datatofc2data;
    wire structure2_fc1tofc2;                                              //structurefc1完成信号
    //wire fc2tofc3;
    wire structure2_fc3finish;                                              //全部完成信号
    

     wire [15:0]structure1_output_data_wire;
    wire structure1_output_vld;
    
     wire [15:0]structure2_output_data_wire;
    wire structure2_output_vld;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
wire[15:0]output_data;
 wire    output_vld;
 assign output_data=(mode==1)?structure1_output_data_wire:structure2_output_data_wire;
 assign  output_vld=(mode==1)?structure1_output_vld:structure2_output_vld;
 assign structure1_fc1_data=(mode==1)?fc1_data:0;
 assign structure2_fc1_data=(mode==0)?fc1_data:0;
  assign  fc1_dataaddr=(mode==1)?structure1_fc1_dataaddr:structure2_fc1_dataaddr;
  assign fc1_W_en=(mode==1)?structure1_fc1_W_en:structure2_fc1_W_en;
    search search(
    .dataaddr(fc1_dataaddr),
    .mode(mode),
    .bramnum(bramnum),
    .bramaddr(bramaddr)
    );


    structure1_fc1  structure1_fc1(
    .clk(clk),
    .rst_n(rst_n),
    .valid(valid),
    .mode(mode),
    .data(structure1_fc1_data),
    //.data_1_test(structure1_fc1_data_1_test)    
    //.data_out_r3_test(data_out_r3_test),
    .data_out(structure1_fc1_data_out),
    .W_en(structure1_fc1_W_en),
    .dataaddra(structure1_fc1_dataaddr),
    .out_en_r(structure1_fc1_writeen),
    .dataaddrin_r(structure1_fc1_writeaddr),
    .finish(structure1_fc1tofc2)
   // .fc2en(fc1entofc2en),
   // .fc2data(fc1datatofc2data)
    );
    
structure1_fc1tofc2bram  structure1_fc1tofc2bram(
.clk(clk),
.rst_n(rst_n),
.fc1en(structure1_fc1_writeen),
.fc2en(structure1_fc2_W_en),
.fc1dataaddrin_r(structure1_fc1_writeaddr),
.fc2dataaddr( structure1_fc2_Wdataaddra),
.fc1datain(structure1_fc1_data_out),
.fc2dataout(structure1_fc2_data_in)
);
 


    
    structure1_fc2 structure1_fc2(
     .clk(clk),
    .rst_n(rst_n),
    .valid( structure1_fc1tofc2),
//    .data_1_test_2(data_1_test_2),    
//    .data_out_r3_test_2(data_out_r3_test_2),
//   .data_out(structure1_fc2_data_out),
    .W_en(structure1_fc2_W_en),
    .dataaddra(structure1_fc2_Wdataaddra),
    .data(structure1_fc2_data_in),
//    .out_en_r(out_en_r_2),
//    .dataaddrin_r(dataaddrin_r_2),
    .structure1_output_data(structure1_output_data_wire),
    .output_vld(structure1_output_vld),
    .finish(structure1_fc3finish)
    );
    
    //第二层的运算结果存储在structure1_fc2output中
    
    //////////////////////////////////////////////////////////////////////////////////////、
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////
    structure2_fc1  structure2_fc1(
    .clk(clk),
    .rst_n(rst_n),
    .valid(valid),
    .data(structure2_fc1_data),
    .mode(mode),
    //.data_1_test(structure2_fc1_data_1_test)    
    //.data_out_r3_test(data_out_r3_test),
    .data_out(structure2_fc1_data_out),
    .W_en(structure2_fc1_W_en),
    .dataaddra(structure2_fc1_dataaddr),
    .out_en_r(structure2_fc1_writeen),
    .dataaddrin_r(structure2_fc1_writeaddr),
    .finish(structure2_fc1tofc2)
   // .fc2en(fc1entofc2en),
   // .fc2data(fc1datatofc2data)
    );
    
structure2_fc1tofc2bram  structure2_fc1tofc2bram(
.clk(clk),
.rst_n(rst_n),
.fc1en(structure2_fc1_writeen),
.fc2en(structure2_fc2_W_en),
.fc1dataaddrin_r(structure2_fc1_writeaddr),
.fc2dataaddr( structure2_fc2_Wdataaddra),
.fc1datain(structure2_fc1_data_out),
.fc2dataout(structure2_fc2_data_in)
);
 


    
    structure2_fc2 structure2_fc2(
     .clk(clk),
    .rst_n(rst_n),
    .valid( structure2_fc1tofc2),
//    .data_1_test_2(data_1_test_2),    
//    .data_out_r3_test_2(data_out_r3_test_2),
//   .data_out(structure2_fc2_data_out),
    .W_en(structure2_fc2_W_en),
    .dataaddra(structure2_fc2_Wdataaddra),
    .data(structure2_fc2_data_in),
//    .out_en_r(out_en_r_2),
//    .dataaddrin_r(dataaddrin_r_2),
    .structure2_output_data(structure2_output_data_wire),
    .output_vld(structure2_output_vld),
    .finish(structure2_fc3finish)
    );

   
endmodule
