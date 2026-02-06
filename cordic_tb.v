// CORDIC Testbench
// Tests the CORDIC module with various input angles
// Q2.14 format: 2 integer bits, 14 fractional bits
// Range: -2 to +1.99994

`timescale 1ns/1ps

module cordic_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg start;
    reg [15:0] angle_in;
    wire [15:0] cos_out;
    wire [15:0] sin_out;
    wire busy;
    wire done;
    
    // Test case counter
    integer test_num;
    
    // For displaying results
    real angle_real, cos_real, sin_real;
    real expected_cos, expected_sin;
    real error_cos, error_sin;
    
    // Instantiate CORDIC module
    cordic_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .angle_in(angle_in),
        .cos_out(cos_out),
        .sin_out(sin_out),
        .busy(busy),
        .done(done)
    );
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Function to convert Q2.14 to real
    function real q214_to_real;
        input signed [15:0] value;
        begin
            q214_to_real = $itor(value) / 16384.0;  // 2^14 = 16384
        end
    endfunction
    
    // Function to convert real to Q2.14
    function signed [15:0] real_to_q214;
        input real value;
        begin
            real_to_q214 = $rtoi(value * 16384.0);
        end
    endfunction
    
    // Task to run a single test
    task run_test;
        input real angle_deg;
        input real exp_cos;
        input real exp_sin;
        begin
            test_num = test_num + 1;
            
            // Convert angle from degrees to radians
            angle_real = angle_deg * 3.14159265359 / 180.0;
            
            // Convert to Q2.14 format
            angle_in = real_to_q214(angle_real);
            
            // Store expected values
            expected_cos = exp_cos;
            expected_sin = exp_sin;
            
            $display("\n========== Test %0d ==========", test_num);
            $display("Input angle: %.2f degrees (%.6f radians)", angle_deg, angle_real);
            $display("Q2.14 format: %d (0x%04h)", angle_in, angle_in);
            
            // Start computation
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for done signal
            @(posedge done);
            @(posedge clk);
            
            // Convert outputs to real
            cos_real = q214_to_real(cos_out);
            sin_real = q214_to_real(sin_out);
            
            // Calculate errors
            error_cos = cos_real - expected_cos;
            error_sin = sin_real - expected_sin;
            
            // Display results
            $display("Results:");
            $display("  cos(%.2f°) = %.6f (expected: %.6f, error: %.6f)", 
                     angle_deg, cos_real, expected_cos, error_cos);
            $display("  sin(%.2f°) = %.6f (expected: %.6f, error: %.6f)", 
                     angle_deg, sin_real, expected_sin, error_sin);
            $display("  cos Q2.14: %d (0x%04h)", cos_out, cos_out);
            $display("  sin Q2.14: %d (0x%04h)", sin_out, sin_out);
            
            // Check if error is acceptable (< 0.001)
            if ((error_cos < 0.001 && error_cos > -0.001) && 
                (error_sin < 0.001 && error_sin > -0.001)) begin
                $display("  ✓ PASS");
            end else begin
                $display("  ✗ FAIL - Error too large!");
            end
            
            // Wait a few cycles before next test
            repeat(5) @(posedge clk);
        end
    endtask
    
    // Main test sequence
    initial begin
        // Initialize
        rst = 1;
        start = 0;
        angle_in = 0;
        test_num = 0;
        
        $display("========================================");
        $display("CORDIC Algorithm Testbench");
        $display("Testing sine/cosine computation");
        $display("========================================");
        
        // Reset
        repeat(5) @(posedge clk);
        rst = 0;
        repeat(5) @(posedge clk);
        
        // Test cases - 10+ different angles in first quadrant
        // Format: angle_degrees, expected_cos, expected_sin
        
        run_test(0.0,    1.000000,  0.000000);  // 0°
        run_test(15.0,   0.965926,  0.258819);  // 15°
        run_test(30.0,   0.866025,  0.500000);  // 30°
        run_test(45.0,   0.707107,  0.707107);  // 45°
        run_test(60.0,   0.500000,  0.866025);  // 60°
        run_test(75.0,   0.258819,  0.965926);  // 75°
        run_test(90.0,   0.000000,  1.000000);  // 90°
        run_test(10.0,   0.984808,  0.173648);  // 10°
        run_test(20.0,   0.939693,  0.342020);  // 20°
        run_test(35.0,   0.819152,  0.573576);  // 35°
        run_test(50.0,   0.642788,  0.766044);  // 50°
        run_test(70.0,   0.342020,  0.939693);  // 70°
        run_test(85.0,   0.087156,  0.996195);  // 85°
        
        // End simulation
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================");
        
        repeat(10) @(posedge clk);
        $finish;
    end
    
    // Timeout watchdog
    initial begin
        #100000;  // 100 microseconds
        $display("\nERROR: Simulation timeout!");
        $finish;
    end
    
    // Optional: Dump waveforms for debugging
    initial begin
        $dumpfile("cordic_tb.vcd");
        $dumpvars(0, cordic_tb);
    end

endmodule
