module testbench();

reg clk;
reg rst_n;
reg[15:0] data[1:0];

integer fsrc;
initial
begin
    fsrc <= $fopen("input.bin", "rb");
end

always #10 clk = ~clk;

integer ret;

initial
begin
    clk <= 0;
    rst_n <= 0;
    data[0] <= 0;
    data[1] <= 0;
    #10 rst_n <= 1;
    while(!$feof(fsrc))
    begin
        ret = $fread(data, fsrc);
        #160;
    end
end

wire[1:0] pdm;
wire[15:0] data_in;
assign data_in = data[0];

delta_sigma tb(
    .clk(clk), //8x
    .rst_n(rst_n),
    .data({data_in[7:0], data_in[15:8]}),
    .pdm(pdm)
);

endmodule
