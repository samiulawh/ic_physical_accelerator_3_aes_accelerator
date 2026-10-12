module tb_sbox;
    reg  [7:0] in;
    wire [7:0] out;

    sbox uut_sbox (
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("gtkwave/sbox.vcd");
        $dumpvars(0, tb_sbox);

        $monitor("in = %h | out = %h", in, out);

        in = 8'h3f;

        #10;
        $finish;
    end

endmodule