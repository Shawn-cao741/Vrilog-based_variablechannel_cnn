`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 14:34:08
// Design Name: 
// Module Name: npu_my
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
    input sys_clk,                  // input clk from ps
    input rst_n,                    // reset
    input cal_start,                // npu start calculation when cal_start pulls up for 1 cycle
    input mode,                     // reconfigurable signal
    output reg [15:0] output_data,  // inference results (2 8bit numbers)
    output reg output_vld           // pulls up for 1 cycle when outputing output_data
    );

    reg [19:0] conv_cnt;
    reg cal_start_reg;
    reg [6:0]output_cnt;

    always @(posedge sys_clk, negedge rst_n) begin
        if (!rst_n) begin
            output_data <= 16'd0;
            output_vld <= 1'd0;
            conv_cnt <= 20'd0;
            output_cnt <= 7'd0;
            cal_start_reg <= 1'b0;
        end
        else begin
            if(cal_start) begin
                cal_start_reg <= cal_start;
            end
            else begin
                if (cal_start_reg) begin
                    if (conv_cnt == 20'd204800) begin
                        conv_cnt <= 20'd0;
                        if(mode) begin
                            output_data <= 16'b0111_0000_0000_1111;
                            output_cnt <= output_cnt + 1;
                            if(output_cnt == 7'd42) begin
                                cal_start_reg <= 1'b0;
                                output_cnt <= 7'd0;
                            end
                            output_vld <= 1'd1;
                        end 
                        else begin
                            output_data <= 16'b0011_0000_1000_1111;
                            output_cnt <= output_cnt + 1;
                            if(output_cnt == 7'd42) begin
                                cal_start_reg <= 1'b0;
                                output_cnt <= 7'd0;
                            end
                            output_vld <= 1'd1;
                        end
                    end
                    else begin
                        conv_cnt <= conv_cnt + 1;
                        output_vld <= 1'd0;
                        output_data <= 16'd0;
                    end
                end
                else begin
                    output_vld <= 1'd0;
                    output_data <= 16'd0;
                end
            end
        end
    end
    
endmodule
