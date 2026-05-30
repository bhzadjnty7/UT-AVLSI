def generate_dvf(num_samples=1000, filename="DVF1.vec"):
    """
    Generate DVF file for testing an 8-bit adder
    """
    import random
    
    # Open file for writing
    with open(filename, 'w') as f:
        # Section 1: Vector pattern definition
        f.write(";8-bit Adder: A[8:1] B[8:1] cin sum[8:1] cout \n")
        f.write("radix 44 44 1 44 1 \n")
        f.write(";define name for each vector \n")
        f.write("vname A[8:1] B[8:1] cin S[8:1] cout \n")
        f.write(";define IO \n")
        f.write("IO II II I OO O \n\n")
        
        # Section 2: Waveform specifications
        f.write(";define waveform characteristics \n")
        f.write("tunit ps \n")
        f.write("Period 5000 \n")
        f.write("tdelay 4900.0 00 00 0 FF 1\n")
        f.write("Slope 50 \n")
        f.write("VOH '0.8*Vdd'\n")
        f.write("VOL '0.2*Vdd'\n\n")
        
        # Section 3: Tabular data
        f.write("; tabular data\n")
        
        # Generate random data
        for _ in range(num_samples):
            a = random.randint(0, 255)  # random 8-bit number for A
            b = random.randint(0, 255)  # random 8-bit number for B
            cin = random.randint(0, 1)   # random carry input
            
            # Calculate expected output
            sum_result = (a + b + cin) & 0xFF  # lower 8 bits of the sum
            cout = 1 if (a + b + cin) > 255 else 0  # carry output
            
            # Write data to file (hexadecimal)
            f.write(f"{a:02x} {b:02x} {cin} {sum_result:02x} {cout}\n")
    
    print(f"DVF file with {num_samples} samples created at {filename}.")

# Generate file with 1000 samples
generate_dvf(1000)