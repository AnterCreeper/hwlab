`timescale 100ps/100ps

`define WIDTH 8
`define N 5 //2^N size

module cas
#(
    parameter A = 0,
    parameter B = 0
)(
    input clk,
    input rst_n,
    input vld_in,
    input[(2**`N)*`WIDTH-1:0] a,
    output reg vld_out,
    output reg[(2**`N)*`WIDTH-1:0] x
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        vld_out <= 0;
    end else
        vld_out <= vld_in;
    begin
    end
end

parameter INC = 2**B;
parameter SEG = 2**(`N-A-1);
parameter CNT = 2**(A-B);
parameter LEN = 2**(A+1);

genvar i, j, k;

generate
for(i = 0; i < SEG; i = i + 1)
for(j = 0; j < CNT; j = j + 1)
for(k = 0; k < INC; k = k + 1)
begin
    localparam m = i*LEN+2*j*INC+k;
    localparam n = i*LEN+2*j*INC+k+INC;
    wire[`WIDTH-1:0] u = a[m*`WIDTH+`WIDTH-1:m*`WIDTH];
    wire[`WIDTH-1:0] v = a[n*`WIDTH+`WIDTH-1:n*`WIDTH];
    //can do further opt over this comparator
    if(i%2)
    begin
        always @(posedge clk)
        begin
            x[m*`WIDTH+`WIDTH-1:m*`WIDTH] <= u > v ? u : v;
            x[n*`WIDTH+`WIDTH-1:n*`WIDTH] <= u > v ? v : u;
        end
    end else
    begin
        always @(posedge clk)
        begin
            x[m*`WIDTH+`WIDTH-1:m*`WIDTH] <= u > v ? v : u;
            x[n*`WIDTH+`WIDTH-1:n*`WIDTH] <= u > v ? u : v;
        end
    end
end
endgenerate

endmodule

module latch_din(
    input clk,
    input rst_n,
    input vld_in,
    input[(2**`N)*`WIDTH-1:0] a,
    output reg vld_out,
    output reg[(2**`N)*`WIDTH-1:0] x
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

module sort(
    input clk,
    input rst_n,
    input vld_in,
    input[(2**`N)*`WIDTH-1:0] a,
    output vld_out,
    output[(2**`N)*`WIDTH-1:0] x
);

parameter STAGE = `N*(`N+1)/2;

wire vld[STAGE:0];
wire[(2**`N)*`WIDTH-1:0] d[STAGE:0];

genvar i, j;
generate
for(i = 0; i < `N; i = i + 1)
begin
    for(j = i; j >= 0; j = j - 1)
    begin
    localparam k = i*(i+1)/2+i-j;
    cas #(i, j) s(
        .clk(clk),
        .rst_n(rst_n),
        .vld_in(k == 0 ? vld_in : vld[k]),
        .a(k == 0 ? a : d[k]),
        .vld_out(vld[k+1]),
        .x(d[k+1])
    );
    end
end

assign vld_out = vld[STAGE];
assign x = d[STAGE];

endgenerate

endmodule

module sort_32_u8(
    input clk,
    input rst_n,
    input vld_in,
    output vld_out,
    
    input[7:0] din_0,
    input[7:0] din_1,
    input[7:0] din_2,
    input[7:0] din_3,
    input[7:0] din_4,
    input[7:0] din_5,
    input[7:0] din_6,
    input[7:0] din_7,
    input[7:0] din_8,
    input[7:0] din_9,
    input[7:0] din_10,
    input[7:0] din_11,
    input[7:0] din_12,
    input[7:0] din_13,
    input[7:0] din_14,
    input[7:0] din_15,
    input[7:0] din_16,
    input[7:0] din_17,
    input[7:0] din_18,
    input[7:0] din_19,
    input[7:0] din_20,
    input[7:0] din_21,
    input[7:0] din_22,
    input[7:0] din_23,
    input[7:0] din_24,
    input[7:0] din_25,
    input[7:0] din_26,
    input[7:0] din_27,
    input[7:0] din_28,
    input[7:0] din_29,
    input[7:0] din_30,
    input[7:0] din_31,
    
    output[7:0] dout_0,
    output[7:0] dout_1,
    output[7:0] dout_2,
    output[7:0] dout_3,
    output[7:0] dout_4,
    output[7:0] dout_5,
    output[7:0] dout_6,
    output[7:0] dout_7,
    output[7:0] dout_8,
    output[7:0] dout_9,
    output[7:0] dout_10,
    output[7:0] dout_11,
    output[7:0] dout_12,
    output[7:0] dout_13,
    output[7:0] dout_14,
    output[7:0] dout_15,
    output[7:0] dout_16,
    output[7:0] dout_17,
    output[7:0] dout_18,
    output[7:0] dout_19,
    output[7:0] dout_20,
    output[7:0] dout_21,
    output[7:0] dout_22,
    output[7:0] dout_23,
    output[7:0] dout_24,
    output[7:0] dout_25,
    output[7:0] dout_26,
    output[7:0] dout_27,
    output[7:0] dout_28,
    output[7:0] dout_29,
    output[7:0] dout_30,
    output[7:0] dout_31
);

wire vld;
wire[255:0] x;

latch_din l(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld_in),
    .a({din_31,din_30,din_29,din_28,din_27,din_26,din_25,din_24,din_23,din_22,din_21,din_20,din_19,din_18,din_17,din_16,din_15,din_14,din_13,din_12,din_11,din_10,din_9,din_8,din_7,din_6,din_5,din_4,din_3,din_2,din_1,din_0}),
    .vld_out(vld),
    .x(x)
);

sort s(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld),
    .a(x),
    .vld_out(vld_out),
    .x({dout_31,dout_30,dout_29,dout_28,dout_27,dout_26,dout_25,dout_24,dout_23,dout_22,dout_21,dout_20,dout_19,dout_18,dout_17,dout_16,dout_15,dout_14,dout_13,dout_12,dout_11,dout_10,dout_9,dout_8,dout_7,dout_6,dout_5,dout_4,dout_3,dout_2,dout_1,dout_0})
);

endmodule
