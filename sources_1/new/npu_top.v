`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 22:48:13
// Design Name: 
// Module Name: npu_top
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


module npu_top(
input sys_clk,
input rst_n,
input mode,
input start,
output [15:0] output_data,
output output_vld
    );
    
    
 wire structure2_end_cnn;
 wire structure1_end_cnn;   
 wire clk;
// wire[7:0]  structure1_data_outm20;
// wire[7:0]  structure1_data_outm21; 
// wire[7:0]  structure1_data_outm22; 
// wire[7:0]  structure1_data_outm22; 
// wire[7:0]  structure1_data_outm24; 
// wire[7:0]  structure1_data_outm25; 
// wire[7:0]  structure1_data_outm26; 
// wire[7:0]  structure1_data_outm27; 
// wire[7:0]  structure1_data_outm28; 
// wire[7:0]  structure1_data_outm29; 
// wire[7:0]  structure1_data_outm210; 
// wire[7:0]  structure1_data_outm211; 
// wire[7:0]  structure1_data_outm212; 
// wire[7:0]  structure1_data_outm213; 
// wire[7:0]  structure1_data_outm214; 
// wire[7:0]  structure1_data_outm215;  
    
 wire[7:0]  structure2_data_outm21; 
 wire [7:0]structure2_data_outm22;   
 wire [7:0] structure2_data_outm23;   
 wire  [7:0]structure2_data_outm24;   
 wire[7:0]  structure2_data_outm25;   
 wire [7:0]structure2_data_outm26;   
 wire [7:0] structure2_data_outm27;   
 wire [7:0] structure2_data_outm28;   
 wire [10:0] structure2_outcount2;     
 wire   structure2_valid_out;
 wire end_cnnbm;
 wire structure1_end_cnnbm; 
 wire structure2_end_cnnbm; 
 assign end_cnnbm=(mode==1)?structure1_end_cnnbm:structure2_end_cnnbm;
 wire[7:0] data_outcnn;
 wire[7:0] structure1_data_outcnn;
 wire[7:0] structure2_data_outcnn;
  assign data_outcnn=(mode==1)?structure1_data_outcnn:structure2_data_outcnn;
  wire W_en;
  wire structure2_W_en;
  assign structure2_W_en=(mode==0)?W_en:0;
  wire structure1_W_en;
  assign structure1_W_en=(mode==1)?W_en:0;
  wire[5:0]num;
  wire[10:0]bramaddr;
  
  clk_wiz_0 u_clk_wiz_0(
        .clk_out1(clk),
        .resetn(rst_n),
        .clk_in1(sys_clk)

  
  );
  
  CNN_test convnet1(
  .clk(clk),
  .rst_n(rst_n),
  .valid(start),
  .w_en(structure1_W_en),
  .num(num),
  .bramaddre(bramaddr),
  .conv2_end( structure1_end_cnnbm),
  .data_out(structure1_data_outcnn)
  
  
  
  
  );
  
  
  cnn convnet2(
.clk(clk),
 .global_rst(!rst_n),
 .cal_start(start),
 .end_cnn(structure2_end_cnn),
 .data_outm21(structure2_data_outm21),
.data_outm22(structure2_data_outm22),
.data_outm23(structure2_data_outm23),
.data_outm24(structure2_data_outm24),
.data_outm25(structure2_data_outm25),
.data_outm26(structure2_data_outm26),
.data_outm27(structure2_data_outm27),
.data_outm28(structure2_data_outm28),
.outcount2 (structure2_outcount2),
.valid_out(structure2_valid_out)
    );
    

    
    
    
  cnnoutbm structure2_cnnoutbm(
  .clk(clk),
  .global_rst(!rst_n),
  .write_start(1),
  .end_write(structure2_end_cnn),
  .write_valid(structure2_valid_out),
  .writeaddr1(structure2_outcount2),
  .read_start(structure2_W_en),
  .i(num),
  .readaddrram(bramaddr),
  .data_inb21(structure2_data_outm21),
  .data_inb22(structure2_data_outm22),
  .data_inb23(structure2_data_outm23),
  .data_inb24(structure2_data_outm24),
  .data_inb25(structure2_data_outm25),
  .data_inb26(structure2_data_outm26),
  .data_inb27(structure2_data_outm27),
  .data_inb28(structure2_data_outm28),
  .data_outcnn(structure2_data_outcnn),
  .end_cnnbm(structure2_end_cnnbm)
  );
  
  fcc_connect fcc_connect(
  .clk(clk),
  .rst_n(rst_n),
  .valid(end_cnnbm),
  .mode(mode),
  .fc1_data(data_outcnn),
  .fc1_W_en(W_en),
  .bramnum(num),
  .bramaddr(bramaddr),
  .output_data(output_data),
  .output_vld(output_vld)

  );
  
  
endmodule
