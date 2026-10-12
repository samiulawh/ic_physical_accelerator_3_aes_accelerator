module main_aes (
    input  wire         clk, 
    input  wire         rst, 
    input  wire         start,
    input  wire [127:0] data, 
    input  wire [127:0] key,

    output wire [127:0] cipher,
    output wire         done 
);

    // _______________________________________________
    // wires for connecting Control (FSM) and Datapath
    wire [3:0] count;
    wire [2:0] curr_stat;
    
    // ____________________
    // Control Module (FSM)
    aes_control uut_aes_control (
        .clk      (clk), 
        .rst      (rst), 
        .start    (start), 
        .curr_stat(curr_stat), 
        .count    (count), 
        .done     (done)
    );

    // ________
    // Datapath
    aes_dpath uut_aes_dpath (
        .clk      (clk), 
        .rst      (rst), 
        .count    (count), 
        .curr_stat(curr_stat), 
        .text     (data), 
        .key      (key), 
        .cipher   (cipher)
    );

endmodule