`timescale 100ps/100ps

`define WIDTH 35

//latch
module stage0(
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,
    input[31:0] d,
    output reg[31:0] q
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
        if(vld_in) q <= d;
    end
end

endmodule

module foo(
    input[31:0] x,
    output[3:0] y
);

//encode
wire[3:0] ai;
wire[7:0] z;
genvar i;
generate
for (i = 0; i < 4; i = i + 1)
begin
    assign ai[i    ] = ~|x[i*8+7:i*8];
    assign  z[i*2+1] = ~|x[i*8+7:i*8+4];
    assign  z[i*2] = ~(x[i*8+7]|x[i*8+6]|(~(x[i*8+5]|x[i*8+4])&(x[i*8+3]|x[i*8+2])));
end
endgenerate

//assembly
assign y = ai[3] ? (
                ai[2] ? (
                ai[1] ? (
                ai[0] ? 4'hf
                : {2'h3, z[1:0]})
                : {2'h2, z[3:2]})
                : {2'h1, z[5:4]})
                : {2'h0, z[7:6]};

endmodule

module stage1(
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,
    input[31:0] q,
    output reg[3:0] len,
    output reg[31:0] z
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
    end
end

wire[3:0] l;
foo c0(
    .x(q),
    .y(l)
);

always @(posedge clk)
begin
    len <= l;
    z <= q;
end

endmodule

//shift
module stage2(
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,
    input[3:0] len,
    input[31:0] z,
    output reg[3:0] a,
    output reg[32:0] b,
    output reg[31:0] z_out,
    output reg[31:0] z_out1
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
    end
end

always @(posedge clk)
begin
    a <= len;
    b <= z << {len, 1'b1};
    z_out <= z;
    z_out1 <= z;
end

endmodule

module lut(
    input[31:0] a,
    output reg x
);

always @(*)
begin
    case(a)
    //I have tried with DC. not too much, bro.
    660969: x <= 1;
    1413721: x <= 1;
    2643876: x <= 1;
    5654884: x <= 1;
    10575504: x <= 1;
    11458225: x <= 1;
    22619536: x <= 1;
    30459361: x <= 1;
    34515625: x <= 1;
    42302016: x <= 1;
    44422225: x <= 1;
    45832900: x <= 1;
    46553329: x <= 1;
    53597041: x <= 1;
    70442449: x <= 1;
    90478144: x <= 1;
    97871449: x <= 1;
    104182849: x <= 1;
    109181601: x <= 1;
    114425809: x <= 1;
    121837444: x <= 1;
    138062500: x <= 1;
    142444225: x <= 1;
    169208064: x <= 1;
    177688900: x <= 1;
    183331600: x <= 1;
    186213316: x <= 1;
    189145009: x <= 1;
    204575809: x <= 1;
    207792225: x <= 1;
    214388164: x <= 1;
    281769796: x <= 1;
    361912576: x <= 1;
    391446225: x <= 1;
    391485796: x <= 1;
    397643481: x <= 1;
    403889409: x <= 1;
    410265025: x <= 1;
    416731396: x <= 1;
    429940225: x <= 1;
    436726404: x <= 1;
    450585529: x <= 1;
    457703236: x <= 1;
    487349776: x <= 1;
    495018001: x <= 1;
    502790929: x <= 1;
    518791729: x <= 1;
    526932025: x <= 1;
    552250000: x <= 1;
    569776900: x <= 1;
    625950361: x <= 1;
    645820569: x <= 1;
    656025769: x <= 1;
    676832256: x <= 1;
    710755600: x <= 1;
    721943161: x <= 1;
    733326400: x <= 1;
    744853264: x <= 1;
    756580036: x <= 1;
    805594689: x <= 1;
    818303236: x <= 1;
    831168900: x <= 1;
    857552656: x <= 1;
    1127079184: x <= 1;
    1447650304: x <= 1;
    1565784900: x <= 1;
    1565784901: x <= 1;
    1565864041: x <= 1;
    1565943184: x <= 1;
    1590494161: x <= 1;
    1590573924: x <= 1;
    1615477249: x <= 1;
    1615557636: x <= 1;
    1615557637: x <= 1;
    1615638025: x <= 1;
    1641060100: x <= 1;
    1666843929: x <= 1;
    1666925584: x <= 1;
    1719760900: x <= 1;
    1719760901: x <= 1;
    1719843841: x <= 1;
    1746905616: x <= 1;
    1774347129: x <= 1;
    1802342116: x <= 1;
    1802427025: x <= 1;
    1830812944: x <= 1;
    1888858521: x <= 1;
    1949310801: x <= 1;
    1949399104: x <= 1;
    1949399105: x <= 1;
    1949487409: x <= 1;
    1979983009: x <= 1;
    1980072004: x <= 1;
    1980072005: x <= 1;
    1980161001: x <= 1;
    2011163716: x <= 1;
    2011253409: x <= 1;
    2075075809: x <= 1;
    2075166916: x <= 1;
    2107728100: x <= 1;
    2107819921: x <= 1;
    2141005441: x <= 1;
    2209000000: x <= 1;
    2209094001: x <= 1;
    2279107600: x <= 1;
    2279203081: x <= 1;
    2503801444: x <= 1;
    2503801445: x <= 1;
    2503901521: x <= 1;
    2503901522: x <= 1;
    2583282276: x <= 1;
    2624103076: x <= 1;
    2707329024: x <= 1;
    2842915761: x <= 1;
    2843022400: x <= 1;
    2887772644: x <= 1;
    2933197281: x <= 1;
    2933305600: x <= 1;
    2979413056: x <= 1;
    3026320144: x <= 1;
    3026430169: x <= 1;
    3222378756: x <= 1;
    3222492289: x <= 1;
    3273098521: x <= 1;
    3273212944: x <= 1;
    3273212945: x <= 1;
    3324675600: x <= 1;
    3324790921: x <= 1;
    3377120769: x <= 1;
    3430210624: x <= 1;
    3651664041: x <= 1;
    3887148409: x <= 1;
    4138992225: x <= 1;
    4270491801: x <= 1;
    //can be easily done within one cycle.
    default: x <= 0;
    endcase
end

endmodule

//pre-process
module stage3(
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,
    input[3:0] a,
    input[31:0] z,
    input[31:0] z1,
    output reg[3:0] a_out,
    output reg[31:0] z_out,
    input[32:0] b,
    output reg sel,
    output reg[`WIDTH-1:0] x0,
    output reg[`WIDTH-1:0] y0
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
    end
end

wire sel0;
wire[`WIDTH-1:0] kk = 32'hbaa11c87; //whom a magic number!
lut lut0(
    .a(z1),
    .x(sel0)
);

wire[`WIDTH-1:0] bb = b;

always @(posedge clk)
begin
    a_out <= a;
    z_out <= z;
    sel <= sel0;
    x0 <= bb + kk;
    y0 <= bb - kk;
end

endmodule

//iteration
module stage_iterate
#(
    parameter INDEX = 1
)(
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,

    input sel,
    input[3:0] a,
    input[31:0] z,
    output reg sel_out,
    output reg[3:0] a_out,
    output reg[31:0] z_out,

    input signed[`WIDTH-1:0] x0,
    input signed[`WIDTH-1:0] y0,
    output reg[`WIDTH-1:0] x1,
    output reg[`WIDTH-1:0] y1
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
    end
end

always @(posedge clk)
begin
    a_out <= a;
    z_out <= z;
    sel_out <= sel;
end

always @(posedge clk)
begin
    if(y0[`WIDTH-1])
    begin
        x1 = x0 + (y0 >>> INDEX);
        y1 = y0 + (x0 >>> INDEX);
    end else
    begin
        x1 = x0 - (y0 >>> INDEX);
        y1 = y0 - (x0 >>> INDEX);
    end
end

endmodule

module stage6 (
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,

    input sel,
    input[3:0] a,
    input[31:0] z,
    input[`WIDTH-1:0] x,

    output reg sel_out,
    output reg[15:0] y,
    output reg[31:0] z_out
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
    end
end

wire[16:0] xi;
assign xi = x[`WIDTH-1:17] >> a;

always @(posedge clk)
begin
    y <= xi;
    z_out <= z;
    sel_out <= sel;
end

endmodule

module stage7 (
    input clk,
    input rst_n,
    input vld_in,
    output reg vld_out,

    input sel,
    input[31:0] z,
    input[15:0] x,

    output reg[15:0] y
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
    begin
        vld_out <= vld_in;
    end
end

wire dec;
assign dec = z < (x * x); //will cost one DSP, because I am lazy...

always @(posedge clk)
begin
    y <= sel ? x + 1 : (dec ? x - 1 : x);
end

endmodule

//connect a bunch of stuffs
module sqrt_u32(
    input clk,
    input rst_n,
    input vld_in,
    input[31:0] x,
    output vld_out,
    output[15:0] y
);

wire v0;
wire[31:0] q0;
stage0 s0(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld_in),
    .vld_out(v0),

    .d(x),

    .q(q0)
);

wire v1;
wire[3:0] l1;
wire[31:0] z1;
stage1 s1(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(v0),
    .vld_out(v1),

    .q(q0),

    .z(z1),
    .len(l1)
);

wire v2;
wire[3:0] a2;
wire[32:0] b2;
wire[31:0] z2, z1_2;
stage2 s2(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(v1),
    .vld_out(v2),

    .z(z1),
    .len(l1),

    .a(a2),
    .b(b2),
    .z_out(z2),
    .z_out1(z1_2)
);

wire v3;
wire[3:0] a3;
wire[31:0] z3;
wire sel3;
wire[`WIDTH-1:0] x0, y0;
stage3 s3(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(v2),
    .vld_out(v3),

    .a(a2),
    .z(z2),
    .z1(z1_2),
    .a_out(a3),
    .z_out(z3),

    .b(b2),
    .sel(sel3),
    .x0(x0),
    .y0(y0)
);

wire v4[9:0];
wire sel4[9:0];
wire[3:0] a4[9:0];
wire[31:0] z4[9:0];
wire[`WIDTH-1:0] x4[9:0];
wire[`WIDTH-1:0] y4[9:0];

genvar i;
integer j;
generate
for(i = 0; i < 8; i = i + 1)
begin
    localparam p = i > 3 ? i+1 : i;
    stage_iterate #(i+1) s4(
        .clk(clk),
        .rst_n(rst_n),
        .vld_in(i?v4[p]:v3),
        .vld_out(v4[p+1]),

        .sel(i?sel4[p]:sel3),.a(i?a4[p]:a3),.z(i?z4[p]:z3),
        .sel_out(sel4[p+1]),.a_out(a4[p+1]),.z_out(z4[p+1]),

        .x0(i?x4[p]:x0),.y0(i?y4[p]:y0),.x1(x4[p+1]),.y1(y4[p+1])
    );
    if(i == 3)
    begin
    stage_iterate #(4) s5(
        .clk(clk),
        .rst_n(rst_n),
        .vld_in(v4[4]),
        .vld_out(v4[5]),

        .sel(sel4[4]),.a(a4[4]),.z(z4[4]),
        .sel_out(sel4[5]),.a_out(a4[5]),.z_out(z4[5]),

        .x0(x4[4]),.y0(y4[4]),.x1(x4[5]),.y1(y4[5])
    );
    end
end
endgenerate

wire v6;
wire sel6;
wire[31:0] z6;
wire[15:0] y6;
stage6 s6(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(v4[9]),
    .vld_out(v6),

    .a(a4[9]),
    .x(x4[9]),
    .z(z4[9]),
    .sel(sel4[9]),

    .y(y6),
    .z_out(z6),
    .sel_out(sel6)
);

stage7 s7(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(v6),
    .vld_out(vld_out),

    .sel(sel6),
    .z(z6),
    .x(y6),

    .y(y)
);

endmodule
