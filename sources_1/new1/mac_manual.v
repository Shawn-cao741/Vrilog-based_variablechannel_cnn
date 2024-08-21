module mac_manual(
    input clk,sclr,ce,
    input signed  [7:0] a,
    input signed  [7:0] b,
    input signed  [23:0] c,
    output signed  [23:0] p
    );
    //wire [15:0] sum;
    //wire [15:0] m;
    //reg sig ;
    //reg signed [15:0] multiplytemp;
    reg signed  [23:0] ptmp;
//qmult #(4,8) mul(a,b,m);
//qadd  #(16,32) add(m,c,sum);
 always@(posedge clk,posedge sclr)
 begin
 
 if(sclr)
 begin
 ptmp<=0;
 //sig<=0;
 //multiplytemp<=0;
 end
 else if(ce)
 begin
//p <= sum;
//sig<=xor(a[7],b[7]);
//multiplytemp<=(sig)?():({sig,a[6:0]*b[6:0]})
if((a==0)|(b==0))
//multiplytemp<=0;
ptmp <= c;
else begin
//multiplytemp<=a*b;
 ptmp <= (a*b+c);
end
 end
 end
 assign p=ptmp;
endmodule