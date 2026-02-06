# ModelSim Simulation Script for CORDIC Project
# This script automates compilation and simulation

# Create work library if it doesn't exist
vlib work

# Compile all Verilog files
echo "Compiling CORDIC modules..."
vlog cordic_datapath.v
vlog cordic_controller.v
vlog cordic_top.v
vlog cordic_tb.v

# Run simulation
echo "Starting simulation..."
vsim -c -do "run -all; quit" cordic_tb

echo "Simulation complete!"
echo "Check the output above for test results"
echo "Waveform saved in cordic_tb.vcd (use GTKWave to view)"
