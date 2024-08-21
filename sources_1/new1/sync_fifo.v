`timescale 1ns / 1ps

module sync_fifo #(
    parameter FIFO_WIDTH = 64,
    parameter FIFO_DEPTH = 256
) (
    input                           clk,
    input                           rst_n,

    input                           rd_en,
    input                           wr_en,
    input   [FIFO_WIDTH-1 : 0]      wr_data,

    output  reg [FIFO_WIDTH-1 : 0]  rd_data,
    output  reg                     valid,
    output                          full,
    output                          empty
);

    wire    [$clog2(FIFO_DEPTH) - 1 : 0]    rd_addr;
    wire    [$clog2(FIFO_DEPTH) - 1 : 0]    wr_addr;
    reg     [$clog2(FIFO_DEPTH)     : 0]    rd_addr_ptr;
    reg     [$clog2(FIFO_DEPTH)     : 0]    wr_addr_ptr;

    assign rd_addr  = rd_addr_ptr[$clog2(FIFO_DEPTH) - 1 : 0];
    assign wr_addr  = wr_addr_ptr[$clog2(FIFO_DEPTH) - 1 : 0];

    reg [FIFO_WIDTH-1:0] fifo_mem [FIFO_DEPTH -1:0];

    integer i;
    //************************************
    // write fifo data
    //************************************
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
        end
        else begin
            if(wr_en && (~full)) begin
                fifo_mem[wr_addr] <= wr_data;
            end
        end
    end
    //************************************
    // read fifo data
    //************************************
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            rd_data <= {FIFO_WIDTH{1'b0}};
            valid   <= 1'b0;
        end
        else begin
            if(rd_en && (~empty)) begin
                rd_data <= fifo_mem[rd_addr];
                valid   <= 1'b1;
            end
            else begin
                valid   <= 1'b0;
            end
        end
    end
    //************************************
    // write addr control
    //************************************
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wr_addr_ptr <= {($clog2(FIFO_DEPTH)+1){1'b0}};
        end
        else begin
            if (wr_en && (~full))
                wr_addr_ptr <= wr_addr_ptr + 1'b1;
            else 
                wr_addr_ptr <= wr_addr_ptr;
        end
    end
    //************************************
    // read addr control
    //************************************
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            rd_addr_ptr <= {($clog2(FIFO_DEPTH)+1){1'b0}};        
        end
        else begin
            if(rd_en && (~empty)) 
                rd_addr_ptr <= rd_addr_ptr + 1'b1;
            else
                rd_addr_ptr <= rd_addr_ptr;
        end
    end
    
    
    reg [$clog2(FIFO_DEPTH) -1:0] data_avail;
    reg [$clog2(FIFO_DEPTH) -1:0] room_avail;
    
    //data_avail judge full
    always @ (*) begin
        if (wr_addr_ptr[$clog2(FIFO_DEPTH)] != rd_addr_ptr[$clog2(FIFO_DEPTH)])begin  
            if (wr_addr == rd_addr)
                data_avail = FIFO_DEPTH - 1'b1;
            else
                data_avail = FIFO_DEPTH-(rd_addr - wr_addr);
            end
        else begin
                data_avail = wr_addr - rd_addr;
        end
    end
    
    //room_avail judge empty
    always @ (*) begin
        if (rd_addr_ptr[$clog2(FIFO_DEPTH)] == wr_addr_ptr[$clog2(FIFO_DEPTH)]) begin
            if (wr_addr == rd_addr)
                room_avail = FIFO_DEPTH-1'b1;
            else
                room_avail = FIFO_DEPTH -(wr_addr - rd_addr);
        end
        else
                room_avail = rd_addr - wr_addr;
    end
    //************************************
    // full , empty judgement
    //************************************
    assign full         = ((rd_addr == wr_addr) && (rd_addr_ptr[$clog2(FIFO_DEPTH)] != wr_addr_ptr[$clog2(FIFO_DEPTH)]));
    assign empty        = (rd_addr_ptr == wr_addr_ptr); 
   
      
endmodule