`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 15:47:33
// Design Name: 
// Module Name: gpio_top
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


module gpio_top(
    input           sys_clk,
    input           rst_n,
    input   [3:0]   gpio_io_i,
    output  [47:0]  gpio_io_o
    );

    wire cal_start;
    wire rd_en;
    wire mode;
    wire npu_out_data_vld;
    wire [15:0] npu_out_data;

    gpio_interface_top gpio_interface(
        .sys_clk            (sys_clk),
        .rst_n              (rst_n),
        .cal_start          (cal_start),
        .npu_out_data_vld   (npu_out_data_vld),
        .npu_out_data       (npu_out_data),
        .out_data_rd_en     (rd_en),
        .interface_out_data (gpio_io_o)
    );

    inst_decoder decoder(
        .sys_clk            (sys_clk),
        .rst_n              (rst_n),
        .gpio_io_i          (gpio_io_i),
        .cal_start          (cal_start),
        .mode               (mode),
        .rd_en              (rd_en)
    );

    npu_top npu(
        .sys_clk            (sys_clk),          
        .rst_n              (rst_n),            
        .cal_start          (cal_start),        
        .mode               (mode),
        .output_data        (npu_out_data),
        .output_vld         (npu_out_data_vld)
    );

endmodule
