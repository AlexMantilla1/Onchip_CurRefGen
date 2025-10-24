v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 870 -420 930 -420 {lab=#net1}
N 870 -420 870 -390 {lab=#net1}
N 800 -390 870 -390 {lab=#net1}
N 910 -450 930 -450 {lab=Vrefp}
N 910 -520 910 -450 {lab=Vrefp}
N 650 -430 690 -430 {
lab=Vout}
N 510 -480 690 -480 {
lab=Vref}
N 870 -450 910 -450 {lab=Vrefp}
N 220 -330 220 -290 {
lab=GND}
N 310 -330 310 -290 {
lab=GND}
N 400 -330 400 -290 {
lab=GND}
N 310 -400 310 -390 {lab=#net2}
N 310 -420 310 -400 {lab=#net2}
N 220 -420 220 -390 {lab=VSS}
N 400 -420 400 -390 {lab=Vref}
N 650 -430 650 -240 {lab=Vout}
N 650 -200 790 -200 {lab=Vout}
N 310 -510 310 -480 {lab=VDD}
N 1240 -170 1280 -170 {lab=VDD}
N 1240 -130 1280 -130 {lab=VSS}
N 990 -130 990 -90 {lab=VSS}
N 990 -200 990 -190 {lab=Vout}
N 1020 -260 1020 -210 {lab=VSS}
N 990 -260 990 -200 {lab=Vout}
N 990 -540 990 -500 {lab=VDD}
N 1320 -290 1320 -200 {lab=#net3}
N 1360 -310 1360 -200 {lab=#net4}
N 1400 -330 1400 -200 {lab=#net5}
N 1440 -350 1440 -200 {lab=#net6}
N 790 -200 990 -200 {lab=Vout}
N 1190 -310 1200 -310 {lab=#net7}
N 1320 -330 1320 -290 {lab=#net3}
N 1190 -330 1320 -330 {lab=#net3}
N 1360 -350 1360 -310 {lab=#net4}
N 1190 -350 1360 -350 {lab=#net4}
N 1400 -370 1400 -330 {lab=#net5}
N 1190 -370 1400 -370 {lab=#net5}
N 1440 -390 1440 -350 {lab=#net6}
N 1190 -390 1440 -390 {lab=#net6}
N 1190 -410 1470 -410 {lab=#net8}
N 1470 -410 1480 -410 {lab=#net8}
N 1480 -410 1480 -200 {lab=#net8}
N 1520 -430 1520 -200 {lab=#net9}
N 1190 -430 1520 -430 {lab=#net9}
N 650 -240 650 -200 {lab=Vout}
C {lab_pin.sym} 760 -370 2 1 {name=p7 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 760 -350 2 1 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 760 -330 2 1 {name=p2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 510 -480 2 1 {name=p4 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 910 -520 0 1 {name=p17 sig_type=std_logic lab=Vrefp}
C {code.sym} 60 -400 0 0 {name=PSR only_toplevel=true value="
.save all
.save @m.x3.xm1.m0[id]
.save @m.x3.xm2.m0[id]
.save @m.x3.xm3.m0[id]
.save @m.x3.xm4.m0[id]
.save @m.x3.xm5.m0[id]
.save @m.x3.xm6.m0[id]
.control

*AC simulation
ac dec 10 1 10e9

let Iref_2n = db(@m.x3.xm1.m0[id])
let Iref_20n = db(@m.x3.xm2.m0[id])
let Iref_50n = db(@m.x3.xm3.m0[id])
let Iref_2p = db(@m.x3.xm4.m0[id])
let Iref_20p = db(@m.x3.xm5.m0[id])
let Iref_50p = db(@m.x3.xm6.m0[id])

meas ac psr_2n find Iref_2n at=10
meas ac psr_20n find Iref_20n at=10
meas ac psr_50n find Iref_50n at=10
meas ac psr_2p find Iref_2p at=10
meas ac psr_20p find Iref_20p at=10
meas ac psr_50p find Iref_50p at=10

set wr_singlescale
*set wr_vecnames
echo $&psr_2n $&psr_20n $&psr_50n $&psr_2p $&psr_20p  $&psr_50p > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"


    

    }
C {devices/vsource.sym} 220 -360 0 0 {name=V3 value=0 savecurrent=false}
C {devices/gnd.sym} 220 -290 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} 310 -360 0 0 {name=V6 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 310 -290 0 0 {name=l3 lab=GND}
C {devices/vsource.sym} 400 -360 0 0 {name=V7 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 400 -290 0 0 {name=l10 lab=GND}
C {lab_pin.sym} 400 -420 2 1 {name=p19 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 310 -510 2 1 {name=p20 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 220 -420 2 1 {name=p21 sig_type=std_logic lab=VSS}
C {devices/code_shown.sym} 50 -760 0 0 {name=SETUP
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
C {vsource.sym} 310 -450 0 0 {name=V5 value="AC 1" savecurrent=false}
C {lab_pin.sym} 990 -90 2 1 {name=p5 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 1240 -170 2 1 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1240 -130 2 1 {name=p6 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 1020 -210 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 990 -540 0 1 {name=p18 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 990 -230 2 1 {name=p8 sig_type=std_logic lab=Vout}
C {res.sym} 990 -160 0 0 {name=R1
value="600k tc1=200e-6"
footprint=1206
device=resistor
m=1}
C {noconn.sym} 1200 -310 2 0 {name=l1}
C {/foss/designs/chipathon_2025/designs/gf180/current_reference_second_stage_v2/xschem/current_reference_second_stage_v2.sym} 1050 -380 0 0 {name=x2}
C {/foss/designs/chipathon_2025/designs/gf180/current_reference_load_v2/xschem/current_reference_load_v2.sym} 1420 -150 0 0 {name=x3}
C {/foss/designs/chipathon_2025/designs/gf180/error_amplifier_N_input_v3/xschem/error_amplifier_N_input_v3.sym} 780 -450 0 0 {name=x1}
