module shift_rows (
    input  wire [127:0] in_sr,
    output wire [127:0] out_sr
);

    // AES State Matrix is Column-Major. 
    // 128-bit state into 16 bytes (B0 to B15).
    // B0 is [127:120], B1 is [119:112] ... B15 is [7:0].
   
    // Row 0 (B0, B4, B8, B12): Shifted 0 bytes left
    // Row 1 (B1, B5, B9, B13): Shifted 1 byte left  -> B5, B9, B13, B1
    // Row 2 (B2, B6, B10, B14): Shifted 2 bytes left -> B10, B14, B2, B6
    // Row 3 (B3, B7, B11, B15): Shifted 3 bytes left -> B15, B3, B7, B11
    
    assign out_sr = {
        // COLUMN 0 
        in_sr[127:120],  // B0  (Row 0, Col 0 - No shift)
        in_sr[87:80],    // B5  (Row 1, Col 1 - Shifted left by 1)
        in_sr[47:40],    // B10 (Row 2, Col 2 - Shifted left by 2)
        in_sr[7:0],      // B15 (Row 3, Col 3 - Shifted left by 3)

        // COLUMN 1
        in_sr[95:88],    // B4  (Row 0, Col 1 - No shift)
        in_sr[55:48],    // B9  (Row 1, Col 2 - Shifted left by 1)
        in_sr[15:8],     // B14 (Row 2, Col 3 - Shifted left by 2)
        in_sr[103:96],   // B3  (Row 3, Col 0 - Shifted left by 3)

        // OUTPUT COLUMN 2
        in_sr[63:56],    // B8  (Row 0, Col 2 - No shift)
        in_sr[23:16],    // B13 (Row 1, Col 3 - Shifted left by 1)
        in_sr[111:104],  // B2  (Row 2, Col 0 - Shifted left by 2)
        in_sr[71:64],    // B7  (Row 3, Col 1 - Shifted left by 3)

        // OUTPUT COLUMN 3
        in_sr[31:24],    // B12 (Row 0, Col 3 - No shift)
        in_sr[119:112],  // B1  (Row 1, Col 0 - Shifted left by 1)
        in_sr[79:72],    // B6  (Row 2, Col 1 - Shifted left by 2)
        in_sr[39:32]     // B11 (Row 3, Col 2 - Shifted left by 3)
    };

endmodule