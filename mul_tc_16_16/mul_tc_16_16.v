`timescale 100ps/100ps

module booth(
    input[2:0] a,
    input[15:0] b,
    output x,
    output[31:0] y //partial product
);

wire s;
assign s = a[2]; //sign
wire[1:0] ai;
assign ai = s ? ~a : a;

wire[2:0] z;
assign z[0] = ~(ai[0]|ai[1]); //zero
assign z[1] = ai[0]^ai[1]; //one
assign z[2] = ai[0]&ai[1]; //two

reg[31:0] res;
always @(*)
begin
    case(z)
    3'b001:
        res = 32'b0;
    3'b010:
        res = {{16{b[15]}},b}; //sign extend
    3'b100:
        res = {{15{b[15]}},b,1'b0}; //and left shift 1
    default: res = 32'bx;
    endcase
end

assign x = s;
assign y = s ? ~res : res;

endmodule

module adder(
    input[31:0] a,
    input[31:0] b,
    input[31:0] c,
    output[31:0] x,
    output[31:0] y
);

genvar i;
generate
for(i = 0; i < 32; i = i + 1)
assign {x[i],y[i]} = a[i]+b[i]+c[i];
endgenerate

endmodule

module mul_tc_16_16(
    input[15:0] a,
    input[15:0] b,
    output[31:0] product
);

wire[16:0] ai;
assign ai = {a,1'b0};

wire[31:0] p[7:0];
wire[31:0] cin;

genvar i;
generate
for(i = 0; i < 8; i = i + 1)
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
assign cin[31:16] = 0;

wire[31:0] c[5:0];
wire[31:0] s[5:0];
wire[31:0] x,y;

adder csa_0(.a(p[0]),    .b(p[1]<<2), .c(p[2]<<4), .x(c[0]),.y(s[0]));
adder csa_1(.a(p[3]<<6), .b(p[4]<<8), .c(p[5]<<10),.x(c[1]),.y(s[1]));
adder csa_2(.a(p[6]<<12),.b(p[7]<<14),.c(cin),     .x(c[2]),.y(s[2]));
adder csa_3(.a(s[0]),    .b(s[1]),    .c(c[2]<<1), .x(c[3]),.y(s[3]));
adder csa_4(.a(c[0]<<1), .b(c[1]<<1), .c(s[2]),    .x(c[4]),.y(s[4]));
adder csa_5(.a(s[3]),    .b(s[4]),    .c(c[4]<<1), .x(c[5]),.y(s[5]));
adder csa_6(.a(s[5]),    .b(c[3]<<1), .c(c[5]<<1), .x(x),   .y(y));

add_tc_16_16 cla(
    .a(x << 1),
    .b(y),
    .sum(product)
);

endmodule
