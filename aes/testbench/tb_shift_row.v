`timescale 1ns / 1ps

module tb_shift_rows ();

    // Inputs hamesha 'reg' hotay hain
    // FIX: Replaced comma (,) with semicolon (;) at the end of declaration
    // Original: reg [127:0] in_sr,
    reg  [127:0] in_sr;
    wire [127:0] out_sr;

    // Unit Under Test (UUT)
    shift_rows uut_shift_rows (
        .in_sr(in_sr), 
        .out_sr(out_sr)
    );

    initial begin
        $dumpfile("vcd_shift_rows.vcd");
        $dumpvars(0, tb_shift_rows);
        
        /*
        in_sr = 128'hB0_B1_B2_B3_B4_B5_B6_B7_B8_B9_B10_B11_B12_B13_B14_B15;
        Bus Wires:   [127:120]  [119:112]  ...  [15:8]   [7:0]
        Data Byte:      B0 (msb)   B1      ...   B14     B15 (lsb)
             All 128 wires transfer at the SAME time to the module.

        B0, B4, B8, B12
        B1, B5, B9, B13
        B2, B6, B10, B14
        B3, B7, B11, B15
        */
        
        // in_sr = 128'hA0_B0_C0_D0_A1_B1_C1_D1_A2_B2_C2_D2_A3_B3_C3_D3;

        // Row 0 No Shift expected
        in_sr[127:120] = 8'hA0; in_sr[95:88] = 8'hA1; in_sr[63:56] = 8'hA2; in_sr[31:24] = 8'hA3;
        
        // Row 1 - 1 Byte Left Shift expected
        in_sr[119:112] = 8'hB0; in_sr[87:80] = 8'hB1; in_sr[55:48] = 8'hB2; in_sr[23:16] = 8'hB3;
        
        // Row 2 - 2 Bytes Left Shift expected
        in_sr[111:104] = 8'hC0; in_sr[79:72] = 8'hC1; in_sr[47:40] = 8'hC2; in_sr[15:8] = 8'hC3;
        
        // Row 3 - 3 Bytes Left Shift expected
        in_sr[103:96]  = 8'hD0; in_sr[71:64] = 8'hD1; in_sr[39:32] = 8'hD2; in_sr[7:0]  = 8'hD3;

        // time delay so combinational logic has time to evaluate
        #10;

        $display("______");
        $display("INPUT:");
        $display("******");
        // Row 0
        $display("%h %h %h %h", in_sr[127:120], in_sr[95:88], in_sr[63:56], in_sr[31:24]);
        // Row 1
        $display("%h %h %h %h", in_sr[119:112], in_sr[87:80], in_sr[55:48], in_sr[23:16]);
        // Row 2
        $display("%h %h %h %h", in_sr[111:104], in_sr[79:72], in_sr[47:40], in_sr[15:8]);
        // Row 3
        $display("%h %h %h %h", in_sr[103:96],  in_sr[71:64], in_sr[39:32], in_sr[7:0]);

        $display("");
        
        $display("________________________");
        $display("OUTPUT (After Shifting):");
        $display("^^^^^^^^^^^^^^^^^^^^^^^^");
        //  Row 0 (Should be: A0 A1 A2 A3)
        $display("%h %h %h %h", out_sr[127:120], out_sr[95:88], out_sr[63:56], out_sr[31:24]);
        //  Row 1 (Should be: B1 B2 B3 B0) -> Left shifted by 1
        $display("%h %h %h %h", out_sr[119:112], out_sr[87:80], out_sr[55:48], out_sr[23:16]);
        //  Row 2 (Should be: C2 C3 C0 C1) -> Left shifted by 2
        $display("%h %h %h %h", out_sr[111:104], out_sr[79:72], out_sr[47:40], out_sr[15:8]);
        //  Row 3 (Should be: D3 D0 D1 D2) -> Left shifted by 3
        $display("%h %h %h %h", out_sr[103:96],  out_sr[71:64], out_sr[39:32], out_sr[7:0]);
        $display("-------------------------");
        
        #10;
        $finish;
    end

endmodule