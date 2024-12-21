`timescale 100ps/100ps

module bsh_32(
    input[31:0] data_in,
    input dir,
    input[4:0] sh,
    output[31:0] data_out
);

wire[4:0] a;
assign a = dir ? ~sh + 1 : sh; //right shift X bits = left shift 32-X bits

wire[31:0] d0,d1,d2,d3,d4;
assign d0 = a[0] ? {data_in[30:0], data_in[31]} : data_in;
assign d1 = a[1] ? {d0[29:0], d0[31:30]} : d0;
assign d2 = a[2] ? {d1[27:0], d1[31:28]} : d1;
assign d3 = a[3] ? {d2[23:0], d2[31:24]} : d2;
assign d4 = a[4] ? {d3[15:0], d3[31:16]} : d3;

assign data_out = d4;

endmodule
