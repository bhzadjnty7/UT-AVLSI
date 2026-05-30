* 8-bit Kogge-Stone Adder
* University of Tehran
* Advanced VLSI Course

* Parameters
*.PARAM dev=agauss(0,0.1)
.PARAM Vdd=1
.PARAM Lmin=180n
.PARAM Wmin=180n

* Include library
.lib 'crn90g_2d5_lk_v1d2p1.l' TT

* Basic Logic Gates as Subcircuits

* Inverter (NOT gate)
.SUBCKT INV in out vdd vss
M1 out in vss vss nch L=Lmin W=Wmin
M2 out in vdd vdd pch L=Lmin W='Wmin*2'
.ENDS INV

* NAND2 gate
.SUBCKT NAND2 inA inB out vdd vss
M1 out inA vdd vdd pch L=Lmin W='Wmin*2'
M2 out inB vdd vdd pch L=Lmin W='Wmin*2'
M3 out inA net1 vss nch L=Lmin W=Wmin
M4 net1 inB vss vss nch L=Lmin W=Wmin
.ENDS NAND2

* NOR2 gate
.SUBCKT NOR2 inA inB out vdd vss
M1 out inA vss vss nch L=Lmin W=Wmin
M2 out inB vss vss nch L=Lmin W=Wmin
M3 out inA net1 vdd pch L=Lmin W='Wmin*2'
M4 net1 inB vdd vdd pch L=Lmin W='Wmin*2'
.ENDS NOR2

* AND2 gate
.SUBCKT AND2 inA inB out vdd vss
XU1 inA inB nand_out vdd vss NAND2
XU2 nand_out out vdd vss INV
.ENDS AND2

* OR2 gate
.SUBCKT OR2 inA inB out vdd vss
XU1 inA inB nor_out vdd vss NOR2
XU2 nor_out out vdd vss INV
.ENDS OR2

* XOR2 gate
.SUBCKT XOR2 A B out vdd vss
Xinv1 A Abar vdd vss INV
Xinv2 B Bbar vdd vss INV
M1 net1 A Vdd Vdd pch L=Lmin W='2*Wmin'
M2 out Bbar net1 Vdd pch L=Lmin W='2*Wmin'
M3 net2 Abar Vdd Vdd pch L=Lmin W='2*Wmin'
M4 out B net2 Vdd pch L=Lmin W='2*Wmin'
M5 out A net3 vss nch L=Lmin W=Wmin
M6 net3 B vss vss nch L=Lmin W=Wmin
M7 out Abar net4 vss nch L=Lmin W=Wmin
M8 net4 Bbar vss vss nch L=Lmin W=Wmin
.ends XOR2

* Black Cell (BC) - Group PG Logic
.SUBCKT BLACK_CELL Gi_j Pi_j Gk_i_1 Pk_i_1 Gi_k Pi_k vdd vss
* Gi_j = Gi_k + (Pi_k * Gk_i_1)
* Pi_j = Pi_k * Pk_i_1
XU1 Pi_k Gk_i_1 and_out vdd vss AND2
XU2 Gi_k and_out Gi_j vdd vss OR2
XU3 Pi_k Pk_i_1 Pi_j vdd vss AND2
.ENDS BLACK_CELL

* Grey Cell (GC) - Only generates group generate signals
.SUBCKT GREY_CELL Gi_j Gk_i_1 Pk_i Gi_k vdd vss
* Gi_j = Gi_k + (Pk_i * Gk_i_1)
XU1 Pk_i Gk_i_1 and_out vdd vss AND2
XU2 Gi_k and_out Gi_j vdd vss OR2
.ENDS GREY_CELL

* Pre-Processing Block - Generates initial P and G signals
.SUBCKT PRE_PROCESS A B P G vdd vss
XU1 A B P vdd vss XOR2
XU2 A B G vdd vss AND2
.ENDS PRE_PROCESS

* Sum Block - Computes final sum bit
.SUBCKT SUM_BLOCK P C S vdd vss
XU1 P C S vdd vss XOR2
.ENDS SUM_BLOCK

* 8-bit Kogge Stone Adder
.SUBCKT KSA8 A8 A7 A6 A5 A4 A3 A2 A1 B8 B7 B6 B5 B4 B3 B2 B1 Cin S8 S7 S6 S5 S4 S3 S2 S1 Cout vdd vss

* Pre-Processing Stage - Generate initial P and G signals
XPP1 A1 B1 P1 G1 vdd vss PRE_PROCESS
XPP2 A2 B2 P2 G2 vdd vss PRE_PROCESS
XPP3 A3 B3 P3 G3 vdd vss PRE_PROCESS
XPP4 A4 B4 P4 G4 vdd vss PRE_PROCESS
XPP5 A5 B5 P5 G5 vdd vss PRE_PROCESS
XPP6 A6 B6 P6 G6 vdd vss PRE_PROCESS
XPP7 A7 B7 P7 G7 vdd vss PRE_PROCESS
XPP8 A8 B8 P8 G8 vdd vss PRE_PROCESS

