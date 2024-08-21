`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 20:38:34
// Design Name: 
// Module Name: tb
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


module tb(

    );
    reg [14:0]dataaddr;
    reg mode;
    wire [5:0]bramnum;
    wire [10:0]bramaddr;
    
    search search(
    .dataaddr(dataaddr),
    .mode(mode),
    .bramnum(bramnum),
    .bramaddr(bramaddr)
    );
    
    
    initial 
    begin
   #2
  mode=1;  
    #5;
    dataaddr=15'd0;
    #10;
    dataaddr=15'd29;
    #10;
    dataaddr=15'd30;
        #10;
    dataaddr=15'd480;
        #10;
    dataaddr=15'd479;
     mode=1;  
    #5
    
    #20;
    mode=0;
    dataaddr=15'd0;
    #10;
    dataaddr=15'd29;
    #10;
    dataaddr=15'd30;
        #10;
    dataaddr=15'd480;
        #10;
    dataaddr=15'd479; 
    
    
    
    
    end
endmodule
