`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 22:14:52
// Design Name: 
// Module Name: cnn1tocnn2bram
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


module cnn1tocnn2bram(
input wire clk,
input wire global_rst,
input wire write_start,
input wire write_valid,
input wire read_start,
input wire [11:0]writeaddr1,
input wire [15:0]readaddr,
input wire [7:0] data_inm1,
input wire [7:0] data_inm2,
input wire [7:0]data_inm3,
input wire [7:0] data_inm4,
output wire [7:0] data_outm1,
output wire [7:0] data_outm2,
output wire [7:0]data_outm3,
output wire [7:0] data_outm4

    );
    
    
    wire  [11:0] writeaddr;
    assign writeaddr=writeaddr1-1;
 conv12conv2_1 bramchan1(   
  .clka(clk),
  .ena(write_start),
  .wea(write_valid),
  .addra(writeaddr),
  .dina(data_inm1),
  .douta(),
  .clkb(clk),
  .enb(read_start),
  .web(0),
  .addrb(readaddr),
  .dinb(),
  .doutb(data_outm1)   
    );
    
  con12conv2_2 bramchan2(   
  .clka(clk),
  .ena(write_start),
  .wea(write_valid),
  .addra(writeaddr),
  .dina(data_inm2),
  .douta(),
  .clkb(clk),
  .enb(read_start),
  .web(0),
  .addrb(readaddr),
  .dinb(),
  .doutb(data_outm2)   
    );
    
    
    
    con12conv2_3 bramchan3(   
  .clka(clk),
  .ena(write_start),
  .wea(write_valid),
  .addra(writeaddr),
  .dina(data_inm3),
  .douta(),
  .clkb(clk),
  .enb(read_start),
  .web(0),
  .addrb(readaddr),
  .dinb(),
  .doutb(data_outm3)   
    );
    
    con12conv2_4 bramchan4(   
  .clka(clk),
  .ena(write_start),
  .wea(write_valid),
  .addra(writeaddr),
  .dina(data_inm4),
  .douta(),
  .clkb(clk),
  .enb(read_start),
  .web(0),
  .addrb(readaddr),
  .dinb(),
  .doutb(data_outm4)   
    );  
    
    
endmodule
