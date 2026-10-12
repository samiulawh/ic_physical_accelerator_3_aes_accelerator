module s_boxes(
    input  wire [127:0] sbox_i,
    output wire [127:0] sbox_o
);

    genvar i;
    generate

        for(i = 0; i < 16; i = i + 1) begin : gen_s_sbox
            sbox inst_sbox (
                .in (sbox_i[i*8 +: 8]), .out(sbox_o[i*8 +: 8])
            );
        end
    endgenerate

endmodule