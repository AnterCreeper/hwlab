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

module add_128(
    input[127:0] a,
    input[127:0] b,
    output[127:0] sum
);

wire cin;
assign cin = 0;

wire[127:0] c;
wire[127:0] p,g;
assign p = a|b;
assign g = a&b;

wire[31:0] bp,bg;
genvar i;
generate
for(i = 0; i < 32; i = i + 1)
begin
carry4 cgen_s0(
    .p(p[i*4+3:i*4]),
    .g(g[i*4+3:i*4]),
    .cin(c[i*4]),
    .bp(bp[i]),
    .bg(bg[i]),
    .cout(c[i*4+3:i*4+1])
);
end
endgenerate

wire[7:0] bbp,bbg;
generate
for(i = 0; i < 8; i = i + 1)
begin
carry4 cgen_s1(
    .p(bp[i*4+3:i*4]),
    .g(bg[i*4+3:i*4]),
    .cin(c[i*16]),
    .bp(bbp[i]),
    .bg(bbg[i]),
    .cout({c[i*16+12],c[i*16+8],c[i*16+4]})
);
end
endgenerate

wire[1:0] bbbp,bbbg;
generate
for(i = 0; i < 2; i = i + 1)
begin
carry4 cgen_s2(
    .p(bbp[i*4+3:i*4]),
    .g(bbg[i*4+3:i*4]),
    .cin(c[i*64]),
    .bp(bbbp[i]),
    .bg(bbbg[i]),
    .cout({c[i*64+48],c[i*64+32],c[i*64+16]})
);
end
endgenerate

assign c[0] = cin;
assign c[64] = bbbg[0]|(bbbp[0]&cin);

//wire z;
wire[127:0] y;
assign y = (~a&~b&c)|(~a&b&~c)|(a&~b&~c)|(a&b&c);
assign sum = y;

endmodule
