v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
L 4 1065 -430 1485 -430 {}
L 4 1065 -380 1485 -380 {}
L 4 1195 -430 1195 -70 {}
L 4 1285 -430 1285 -70 {}
L 4 1375 -430 1375 -70 {}
L 4 1485 -430 1485 -70 {}
L 4 1065 -430 1065 -70 {}
L 4 1065 -70 1485 -70 {}
T {Expected values for inputs:} 1145 -480 0 0 0.4 0.4 {}
T {Input} 1105 -420 0 0 0.4 0.4 {}
T {Min} 1225 -420 0 0 0.4 0.4 {}
T {Typ} 1315 -420 0 0 0.4 0.4 {}
T {Max} 1415 -420 0 0 0.4 0.4 {}
T {VDD} 1105 -370 0 0 0.4 0.4 {}
T {1.8} 1315 -370 0 0 0.4 0.4 {}
T {VIN_CM} 1085 -320 0 0 0.4 0.4 {}
T {0.8} 1415 -320 0 0 0.4 0.4 {}
T {VbiasP1} 1085 -270 0 0 0.4 0.4 {}
T {VbiasP2} 1085 -220 0 0 0.4 0.4 {}
T {VbiasN1} 1085 -170 0 0 0.4 0.4 {}
T {VbiasN2} 1085 -120 0 0 0.4 0.4 {}
T {0.95} 1310 -270 0 0 0.4 0.4 {}
T {0.81} 1310 -170 0 0 0.4 0.4 {}
T {1.2} 1315 -120 0 0 0.4 0.4 {}
T {0.5} 1315 -220 0 0 0.4 0.4 {}
N 220 -70 220 -60 {lab=GND}
N 220 -160 220 -130 {lab=VbiasP2}
N 300 -70 300 -60 {lab=GND}
N 300 -160 300 -130 {lab=VbiasN2}
N 380 -70 380 -60 {lab=GND}
N 380 -160 380 -130 {lab=VbiasN1}
N 60 -70 60 -60 {lab=GND}
N 60 -160 60 -130 {lab=VDD}
N 140 -70 140 -60 {lab=GND}
N 140 -160 140 -130 {lab=VSS}
N 980 -110 980 -50 {
lab=GND}
N 890 -220 980 -220 {
lab=Vout}
N 980 -220 980 -170 {
lab=Vout}
N 590 -250 690 -250 {
lab=Vn}
N 590 -320 590 -250 {
lab=Vn}
N 980 -320 980 -220 {
lab=Vout}
N 590 -60 590 -50 {lab=GND}
N 590 -150 590 -120 {lab=Vin}
N 590 -190 590 -150 {
lab=Vin}
N 590 -190 690 -190 {
lab=Vin}
N 890 -450 940 -450 {lab=Vout}
N 850 -400 850 -370 {lab=GND}
N 890 -410 930 -410 {lab=GND}
N 930 -410 930 -380 {lab=GND}
N 850 -380 930 -380 {lab=GND}
N 850 -480 850 -460 {lab=Vz}
N 800 -480 850 -480 {lab=Vz}
N 940 -450 980 -450 {lab=Vout}
N 980 -450 980 -320 {lab=Vout}
N 590 -480 590 -320 {lab=Vn}
N 690 -90 740 -90 {lab=Vcom}
N 690 -480 720 -480 {lab=#net1}
N 780 -480 800 -480 {lab=Vz}
N 590 -480 630 -480 {lab=Vn}
C {devices/vsource.sym} 220 -100 0 0 {name=V1 value=\{VbiasP2\}}
C {devices/gnd.sym} 220 -60 0 0 {name=l2 lab=GND}
C {devices/launcher.sym} 140 -380 0 0 {name=h3
descr="Save & Netlist & sim" 
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {devices/lab_wire.sym} 220 -160 0 0 {name=p1 sig_type=std_logic lab=VbiasP2}
C {devices/vsource.sym} 300 -100 0 0 {name=V2 value=\{VbiasN2\}}
C {devices/gnd.sym} 300 -60 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 300 -160 0 0 {name=p2 sig_type=std_logic lab=VbiasN2}
C {devices/vsource.sym} 380 -100 0 0 {name=V3 value=\{VbiasN1\}}
C {devices/gnd.sym} 380 -60 0 0 {name=l3 lab=GND}
C {devices/lab_wire.sym} 380 -160 0 0 {name=p3 sig_type=std_logic lab=VbiasN1}
C {devices/lab_wire.sym} 740 -30 0 0 {name=p4 sig_type=std_logic lab=VbiasN1}
C {devices/lab_wire.sym} 740 -50 0 0 {name=p5 sig_type=std_logic lab=VbiasN2}
C {devices/lab_wire.sym} 740 -70 0 0 {name=p6 sig_type=std_logic lab=VbiasP2}
C {devices/lab_wire.sym} 740 -110 0 0 {name=p7 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 740 -130 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 60 -100 0 0 {name=V4 value=\{VDD\}}
C {devices/gnd.sym} 60 -60 0 0 {name=l5 lab=GND}
C {devices/lab_wire.sym} 60 -160 0 0 {name=p9 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 140 -100 0 0 {name=V5 value=\{VSS\}}
C {devices/gnd.sym} 140 -60 0 0 {name=l6 lab=GND}
C {devices/lab_wire.sym} 140 -160 0 0 {name=p10 sig_type=std_logic lab=VSS}
C {devices/capa.sym} 980 -140 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {devices/vsource.sym} 590 -90 0 0 {name=V6 value=\{Vin_CM\}}
C {devices/gnd.sym} 590 -50 0 0 {name=l7 lab=GND}
C {devices/lab_wire.sym} 590 -190 0 0 {name=p11 sig_type=std_logic lab=Vin}
C {devices/lab_wire.sym} 980 -220 0 0 {name=p12 sig_type=std_logic lab=Vout}
C {devices/gnd.sym} 980 -50 0 0 {name=l8 lab=GND}
C {launcher.sym} 140 -310 0 0 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {simulator_commands.sym} 130 -550 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="

* --- Include PDK and Model Files ---
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical

* --- Define Parameters for the Simulation ---
.param VDD = 3.3
.param VSS = 0
.param VbiasN1 = 0.71
.param VbiasN2 = 1.47
.param VbiasP2 = 1.01
.param Vin_CM = 1.22
.param Vout_CM = 1.65
.param Vy = (Vout_CM - Vin_CM)
.param load_cap = 1*1e-12 

* --- Simulation Commands and Analysis ---
.control
save all

** OP & DC simulations
op
dc V9 0 3.3 0.001

** DC measurements 
setplot dc1
let dvout = deriv(v(Vout))

meas dc limmin when dvout=0.98 rise=1
meas dc limmax when dvout=0.98 fall=1

let Output_swing = limmax - limmin

print Output_swing
plot dvout


write error_amplifier_N_input_core_v4_TB_os_v2.raw
.endc
"}
C {devices/vsource.sym} 660 -480 1 0 {name=V9 value=\{Vout_CM\}}
C {vcvs.sym} 850 -430 0 1 {name=E1 value=1}
C {devices/gnd.sym} 850 -370 0 0 {name=l11 lab=GND}
C {devices/lab_wire.sym} 850 -480 0 0 {name=p19 sig_type=std_logic lab=Vz}
C {devices/lab_wire.sym} 590 -350 0 0 {name=p15 sig_type=std_logic lab=Vn}
C {noconn.sym} 690 -90 2 1 {name=l9}
C {devices/lab_wire.sym} 740 -90 0 0 {name=p16 sig_type=std_logic lab=Vcom}
C {devices/vsource.sym} 750 -480 3 0 {name=V7 value=\{Vin_CM\}
}
C {gf180/error_amplifier_N_input_core_v4/xschem/error_amplifier_N_input_core_v4.sym} 790 -220 0 0 {name=x1}
