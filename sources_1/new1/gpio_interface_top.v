`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 13:27:51
// Design Name: 
// Module Name: gpio_interface_top
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


module gpio_interface_top#(
        parameter BATCH_NUM = 42,
        parameter NPU_OUTPUT_WIDTH = 16,
        parameter OUTPUT_WIDTH = 48,
        parameter FIFO_WIDTH = 48,
        parameter FIFO_DEPTH = 16
    )(
        input   sys_clk,
        input   rst_n,
        input   cal_start,
        input   npu_out_data_vld,
        input   [NPU_OUTPUT_WIDTH-1 : 0] npu_out_data,
        input   out_data_rd_en,
        output reg [OUTPUT_WIDTH-1 : 0] interface_out_data
    );
    
    reg fifo_wr_en;
    reg  [OUTPUT_WIDTH-1 : 0] fifo_wr_data;
    wire  [OUTPUT_WIDTH-1 : 0] fifo_rd_data;
    sync_fifo #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )
    sync_fifo_inst
    (
        .clk            (sys_clk           ),
        .rst_n          (rst_n             ),
        .rd_en          (out_data_rd_en    ),
        .wr_en          (fifo_wr_en        ),
        .wr_data        (fifo_wr_data      ),
        .rd_data        (fifo_rd_data      ),
        .valid          (fifo_rd_data_vld  ),
        .full           (fifo_full         ),
        .empty          (fifo_empty        )
    );
    
    localparam IDLE            = 4'b1;
    localparam CALCULATE       = 4'b10;
    localparam RD_CLASS_RESULT = 4'b100;
    localparam RD_DATA         = 4'b1000;
    reg [3:0] n_state;
    reg [3:0] c_state;
    
    always @(posedge sys_clk or negedge rst_n) begin
        if(~rst_n) begin
            c_state <= IDLE;
        end
        else begin
            c_state <= n_state;
        end
    end
    
    reg [6:0] batch_cnt;
    reg [6:0] out_cnt;
    reg [2:0] shift_cnt;
    reg [OUTPUT_WIDTH-1 : 0] class_result;
    always @(posedge sys_clk or negedge rst_n) begin
        if(~rst_n) begin
            interface_out_data <= {(OUTPUT_WIDTH){1'b0}};
            fifo_wr_data <= {(OUTPUT_WIDTH){1'b0}};
            class_result <= {(OUTPUT_WIDTH){1'b0}};
            fifo_wr_en <= 1'b0;
            shift_cnt <= 3'b0;
            batch_cnt <= 7'b0;
            out_cnt <= 7'b0;
        end
        else begin
            case(c_state)
                IDLE: begin
//                    interface_out_data <= {(OUTPUT_WIDTH){1'b0}};
                    fifo_wr_data <= {(OUTPUT_WIDTH){1'b0}};
                    class_result <= {(OUTPUT_WIDTH){1'b0}};
                    fifo_wr_en <= 1'b0;
                    shift_cnt <= 3'b0;
                    batch_cnt <= 7'b0;
                    out_cnt <= 7'b0;
                end
                CALCULATE: begin
                    interface_out_data <= {(OUTPUT_WIDTH){1'b0}};
                    if(npu_out_data_vld) begin
                        batch_cnt <= batch_cnt+1'b1;
                        if(npu_out_data[15] == npu_out_data[7]) begin
                            if(npu_out_data[14:8] > npu_out_data[6:0]) begin
                                class_result <= {class_result[OUTPUT_WIDTH-2 : 0], 1'b1};
                            end
                            else begin
                                class_result <= {class_result[OUTPUT_WIDTH-2 : 0], 1'b0};
                            end
                        end
                        else begin
                            if(npu_out_data[15] == 1'b0) begin
                                class_result <= {class_result[OUTPUT_WIDTH-2 : 0], 1'b1};
                            end
                            else begin
                                class_result <= {class_result[OUTPUT_WIDTH-2 : 0], 1'b0};
                            end
                        end
                        
                        fifo_wr_data <= {fifo_wr_data[OUTPUT_WIDTH-NPU_OUTPUT_WIDTH-1 : 0], npu_out_data};
                        if(shift_cnt == 3'd2) begin
                            shift_cnt <= 3'b0;
                            fifo_wr_en <= 1'b1;
                        end
                        else begin
                            shift_cnt <= shift_cnt+1'b1;
                            fifo_wr_en <= 1'b0;
                        end
                    end
                    else begin
                        fifo_wr_en <= 1'b0;
                    end
                end
                RD_CLASS_RESULT: begin
                    interface_out_data <= class_result;
                end
                RD_DATA: begin
                    if(fifo_rd_data_vld)begin
                        interface_out_data <= fifo_rd_data;
                        out_cnt <= out_cnt + 1'b1;
                    end
                end
            endcase 
        end
    end
    
    always @(*) begin
        case(c_state)
            IDLE: begin
                n_state = cal_start ? CALCULATE : IDLE;
            end
            CALCULATE: begin
                n_state = (batch_cnt == BATCH_NUM) ? RD_CLASS_RESULT : CALCULATE;
            end
            RD_CLASS_RESULT: begin
                n_state = out_data_rd_en ? RD_DATA : RD_CLASS_RESULT;
            end
            RD_DATA: begin
                n_state = (out_cnt == BATCH_NUM/3) ? IDLE : RD_DATA;
            end
            default:begin
                n_state = IDLE;
            end
        endcase
    end
    
endmodule
