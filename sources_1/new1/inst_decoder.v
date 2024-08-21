`timescale 1ns / 1ps


module inst_decoder (
    input       sys_clk,
    input       rst_n,
    input [3:0] gpio_io_i,
    output reg  cal_start,
    output reg  mode,     // if you choose reconfigurable net, please use this signal to control your net structure
    output reg  rd_en
    );
     

    reg [4:0] batch_cnt;

    always @(posedge sys_clk, negedge rst_n) begin
        if(!rst_n) begin
            cal_start <= 1'b0;
            rd_en <= 1'b0;
            batch_cnt <= 5'b0;
            mode <= 1'b1;
        end
        else begin
            cal_start <= 1'b0;
            rd_en <= 1'b0;
            if(gpio_io_i == 4'd1 && batch_cnt == 5'd0) begin       // start, reverse mode and start cal
                cal_start <= 1'b1;
                mode <= ~mode;
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b0;
            end
            else if(gpio_io_i == 4'd2 && batch_cnt == 5'd1) begin  // batch 0~2
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd3 && batch_cnt == 5'd2) begin  // batch 3~5
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd4 && batch_cnt == 5'd3) begin  // mode 0, batch 9~11
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd5 && batch_cnt == 5'd4) begin  // batch 12~14
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd6 && batch_cnt == 5'd5) begin  // batch 15~17
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd7 && batch_cnt == 5'd6) begin  // batch 18~20
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd8 && batch_cnt == 5'd7) begin  // batch 21~23
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd9 && batch_cnt == 5'd8) begin  // batch 24~26
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd10 && batch_cnt == 5'd9) begin  // batch 27~29
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd11 && batch_cnt == 5'd10) begin  // batch 30~32
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd12 && batch_cnt == 5'd11) begin  // batch 33~35
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd13 && batch_cnt == 5'd12) begin  // batch 36~38
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd14 && batch_cnt == 5'd13) begin  // batch 39~41
                batch_cnt <= batch_cnt+1'b1;
                rd_en <= 1'b1;
            end
            else if(gpio_io_i == 4'd15 && batch_cnt == 5'd14) begin  // batch 39~41
                batch_cnt <= 5'b0;
                rd_en <= 1'b1;
            end
        end
    end

endmodule

