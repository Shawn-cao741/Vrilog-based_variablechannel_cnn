`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 20:45:47
// Design Name: 
// Module Name: syn_fifo
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


module syn_fifo#(
parameter DATA_WIDTH=16,
parameter ADD_WIDTH=5,
parameter remain_num='d6
    )(
    input clk,
    input rst_n,
    input rd_en,
    output reg [DATA_WIDTH-1:0] rd_data,
    output reg valid,
    input wr_en,
    input [DATA_WIDTH-1:0] wr_data,
    output full,
    output near_full,
    output empty);
    
    wire [ADD_WIDTH-1:0] rd_addr;
    wire [ADD_WIDTH-1:0] wr_addr;
    reg [ADD_WIDTH:0] rd_addr_ptr;
    reg [ADD_WIDTH:0] wr_addr_ptr;
    assign rd_addr=rd_addr_ptr[ADD_WIDTH-1:0];
    assign wr_addr=wr_addr_ptr[ADD_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] fifo_mem[{ADD_WIDTH{1'B1}}:0];
    integer i;
    always @(posedge clk or negedge rst_n)
    begin 
    if (!rst_n)
    begin 
    for (i=0;i<={ADD_WIDTH{1'b1}};i=i+1)
    fifo_mem[i]<={DATA_WIDTH{1'b0}};
    end
    else
    begin
    if (wr_en&&(~full))
    begin
    fifo_mem[wr_addr]<=wr_data;
    end
    else
    begin
    fifo_mem[wr_addr]<=fifo_mem[wr_addr];
    end
    end
    end
    always@(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
    begin
        rd_data<={DATA_WIDTH{1'b0}};
        valid<=1'b0;
        end
        else
        begin
            if(rd_en&&(~empty))
            begin
                rd_data<=fifo_mem[rd_addr];
                valid<=1'b1;
                end
             else 
             begin
                rd_data<=rd_data;
                valid<=1'b0;
                end
               end
              end
              
    always@(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
        wr_addr_ptr <= {(ADD_WIDTH+1){1'b0}};
        else
        begin
            if(wr_en&&(~full))
            wr_addr_ptr<=wr_addr_ptr+1'b1;
            else
                wr_addr_ptr<=wr_addr_ptr;
             end
          end
     always @(posedge clk or negedge rst_n)  
     begin
        if (!rst_n)
     rd_addr_ptr <={(ADD_WIDTH+1){1'b0}};
     else
     begin
     if (rd_en &&(~empty))
     rd_addr_ptr <=rd_addr_ptr+ 1'b1;
     else
     rd_addr_ptr <=rd_addr_ptr;
     end
     end
assign full =((rd_addr ==wr_addr)&&(rd_addr_ptr[ADD_WIDTH]!=wr_addr_ptr[ADD_WIDTH]));
     assign near_full=((rd_addr+remain_num)>=wr_addr) && (rd_addr_ptr[ADD_WIDTH] !=wr_addr_ptr[ADD_WIDTH]);
     assign empty =(rd_addr_ptr ==wr_addr_ptr);

      
              
    
endmodule
