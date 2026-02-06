// CORDIC Datapath Module
// Implements the iterative CORDIC rotation algorithm for sine/cosine calculation
// Uses Q2.14 fixed-point format for 16-bit precision

module cordic_datapath (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [15:0] angle_in,  // Input angle in radians (Q2.14 format)
    output reg [15:0] cos_out,   // Cosine output (Q2.14 format)
    output reg [15:0] sin_out,   // Sine output (Q2.14 format)
    output wire done,
    // Control signals from controller
    input wire load_init,
    input wire update_iter,
    input wire output_result
);

    // CORDIC gain compensation constant: 1/K = 0.60725 in Q2.14 format
    // 0.60725 * 2^14 = 9949.44 ≈ 9949
    localparam signed [15:0] CORDIC_GAIN = 16'sd9949;
    
    // Number of iterations (minimum 12 for good precision)
    localparam ITERATIONS = 12;
    
    // Internal registers
    reg signed [15:0] x, y, z;
    reg [3:0] iter;
    
    // ATAN lookup table - stores atan(2^-i) in Q2.14 format (radians)
    // Precomputed values for i = 0 to 11
    reg signed [15:0] atan_table [0:11];
    
    initial begin
        // atan(2^0) = atan(1) = 0.785398 rad → 12868
        atan_table[0]  = 16'sd12868;
        // atan(2^-1) = atan(0.5) = 0.463648 rad → 7596
        atan_table[1]  = 16'sd7596;
        // atan(2^-2) = atan(0.25) = 0.244979 rad → 4013
        atan_table[2]  = 16'sd4013;
        // atan(2^-3) = atan(0.125) = 0.124355 rad → 2037
        atan_table[3]  = 16'sd2037;
        // atan(2^-4) = atan(0.0625) = 0.062419 rad → 1022
        atan_table[4]  = 16'sd1022;
        // atan(2^-5) = 0.031240 rad → 512
        atan_table[5]  = 16'sd512;
        // atan(2^-6) = 0.015624 rad → 256
        atan_table[6]  = 16'sd256;
        // atan(2^-7) = 0.007812 rad → 128
        atan_table[7]  = 16'sd128;
        // atan(2^-8) = 0.003906 rad → 64
        atan_table[8]  = 16'sd64;
        // atan(2^-9) = 0.001953 rad → 32
        atan_table[9]  = 16'sd32;
        // atan(2^-10) = 0.000977 rad → 16
        atan_table[10] = 16'sd16;
        // atan(2^-11) = 0.000488 rad → 8
        atan_table[11] = 16'sd8;
    end
    
    // Direction signal based on z sign
    wire di;
    assign di = (z >= 0) ? 1'b1 : 1'b0;
    
    // Shifted values for current iteration
    wire signed [15:0] y_shifted, x_shifted;
    assign y_shifted = y >>> iter;  // Arithmetic right shift
    assign x_shifted = x >>> iter;
    
    // Next values computation
    wire signed [15:0] x_next, y_next, z_next;
    assign x_next = di ? (x - y_shifted) : (x + y_shifted);
    assign y_next = di ? (y + x_shifted) : (y - x_shifted);
    assign z_next = di ? (z - atan_table[iter]) : (z + atan_table[iter]);
    
    // Iteration counter management
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            iter <= 4'd0;
        end else if (load_init) begin
            iter <= 4'd0;
        end else if (update_iter) begin
            iter <= iter + 1;
        end
    end
    
    // Main datapath registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'sd0;
            y <= 16'sd0;
            z <= 16'sd0;
        end else if (load_init) begin
            // Initialize with gain-compensated values
            x <= CORDIC_GAIN;  // 0.60725 in Q2.14
            y <= 16'sd0;
            z <= angle_in;
        end else if (update_iter) begin
            // Update for next iteration
            x <= x_next;
            y <= y_next;
            z <= z_next;
        end
    end
    
    // Output registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cos_out <= 16'sd0;
            sin_out <= 16'sd0;
        end else if (output_result) begin
            cos_out <= x;
            sin_out <= y;
        end
    end
    
    // Done signal when iterations complete
    assign done = (iter >= ITERATIONS);

endmodule
