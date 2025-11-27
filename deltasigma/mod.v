module delta_sigma(
    input clk, //8x
    input rst_n,
    input[15:0] data,
    output reg[1:0] pdm
);

reg[24:0] adder0;
reg[24:0] adder1;

wire[24:0] data_ext;
assign data_ext = {{9{data[15]}}, data};

wire[1:0] cmp;
assign cmp[0] = adder1[24]&(~adder1[23]);
assign cmp[1] = (~adder1[24])&adder1[23];

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        adder0 <= 0;
        adder1 <= 0;
    end else
    begin
        case(cmp)
        2'b01:
        begin
            //most negative
            pdm <= 2'b00;
            adder0 <= adder0 + data_ext + 32767;
            adder1 <= adder1 + adder0 + 65535;
        end
        2'b10:
        begin
            //most positive
            pdm <= 2'b10;
            adder0 <= adder0 + data_ext - 32768;
            adder1 <= adder1 + adder0 - 65536;
        end
        2'b00:
        begin
            //within threshold
            pdm <= 2'b01;
            adder0 <= adder0 + data_ext;
            adder1 <= adder1 + adder0;
        end
        endcase
    end
end

endmodule
