v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 680 -280 690 -280 {lab=Vout}
N 690 -150 690 -70 {
lab=VSS}
N 690 -280 690 -210 {
lab=Vout}
N 420 -260 450 -260 {lab=Vref}
N 420 -310 450 -310 {lab=Vn}
N 420 -360 420 -310 {lab=Vn}
N 690 -360 690 -280 {lab=Vout}
N 110 -120 110 -80 {
lab=GND}
N 190 -120 190 -80 {
lab=GND}
N 290 -120 290 -80 {
lab=GND}
N 190 -190 190 -180 {lab=#net1}
N 190 -270 190 -250 {lab=VDD}
N 110 -210 110 -180 {lab=VSS}
N 290 -210 290 -180 {lab=Vref}
N 630 -280 680 -280 {lab=Vout}
N 610 -490 660 -490 {lab=Vout}
N 570 -440 570 -410 {lab=GND}
N 610 -450 650 -450 {lab=GND}
N 650 -450 650 -420 {lab=GND}
N 570 -420 650 -420 {lab=GND}
N 570 -520 570 -500 {lab=Vz}
N 520 -520 570 -520 {lab=Vz}
N 690 -490 690 -360 {lab=Vout}
N 660 -490 690 -490 {lab=Vout}
N 420 -520 460 -520 {lab=Vn}
N 420 -520 420 -360 {lab=Vn}
C {devices/code_shown.sym} 40 -800 0 0 {name=SETUP
simulator=ngspice
only_toplevel=false
value="
.lib CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/sm141064.ngspice CACE\{corner\}

.include CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/design.ngspice
.include CACE\{DUT_path\}

.temp CACE\{temperature\}

.option SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]

* Flag unsafe operating conditions (exceeds models' specified limits)
.option warn=1
"}
C {lab_pin.sym} 520 -200 2 1 {name=p7 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 520 -180 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 520 -160 2 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 420 -260 2 1 {name=p10 sig_type=std_logic lab=Vref}
C {capa.sym} 690 -180 0 0 {name=C1
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 690 -70 2 1 {name=p1 sig_type=std_logic lab=VSS}
C {noconn.sym} 560 -220 2 0 {name=l1}
C {lab_pin.sym} 690 -280 0 1 {name=p2 sig_type=std_logic lab=Vout}
C {devices/vsource.sym} 110 -150 0 0 {name=V0 value=0 savecurrent=false}
C {devices/gnd.sym} 110 -80 0 0 {name=l4 lab=GND}
C {devices/vsource.sym} 190 -150 0 0 {name=V1 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 190 -80 0 0 {name=l8 lab=GND}
C {devices/vsource.sym} 290 -150 0 0 {name=V3 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 290 -80 0 0 {name=l9 lab=GND}
C {lab_pin.sym} 290 -210 2 1 {name=p3 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 190 -270 2 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 110 -210 2 1 {name=p6 sig_type=std_logic lab=VSS}
C {ammeter.sym} 190 -220 2 0 {name=vdd_i savecurrent=true spice_ignore=0}
C {code.sym} 120 -460 0 0 {name=OP only_toplevel=true value="
.control
save all

*DC simulation
op

let Vout = v(Vout)
let Power = i(vdd_i)*v(VDD)

print Vout Ivdd
echo $&Vout $&Power> CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/vsource.sym} 490 -520 1 0 {name=V9 value=CACE\{Vy\}}
C {vcvs.sym} 570 -470 0 1 {name=E1 value=1}
C {devices/gnd.sym} 570 -410 0 0 {name=l11 lab=GND}
C {devices/lab_wire.sym} 570 -520 0 0 {name=p19 sig_type=std_logic lab=Vz}
C {lab_pin.sym} 420 -350 2 1 {name=p5 sig_type=std_logic lab=Vn}
C {xschem/error_amplifier_N_input_v4.sym} 540 -280 0 0 {name=x1}
