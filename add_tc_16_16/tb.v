`timescale 100ps/100ps

`define DELAY 20
`define COUNT 1024768
//`define COUNT 4 //for demo show only

module testbench();

reg d;
reg[31:0] a;
reg[31:0] b;
wire[32:0] y;

reg[32:0] ans;

add_tc_16_16 tb(
    .a(a),
    .b(b),
    .sum(y)
);

integer i, j;
initial
begin
    for(j = 0; j < `COUNT; j = j + 1)
    begin
        a = $random;
        b = $random;
        ans = a + b;
        #`DELAY if(y != ans) $display("error!");
    end
    $stop();
end
endmodule
