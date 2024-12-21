`timescale 100ps/100ps

module carry4(
    input[3:0] p,
    input[3:0] g,
    input cin,
    output bp,
    output bg,
    output[2:0] cout
);

assign bp = &p;
assign bg = g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]);

assign cout[0] = g[0]|(p[0]&cin);
assign cout[1] = g[1]|(p[1]&g[0])|(p[1]&p[0]&cin);
assign cout[2] = g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin);

endmodule

module add_tc_16_16(
    input[31:0] a,
    input[31:0] b,
    output[32:0] sum
);

wire cin;
assign cin = 1'b0;

wire[31:0] c;
wire[31:0] p,g;
assign p = a|b;
assign g = a&b;

wire[7:0] bp,bg;

genvar i;
generate
for(i = 0; i < 8; i = i + 1)
begin
carry4 c(
    .p(p[i*4+3:i*4]),
    .g(g[i*4+3:i*4]),
    .cin(c[i*4]),
    .bp(bp[i]),
    .bg(bg[i]),
    .cout(c[i*4+3:i*4+1])
);
end
endgenerate

wire[1:0] bbp;
wire[1:0] bbg;
assign c[0] = cin;
assign c[16] = bbg[0]|(bbp[0]&cin);

carry4 bc0(
    .p(bp[3:0]),
    .g(bg[3:0]),
    .cin(c[0]),
    .bp(bbp[0]),
    .bg(bbg[0]),
    .cout({c[12],c[8],c[4]})
);
carry4 bc1(
    .p(bp[7:4]),
    .g(bg[7:4]),
    .cin(c[16]),
    .bp(bbp[1]),
    .bg(bbg[1]),
    .cout({c[28],c[24],c[20]})
);

wire z;
wire[31:0] y;
assign y = (~a&~b&c)|(~a&b&~c)|(a&~b&~c)|(a&b&c);
assign z = bbg[1]|(bbp[1]&bbg[0])|(bbp[1]&bbp[0]&cin);
//assign z = (a[31]&b[31])|(a[31]&c[31])|(b[31]&c[31]);
assign sum = {z,y};

endmodule
