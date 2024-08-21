`timescale 1ns / 1ps

module convolver(clk,ce,weight1,global_rst,activation1,bias,end_activate,data_out,valid_conv,outcount1,maxout);
//parameter n = 32'd512;     // activation map size->input size
parameter k = 9'd32;     // kernel size 
parameter step=4'd8;
parameter outlenper=13'd61;
parameter outlenall=13'd2562;
//parameter batch=6'd42;

input wire clk,ce,global_rst;
input wire  [7:0] activation1;
input wire signed   [7:0] bias ;
input wire   [8*k-1:0]weight1;
//output wire [8*outlen-1:0] data_out1;
output wire end_activate;
output wire [7:0] data_out;
output wire valid_conv;
output wire [11:0] outcount1;
output wire signed  [23:0] maxout;
//output wire dataout_begin;
//test pin
//output wire [15:0] conv_op;
//wire clk8;
///////////////////////////////////////////修改
//reg [7:0] data_out[0:outlen-1];
reg  [7:0]  data_outreg;
//test
reg  signed [23:0]  maxoutreg;
wire signed [23:0] tmp [0:k];

reg dataout_beginreg;

wire signed [23:0] conv_op;
wire [23:0] relu_op;
reg end_activatetem;
assign tmp[0]=0;




assign data_out=data_outreg;
assign maxout=maxoutreg;



generate
genvar i;
for(i = 0;i<k;i=i+1)
begin: MAC
//(* use_dsp = "yes" *)               //this line is optional depending on tool behaviour
mac_manual mac2(                     //implements a*b+c
  .clk(clk), // input clk
  .ce(ce), // input ce
  .sclr(global_rst), // input sclr
  .a(activation1), // activation input [15 : 0] a
  .b(weight1[8*i +: 8]), // weight input [15 : 0] b
  .c(tmp[i]), // previous mac sum input [31 : 0] c
  .p(tmp[i+1]) // output [31 : 0] p
  );
end 
//end 
endgenerate

reg [31:0] countclk;
reg [11:0] outcount;
reg [11:0] countper;
//reg [5:0]  outcountbatch;
reg en2,en3;
//reg [5:0] step;

assign outcount1=outcount;

//integer d;
always@(posedge clk) begin
if(global_rst)
begin
countclk<=32'b0;     
//countstep<=32'b0;
//outcount<=16'b0;
countper<=0;
//step<=step1;
//dataout_beginreg<=0;
en2<=1'b0;
en3<=1'b0;
//for(d=0;d<outlen;d=d+1) begin
data_outreg<=0;//end
end_activatetem<=0;
maxoutreg<=0;
end

else if(ce)
if((countclk>=k-1)) 
//由于时序问题，第一个数会在第K+1个周期出来，但是计数慢了一个周期，又要提前一个周期预防en2和poseclk一起来导致en3失效
begin
en2 <= 1'b1;
countclk<= countclk+1'b1;
end
else
begin 
en2<= 1'b0;
countclk<= countclk+1'b1;
end
end

//always @(posedge clk)begin
//if((en2==1))  begin
//if (countclk==k+countper*(k-step)+outcount*step)begin
//en3 <= 1'b1;
//outcount<=outcount+1;
//end
///////////////////////////////////////////////////////////////16:46mod
////else if (countclk!=k+1+outcount*step)
//else if (countclk!=k+countper*(k-step)+outcount*step)
//begin en3<=1'b0;
//end
//else begin
//outcount<=0;
//en3<=0; end
//end
//end
always @(posedge clk)begin
if(global_rst)
outcount<=0;

else begin

if((en2==1))  begin
    if (countclk==k+countper*(k-step)+outcount*step)
        begin
            en3 <= 1'b1;
            if(outcount==outlenall)
           outcount<=outcount;
            else 
            outcount<=outcount+1;
        end
                
/////////////////////////////////////////////////////////////16:46mod
//else if (countclk!=k+1+outcount*step)
    else
           en3<=1'b0;
                    end
 else begin
         outcount<=0;
        en3<=0; 
        end
        end
end



//end
///////////////////////////////



assign conv_op=tmp[k]+bias;
//assign end_conv = (count>= n+k)?1'b1:1'b0;
assign valid_conv = (en2&&en3);
 relu act(valid_conv,conv_op,relu_op);


always@(negedge clk) begin//改为下降沿
  if(valid_conv) 
  begin
//data_out[outcount-1]<={relu_op[15:8]};//由于时序这里在第120行outcount已经＋1
data_outreg<={relu_op[23],relu_op[15:9]};
////////////test
if(maxoutreg<conv_op)
maxoutreg<=conv_op;
 

    if(outcount==outlenper*(countper+1))begin
  //step<=k;
  countper<=countper+1;
  //end_activatetem<=1'b1;
  end
   if(outcount==outlenall)begin
   end_activatetem<=1'b1;end
  
  
  end
end
assign end_activate=end_activatetem;

endmodule
