`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 20:52:21
// Design Name: 
// Module Name: Conv1_outdata
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


module Conv1_outdata(
    input conv_end,
    input clk,rst_n,
    input [31:0] conv1_output,

    output wea,ena,
    output [11:0] addra,
    output [7:0] data_0,
    output [7:0] data_1,
    output [7:0] data_2,
    output [7:0] data_3

    );

    reg [11:0] cnt_addra = 12'd0;
    // wire [7:0] data_0;
    // wire [7:0] data_1;
    // wire [7:0] data_2;
    // wire [7:0] data_3;
    // wire wea;
    // wire ena;

    reg w_en;
    reg e_en;

    reg w_en_r;
    reg e_en_r;

    assign data_0 = conv1_output[7:0];
    assign data_1 = conv1_output[15:8];
    assign data_2 = conv1_output[23:16];
    assign data_3 = conv1_output[31:24];

    assign wea = w_en;
    assign ena = e_en;

    //地址
    always@(posedge conv_end)begin 
        if(!rst_n)begin 
            cnt_addra <= 6'd0;
        end
        else if (cnt_addra<12'd2562)begin 
            cnt_addra <= cnt_addra + 1'd1;
        end
        else begin 
            cnt_addra <= cnt_addra;
        end
    end

    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         cnt_addra <= 6'd0;
    //     end
    //     else  begin 
    //         cnt_addra <= cnt_addra;
    //     end
    // end

    //数据写使能
    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         w_en_r <= 1'b0;
    //         e_en_r <= 1'b0;
    //     end
    //     else begin 
    //         w_en_r <= w_en_r;
    //         e_en_r <= e_en_r;
    //     end
    // end

    always@(posedge conv_end)begin 
        if(!rst_n)begin 
            w_en <= 1'b0;
            e_en<= 1'b0;
        end
        else if((cnt_addra<12'd2562))begin 
            w_en <= 1'b1;
            e_en <= 1'b1;
        end
        else begin 
            w_en <= 1'b0;
            e_en <= 1'b0;
        end
    end

    // always@(posedge clk or negedge rst_n)begin 
    //     if(!rst_n)begin 
    //         w_en <= 1'b0;
    //         e_en <= 1'b0;
    //     end
    //     else begin 
    //         w_en <= w_en_r;
    //         e_en <= e_en_r;
    //     end
    // end
    assign addra = cnt_addra - 12'd1;







endmodule
