module tb_main_aes;

    reg clk, rst, start;
    reg [127:0] data, key;
    wire done;
    wire [127:0] cipher;

    main_aes uut_main_aes (
        .clk(clk), .rst(rst), .start(start), .data(data), .key(key), .cipher(cipher), .done(done)
    );

    // ________________
    // Clock Generation
    initial begin
        clk = 0; 
        forever begin
            #5; clk = ~clk;
        end
    end

    // _____________
    // Main Stimulus
    initial begin

        $dumpfile("gtkwave/aes.vcd");
        $dumpvars(0, tb_main_aes);

        $monitor("Time=%0t | clk=%b | rst=%b | start=%b | done=%b | count=%d | data=%h | key=%h | cipher=%h", 
                 $time, clk, rst, start, done, uut_main_aes.count, data, key, cipher);

        rst = 1; start = 0; 
        data = 128'd0; key = 128'd0;
        #15;

        rst = 0;
        #10;

        // test
        data = 128'h3243f6a3339a308d313198a2e0370734;
        key  = 128'h2b7e151628aeda45abf7331209cf4f3c;        
        #5; 

        // start pulse
        start = 1'b1;
        #10;
        start = 1'b0; // Turn off start after 1 clock cycle 

        // wait for the 'done' signal from FSM
        wait (done == 1'b1);
        
        #10;
        $finish;

    end
    
endmodule