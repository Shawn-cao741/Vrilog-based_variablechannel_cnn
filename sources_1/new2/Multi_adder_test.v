`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/16 21:28:14
// Design Name: 
// Module Name: Multi_adder_test
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


module Multi_adder_test(
    input clk,rst_n,
    input weight_en,
    input Multiply_en,
    input datain_en,
    input bias_en,
    output data_out,
    output out_start,
    output out_end,
    output out_vaild
    );

    reg [14:0] data_addr;
    wire [7:0] weight;
    wire [7:0] bias;
    wire [7:0] data_in;
    reg			[6:0]				weight_addr;
    reg			[6:0]				bias_addr;

    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            weight_addr<=1'b0;
            data_addr<=1'b0;
        end
        else begin 
            if(weight_en&&datain_en)begin 
                weight_addr<=weight_addr+1'b1;
                data_addr<=data_addr+1'b1;
            end 
            else begin 
                weight_addr<=weight_addr;
                data_addr<=data_addr;
            end
        end
    end

    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            bias_addr<=1'b0;
        end
        else begin 
            if(bias_en)begin 
                bias_addr<=1'b1;
            end 
            else begin 
                bias_addr<=bias_addr;
            end
        end
    end

    // conv1weight u_conv1weight(
    //     .clka(clk),
    //     .ena(weight_en),
    //     .wea(0),
    //     .addra(weight_addr),
    //     .dina(0),
    //     .douta(weight)
    // );

    // inputdata u_inputdata(
    //     .clka(clk),
    //     .ena(datain_en),
    //     .wea(0),
    //     .addra(data_addr),
    //     .dina(0),
    //     .douta(data_in)
    // );

    // conv1bias u_conv1bias(
    //     .clka(clk),
    //     .ena(bias_en),
    //     .wea(0),
    //     .addra(bias_addr),
    //     .dina(0),
    //     .douta(bias)
    // );

    // Multiply_adder u_Multiply_adder(
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .weight_en(weight_en),
    //     //.Multiply_en(Multiply_en),
    //     .weight(weight)
    //     //.bias(bias),
    //     // .data_in(data_in),
    //     // .data_out(data_out),
    //     // .out_start(out_start),
    //     // .out_end(out_end),
    //     // .out_vaild(out_vaild)
    // );


endmodule
