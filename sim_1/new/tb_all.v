`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/29 10:15:39
// Design Name: 
// Module Name: tb_all
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


module tb_all(

    );
    reg clk;
    reg rst_n;
    reg mode;
    reg start;
    wire[15:0]output_data;
    wire output_vld;
    
    always #20 clk=~clk;
    initial 
    #40
    begin
    clk=1;
    rst_n=1;
    mode=0;
    start=0;
    end
    initial 
    begin
    #40;
    rst_n=0;
    #40;
    rst_n=1;  
    start=1;
    
    
    
    
    
    end
    
    
    npu_top npu_top
    (
    .clk(clk),
    .rst_n(rst_n),
    .mode(mode),
    .start(start),
    .output_data(output_data),
    .output_vld(output_vld)
    );
    
    
endmodule
