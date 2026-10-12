module key_exp(
    input wire [127:0] key,
    input wire [7:0] round_const,
    output wire [127:0] exp_key
);
    wire [31:0] w0, w1, w2, w3;
    wire [31:0] w4, w5, w6, w7;
    wire [31:0] w3_rot;
    wire [7:0] sbox_rot_w_0, sbox_rot_w_1, sbox_rot_w_2, sbox_rot_w_3;
    wire [31:0] sbox_rot_xored;

    assign w0 = key[127:96];
    assign w1 = key[95:64];
    assign w2 = key[63:32];
    assign w3 = key[31:0];

    // step 1: rotation
    // 31:24 - 23:16 - 15:8 - 7:0 --after rotated>> 23:16 - 15:8 - 7:0 - 31:24
    assign w3_rot = {w3[23:16], w3[15:8], w3[7:0], w3[31:24]};

    // step 2: sbox passing
    sbox uut_sbox_0 (.in(w3_rot[31:24]), .out(sbox_rot_w_0));
    sbox uut_sbox_1 (.in(w3_rot[23:16]), .out(sbox_rot_w_1));
    sbox uut_sbox_2 (.in(w3_rot[15:8]), .out(sbox_rot_w_2));
    sbox uut_sbox_3 (.in(w3_rot[7:0]), .out(sbox_rot_w_3));

    // step 3: xoring - each xor element have 32-bits width
    assign w4 = w0 ^ {sbox_rot_w_0, sbox_rot_w_1, sbox_rot_w_2, sbox_rot_w_3} ^ {round_const, 24'h000000};
    assign w5 = w4 ^ w1;
    assign w6 = w5 ^ w2;
    assign w7 = w6 ^ w3;

    assign exp_key = {w4, w5, w6, w7};
    
endmodule