v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 130 -120 130 -80 {
lab=GND}
N 210 -120 210 -80 {
lab=GND}
N 310 -120 310 -80 {
lab=GND}
N 130 -210 130 -180 {lab=VSS}
N 310 -210 310 -180 {lab=Vref}
N 210 -210 210 -180 {lab=VDD}
N 950 -270 960 -270 {lab=Vout}
N 960 -140 960 -60 {
lab=VSS}
N 960 -270 960 -200 {
lab=Vout}
N 690 -250 720 -250 {lab=Vref}
N 690 -300 720 -300 {lab=Vn}
N 690 -350 690 -300 {lab=Vn}
N 960 -350 960 -270 {lab=Vout}
N 900 -270 950 -270 {lab=Vout}
N 880 -480 930 -480 {lab=Vout}
N 840 -430 840 -400 {lab=GND}
N 880 -440 920 -440 {lab=GND}
N 920 -440 920 -410 {lab=GND}
N 840 -410 920 -410 {lab=GND}
N 840 -510 840 -490 {lab=Vz}
N 790 -510 840 -510 {lab=Vz}
N 960 -480 960 -350 {lab=Vout}
N 930 -480 960 -480 {lab=Vout}
N 690 -510 730 -510 {lab=Vn}
N 690 -510 690 -350 {lab=Vn}
C {devices/launcher.sym} 190 -370 0 0 {name=h15
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/launcher.sym} 190 -440 0 0 {name=h3
descr="Netlist & sim" 
tclcommand="xschem netlist; xschem simulate"}
C {devices/code_shown.sym} 100 -780 0 0 {name=SETUP
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
C {devices/vsource.sym} 130 -150 0 0 {name=V0 value=0 savecurrent=false}
C {devices/gnd.sym} 130 -80 0 0 {name=l13 lab=GND}
C {devices/vsource.sym} 210 -150 0 0 {name=V10 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 210 -80 0 0 {name=l14 lab=GND}
C {devices/vsource.sym} 310 -150 0 0 {name=V11 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 310 -80 0 0 {name=l15 lab=GND}
C {lab_pin.sym} 310 -210 2 1 {name=p22 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 210 -210 2 1 {name=p23 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 130 -210 2 1 {name=p24 sig_type=std_logic lab=VSS}
C {code.sym} 950 -740 0 0 {name=OP only_toplevel=true value="
.control
.param sw_stat_global = 1 
.param sw_stat_mismatch = 1
save all

*DC simulation
op

let Voffset = v(Vout)-1.65

print Voffset
echo $&Voffset> CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {lab_pin.sym} 790 -190 2 1 {name=p7 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 790 -170 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 790 -150 2 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 690 -250 2 1 {name=p10 sig_type=std_logic lab=Vref}
C {capa.sym} 960 -170 0 0 {name=C1
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 960 -60 2 1 {name=p2 sig_type=std_logic lab=VSS}
C {noconn.sym} 830 -210 2 0 {name=l2}
C {lab_pin.sym} 960 -270 0 1 {name=p3 sig_type=std_logic lab=Vout}
C {devices/vsource.sym} 760 -510 1 0 {name=V9 value=CACE\{Vy\}}
C {vcvs.sym} 840 -460 0 1 {name=E1 value=1}
C {devices/gnd.sym} 840 -400 0 0 {name=l11 lab=GND}
C {devices/lab_wire.sym} 840 -510 0 0 {name=p19 sig_type=std_logic lab=Vz}
C {lab_pin.sym} 690 -340 2 1 {name=p5 sig_type=std_logic lab=Vn}
C {xschem/error_amplifier_N_input_v4.sym} 810 -270 0 0 {name=x1}
