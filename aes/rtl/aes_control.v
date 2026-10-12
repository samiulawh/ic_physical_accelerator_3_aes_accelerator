module aes_control(
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    
    output reg  [2:0] curr_stat, 
    output reg  [3:0] count,     
    output reg        done
);

    // Defined FSM states
    localparam [2:0] IDLE       = 3'd0, 
                     ROUND_0    = 3'd1, 
                     MID_ROUNDS = 3'd2, 
                     ROUND_10   = 3'd3,
                     DONE       = 3'd4;

    reg [2:0] next_stat; 

    // ___________________________
    // State Register (Sequential)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            curr_stat <= IDLE;
        end else begin
            curr_stat <= next_stat;
        end
    end

    // _____________________________________________________
    // Next-State Logic (Combinational)
    // transitions based on current state and control inputs
    always @(*) begin
        // default assignment
        next_stat = curr_stat;

        case (curr_stat)
            IDLE: begin
                // if start then start
                if (start) begin
                    next_stat = ROUND_0;
                end else begin
                    next_stat = IDLE;
                end
            end

            ROUND_0: begin
                next_stat = MID_ROUNDS;
            end

            MID_ROUNDS: begin

                // loop run until count is 10, 
                if (count == 4'd10) begin
                    next_stat = ROUND_10;
                end else begin
                    next_stat = MID_ROUNDS;
                end
            end

            ROUND_10: begin
                next_stat = DONE;
            end

            DONE: begin
                next_stat = IDLE;
            end

            default: begin
                next_stat = IDLE;
            end
        endcase
    end

    // ______________________________________________________
    // Round Counter Logic (Sequential Logic)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'd0;
        end else begin
            case (curr_stat)
                IDLE: begin
                    if (start) count <= 4'd1;
                    else count <= 4'd0;
                end

                ROUND_0: begin
                    count <= 4'd2;
                end

                MID_ROUNDS: begin
                    // Increment on count until reaching round 10
                    if (count < 4'd10) begin
                        count <= count + 1'b1;
                    end
                end

                ROUND_10: begin
                    count <= 4'd0;
                end

                DONE: begin
                    // Reset counter in DONE state
                    count <= 4'd0;
                end

                default: begin
                    count <= 4'd0;
                end
            endcase
        end
    end

    // ______________________
    // Output / Control Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset 
            done <= 1'b0;
        end else begin
            case (curr_stat)
                DONE: begin
                    // done signal during completion
                    done <= 1'b1;
                end
                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule