`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 17:39:42
// Design Name: 
// Module Name: cnnoutbm
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


module cnnoutbm(
input wire clk,
input wire global_rst,
input wire write_start,
input wire write_valid,
input wire [10:0]writeaddr1,
input wire read_start,
input wire [5:0] i,//ram ±àºÅ
input wire [10:0] readaddrram,
input wire  end_write,

input wire[7:0]  data_inb21,
input wire [7:0]data_inb22,
input wire [7:0] data_inb23,
input wire  [7:0]data_inb24,
input wire[7:0]  data_inb25,
input wire [7:0] data_inb26,
input wire [7:0] data_inb27,
input wire [7:0] data_inb28,
output wire [7:0] data_outcnn,
output wire end_cnnbm

    );
    
 wire [7:0] data_in [0:7];
    assign data_in[0]=data_inb21;
    assign data_in[1]=data_inb22;
    assign data_in[2]=data_inb23;
    assign data_in[3]=data_inb24;
    assign data_in[4]=data_inb25;
    assign data_in[5]=data_inb26;
    assign data_in[6]=data_inb27;
    assign data_in[7]=data_inb28;
  wire [7:0] data_out [0:7];  
  
  assign end_cnnbm=end_write;
  
  
    wire  [10:0] writeaddr;
    assign writeaddr=writeaddr1-1'b1;  
  
    
    generate
    genvar k;
    for(k = 0;k<8;k=k+1)begin
    cnnoutbram1 outbm (
    .clka(clk),
  .ena(write_start),
  .wea(write_valid),
  .addra(writeaddr),
  .dina(data_in[k]),
  .douta(),
  .clkb(clk),
  .enb(read_start),
  .web(0),
  .addrb(readaddrram),
  .dinb(),
  .doutb(data_out[k])   
    );
   
    assign data_outcnn=data_out[i];

    end
    endgenerate
endmodule
