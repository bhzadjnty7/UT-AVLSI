**********carry ripple adder***************
.lib "crn90g_2d5_lk_v1d2p1.l" TT

* Technology Parameters
.param Lmin=180n
.param Wmin=180n
.param VDD = 1.0

********************************************************************************

****** defining subcircuit for NAND2 gate *******
.SUBCKT NAND2 A B out vdd vss
M1 out A net1 vss nch L=Lmin W=Wmin
M2 net1	B vss vss nch L=Lmin W=Wmin
M3 out A vdd vdd pch L=Lmin W='2*Wmin'
M4 out B vdd vdd pch L=Lmin W='2*Wmin'
.ENDS NAND2

******* defining subcircuit for NOR2 gate ********
.SUBCKT NOR2 A B out vdd vss
M1 out A vss vss nch L=Lmin W=Wmin
M2 out B vss vss nch L=Lmin W=Wmin
M3 out A net1 vdd pch L=Lmin W='2*Wmin'
M4 net1 B vdd vdd pch L=Lmin W='2*Wmin'
.ENDS NOR2

****** defining subcircuit for inverter gate ********
.SUBCKT	INV in out vdd vss
M1	out	in	vss	vss	nch	L=Lmin	W=Wmin
M2	out	in	vdd vdd pch L=Lmin  W='2*Wmin'
.ENDS INV

****** defining subcircuit for XOR2 gate *******
.SUBCKT XOR2 A B out vdd vss
Xinv1 A Abar vdd vss INV
Xinv2 B Bbar vdd vss INV
M1 net1 A Vdd Vdd pch L=Lmin W='2*Wmin'
M2 out Bbar net1 Vdd pch L=Lmin W='2*Wmin'
M3 net2 Abar Vdd Vdd pch L=Lmin W='2*Wmin'
M4 out B net2 Vdd pch L=Lmin W='2*Wmin'
M5 out A net3 vss nch L=Lmin W='Wmin'
M6 net3 B vss vss nch L=Lmin W='Wmin'
M7 out Abar net4 vss nch L=Lmin W='Wmin'
M8 net4 Bbar vss vss nch L=Lmin W='Wmin'
.ends XOR2

********************************************************************************
* defining subcircuit for AND2 gate
.SUBCKT AND2 A B out vdd vss
X1 A B net1 vdd vss NAND2
X2 net1 out vdd vss INV
.ENDS AND2

********************************************************************************
* defining subcircuit for OR2 GATE 
.SUBCKT OR2 A B out vdd vss
X1 A B net1 vdd vss NOR2
X2 net1 out vdd vss INV
.ENDS OR2

********************************************************************************
***** defining subcircuit for Full Adder *****
.SUBCKT FA a b cin sum cout vdd vss
* Generate sum: a XOR b XOR cin
X1 a b net1 vdd vss XOR2
X2 net1 cin sum vdd vss XOR2

* Generate Cout(carry) = AB + Cin(A XOR B)
X3 a b net2 vdd vss AND2
X4 net1 cin net3 vdd vss AND2
X5 net2 net3 cout vdd vss OR2
.ENDS FA

********************************************************************************
* 8-bit Ripple-Carry Adder
.SUBCKT RCA8 A8 A7 A6 A5 A4 A3 A2 A1 B8 B7 B6 B5 B4 B3 B2 B1 Cin S8 S7 S6 S5 S4 S3 S2 S1 Cout vdd vss
XFA1 A1 B1 Cin S1 C2 vdd vss FA
XFA2 A2 B2 C2 S2 C3 vdd vss FA
XFA3 A3 B3 C3 S3 C4 vdd vss FA
XFA4 A4 B4 C4 S4 C5 vdd vss FA
XFA5 A5 B5 C5 S5 C6 vdd vss FA
XFA6 A6 B6 C6 S6 C7 vdd vss FA
XFA7 A7 B7 C7 S7 C8 vdd vss FA
XFA8 A8 B8 C8 S8 Cout vdd vss FA
.ENDS RCA8

********************************************************************************
* Testbench
Vdd vdd 0 DC 'VDD'
Vss vss 0 DC 0

.VEC 'DVF1.vec'

XRCA8 A8 A7 A6 A5 A4 A3 A2 A1 B8 B7 B6 B5 B4 B3 B2 B1 Cin S8 S7 S6 S5 S4 S3 S2 S1 Cout vdd vss RCA8

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

.tran 10ps 5000n

* measuring delay
.measure tran delay_Cout TRIG v(A1) VAL='Vdd/2' RISE=1 TARG v(Cout) VAL='Vdd/2' RISE=1
.measure tran delay_S8 TRIG v(A1) VAL='Vdd/2' RISE=1 TARG v(S8) VAL='Vdd/2' RISE=1

.MEASURE TRAN power_avg AVG P(Vdd) FROM=0ns TO=5000ns

.option post = 2

.end