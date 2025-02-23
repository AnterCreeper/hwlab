`timescale 100ps/100ps

`define DELAY 20
`define COUNT 1024768
//`define COUNT 4 //for demo show only

module testbench();

reg[63:0] a;
reg[63:0] b;
wire[127:0] y;

reg[127:0] ans;
reg[127:0] ans1;
reg[127:0] ans2;
reg[127:0] ans3;

reg clk, rst_n, vld_in;
wire vld_out;

mul_signed_64 tb(
    .clk(clk),
    .rst_n(rst_n),
    .stb(vld_in),
    .din1(a),
    .din2(b),
    .valid_out(vld_out),
    .dout(y)
);

always #`DELAY clk = ~clk;

integer i, j;
initial
begin
    clk = 1;
    rst_n = 0;
    vld_in = 0;
    #(`DELAY-1)
    rst_n = 1;
    #`DELAY
    vld_in = 1;
    for(j = 0; j < `COUNT; j = j + 1)
    begin
        a = {$random,$random};
        b = {$random,$random};
        ans <= $signed(a)*$signed(b);
        ans1 <= ans;
        ans2 <= ans1;
        ans3 <= ans2;
        #(2*`DELAY) if(y != ans3) $display("error!");
    end
    $stop();
end
endmodule
