`timescale 100ps/100ps

module booth(
    input[2:0] a,
    input[63:0] b,
    output x,
    output[127:0] y //partial product
);

wire s;
assign s = a[2]; //sign
wire[1:0] ai;
assign ai = s ? ~a : a;

wire[2:0] z;
assign z[0] = ~(ai[0]|ai[1]); //zero
assign z[1] = ai[0]^ai[1]; //one
assign z[2] = ai[0]&ai[1]; //two

reg[127:0] res;
always @(*)
begin
    case(z)
    3'b001:
        res = 128'b0;
    3'b010:
        res = {{64{b[63]}},b}; //sign extend
    3'b100:
        res = {{63{b[63]}},b,1'b0}; //and left shift 1
    default: res = 128'bx;
    endcase
end

assign x = s;
assign y = s ? ~res : res;

endmodule

module adder(
    input[127:0] a,
    input[127:0] b,
    input[127:0] c,
    output[127:0] x,
    output[127:0] y
);

genvar i;
generate
for(i = 0; i < 128; i = i + 1)
assign {x[i],y[i]} = a[i]+b[i]+c[i];
endgenerate

endmodule

module DFF
#(
    parameter WIDTH = 32
)(
    input clk,
    input rst_n,
    input vld_in,
    input[WIDTH-1:0] a,
    output reg vld_out,
    output reg[WIDTH-1:0] x
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
        if(vld_in) x <= a;
    end
end

endmodule

module mul_signed_64(
    input clk,
    input rst_n,
    input stb, //vld_in
    input[63:0] din1,
    input[63:0] din2,
    output valid_out,
    output[127:0] dout
);

wire[2:0] vld;

wire[63:0] a, b;
DFF #(128) latch0(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(stb),
    .a({din1, din2}),
    .vld_out(vld[0]),
    .x({a, b})
);

wire[64:0] ai;
assign ai = {a,1'b0};

wire[127:0] p[32:0];
wire[127:0] cin;

genvar i;
generate
for(i = 0; i < 32; i = i + 1)
begin
booth enc(
    .a(ai[i*2+2:i*2]),
    .b(b),
    .x(cin[i*2]),
    .y(p[i])
);
assign cin[i*2+1] = 0;
end
endgenerate
assign cin[127:64] = 0;

wire[127:0] c0[11:0];
wire[127:0] s0[11:0];
genvar j;
generate
for(j = 0; j < 11; j = j + 1)
begin
adder csa_s0(.a(p[j*3]<<(j*6)), .b(p[j*3+1]<<(j*6+2)), .c(j==10?cin:(p[j*3+2]<<(j*6+4))), .x(c0[j]), .y(s0[j]));
end
endgenerate

wire[127:0] c1[8:0];
wire[127:0] s1[8:0];
generate
for(j = 0; j < 4; j = j + 1)
begin
adder csa_s1_0(.a(c0[j*3]<<1), .b(s0[j*3+1]), .c(j==3?0:(c0[j*3+2]<<1)), .x(c1[j*2]), .y(s1[j*2]));
adder csa_s1_1(.a(s0[j*3]), .b(c0[j*3+1]<<1), .c(j==3?0:s0[j*3+2]), .x(c1[j*2+1]), .y(s1[j*2+1]));
end
endgenerate

wire[127:0] c2[5:0];
wire[127:0] s2[5:0];
generate
for(j = 0; j < 3; j = j + 1)
begin
adder csa_s2_0(.a(c1[j*3]<<1), .b(s1[j*3+1]), .c(j==2?0:(c1[j*3+2]<<1)), .x(c2[j*2]), .y(s2[j*2]));
adder csa_s2_1(.a(s1[j*3]), .b(c1[j*3+1]<<1), .c(j==2?0:s1[j*3+2]), .x(c2[j*2+1]), .y(s2[j*2+1]));
end
endgenerate

wire[127:0] c3[5:0];
wire[127:0] s3[5:0];
DFF #(1536) latch1(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld[0]),
    .a({c2[0],c2[1],c2[2],c2[3],c2[4],c2[5],s2[0],s2[1],s2[2],s2[3],s2[4],s2[5]}),
    .vld_out(vld[1]),
    .x({c3[0],c3[1],c3[2],c3[3],c3[4],c3[5],s3[0],s3[1],s3[2],s3[3],s3[4],s3[5]})
);

wire[127:0] c4[3:0];
wire[127:0] s4[3:0];
generate
for(j = 0; j < 2; j = j + 1)
begin
adder csa_s3_0(.a(c3[j*3]<<1), .b(s3[j*3+1]), .c(c3[j*3+2]<<1), .x(c4[j*2]), .y(s4[j*2]));
adder csa_s3_1(.a(s3[j*3]), .b(c3[j*3+1]<<1), .c(s3[j*3+2]), .x(c4[j*2+1]), .y(s4[j*2+1]));
end
endgenerate

wire[127:0] c5[2:0];
wire[127:0] s5[2:0];
adder csa_s4_0(.a(c4[0]<<1), .b(c4[1]<<1), .c(s4[1]), .x(c5[0]), .y(s5[0]));
adder csa_s4_1(.a(c4[2]<<1), .b(c4[3]<<1), .c(s4[3]), .x(c5[1]), .y(s5[1]));
adder csa_s4_2(.a(s4[0]), .b(s4[2]), .c(128'b0), .x(c5[2]), .y(s5[2]));

wire[127:0] c6[1:0];
wire[127:0] s6[1:0];
adder csa_s5_0(.a(s5[0]), .b(s5[1]), .c(c5[2]<<1), .x(c6[0]), .y(s6[0]));
adder csa_s5_1(.a(c5[0]<<1), .b(c5[1]<<1), .c(s5[2]), .x(c6[1]), .y(s6[1]));

wire[127:0] c7[1:0];
wire[127:0] s7[1:0];
adder csa_s6_0(.a(c6[0]<<1), .b(c6[1]<<1), .c(s6[1]), .x(c7[0]), .y(s7[0]));
adder csa_s6_1(.a(c7[0]<<1), .b(s7[0]), .c(s6[0]), .x(c7[1]), .y(s7[1]));

wire[127:0] x,y;
DFF #(256) latch2(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld[1]),
    .a({c7[1]<<1, s7[1]}),
    .vld_out(vld[2]),
    .x({x, y})
);

wire[127:0] product;
add_128 cla(
    .a(x),
    .b(y),
    .sum(product)
);

DFF #(128) latch3(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld[2]),
    .a(product),
    .vld_out(valid_out),
    .x(dout)
);

endmodule
