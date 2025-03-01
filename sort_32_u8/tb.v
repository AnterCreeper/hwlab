`timescale 100ps/100ps

`define DELAY 20

module testbench();

reg[7:0] din_0;
reg[7:0] din_1;
reg[7:0] din_2;
reg[7:0] din_3;
reg[7:0] din_4;
reg[7:0] din_5;
reg[7:0] din_6;
reg[7:0] din_7;
reg[7:0] din_8;
reg[7:0] din_9;
reg[7:0] din_10;
reg[7:0] din_11;
reg[7:0] din_12;
reg[7:0] din_13;
reg[7:0] din_14;
reg[7:0] din_15;
reg[7:0] din_16;
reg[7:0] din_17;
reg[7:0] din_18;
reg[7:0] din_19;
reg[7:0] din_20;
reg[7:0] din_21;
reg[7:0] din_22;
reg[7:0] din_23;
reg[7:0] din_24;
reg[7:0] din_25;
reg[7:0] din_26;
reg[7:0] din_27;
reg[7:0] din_28;
reg[7:0] din_29;
reg[7:0] din_30;
reg[7:0] din_31;

wire[7:0] dout_0;
wire[7:0] dout_1;
wire[7:0] dout_2;
wire[7:0] dout_3;
wire[7:0] dout_4;
wire[7:0] dout_5;
wire[7:0] dout_6;
wire[7:0] dout_7;
wire[7:0] dout_8;
wire[7:0] dout_9;
wire[7:0] dout_10;
wire[7:0] dout_11;
wire[7:0] dout_12;
wire[7:0] dout_13;
wire[7:0] dout_14;
wire[7:0] dout_15;
wire[7:0] dout_16;
wire[7:0] dout_17;
wire[7:0] dout_18;
wire[7:0] dout_19;
wire[7:0] dout_20;
wire[7:0] dout_21;
wire[7:0] dout_22;
wire[7:0] dout_23;
wire[7:0] dout_24;
wire[7:0] dout_25;
wire[7:0] dout_26;
wire[7:0] dout_27;
wire[7:0] dout_28;
wire[7:0] dout_29;
wire[7:0] dout_30;
wire[7:0] dout_31;

reg clk, rst_n, vld_in;
wire vld_out;

sort_32_u8 tb(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld_in),
    .vld_out(vld_out),

    .din_0(din_0),
    .din_1(din_1),
    .din_2(din_2),
    .din_3(din_3),
    .din_4(din_4),
    .din_5(din_5),
    .din_6(din_6),
    .din_7(din_7),
    .din_8(din_8),
    .din_9(din_9),
    .din_10(din_10),
    .din_11(din_11),
    .din_12(din_12),
    .din_13(din_13),
    .din_14(din_14),
    .din_15(din_15),
    .din_16(din_16),
    .din_17(din_17),
    .din_18(din_18),
    .din_19(din_19),
    .din_20(din_20),
    .din_21(din_21),
    .din_22(din_22),
    .din_23(din_23),
    .din_24(din_24),
    .din_25(din_25),
    .din_26(din_26),
    .din_27(din_27),
    .din_28(din_28),
    .din_29(din_29),
    .din_30(din_30),
    .din_31(din_31),

    .dout_0(dout_0),
    .dout_1(dout_1),
    .dout_2(dout_2),
    .dout_3(dout_3),
    .dout_4(dout_4),
    .dout_5(dout_5),
    .dout_6(dout_6),
    .dout_7(dout_7),
    .dout_8(dout_8),
    .dout_9(dout_9),
    .dout_10(dout_10),
    .dout_11(dout_11),
    .dout_12(dout_12),
    .dout_13(dout_13),
    .dout_14(dout_14),
    .dout_15(dout_15),
    .dout_16(dout_16),
    .dout_17(dout_17),
    .dout_18(dout_18),
    .dout_19(dout_19),
    .dout_20(dout_20),
    .dout_21(dout_21),
    .dout_22(dout_22),
    .dout_23(dout_23),
    .dout_24(dout_24),
    .dout_25(dout_25),
    .dout_26(dout_26),
    .dout_27(dout_27),
    .dout_28(dout_28),
    .dout_29(dout_29),
    .dout_30(dout_30),
    .dout_31(dout_31)
);

always #`DELAY clk = ~clk;

integer i, j;
initial
begin
    clk = 1;
    rst_n = 0;
    vld_in = 0;
    #`DELAY
    rst_n = 1;
    vld_in = 1;
    /*
    din_0 = 31;
    din_1 = 30;
    din_2 = 29;
    din_3 = 28;
    din_4 = 27;
    din_5 = 26;
    din_6 = 25;
    din_7 = 24;
    din_8 = 23;
    din_9 = 22;
    din_10 = 21;
    din_11 = 20;
    din_12 = 19;
    din_13 = 18;
    din_14 = 17;
    din_15 = 16;
    din_16 = 15;
    din_17 = 14;
    din_18 = 13;
    din_19 = 12;
    din_20 = 11;
    din_21 = 10;
    din_22 = 9;
    din_23 = 8;
    din_24 = 7;
    din_25 = 6;
    din_26 = 5;
    din_27 = 4;
    din_28 = 3;
    din_29 = 2;
    din_30 = 1;
    din_31 = 0;
    */
    din_0 = 31;
    din_1 = 29;
    din_2 = 27;
    din_3 = 25;
    din_4 = 23;
    din_5 = 21;
    din_6 = 19;
    din_7 = 17;
    din_8 = 15;
    din_9 = 13;
    din_10 = 11;
    din_11 = 9;
    din_12 = 7;
    din_13 = 5;
    din_14 = 3;
    din_15 = 1;
    din_16 = 2;
    din_17 = 2;
    din_18 = 4;
    din_19 = 4;
    din_20 = 4;
    din_21 = 4;
    din_22 = 8;
    din_23 = 16;
    din_24 = 8;
    din_25 = 16;
    din_26 = 32;
    din_27 = 32;
    din_28 = 0;
    din_29 = 10;
    din_30 = 20;
    din_31 = 30;
    #(2*`DELAY)
    vld_in = 0;
    #(40*`DELAY)
    $stop();
end
endmodule
