v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 650 -150 730 -150 {
lab=Vx}
N 650 -200 650 -150 {
lab=Vx}
N 510 -150 550 -150 {
lab=Vref}
N 610 -150 650 -150 {
lab=Vx}
N 470 -150 510 -150 {
lab=Vref}
N 1060 -440 1060 -230 {
lab=Vout}
N 1140 -310 1140 -230 {
lab=GND}
N 1140 -440 1140 -380 {
lab=Vout}
N 990 -440 1140 -440 {
lab=Vout}
N 650 -300 650 -260 {
lab=Vn}
N 1140 -380 1140 -370 {
lab=Vout}
N 510 -230 510 -150 {lab=Vref}
N 1060 -230 1060 -150 {lab=Vout}
N 510 -410 510 -230 {lab=Vref}
N 650 -470 730 -470 {lab=Vn}
N 650 -390 650 -300 {lab=Vn}
N 650 -430 650 -390 {lab=Vn}
N 650 -470 650 -430 {lab=Vn}
N 1140 -230 1140 -210 {lab=GND}
N 730 -150 750 -150 {lab=Vx}
N 1010 -120 1060 -120 {lab=Vout}
N 1060 -150 1060 -120 {lab=Vout}
N 970 -70 970 -40 {lab=GND}
N 1010 -80 1050 -80 {lab=GND}
N 1050 -80 1050 -50 {lab=GND}
N 970 -50 1050 -50 {lab=GND}
N 970 -150 970 -130 {lab=Vz}
N 920 -150 970 -150 {lab=Vz}
N 810 -150 860 -150 {lab=Vy}
N 730 -470 760 -470 {lab=Vn}
N 510 -420 760 -420 {lab=Vref}
N 510 -420 510 -410 {lab=Vref}
N 130 -120 130 -80 {
lab=GND}
N 210 -120 210 -80 {
lab=GND}
N 310 -120 310 -80 {
lab=GND}
N 210 -190 210 -180 {lab=#net1}
N 210 -270 210 -250 {lab=VDD}
N 130 -210 130 -180 {lab=VSS}
N 310 -210 310 -180 {lab=Vref}
N 870 -380 890 -380 {lab=#net2}
N 940 -440 990 -440 {lab=Vout}
C {devices/launcher.sym} 190 -370 0 0 {name=h15
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/launcher.sym} 190 -440 0 0 {name=h3
descr="Netlist & sim" 
tclcommand="xschem netlist; xschem simulate"}
C {vsource.sym} 650 -230 0 0 {name=V5 value="AC 1" savecurrent=false}
C {capa.sym} 580 -150 1 0 {name=C2
m=1
value=10G
footprint=1206
device="ceramic capacitor"}
C {ind.sym} 780 -150 1 0 {name=L4
m=1
value=10G
footprint=1206
device=inductor}
C {capa.sym} 1140 -340 0 0 {name=C1
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1140 -440 0 1 {name=p2 sig_type=std_logic lab=Vout}
C {devices/gnd.sym} 1140 -210 0 0 {name=l9 lab=GND}
C {devices/lab_wire.sym} 690 -150 0 0 {name=p1 sig_type=std_logic lab=Vx}
C {devices/lab_wire.sym} 670 -470 0 0 {name=p17 sig_type=std_logic lab=Vn}
C {devices/vsource.sym} 890 -150 1 0 {name=V9 value=CACE\{Vy\}}
C {vcvs.sym} 970 -100 0 1 {name=E1 value=1}
C {devices/gnd.sym} 970 -40 0 0 {name=l11 lab=GND}
C {devices/lab_wire.sym} 830 -150 0 0 {name=p18 sig_type=std_logic lab=Vy}
C {devices/lab_wire.sym} 970 -150 0 0 {name=p19 sig_type=std_logic lab=Vz}
C {devices/code_shown.sym} 290 -770 0 0 {name=SETUP
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
C {code.sym} 1110 -710 0 0 {name=AC only_toplevel=true value="

.control
save all

*DC simulation
op
* run ac simulation
ac dec 20 1 100e7


* measure parameters
let vout_mag = db(abs(v(Vout)))
*let vout_phase = cph(v(Vout)) * (180/pi)
let vout_phase = cph(v(Vout)) * (57.295779513)
let gm = (-1)*db(abs(v(Vout)))

meas ac A0 find vout_mag at=1
meas ac UGB when vout_mag=0 fall=1
meas ac PM find vout_phase when vout_mag=0
meas ac GM find gm when vout_phase=0

let A0_p1 = A0 - 3
meas ac BW when vout_mag=A0_p1 

print A0 UGB PM GM BW
echo $&A0 $&UGB $&PM $&GM $&BW > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/vsource.sym} 130 -150 0 0 {name=V0 value=0 savecurrent=false}
C {devices/gnd.sym} 130 -80 0 0 {name=l13 lab=GND}
C {devices/vsource.sym} 210 -150 0 0 {name=V10 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 210 -80 0 0 {name=l14 lab=GND}
C {devices/vsource.sym} 310 -150 0 0 {name=V11 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 310 -80 0 0 {name=l15 lab=GND}
C {lab_pin.sym} 310 -210 2 1 {name=p22 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 210 -270 2 1 {name=p23 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 130 -210 2 1 {name=p24 sig_type=std_logic lab=VSS}
C {ammeter.sym} 210 -220 2 0 {name=vdd_i savecurrent=true spice_ignore=0}
C {lab_pin.sym} 830 -360 2 1 {name=p3 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 830 -340 2 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 830 -320 2 1 {name=p12 sig_type=std_logic lab=VSS}
C {noconn.sym} 890 -380 2 0 {name=l1}
C {lab_pin.sym} 470 -150 2 1 {name=p5 sig_type=std_logic lab=Vref}
C {xschem/error_amplifier_N_input_v4.sym} 850 -440 0 0 {name=x1}
