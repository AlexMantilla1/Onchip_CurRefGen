v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 860 -320 900 -320 {lab=VDD}
N 860 -280 900 -280 {lab=VSS}
N 580 -160 580 -120 {lab=VSS}
N 580 -350 580 -310 {lab=V_rext}
N 780 -540 800 -540 {lab=Vrefp}
N 780 -400 800 -400 {lab=Vrefn}
N 580 -310 580 -300 {lab=V_rext}
N 580 -240 580 -220 {lab=V_rext}
N 800 -560 800 -540 {lab=Vrefp}
N 800 -400 800 -380 {lab=Vrefn}
N 410 -550 460 -550 {lab=Vref}
N 580 -630 580 -590 {lab=VDD}
N 610 -350 610 -310 {lab=VSS}
N 580 -300 580 -240 {lab=V_rext}
N 130 -170 130 -130 {
lab=GND}
N 210 -170 210 -130 {
lab=GND}
N 310 -170 310 -130 {
lab=GND}
N 210 -240 210 -230 {lab=VDD}
N 210 -260 210 -240 {lab=VDD}
N 130 -260 130 -230 {lab=VSS}
N 310 -260 310 -230 {lab=Vref}
N 780 -420 790 -420 {lab=#net1}
N 790 -420 940 -420 {lab=#net1}
N 940 -420 940 -350 {lab=#net1}
N 780 -440 980 -440 {lab=#net2}
N 980 -440 980 -350 {lab=#net2}
N 780 -460 1020 -460 {lab=#net3}
N 1020 -460 1020 -350 {lab=#net3}
N 780 -480 1060 -480 {lab=#net4}
N 1060 -480 1060 -350 {lab=#net4}
N 780 -500 1100 -500 {lab=#net5}
N 1100 -500 1100 -350 {lab=#net5}
N 1140 -520 1140 -350 {lab=#net6}
N 780 -520 1140 -520 {lab=#net6}
C {devices/code_shown.sym} 30 -900 0 0 {name=SETUP
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
C {res.sym} 580 -190 0 0 {name=R1
value="600k tc1=200e-6"
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 580 -120 2 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 860 -320 2 1 {name=p13 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 860 -280 2 1 {name=p14 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 800 -560 0 1 {name=p2 sig_type=std_logic lab=Vrefp}
C {lab_pin.sym} 800 -380 0 1 {name=p3 sig_type=std_logic lab=Vrefn}
C {lab_pin.sym} 580 -320 2 1 {name=p4 sig_type=std_logic lab=V_rext}
C {lab_pin.sym} 410 -550 2 1 {name=p1 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 580 -630 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 610 -310 2 0 {name=p15 sig_type=std_logic lab=VSS}
C {code.sym} 120 -530 0 0 {name=OP only_toplevel=true value="
.control
.param sw_stat_global = 1 
.param sw_stat_mismatch = 1
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

set wr_singlescale
echo $&Iref_2n $&Iref_20n $&Iref_50n $&Iref_2p $&Iref_20p $&Iref_50p > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data

.endc
"}
C {devices/vsource.sym} 130 -200 0 0 {name=V1 value=0 savecurrent=false}
C {devices/gnd.sym} 130 -130 0 0 {name=l4 lab=GND}
C {devices/vsource.sym} 210 -200 0 0 {name=V3 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 210 -130 0 0 {name=l8 lab=GND}
C {devices/vsource.sym} 310 -200 0 0 {name=V5 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 310 -130 0 0 {name=l9 lab=GND}
C {lab_pin.sym} 310 -260 2 1 {name=p5 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 210 -260 2 1 {name=p6 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 130 -260 2 1 {name=p7 sig_type=std_logic lab=VSS}
C {xschem/current_reference_generator_v2.sym} 610 -470 0 0 {name=x1}
C {/foss/designs/chipathon_2025/designs/gf180/current_reference_load_v2/xschem/current_reference_load_v2.sym} 1040 -300 0 0 {name=x2}
