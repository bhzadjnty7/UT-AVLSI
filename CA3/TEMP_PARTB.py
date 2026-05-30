# -*- coding: utf-8 -*-
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def read_mt0(filepath):
    """
    This function reads an mt0 file and:
      - Finds the header line containing 'tpd_max_cout'.
      - Skips the next header line (alter#).
      - Reads the next line which contains four numbers (delay_cout, delay_s8, power_avg, temper).
    Output: a single-row DataFrame with columns ["delay", "dynamic_power", "temper_actual"].
    """
    data = []
    found_header = False

    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        for raw in f:
            line = raw.strip()
            # Skip empty lines or metadata lines
            if not line or line.startswith("$") or line.startswith("."):
                continue

            # Find the header line containing 'tpd_max_cout'
            if not found_header and "tpd_max_cout" in line:
                found_header = True
                continue

            # Skip the 'alter#' line after the header
            if found_header and line.startswith("alter#"):
                continue

            # Read the first data line containing at least 4 numbers
            if found_header:
                parts = line.split()
                if len(parts) >= 4:
                    try:
                        delay_cout    = float(parts[0])  # tpd_max_cout
                        # delay_s8 = float(parts[1])    # tpd_max_s8  (can be ignored)
                        dynamic_power = float(parts[2])  # power_avg
                        temper_actual = float(parts[3])  # actual simulation temperature
                    except ValueError:
                        # If conversion fails, just continue
                        continue

                    data.append((delay_cout, dynamic_power, temper_actual))
                    break  # Because each mt0 file has only one data line

    if not data:
        raise ValueError(f"No valid data found in file '{filepath}' or header is incorrect.")

    df = pd.DataFrame(data, columns=["delay", "dynamic_power", "temper_actual"])
    return df


if __name__ == "__main__":
    # List of 16 simulated temperatures (index 0 → 15°C, 1 → 20°C, …, 15 → 90°C)
    temps = [15, 20, 25, 30, 35, 40, 45, 50,
             55, 60, 65, 70, 75, 80, 85, 90]

    # Arrays to store Delay and Power values for each temperature
    delays = []
    powers = []

    # Read 16 mt0 files and extract Delay/Power
    for idx, T in enumerate(temps):
        filename = f"ca3_koggestone.mt{idx}"
        if not os.path.isfile(filename):
            raise FileNotFoundError(f"mt0 file for temperature {T}°C not found: {filename}")

        df = read_mt0(filename)

        # Optional temperature validation
        temper_val = df["temper_actual"].iloc[0]
        if abs(temper_val - T) > 1e-3:
            print(f"WARNING: Temperature inside file ({temper_val}) differs from list temperature ({T}).")

        # Since there is only one data row, append directly
        delays.append(df["delay"].iloc[0])
        powers.append(df["dynamic_power"].iloc[0])

    # Convert lists to NumPy arrays
    temps_array = np.array(temps)
    delays_arr  = np.array(delays)
    powers_arr  = np.array(powers)

    # --------------------------------------------------------
    # Plot 1: Delay vs Temperature
    # --------------------------------------------------------
    plt.figure(figsize=(6,4))
    plt.plot(
        temps_array,
        delays_arr,
        marker='o',
        linestyle='-',
        color='tab:green',
        label="Delay vs Temp"
    )
    plt.title("Delay vs. Temperature")
    plt.xlabel("Temperature (°C)")
    plt.ylabel("Delay (s)")      # If delay unit is ps, write "Delay (ps)"
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.legend()
    plt.tight_layout()
    # If you want to save:
    # plt.savefig("delay_vs_temp.png", dpi=150, bbox_inches='tight')
    plt.show()

    # --------------------------------------------------------
    # Plot 2: Dynamic Power vs Temperature
    # --------------------------------------------------------
    plt.figure(figsize=(6,4))
    plt.plot(
        temps_array,
        powers_arr,
        marker='s',
        linestyle='-',
        color='tab:orange',
        label="Power vs Temp"
    )
    plt.title("Dynamic Power vs. Temperature")
    plt.xlabel("Temperature (°C)")
    plt.ylabel("Dynamic Power (W)")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.legend()
    plt.tight_layout()
    # If you want to save:
    # plt.savefig("power_vs_temp.png", dpi=150, bbox_inches='tight')
    plt.show()

    print("Plots of Delay vs Temp and Power vs Temp have been successfully drawn.")