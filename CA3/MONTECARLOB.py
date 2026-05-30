# -*- coding: utf-8 -*-
import sys
import os
import pandas as pd
import matplotlib.pyplot as plt

# ---------------------------------------------------
# If you want to print Unicode messages (e.g., Persian) in the console,
# use the line below (Python 3.7+):
# sys.stdout.reconfigure(encoding='utf-8')
# ---------------------------------------------------

def read_mc0(filepath):
    """
    Read a MonteCarlo output file (mc0) with a header like:
        index vdd:@:dev:@:IGNC
    and parse only the 'index' and 'dev' columns into a DataFrame,
    then compute Vdd_actual = 1.0 + dev.
    """
    colnames = None
    data = []

    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        # Step 1: Find the header line starting with "index "
        for raw in f:
            line = raw.strip()
            if not line:
                continue
            if line.startswith("index "):
                # Example header: "index vdd:@:dev:@:IGNC"
                parts = line.split(None, 1)   # ['index', 'vdd:@:dev:@:IGNC']
                rest = parts[1]               # "vdd:@:dev:@:IGNC"
                extra_cols = rest.split(":@:")  # ['vdd', 'dev', 'IGNC']
                colnames = ["index"] + extra_cols
                break

        if colnames is None:
            raise ValueError("Header line (e.g. 'index vdd:@:dev:@:IGNC') not found in file.")

        # Step 2: Read data lines until a blank line or a line starting with '$' or '.'
        for raw in f:
            line = raw.strip()
            if not line:
                # Reached a blank line → data block is over
                break

            if line.startswith("$") or line.startswith("."):
                # Entered another section (footer or different block) → stop
                break

            parts = line.split()
            if len(parts) < 2:
                continue

            try:
                idx = int(parts[0])
                dev = float(parts[1])
            except ValueError:
                # If conversion fails, skip this line
                continue

            data.append((idx, dev))

    # Convert the collected list of tuples into a DataFrame
    df = pd.DataFrame(data, columns=["index", "dev"])
    # Compute actual Vdd = nominal + dev (assuming nominal = 1.0 V)
    nominal_vdd = 1.0
    df["Vdd_actual"] = nominal_vdd + df["dev"]
    return df


if __name__ == "__main__":
    # -----------------------
    # Set the path to the mc0 file here
    filepath = "ca3_koggestone.mc0"
    # -----------------------

    if not os.path.isfile(filepath):
        print(f"ERROR: File not found: {filepath}")
        sys.exit(1)

    try:
        df_mc0 = read_mc0(filepath)

        # Display the first few rows of the DataFrame
        print("---- First 5 rows of the DataFrame ----")
        print(df_mc0.head(), "\n")

        # Number of records
        print(f"Number of records read: {len(df_mc0)}\n")

        # Descriptive statistics of the 'Vdd_actual' column
        print("Statistics for 'Vdd_actual':")
        print(df_mc0["Vdd_actual"].describe(), "\n")

        # ===============================
        # Plotting section with matplotlib
        # ===============================

        # 1. Histogram of Vdd_actual distribution
        plt.figure(figsize=(6,4))
        plt.hist(df_mc0["Vdd_actual"], bins=30, edgecolor='black')
        plt.title("Histogram of Vdd_actual")
        plt.xlabel("Vdd_actual [V]")
        plt.ylabel("Frequency")
        plt.grid(linestyle='--', alpha=0.4)
        # If you want to save the figure, use this line:
        # plt.savefig("histogram_vdd.png", dpi=150, bbox_inches='tight')
        plt.show()

        # 2. Scatter plot: index vs Vdd_actual
        plt.figure(figsize=(6,4))
        plt.scatter(df_mc0["index"], df_mc0["Vdd_actual"], s=15, alpha=0.7)
        plt.title("Scatter: index vs Vdd_actual")
        plt.xlabel("index (sample number)")
        plt.ylabel("Vdd_actual [V]")
        plt.grid(linestyle='--', alpha=0.4)
        # plt.savefig("scatter_index_vdd.png", dpi=150, bbox_inches='tight')
        plt.show()

        # If you have added another variable (e.g., delay or dynamic_power) to the DataFrame
        # (here we don't assume the mc0 file has it), you can similarly:
        #
        # plt.figure(figsize=(6,4))
        # plt.scatter(df_mc0["Vdd_actual"], df_mc0["delay"], s=15, alpha=0.7)
        # plt.title("Delay vs Vdd_actual")
        # plt.xlabel("Vdd_actual [V]")
        # plt.ylabel("Delay [unit]")
        # plt.grid(linestyle='--', alpha=0.4)
        # plt.show()
        #
        # Or for dynamic power:
        #
        # plt.figure(figsize=(6,4))
        # plt.plot(df_mc0["Vdd_actual"], df_mc0["dynamic_power"], 'o-', markersize=4, alpha=0.8)
        # plt.title("Dynamic Power vs Vdd_actual")
        # plt.xlabel("Vdd_actual [V]")
        # plt.ylabel("Dynamic Power [unit]")
        # plt.grid(linestyle='--', alpha=0.4)
        # plt.show()

    except Exception as e:
        print("ERROR occurred:", e)
        sys.exit(1)