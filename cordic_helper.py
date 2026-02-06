#!/usr/bin/env python3
"""
CORDIC Helper Script
Converts between Q2.14 fixed-point and floating-point formats
Generates test vectors for verification
"""

import math

def real_to_q214(value):
    """Convert real number to Q2.14 format (16-bit signed)"""
    # Q2.14: 1 sign bit, 1 integer bit, 14 fractional bits
    # Range: -2.0 to +1.99994
    q214 = int(round(value * (2**14)))
    
    # Handle overflow/underflow
    if q214 > 32767:
        q214 = 32767
    elif q214 < -32768:
        q214 = -32768
    
    return q214

def q214_to_real(q214_value):
    """Convert Q2.14 format to real number"""
    # Handle as signed 16-bit integer
    if q214_value > 32767:
        q214_value = q214_value - 65536
    
    return q214_value / (2**14)

def degrees_to_radians(degrees):
    """Convert degrees to radians"""
    return degrees * math.pi / 180.0

def print_q214_hex(value, name="Value"):
    """Print Q2.14 value in decimal and hex"""
    q214 = real_to_q214(value)
    # Handle negative numbers in hex (two's complement)
    if q214 < 0:
        hex_val = (q214 + 65536) & 0xFFFF
    else:
        hex_val = q214
    print(f"{name}: {q214:6d} (0x{hex_val:04X}) = {value:.6f}")

def generate_atan_table():
    """Generate ATAN lookup table for CORDIC"""
    print("\n" + "="*60)
    print("ATAN Lookup Table for CORDIC (Q2.14 format)")
    print("="*60)
    print(f"{'i':>3} | {'2^-i':>8} | {'atan(2^-i) rad':>16} | {'Q2.14':>6} | {'Hex':>6}")
    print("-" * 60)
    
    for i in range(12):
        power = 2.0 ** (-i)
        atan_val = math.atan(power)
        q214_val = real_to_q214(atan_val)
        hex_val = q214_val & 0xFFFF
        print(f"{i:3d} | {power:8.5f} | {atan_val:16.6f} | {q214_val:6d} | 0x{hex_val:04X}")

def generate_test_vectors(angles_deg):
    """Generate test vectors for given angles"""
    print("\n" + "="*70)
    print("Test Vectors for CORDIC Testbench")
    print("="*70)
    print(f"{'Angle(°)':>8} | {'Rad':>10} | {'Q2.14':>6} | {'cos':>10} | {'sin':>10}")
    print("-" * 70)
    
    for angle_deg in angles_deg:
        angle_rad = degrees_to_radians(angle_deg)
        angle_q214 = real_to_q214(angle_rad)
        cos_val = math.cos(angle_rad)
        sin_val = math.sin(angle_rad)
        
        print(f"{angle_deg:8.2f} | {angle_rad:10.6f} | {angle_q214:6d} | "
              f"{cos_val:10.6f} | {sin_val:10.6f}")

def interactive_converter():
    """Interactive Q2.14 converter"""
    print("\n" + "="*60)
    print("Interactive Q2.14 Converter")
    print("="*60)
    print("Options:")
    print("  1. Real to Q2.14")
    print("  2. Q2.14 to Real")
    print("  3. Degrees to Q2.14 (radians)")
    print("  4. Exit")
    
    while True:
        choice = input("\nEnter choice (1-4): ").strip()
        
        if choice == '1':
            try:
                real_val = float(input("Enter real number (-2.0 to +2.0): "))
                q214 = real_to_q214(real_val)
                hex_val = q214 & 0xFFFF
                print(f"Q2.14: {q214:6d} (decimal)")
                print(f"       0x{hex_val:04X} (hex)")
                print(f"       0b{hex_val:016b} (binary)")
            except ValueError:
                print("Invalid input!")
        
        elif choice == '2':
            try:
                q214_val = int(input("Enter Q2.14 value (decimal): "))
                real_val = q214_to_real(q214_val)
                print(f"Real: {real_val:.6f}")
            except ValueError:
                print("Invalid input!")
        
        elif choice == '3':
            try:
                degrees = float(input("Enter angle in degrees: "))
                radians = degrees_to_radians(degrees)
                q214 = real_to_q214(radians)
                hex_val = q214 & 0xFFFF
                print(f"Radians: {radians:.6f}")
                print(f"Q2.14: {q214:6d} (0x{hex_val:04X})")
                print(f"Expected cos: {math.cos(radians):.6f}")
                print(f"Expected sin: {math.sin(radians):.6f}")
            except ValueError:
                print("Invalid input!")
        
        elif choice == '4':
            break
        else:
            print("Invalid choice!")

def verify_cordic_gain():
    """Verify CORDIC gain constant"""
    print("\n" + "="*60)
    print("CORDIC Gain Verification")
    print("="*60)
    
    # Calculate K = product of cos(atan(2^-i)) for i=0 to infinity
    K = 1.0
    for i in range(20):  # 20 iterations for good precision
        angle = math.atan(2.0 ** (-i))
        K *= math.cos(angle)
    
    print(f"CORDIC Gain K = {K:.10f}")
    print(f"1/K = {1/K:.10f}")
    
    gain_inv = 1.0 / K
    q214_gain = real_to_q214(gain_inv)
    hex_val = q214_gain & 0xFFFF
    
    print(f"\nFor initialization:")
    print(f"1/K in Q2.14: {q214_gain:6d} (decimal)")
    print(f"              0x{hex_val:04X} (hex)")
    print(f"This is the value used for x[0] initialization")

def main():
    print("="*70)
    print(" "*20 + "CORDIC Helper Utilities")
    print("="*70)
    
    # Generate ATAN table
    generate_atan_table()
    
    # Verify gain
    verify_cordic_gain()
    
    # Generate test vectors for common angles
    test_angles = [0, 10, 15, 20, 30, 35, 45, 50, 60, 70, 75, 85, 90]
    generate_test_vectors(test_angles)
    
    # Examples
    print("\n" + "="*60)
    print("Example Conversions")
    print("="*60)
    print_q214_hex(0.5, "0.5")
    print_q214_hex(0.707107, "√2/2 (45° sin/cos)")
    print_q214_hex(0.866025, "√3/2 (30° cos)")
    print_q214_hex(1.0, "1.0")
    print_q214_hex(math.pi/6, "π/6 (30°)")
    print_q214_hex(math.pi/4, "π/4 (45°)")
    print_q214_hex(math.pi/2, "π/2 (90°)")
    
    # Interactive mode
    print("\n" + "="*60)
    user_input = input("Enter interactive mode? (y/n): ").strip().lower()
    if user_input == 'y':
        interactive_converter()
    
    print("\n" + "="*60)
    print("Done!")
    print("="*60)

if __name__ == "__main__":
    main()
