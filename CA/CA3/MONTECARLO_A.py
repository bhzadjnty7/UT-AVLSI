import matplotlib.pyplot as plt
import numpy as np

# Path to the mc0 output file from Monte Carlo simulation
filename = "ca3_koggestone.mt0"  

# Reading the file and extracting useful lines
with open(filename, 'r') as f:
    lines = f.readlines()

# Extracting voltage and power from each line (based on mc0 file structure assumption)
voltages = []
delays = []
powers = []

for line in lines:
    parts = line.strip().split()
    if len(parts) >= 3:
        try:
            vdd = float(parts[0])      # For example, Vdd value
            delay = float(parts[1])    # For example, delay
            power = float(parts[2])    # For example, power
            voltages.append(vdd)
            delays.append(delay)
            powers.append(power)
        except ValueError:
            continue  # Ignoring lines that are not numeric

# Converting to numeric arrays
voltages = np.array(voltages)
delays = np.array(delays)
powers = np.array(powers)

# Power vs. voltage plot
plt.figure()
plt.scatter(voltages, powers, color='blue', alpha=0.6, label="Power vs Vdd")
plt.xlabel("Vdd (V)")
plt.ylabel("Dynamic Power (W)")
plt.title("Power vs. Vdd")
plt.grid(True)
plt.legend()
plt.show()

# Delay histogram
plt.figure()
plt.hist(delays, bins=30, color='green', alpha=0.7)
plt.xlabel("Delay (s)")
plt.ylabel("Frequency")
plt.title("Histogram of Delay")
plt.grid(True)
plt.show()

# Power histogram
plt.figure()
plt.hist(powers, bins=30, color='orange', alpha=0.7)
plt.xlabel("Power (W)")
plt.ylabel("Frequency")
plt.title("Histogram of Power")
plt.grid(True)
plt.show()