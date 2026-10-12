module aes_dpath (
    input  wire         clk,
    input  wire         rst,
    input  wire [3:0]   count,     // Round counter coming from FSM
    input  wire [2:0]   curr_stat, // Current state indicator from FSM
    input  wire [127:0] text,      // Original 128-bit plaintext input
    input  wire [127:0] key,       // Original 128-bit secret key input
    output wire [127:0] cipher     // Final 128-bit ciphertext output
);

    // state registers
    reg  [127:0] state_reg;
    reg  [127:0] key_reg;

    // Interconnect wires for datapath 
    wire [127:0] sb_in;
    wire [127:0] sb_out;
    wire [127:0] sr_out;
    wire [127:0] mc_out;
    wire [127:0] round_data;

    // Interconnect wires for AddRoundKey and Key Expansion 
    wire [127:0] ark_data_in;
    wire [127:0] ark_key_in;
    wire [127:0] ark_out;
    wire [127:0] key_exp_in;
    wire [127:0] next_key;
    reg  [7:0]   rcon;

    // __________________________________________________________________________
    // RCON Lookup Logic - 8-bit round constant corresponding to the active round
    always @(*) begin
        case (count)
            4'd1:    rcon = 8'h01; // Prep Key 1
            4'd2:    rcon = 8'h02; // Prep Key 2
            4'd3:    rcon = 8'h04; // Prep Key 3
            4'd4:    rcon = 8'h08; // Prep Key 4
            4'd5:    rcon = 8'h10; // Prep Key 5
            4'd6:    rcon = 8'h20; // Prep Key 6
            4'd7:    rcon = 8'h40; // Prep Key 7
            4'd8:    rcon = 8'h80; // Prep Key 8
            4'd9:    rcon = 8'h1b; // Prep Key 9
            4'd10:   rcon = 8'h36; // Prep Key 10
            default: rcon = 8'h00;
        endcase
    end

    // _________________________________________________________________
    // STAGE 1: Datapath Input Selection (SubBytes Input MUX)
    // For Round 1 onwards, feed the state register output into SubBytes

    assign sb_in = state_reg;

    s_boxes u_sub_bytes (
        .sbox_i (sb_in),
        .sbox_o (sb_out)
    );

    shift_rows u_shift_rows (
        .in_sr  (sb_out),
        .out_sr (sr_out)
    );

    mix_columns u_mix_columns (
        .in_mc  (sr_out),
        .out_mc (mc_out)
    );

    // Bypass MUX for MixColumns
    assign round_data = (curr_stat == 3'd3) ? sr_out : mc_out;

    // ___________________________________________________________________
    // STAGE 2: AddRoundKey Multiplexing
    // Round 0: XOR plaintext with original key 
    // Rounds 1-10: XOR transformed round data with the expanded round key
    
    assign ark_data_in = (curr_stat == 3'd1) ? text : round_data;
    assign ark_key_in  = (curr_stat == 3'd1) ? key  : key_reg;

    roundkey_xor u_roundkey_xor (
        .state_in (ark_data_in),
        .round_key(ark_key_in),
        .state_out(ark_out)
    );

    // _________________________________________________________________
    // key Expansion Logic
    // Round 1 expands from initial key; rounds 2-10 expand from key_reg

    assign key_exp_in = (curr_stat == 3'd1) ? key : key_reg;

    // ___________________
    // instance of key_exp 
    key_exp u_key_exp (
        .key        (key_exp_in),
        .round_const(rcon),
        .exp_key    (next_key)
    );

    // _______________________________________________
    // internal registers update (state_reg & key_reg)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_reg <= 128'd0;
            key_reg   <= 128'd0;
        end else begin
            // Only update during active round states.
            // IDLE (3'd0) and DONE (3'd4) will naturally freeze the register.
            if (curr_stat == 3'd1 || curr_stat == 3'd2 || curr_stat == 3'd3) begin
                state_reg <= ark_out;
                key_reg   <= next_key;
            end
        end
    end

    // ciphertext output continuously from the state register
    assign cipher = state_reg;

endmodule