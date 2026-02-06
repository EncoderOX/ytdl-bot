// CORDIC Top Module
// Computes sine and cosine using CORDIC algorithm
// Input: angle in radians (Q2.14 fixed-point, 16-bit)
// Output: sine and cosine values (Q2.14 fixed-point, 16-bit)
// Assumes input angle is in first quadrant [0, π/2]

module cordic_top (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [15:0] angle_in,  // Input angle in radians (Q2.14 format)
    output wire [15:0] cos_out,  // Cosine output (Q2.14 format)
    output wire [15:0] sin_out,  // Sine output (Q2.14 format)
    output wire busy,
    output wire done
);

    // Control signals between controller and datapath
    wire load_init;
    wire update_iter;
    wire output_result;
    wire done_iter;
    
    // Instantiate controller
    cordic_controller controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done_iter(done_iter),
        .load_init(load_init),
        .update_iter(update_iter),
        .output_result(output_result),
        .busy(busy),
        .done(done)
    );
    
    // Instantiate datapath
    cordic_datapath datapath (
        .clk(clk),
        .rst(rst),
        .start(start),
        .angle_in(angle_in),
        .cos_out(cos_out),
        .sin_out(sin_out),
        .done(done_iter),
        .load_init(load_init),
        .update_iter(update_iter),
        .output_result(output_result)
    );

endmodule
