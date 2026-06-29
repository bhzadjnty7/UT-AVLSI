<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:2E1065,50:5B21B6,100:7C3AED&height=220&section=header&text=AVLSI%20Course%20Projects&fontSize=38&fontColor=ffffff&animation=fadeIn&fontAlignY=38"/>
</p>

<hr style="height:4px; border:none; background: linear-gradient(90deg, #2c3e66, #4a90e2, #2c3e66); margin: 20px 0 20px 0;">

# Advanced VLSI Course Repository – University of Tehran

This repository contains all **Computer Assignments (CA)**, **Homeworks (HW)**, and **Quiz Solutions** for the **Advanced VLSI** course taught by **Dr. Vahdat** at the Faculty of Electrical and Computer Engineering, University of Tehran, during **Spring 2025**.( Includes Cadence Virtuoso layouts, HSPICE simulations, timing/power analysis, Monte Carlo, and Kogge‑Stone adders.)

![University](https://img.shields.io/badge/University-Tehran-blue?style=flat-square)
![Course](https://img.shields.io/badge/Course-Advanced%20VLSI-blue?style=flat-square)
![Instructor](https://img.shields.io/badge/Instructor-Dr.%20Vahdat-lightgrey?style=flat-square)
![Semester](https://img.shields.io/badge/Semester-Spring%202025-green?style=flat-square)
![CAD](https://img.shields.io/badge/CAD-Cadence%20Virtuoso-orange?style=flat-square)
![Simulation](https://img.shields.io/badge/Simulation-HSPICE-red?style=flat-square)
![Tech_0.18µm](https://img.shields.io/badge/Technology-TSMC18rf%200.18µm-yellow?style=flat-square)
![Tech_90nm](https://img.shields.io/badge/Technology-90nm-purple?style=flat-square)
![Tech_32nm](https://img.shields.io/badge/Technology-32nm-cyan?style=flat-square)
![Layout](https://img.shields.io/badge/Flow-DRC%2FLVS%2FPEX-brightgreen?style=flat-square)

## Table of Contents

- [Repository Structure](#repository-structure)
- [Computer Assignments (CA) – Detailed Description](#computer-assignments-ca--detailed-description)
  - [CA1 – Basic Gates, Full Adders, and Layout](#ca1--basic-gates-full-adders-and-layout)
  - [CA2 – Effect of Gate Sizing on Delay and Power](#ca2--effect-of-gate-sizing-on-delay-and-power)
  - [CA3 – Adder Comparison, Monte Carlo, and Temperature Analysis](#ca3--adder-comparison-monte-carlo-and-temperature-analysis)
  - [CA4 – Memory Elements and Timing Constraints](#ca4--memory-elements-and-timing-constraints)
- [Homeworks (HW) – Summary](#homeworks-hw--summary)
- [Quizzes – Summary](#quizzes--summary)
- [How to Use](#how-to-use)
- [License](#license)

## Repository Structure

```text
├── CA/ # Computer Assignments
│ ├── CA1/ # Basic gates, full adders, XOR layout
│ ├── CA2/ # Logical effort, delay optimization, HSPICE
│ ├── CA3/ # 8-bit adders (CPA / Kogge‑Stone), Monte Carlo, temperature analysis
│ └── CA4/ # Memory systems, registers, latches, timing constraints
├── HW/ # Handwritten/Homeworks
│ ├── HW1.pdf
│ ├── HW2.pdf
│ ├── HW3.pdf
│ ├── HW4.pdf
│ ├── HW5.pdf
│ └── HW6.pdf
├── Quiz/ # Quiz solutions
│ ├── Quiz1_Solution.pdf
│ ├── Quiz2_Solution.pdf
│ ├── Quiz3_Solution.pdf
│ └── Quiz4_Solution.pdf
└── README.md
```

> Each `CAx/` folder contains simulation files (HSPICE, Cadence, DVF), the problem statement (PDF), the final report, and relevant output images.

---

## 📚 Computer Assignments (CA) – Detailed Description

### CA1 – Basic Gates, Full Adders, and Layout
In this assignment, we first designed the schematic and symbol of fundamental gates (INV, AND, NAND, XOR, 2:1 MUX) using **Cadence Virtuoso** with the **TSMC18rf** 0.18 µm technology. Transistor widths followed a given table, and all lengths were 180 nm. After verifying the gates with transient simulations (using pulse voltage sources), we constructed two different full‑adder architectures: one based on NAND gates and another alternative structure. Using these, we implemented 4‑bit ripple‑carry adders for each type, as well as a Manchester carry‑chain adder. We measured propagation delays and power consumption for all structures. Finally, we drew the **layout** of the XOR gate, performed DRC, LVS, and PEX (parasitic extraction), and ran post‑layout simulations to compare the results with the ideal schematic.

### CA2 – Effect of Gate Sizing on Delay and Power
The goal of this exercise was to understand how transistor dimensions affect circuit delay. We first computed the optimal gate sizes using the **logical effort** method for a given combinational path, then implemented the circuit in **HSPICE** using a 32 nm technology library. The design included parameterized subcircuits so that the size of each gate could be scaled by a user‑defined variable. After simulating the circuit with the calculated sizes, we measured the rise and fall times at the output node. We then swept the size parameter of one NAND gate over 20 values around the theoretical optimum and observed the resulting changes in delay. In the final step, we added tapered inverters to the path to minimize the overall propagation delay, demonstrating the trade‑off between delay and area.

### CA3 – Adder Comparison, Monte Carlo, and Temperature Analysis
This part focused on comparing two 8‑bit adder architectures: a **Carry Propagation Adder (CPA)** and a **Kogge‑Stone Adder**. We described both adders in HSPICE using modular subcircuits and verified their functionality with a **Digital Vector File (DVF)** containing more than 1000 random input patterns. For each adder, we measured the worst‑case delay, dynamic power, and static power. The analysis was extended to process corners (TT, SS, FF, FS, SF) using the 90 nm library. We also performed **Monte Carlo simulations** to study the effect of supply voltage variations (Vdd with Gaussian distribution) on delay and power, plotting histograms and voltage‑dependency graphs. Finally, we swept the temperature from 15 °C to 90 °C and observed how delay and dynamic power evolved, explaining the underlying physical phenomena.

### CA4 – Memory Elements and Timing Constraints
In the last assignment, we designed a combinational circuit (with a 100 fF load) and measured its worst‑case delay. We then implemented a **D‑Latch** and a **Master‑Slave D‑Flip‑Flop** using the mm018 library (180 nm / 220 nm minimum lengths). Placing the combinational block between two registers, we computed the maximum operating frequency based on setup/hold constraints. Next, we replaced the registers with latches and investigated **time borrowing** – the ability of a latch to “borrow” time from the next clock cycle. By breaking the combinational logic into smaller pieces and inserting latches between them (as shown in Figures 5, 6, 7 of the problem statement), we compared the achievable clock frequencies. The final analysis showed how pipeline partitioning with latches can increase throughput even when the clock duty cycle is not perfectly balanced.

---

## Homeworks (HW) – Summary

| HW# | Main Topics |
|-----|--------------|
| **HW1** | Threshold voltage extraction, mobility, body effect, temperature impact, short‑channel effects |
| **HW2** | Threshold gate design, Boolean logic realization, stick diagram extraction |
| **HW3** | Elmore delay estimation, logical effort of NAND/NOR gates, inverter chain optimization for large capacitive loads |
| **HW4** | Switching power calculation (activity factor), power gating using PMOS sleep transistors |
| **HW5** | Timing constraints (setup/hold, pcq, pdq), minimum clock period, time borrowing in latch‑based systems |
| **HW6** | Skin effect, RC modeling of long interconnects, Elmore delay of on‑chip wires |

---

## Quizzes – Summary

- **Quiz 1:** Transistor current with series resistance, transistor‑level implementation of a logic function.  
- **Quiz 2:** (Solution provided; problem statement not included – only detailed solution)  
- **Quiz 3:** Inverter rise/fall delay, optimal supply voltage using the Energy‑Delay Product (EDP) criterion.  
- **Quiz 4:** Setup/hold analysis in the presence of clock skew and jitter, violation detection and post‑silicon workarounds.

---

## How to Use

1. Each `CAx/` folder contains:
   - Problem statement (PDF, in Persian)
   - Simulation files (`.sp`, `.scs`, `.vec`, library files)
   - Final report (PDF or Markdown) with screenshots and tables
2. To run HSPICE simulations:
   ```bash
   hspice input_file.sp -o output_dir
   ```
3. For Cadence Virtuoso (CA1), access to the TSMC18rf library is required.

* Note: Process library files and transistor models are not included in this repository due to distribution restrictions. Please obtain them from university resources or official vendors.

---
## License
This repository is for educational purposes only. Feel free to use the content with proper attribution.

---
## Author

**Behzad Jannati**
M.Sc. Student – Computer Architecture
University of Tehran

GitHub: [https://github.com/bhzadjnty7](https://github.com/bhzadjnty7)

Linkedin: [www.linkedin.com/in/behzadjannati](www.linkedin.com/in/behzadjannati)

* Instructor: Dr. Shaghayegh Vahdat
* Semester: Spring 2025
---
## ⭐️ Support

If you find this repository useful, consider giving it a ⭐️

---
<div align="center"> <sub>Built with ❤️ using Hspice and Python</sub> </div> 
