`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 19:26:23
// Design Name: 
// Module Name: cnnlayer2
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
// 5.26日志：第二成卷积的速度比第一层快，需要降频或者减少计算单元时分复用
//////////////////////////////////////////////////////////////////////////////////


module cnnlayer2(
input wire clk,
input wire global_rst,
input wire flag,
input wire cal_start,
input wire [16:0] activationlayer21,
input wire [16:0] activationlayer22,
input wire [16:0] activationlayer23,
input wire [16:0] activationlayer24,
output        wire end_conlay2,
output        wire valid_conv2 ,
output        wire [10:0]outcount2 ,
output        wire[7:0]  data_outm1,
output        wire [7:0]data_outm2,
output        wire [7:0] data_outm3,
output        wire  [7:0]data_outm4,
output        wire[7:0]  data_outm5,
output        wire [7:0] data_outm6,
output        wire [7:0] data_outm7,
output        wire  [7:0]data_outm8,
//output        wire[23:0]  data_outm9,
//output        wire [23:0] data_outm10,
//output        wire [23:0] data_outm11,
//output        wire  [23:0]data_outm12,
//output        wire[23:0]  data_outm13,
//output        wire [23:0] data_outm14,
//output        wire [23:0] data_outm15,
//output        wire  [23:0]data_outm16,
output        wire readytostart2,
output       wire  [31:0] maxoutlayer2out,
output        wire [11:0] addract // data地址信号（10位）
    );
    
parameter n = 16'd2562;     // activation map size->input size
parameter k = 9'd3;     // kernel size 
parameter step =2;
parameter outlenper=13'd30;
parameter outlenall=13'd1260;
parameter inchan=7'd4;
parameter outchan=7'd8;

////////////声明参数
    wire [7:0] biastep;
    wire [8*inchan*outchan-1:0] bias;
    wire [7:0]weighttep;
    wire [(8*k*inchan*outchan)-1:0] weight;
    
    //wire [14:0] addract; // data地址信号（10位）
    wire [6:0] addrwet; // weight地址信号（10位）
    wire [4:0] addrbias;//
    
    
    wire [16:0] activationlayer2[0:inchan-1];
    reg [31:0] counterweight = 0;
    reg [31:0] counterdata=0;
    reg [31:0] counterbias=0;

wire signed [31:0] data_out[0:(inchan*outchan)-1];
wire signed  [31:0] data_outtep[0:outchan-1];

 wire ready;
 
assign readytostart2=flag?ready:0;




assign activationlayer2 [0][16:0] =activationlayer21 ; 
assign activationlayer2 [1][16:0] =activationlayer22 ; 
assign activationlayer2 [2][16:0] =activationlayer23 ; 
assign activationlayer2 [3][16:0] =activationlayer24 ; 
 

generate 
genvar out;
for(out=0;out<outchan;out=out+1)
begin
assign data_outtep[out]=data_out[out*inchan]+data_out[out*inchan+1]+data_out[out*inchan+2]+data_out[out*inchan+3];

end
endgenerate



reg signed [31:0] max;
genvar maxc;
    generate 
        for(maxc=0;maxc<8;maxc = maxc +1)
        begin: Find_max
            always@(posedge clk or posedge global_rst)begin
                if(global_rst)begin 
                    max <= 32'd0;
                end
                else if(data_outtep[maxc]>max)begin 
                        max <= data_outtep[maxc];
                end
                else begin 
                    max <= max;
                end
             end
        end
    endgenerate
assign maxoutlayer2out=max;














relucutto8 act1(valid_conv2,data_outtep[0],data_outm1);
relucutto8 act2(valid_conv2,data_outtep[1],data_outm2);
relucutto8 act3(valid_conv2,data_outtep[2],data_outm3);
relucutto8 act4(valid_conv2,data_outtep[3],data_outm4);
relucutto8 act5(valid_conv2,data_outtep[4],data_outm5);
relucutto8 act6(valid_conv2,data_outtep[5],data_outm6);
relucutto8 act7(valid_conv2,data_outtep[6],data_outm7);
relucutto8 act8(valid_conv2,data_outtep[7],data_outm8);
//relu act9(valid_conv,data_outtep[8],data_outm9);
//relu act10(valid_conv,data_outtep[9],data_outm10);
//relu act11(valid_conv,data_outtep[10],data_outm11);
//relu act12(valid_conv,data_outtep[11],data_outm12);
//relu act13(valid_conv,data_outtep[12],data_outm13);
//relu act14(valid_conv,data_outtep[13],data_outm14);
//relu act15(valid_conv,data_outtep[14],data_outm15);
//relu act16(valid_conv,data_outtep[15],data_outm16);

//assign data_outm1=valid_conv2?data_outtep[0]:0;
//assign data_outm2=valid_conv2?data_outtep[1]:0;
//assign data_outm3=valid_conv2?data_outtep[2]:0;
//assign data_outm4=valid_conv2?data_outtep[3]:0;
//assign data_outm5=valid_conv2?data_outtep[4]:0;
//assign data_outm6=valid_conv2?data_outtep[5]:0;
//assign data_outm7=valid_conv2?data_outtep[6]:0;
//assign data_outm8=valid_conv2?data_outtep[7]:0;
//assign data_outm9=valid_conv2?data_outtep[8]:0;
//assign data_outm10=valid_conv2?data_outtep[9]:0;
//assign data_outm11=valid_conv2?data_outtep[10]:0;
//assign data_outm12=valid_conv2?data_outtep[11]:0;
//assign data_outm13=valid_conv2?data_outtep[12]:0;
//assign data_outm14=valid_conv2?data_outtep[13]:0;
//assign data_outm15=valid_conv2?data_outtep[14]:0;
//assign data_outm16=valid_conv2?data_outtep[15]:0;



 
 
 
 
 
 
    
generate
genvar i;
genvar j;
for(i = 0;i<outchan-1;i=i+1)begin
for(j = 0;j<inchan;j=j+1)
begin: CONV2
//(* use_dsp = "yes" *)               //this line is optional depending on tool behaviour
convolverlayer2 #(k,step,outlenper,outlenall)uut1 (
        .clk(clk), 
        .ce(readytostart2), 
        //.ce(ce),
        .weight1(weight[(i*inchan+j)*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activationlayer2[j]), 
        .bias(bias[(i*inchan+j)*8+:8]), 
        //.end_activate(end_activate[i]), 
        .data_out(data_out[(i*inchan+j)])
//        .valid_conv(valid_conv[i]),
//        .outcount1(outcount1[i])  
        //.conv_op(conv_op)
    );
end 
end
//end 
endgenerate
 ///////////////////////////////////////////////////////////////逐个例化
 
//clk8 ck8( 
//.clk(clk),
//.clk8(clk8)
//    );
  
    convolverlayer2 #(k,step,outlenper,outlenall)uutchan1 (
        .clk(clk), 
        .ce(readytostart2), 
        //.ce(ce),
        .weight1(weight[(28)*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activationlayer2[0]), 
        .bias(bias[(28)*8+:8]), 
        //.end_activate(end_activate[chan-1]), 
        .data_out(data_out[28])
         //.valid_conv(valid_conv),
        //.outcount1(outcount1),
        //.end_activate(end_conlay1)
        //.conv_op(conv_op)
    );
    
    
    convolverlayer2 #(k,step,outlenper,outlenall)uutchan2 (
       .clk(clk), 
        .ce(readytostart2), 
        //.ce(ce),
        .weight1(weight[(29)*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activationlayer2[1]), 
        .bias(bias[(29)*8+:8]), 
        //.end_activate(end_activate[chan-1]), 
        .data_out(data_out[29])
         //.valid_conv(valid_conv),
        //.outcount1(outcount1),
        //.end_activate(end_conlay1)
        //.conv_op(conv_op)
    );
    
    convolverlayer2 #(k,step,outlenper,outlenall)uutchan3 (
       .clk(clk), 
        .ce(readytostart2), 
        //.ce(ce),
        .weight1(weight[(30)*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activationlayer2[2]), 
        .bias(bias[(30)*8+:8]), 
        //.end_activate(end_activate[chan-1]), 
        .data_out(data_out[30])
         //.valid_conv(valid_conv),
        //.outcount1(outcount1),
        //.end_activate(end_conlay1)
        //.conv_op(conv_op)
    );
    
    convolverlayer2 #(k,step,outlenper,outlenall)uutchan4 (
      .clk(clk), 
        .ce(readytostart2), 
        //.ce(ce),
        .weight1(weight[(31)*(8*k)+:8*k]), 
        .global_rst(global_rst), 
        .activation1(activationlayer2[3]), 
        .bias(bias[(31)*8+:8]), 
        //.end_activate(end_activate[chan-1]), 
        .data_out(data_out[31]),
         .valid_conv(valid_conv2),
        .outcount1(outcount2),
        .end_activate(end_conlay2)
        //.conv_op(conv_op)
    );
    /////////////////////////////////////////////////例化完成
    //bram 例化
     convnet2layerer2bias conv2bias2(
    .clka(clk),
    .ena(cal_start), 
    .addra(addrbias),
    .wea(0),
    .dina(0),
    .douta(biastep)
  );   
  
     convnet2layer2weight conv2weight2(
    .clka(clk),
    .ena(cal_start), 
    .addra(addrwet),
    .wea(0),
    .dina(0),
    .douta(weighttep)
  );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// assign data_outm1=valid_conv2?data_out[0]:0;
// assign data_outm2=valid_conv2?data_out[1]:0;
// assign data_outm3=valid_conv2?data_out[2]:0;
// assign data_outm4=valid_conv2?data_out[3]:0; 
// assign data_outm5=valid_conv2?data_out[4]:0; 
// assign data_outm6=valid_conv2?data_out[5]:0; 
// assign data_outm7=valid_conv2?data_out[6]:0; 
// assign data_outm8=valid_conv2?data_out[7]:0; 
// assign data_outm9=valid_conv2?data_out[8]:0; 
// assign data_outm10=valid_conv2?data_out[9]:0; 
// assign data_outm11=valid_conv2?data_out[10]:0; 
// assign data_outm12=valid_conv2?data_out[11]:0; 
// assign data_outm13=valid_conv2?data_out[12]:0; 
// assign data_outm14=valid_conv2?data_out[13]:0; 
// assign data_outm15=valid_conv2?data_out[14]:0; 
// assign data_outm16=valid_conv2?data_out[15]:0; 
            
 
    always @(posedge clk) begin
if(cal_start) begin
    counterweight <= counterweight + 1;
    counterbias   <= counterbias+1;
if(readytostart2)
    counterdata   <= counterdata+1;
//    end
end
end

//always @(posedge clk8)begin
//if(cal_start)begin
//if(ready)
//counterdata   <= counterdata+1;
//end
//end

assign addract=(counterdata<n)?counterdata:0;
assign addrwet=(counterweight<k*inchan*outchan)?counterweight:0;
assign addrbias=(counterbias<inchan*outchan)?counterbias:0;         
    
read#(8,(k*inchan*outchan)) rdweight
(.en(cal_start),.clk(clk),.global_rst(global_rst),
.indata(weighttep),
.endread(ready),
.outdata(weight));
    
    
  read#(8,inchan*outchan) rdbias
(.en(cal_start),.clk(clk),.global_rst(global_rst),
.indata(biastep),
.endread(),
.outdata(bias));    

endmodule
