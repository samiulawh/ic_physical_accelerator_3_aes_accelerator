module mix_columns (
    input  wire [127:0] in_mc,
    output wire [127:0] out_mc
);

    // Function to multiply an 8-bit number by 0x02 in GF(2^8)
    // Left shift by 1, and conditionally XOR with 0x1B if MSB is 1
    function [7:0] xtime;
        input [7:0] b;
        begin
            xtime = (b[7]) ? ((b << 1) ^ 8'h1b) : (b << 1);
        end
    endfunction

    genvar i;
    generate
        // AES state has 4 columns (each column is 32 bits = 4 bytes)
        for (i = 0; i < 4; i = i + 1) begin : gen_mix_col
            
            // Extract the 4 bytes of the i-th column
            wire [7:0] b0 = in_mc[127 - (32 * i)      -: 8];
            wire [7:0] b1 = in_mc[127 - (32 * i) - 8  -: 8];
            wire [7:0] b2 = in_mc[127 - (32 * i) - 16 -: 8];
            wire [7:0] b3 = in_mc[127 - (32 * i) - 24 -: 8];

            // MixColumns matrix multiplication equations:
            // c0 = (02 * b0) ^ (03 * b1) ^ (01 * b2) ^ (01 * b3)
            // c1 = (01 * b0) ^ (02 * b1) ^ (03 * b2) ^ (01 * b3)
            // c2 = (01 * b0) ^ (01 * b1) ^ (02 * b2) ^ (03 * b3)
            // c3 = (03 * b0) ^ (01 * b1) ^ (01 * b2) ^ (02 * b3)
            // Note: (03 * b) is equivalent to (xtime(b) ^ b)

            wire [7:0] c0 = xtime(b0) ^ (xtime(b1) ^ b1) ^ b2 ^ b3;
            wire [7:0] c1 = b0 ^ xtime(b1) ^ (xtime(b2) ^ b2) ^ b3;
            wire [7:0] c2 = b0 ^ b1 ^ xtime(b2) ^ (xtime(b3) ^ b3);
            wire [7:0] c3 = (xtime(b0) ^ b0) ^ b1 ^ b2 ^ xtime(b3);

            // Assign mixed bytes back into the output state
            assign out_mc[127 - (32 * i)      -: 8] = c0;
            assign out_mc[127 - (32 * i) - 8  -: 8] = c1;
            assign out_mc[127 - (32 * i) - 16 -: 8] = c2;
            assign out_mc[127 - (32 * i) - 24 -: 8] = c3;

        end
    endgenerate

endmodule