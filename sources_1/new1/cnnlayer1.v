`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 15:46:52
// Design Name: 
// Module Name: cnnlayer1
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


module cnnlayer1(
input wire clk,
input wire global_rst,
input wire cal_start,
//output wire [7:0] convlay1_dataout,
output        wire end_conlay1,
output        wire valid_conv ,
output        wire [11:0]outcount1 ,
output        wire[7:0]  data_outm1,
output        wire [7:0] data_outm2,
output        wire [7:0] data_outm3,
output        wire  [7:0]data_outm4
    );
parameter n = 16'd21504;     // activation map size->input size
parameter k = 9'd32;     // kernel size 
parameter step =8;
parameter outlenper=13'd61;
parameter outlenall=13'd2562;
parameter chan=7'd4;
    
////////////声明参数
    wire [7:0] biastep;
    wire signed [8*chan-1:0] bias;
    wire [7:0]weighttep;
    wire [(8*k*chan)-1:0] weight;
    wire [14:0] addract; // data地址信号（10位）
    wire [6:0] addrwet; // weight地址信号（10位）
    wire [1:0] addrbias;//
    wire [7:0] activation1;
    reg [31:0] counterweight = 0;
    reg [31:0] counterdata=0;
    reg [31:0] counterbias=0;
    
    
//    wire valid_conv ;
//    wire outcount1  ;
    wire [7:0] data_out[0:chan];
   // wire end_activate[0:chan];
    wire ready;
    
    
    
    
    
 //////模块例化
generate
genvar i;
for(i = 0;i<chan-1;i=i+1)
begin: CONV
//(* use_dsp = "yes" *)               //this line is optional depending on tool behaviour
convolver #(k,step,outlenper,outlenall)uut1 (
        .clk(clk), 
        .ce(ready), 
        //.ce(ce),
        .weight1(weight[i*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activation1), 
        .bias(bias[i*8+:8]), 
        //.end_activate(end_activate[i]), 
        .data_out(data_out[i])
//        .valid_conv(valid_conv[i]),
//        .outcount1(outcount1[i])  
        //.conv_op(conv_op)
    );
end 
//end 
endgenerate
 
 convolver #(k,step,outlenper,outlenall)uutchan (
        .clk(clk), 
        .ce(ready), 
        //.ce(ce),
        .weight1(weight[(chan-1)*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activation1), 
        .bias(bias[(chan-1)*8+:8]), 
        //.end_activate(end_activate[chan-1]), 
        .data_out(data_out[chan-1]),
         .valid_conv(valid_conv),
        .outcount1(outcount1),
        .end_activate(end_conlay1)
        //.conv_op(conv_op)
    );
 
 
 
 

    
inputdata inputdata1(
    .clka(clk),
    .ena(ready), 
    .addra(addract),
    .wea(0),
    .dina(0),
    .douta(activation1)
  );
  ////////conv1bias convnet2layer1bias
  convnet2layer1bias conv2bias1(
    .clka(clk),
    .ena(cal_start), 
    .addra(addrbias),
    .wea(0),
    .dina(0),
    .douta(biastep)
  );   
  ////////conv1weight  convnet2layer1weight
     convnet2layer1weight conv2weight1(
    .clka(clk),
    .ena(cal_start), 
    .addra(addrwet),
    .wea(0),
    .dina(0),
    .douta(weighttep)
  );
  
  
//  conv12conv2_1 b1 (
//  .clka(clk),
//    .ena(1),//读使能在fc2模块
//    .wea(valid_conv[1]),
//    .addra(outcount1[1]),
//    .dina(data_out[0]),
   
//    .clkb(clk),
//    .web(0),
//    .enb(fc2en),
//    .addrb(fc2dataaddr),
//    .doutb(fc2dataout)   
//  );
 assign data_outm1=valid_conv?data_out[0]:0;
 assign data_outm2=valid_conv?data_out[1]:0;
 assign data_outm3=valid_conv?data_out[2]:0;
 assign data_outm4=valid_conv?data_out[3]:0; 
    
    always @(posedge clk) begin
if(cal_start) begin
    counterweight <= counterweight + 1;
    counterbias   <= counterbias+1;
if(ready)
    counterdata   <= counterdata+1;
    end
end

assign addract=(counterdata<n)?counterdata:0;
assign addrwet=(counterweight<k*chan)?counterweight:0;
assign addrbias=(counterbias<chan)?counterbias:0;
//assign end_conlay1=(outcount1==outlen)?1:0;

read#(8,(k*chan)) rdweight
(.en(cal_start),.clk(clk),.global_rst(global_rst),
.indata(weighttep),
.endread(ready),
.outdata(weight));
    
    
  read#(8,chan) rdbias
(.en(cal_start),.clk(clk),.global_rst(global_rst),
.indata(biastep),
.endread(),
.outdata(bias));




      
    
    
endmodule