* Handle Cin by creating G0 = Cin
* Grey Cell to handle Cin for position 1
XGC0 C1 Cin P1 G1 vdd vss GREY_CELL

* Stage 1: Compute spans of 2
* Black Cells for stage 1
XBC1_1 G2_1 P2_1 G1 P1 G2 P2 vdd vss BLACK_CELL
XBC1_2 G3_2 P3_2 G2 P2 G3 P3 vdd vss BLACK_CELL
XBC1_3 G4_3 P4_3 G3 P3 G4 P4 vdd vss BLACK_CELL
XBC1_4 G5_4 P5_4 G4 P4 G5 P5 vdd vss BLACK_CELL
XBC1_5 G6_5 P6_5 G5 P5 G6 P6 vdd vss BLACK_CELL
XBC1_6 G7_6 P7_6 G6 P6 G7 P7 vdd vss BLACK_CELL
XBC1_7 G8_7 P8_7 G7 P7 G8 P8 vdd vss BLACK_CELL

* Stage 2: Compute spans of 4
* Grey Cell for C2
XGC2_1 C2 G1 P2_1 G2_1 vdd vss GREY_CELL
* Grey Cell for C3
XGC2_2 C3 G2_1 P3_2 G3_2 vdd vss GREY_CELL
* Black Cells for stage 2
XBC2_3 G4_1 P4_1 G2_1 P2_1 G4_3 P4_3 vdd vss BLACK_CELL
XBC2_4 G5_2 P5_2 G3_2 P3_2 G5_4 P5_4 vdd vss BLACK_CELL
XBC2_5 G6_3 P6_3 G4_3 P4_3 G6_5 P6_5 vdd vss BLACK_CELL
XBC2_6 G7_4 P7_4 G5_4 P5_4 G7_6 P7_6 vdd vss BLACK_CELL
XBC2_7 G8_5 P8_5 G6_5 P6_5 G8_7 P8_7 vdd vss BLACK_CELL

* Stage 3: Compute spans of 8 and final carries
* Grey Cell for C4
XGC3_1 C4 G1 P4_1 G4_1 vdd vss GREY_CELL
* Grey Cell for C5
XGC3_2 C5 G2_1 P5_2 G5_2 vdd vss GREY_CELL
* Grey Cell for C6
XGC3_3 C6 G3_2 P6_3 G6_3 vdd vss GREY_CELL
* Grey Cell for C7
XGC3_4 C7 G4_1 P7_4 G7_4 vdd vss GREY_CELL
* Grey Cell for C8
XGC3_5 C8 G5_2 P8_5 G8_5 vdd vss GREY_CELL

* Cout is equal to C8
XGC_Cout Cout G5_2 P8_5 G8_5 vdd vss GREY_CELL

* Calculate sum bits
* S_i = P_i ⊕ C_(i-1)
XS1 P1 Cin S1 vdd vss SUM_BLOCK
XS2 P2 C1 S2 vdd vss SUM_BLOCK
XS3 P3 C2 S3 vdd vss SUM_BLOCK
XS4 P4 C3 S4 vdd vss SUM_BLOCK
XS5 P5 C4 S5 vdd vss SUM_BLOCK
XS6 P6 C5 S6 vdd vss SUM_BLOCK
XS7 P7 C6 S7 vdd vss SUM_BLOCK
XS8 P8 C7 S8 vdd vss SUM_BLOCK

.ENDS KSA8

* Main circuit - Power supplies and connections
Vdd vdd 0 DC Vdd
Vvss vss 0 DC 0

.VEC 'DVF.vec'

* Instantiate the 8-bit Kogge Stone Adder
XKSA A8 A7 A6 A5 A4 A3 A2 A1 B8 B7 B6 B5 B4 B3 B2 B1 Cin S8 S7 S6 S5 S4 S3 S2 S1 Cout vdd vss KSA8

* Input signals
*VA1 A1 0 DC 1
*VA2 A2 0 DC 0
*VA3 A3 0 DC 1
*VA4 A4 0 DC 1
*VA5 A5 0 DC 0
*VA6 A6 0 DC 0
*VA7 A7 0 DC 1
*VA8 A8 0 DC 1

*VB1 B1 0 DC 0
*VB2 B2 0 DC 1
*VB3 B3 0 DC 0
*VB4 B4 0 DC 1
*VB5 B5 0 DC 0
*VB6 B6 0 DC 1
*VB7 B7 0 DC 0
*VB8 B8 0 DC 0

*VCin Cin 0 DC 0

.temp 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90

* Analysis
.tran 10ps 200ns
*.tran 1p 20n SWEEP MONTE=100

* Measure delay
.MEASURE TRAN tpd_max_Cout TRIG V(A1) VAL='Vdd/2' RISE=1 TARG V(Cout) VAL='Vdd/2' RISE=1
.MEASURE TRAN tpd_max_S8 TRIG V(A1) VAL='Vdd/2' RISE=1 TARG V(S8) VAL='Vdd/2' RISE=1
.MEASURE TRAN power_avg AVG P(Vdd) FROM=0ns TO=200ns

* Use DVF for verification
.option post=2
.END