`timescale 100ps/100ps

`define DELAY 20
`define ROUND 1

module testbench();

reg clk;
reg rst_n;
reg vld_in;
reg[9:0] din;
wire vld_out;
wire[9:0] dout;

mat_scan tb(
    .clk(clk),
    .rst_n(rst_n),
    .vld_in(vld_in),
    .din(din),
    .vld_out(vld_out),
    .dout(dout)
);

always #`DELAY clk = ~clk;

integer i,j;

reg[5:0] dst;
reg[9:0] result[127:0];

initial
begin
    $readmemh("result.txt", result);
    clk = 1;
    rst_n = 0;
    vld_in = 0;
    dst = 0;
    #(`DELAY+1)
    rst_n = 1;
    #`DELAY
    for(j = 0; j < `ROUND; j = j + 1)
    begin
    vld_in = 1;
    for(i = 0; i < 64; i = i + 1)
    begin
        din = i + 1;
        #(2*`DELAY);
    end
    vld_in = 0;
    #(j*2*`DELAY);
    end
    din = 0;
    vld_in = 0;
    #(32768*`DELAY)
    $stop();
end

always @(negedge clk)
begin
    if(vld_out)
    begin
        if(result[dst] != dout) $display("err, dout:%d, ans:%d", dout, result[dst]);
        dst <= dst + 1;
    end
end

endmodule
