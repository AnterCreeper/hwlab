`timescale 100ps/100ps

module rom_6x64_sim(
    input CLK,
    input CEN,
    input[5:0] A,
    output reg[5:0] Q
);

(* rom_style = "distributed" *)reg[5:0] D[63:0];
//FPGA flavor RAM gen
initial begin
    $readmemb("source.rcf", D); //ROM code file
end

always @(posedge CLK)
begin
    if(~CEN) Q <= D[A];
end

endmodule

module rf_2p_10x64_sim(
    input CLKA,
    input CLKB,
    input CENA,
    input[5:0] AA,
    output reg[9:0] QA,
    input CENB,
    input[5:0] AB,
    input[9:0] DB
);

reg[9:0] D[63:0];

always @(posedge CLKA)
begin
    if(~CENA) QA <= D[AA];
end

always @(posedge CLKB)
begin
    if(~CENB) D[AB] <= DB;
end

endmodule

module mat_scan(
    input clk,
    input rst_n,
    input vld_in,
    input[9:0] din,
    output reg vld_out,
    output[9:0] dout
);

reg[63:0] valid;

wire rd;
reg[5:0] ra;
wire[5:0] wa;

reg[5:0] pos; //0~63
wire[5:0] new_pos;
assign new_pos = vld_in ? pos+1 : pos;

rom_6x64_sim mat_scan_rom(
    .CLK(clk),
    .CEN(1'b0),
    .A(new_pos),
    .Q(wa)
);

rf_2p_10x64_sim mat_scan_rf(
    .CLKA(clk),
    .CLKB(clk),

    .CENA(rd),
    .AA(ra),
    .QA(dout),

    .CENB(~vld_in),
    .AB(wa),
    .DB(din)
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        valid <= 0;
        pos <= 0;
    end else
    begin
        if(ra != wa) valid[ra] <= 0;
        valid[wa] <= vld_in;
        pos <= new_pos;
    end
end

assign rd = ~valid[ra];

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        ra <= 0;
        vld_out <= 0;
    end else
    begin
        ra <= valid[ra] ? ra+1 : ra;
        vld_out <= valid[ra];
    end
end

endmodule
