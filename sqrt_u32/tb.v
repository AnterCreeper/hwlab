`timescale 100ps/100ps

`define DELAY 20

module testbench();

reg clk, rst_n, vld_in;
wire vld_out;

reg[31:0] x;
wire[15:0] y;

sqrt_u32 tb(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld_in),
    .vld_out(vld_out),
    .x(x),
    .y(y)
);

always #`DELAY clk = ~clk;

initial
begin
    clk = 1;
    rst_n = 0;
    vld_in = 0;
    x = 0;
    #`DELAY
    rst_n = 1;
    vld_in = 1;
    while(x != 32'hffffffff)
    begin
        #(2*`DELAY)
        x = x + 1;
    end
    vld_in = 0;
    #(40*`DELAY)
    $stop();
end
endmodule
