v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 120 -140 120 -100 {
lab=GND}
N 200 -140 200 -100 {
lab=GND}
N 300 -140 300 -100 {
lab=GND}
N 200 -210 200 -200 {lab=#net1}
N 200 -290 200 -270 {lab=VDD}
N 120 -230 120 -200 {lab=VSS}
N 300 -230 300 -200 {lab=Vref}
N 900 -300 940 -300 {lab=VDD}
N 900 -260 940 -260 {lab=VSS}
N 620 -140 620 -100 {lab=VSS}
N 620 -330 620 -290 {lab=V_rext}
N 820 -520 840 -520 {lab=Vrefp}
N 820 -380 840 -380 {lab=Vrefn}
N 620 -290 620 -280 {lab=V_rext}
N 620 -220 620 -200 {lab=V_rext}
N 840 -540 840 -520 {lab=Vrefp}
N 840 -380 840 -360 {lab=Vrefn}
N 450 -530 500 -530 {lab=Vref}
N 620 -610 620 -570 {lab=VDD}
N 650 -330 650 -290 {lab=VSS}
N 620 -280 620 -220 {lab=V_rext}
N 820 -400 830 -400 {lab=#net2}
N 830 -400 980 -400 {lab=#net2}
N 980 -400 980 -330 {lab=#net2}
N 820 -420 1020 -420 {lab=#net3}
N 1020 -420 1020 -330 {lab=#net3}
N 820 -440 1060 -440 {lab=#net4}
N 1060 -440 1060 -330 {lab=#net4}
N 820 -460 1100 -460 {lab=#net5}
N 1100 -460 1100 -330 {lab=#net5}
N 820 -480 1140 -480 {lab=#net6}
N 1140 -480 1140 -330 {lab=#net6}
N 1180 -500 1180 -330 {lab=#net7}
N 820 -500 1180 -500 {lab=#net7}
C {code.sym} 150 -520 0 0 {name=OP only_toplevel=true value="
.control
save all

*OP simulation
op

*TOP

let Iref_2n = @m.x2.xm1.m0[id]
let Iref_20n = @m.x2.xm2.m0[id]
let Iref_50n = @m.x2.xm3.m0[id]
let Iref_2p = @m.x2.xm4.m0[id]
let Iref_20p = @m.x2.xm5.m0[id]
let Iref_50p = @m.x2.xm6.m0[id]
let Iqscnt= i(vdd_i) - (Iref_2n + Iref_20n + Iref_50n + Iref_2p + Iref_20p + Iref_50p)

set wr_singlescale
echo $&Iref_2n $&Iref_20n $&Iref_50n $&Iref_2p $&Iref_20p $&Iref_50p $&Iqscnt > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data

.endc
"}
C {devices/code_shown.sym} 10 -860 0 0 {name=SETUP
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
C {devices/vsource.sym} 120 -170 0 0 {name=V1 value=0 savecurrent=false}
C {devices/gnd.sym} 120 -100 0 0 {name=l4 lab=GND}
C {devices/vsource.sym} 200 -170 0 0 {name=V3 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 200 -100 0 0 {name=l8 lab=GND}
C {devices/vsource.sym} 300 -170 0 0 {name=V5 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 300 -100 0 0 {name=l9 lab=GND}
C {lab_pin.sym} 300 -230 2 1 {name=p5 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 200 -290 2 1 {name=p6 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 120 -230 2 1 {name=p7 sig_type=std_logic lab=VSS}
C {ammeter.sym} 200 -240 2 0 {name=vdd_i savecurrent=true spice_ignore=0}
C {res.sym} 620 -170 0 0 {name=R1
value="600k tc1=200e-6"
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 620 -100 2 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 900 -300 2 1 {name=p13 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 900 -260 2 1 {name=p14 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 840 -540 0 1 {name=p2 sig_type=std_logic lab=Vrefp}
C {lab_pin.sym} 840 -360 0 1 {name=p3 sig_type=std_logic lab=Vrefn}
C {lab_pin.sym} 620 -300 2 1 {name=p4 sig_type=std_logic lab=V_rext}
C {lab_pin.sym} 450 -530 2 1 {name=p1 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 620 -610 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 650 -290 2 0 {name=p15 sig_type=std_logic lab=VSS}
C {xschem/current_reference_generator_v2.sym} 650 -450 0 0 {name=x1}
C {/foss/designs/chipathon_2025/designs/gf180/current_reference_load_v2/xschem/current_reference_load_v2.sym} 1080 -280 0 0 {name=x2}
