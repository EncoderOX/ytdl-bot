// CORDIC Controller - Finite State Machine
// Controls the sequence of operations for CORDIC algorithm

module cordic_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire done_iter,  // Signal from datapath when iterations complete
    output reg load_init,
    output reg update_iter,
    output reg output_result,
    output reg busy,
    output reg done
);

    // State definitions
    localparam [2:0] IDLE     = 3'b000,
                     LOAD     = 3'b001,
                     COMPUTE  = 3'b010,
                     OUTPUT   = 3'b011,
                     COMPLETE = 3'b100;
    
    // State register
    reg [2:0] state, next_state;
    
    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        // Default values
        next_state = state;
        load_init = 1'b0;
        update_iter = 1'b0;
        output_result = 1'b0;
        busy = 1'b0;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = LOAD;
                end
            end
            
            LOAD: begin
                load_init = 1'b1;
                busy = 1'b1;
                next_state = COMPUTE;
            end
            
            COMPUTE: begin
                busy = 1'b1;
                if (done_iter) begin
                    next_state = OUTPUT;
                end else begin
                    update_iter = 1'b1;
                    next_state = COMPUTE;
                end
            end
            
            OUTPUT: begin
                output_result = 1'b1;
                busy = 1'b1;
                next_state = COMPLETE;
            end
            
            COMPLETE: begin
                done = 1'b1;
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
