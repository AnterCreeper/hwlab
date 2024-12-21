`timescale 100ps/100ps

`define DELAY 20
`define COUNT 1024
//`define COUNT 4 //for demo show only

module testbench();

reg d;
reg[4:0] a;
reg[31:0] b;
wire[31:0] y;

reg[63:0] ans;

bsh_32 tb(
    .data_in(b),
    .dir(d),
    .sh(a),
    .data_out(y)
);

integer i, j;
initial
begin
    //left case
    d = 0;
    for(i = 0; i < 32; i = i + 1)
    begin
        a = i;
        for(j = 0; j < `COUNT; j = j + 1)
        begin
            b = $random;
            ans = {b, b} << i;
            #`DELAY if(y != ans[63:32]) $display("error!");
        end
    end
    //right case
    d = 1;
    for(i = 0; i < 32; i = i + 1)
    begin
        a = i;
        for(j = 0; j < `COUNT; j = j + 1)
        begin
            b = $random;
            ans = {b, b} >> i;
            #`DELAY if(y != ans[31:0]) $display("error!");
        end
    end
    $stop();
end
endmodule
