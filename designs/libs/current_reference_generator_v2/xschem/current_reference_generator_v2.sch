v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 520 -480 560 -480 {
lab=Vrefp}
N 430 -420 500 -420 {
lab=#net1}
N 500 -450 500 -420 {
lab=#net1}
N 500 -450 560 -450 {
lab=#net1}
N 280 -460 320 -460 {
lab=Vres}
N 280 -460 280 -290 {
lab=Vres}
N 280 -280 620 -280 {
lab=Vres}
N 620 -570 620 -530 {
lab=VDD}
N 520 -530 520 -480 {
lab=Vrefp}
N 500 -480 520 -480 {
lab=Vrefp}
N 650 -290 650 -260 {lab=VSS}
N 280 -290 280 -280 {lab=Vres}
N 620 -290 620 -280 {lab=Vres}
N 120 -510 320 -510 {lab=Vref}
N 140 -400 390 -400 {lab=Vref}
N 140 -510 140 -400 {lab=Vref}
N 520 -600 920 -600 {lab=Vrefp}
N 280 -280 280 -230 {lab=Vres}
N 120 -130 650 -130 {lab=VSS}
N 650 -260 650 -130 {lab=VSS}
N 520 -600 520 -530 {lab=Vrefp}
N 620 -670 620 -570 {lab=VDD}
N 120 -670 620 -670 {lab=VDD}
N 820 -460 940 -460 {lab=Iref3p}
N 820 -440 940 -440 {lab=Iref2p}
N 820 -420 940 -420 {lab=Iref1p}
N 820 -400 940 -400 {lab=Iref1n}
N 820 -380 940 -380 {lab=Iref2n}
N 820 -360 940 -360 {lab=Iref3n}
N 820 -340 880 -340 {lab=Vrefn}
N 880 -340 880 -260 {lab=Vrefn}
N 880 -260 920 -260 {lab=Vrefn}
C {ipin.sym} 120 -510 0 0 {name=p22 lab=Vref}
C {iopin.sym} 120 -670 2 0 {name=p23 lab=VDD}
C {iopin.sym} 120 -130 2 0 {name=p24 lab=VSS}
C {iopin.sym} 920 -600 0 0 {name=p25 lab=Vrefp}
C {iopin.sym} 920 -260 0 0 {name=p27 lab=Vrefn}
C {iopin.sym} 940 -400 0 0 {name=p15 lab=Iref1n}
C {iopin.sym} 940 -360 0 0 {name=p21 lab=Iref3n}
C {iopin.sym} 940 -420 0 0 {name=p26 lab=Iref1p}
C {iopin.sym} 940 -460 0 0 {name=p28 lab=Iref3p}
C {iopin.sym} 280 -230 1 0 {name=p29 lab=Vres}
C {lab_pin.sym} 390 -380 2 1 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 390 -360 2 1 {name=p2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 820 -360 0 1 {name=p6 sig_type=std_logic lab=Iref3n}
C {lab_pin.sym} 820 -400 0 1 {name=p7 sig_type=std_logic lab=Iref1n}
C {lab_pin.sym} 820 -420 0 1 {name=p8 sig_type=std_logic lab=Iref1p}
C {lab_pin.sym} 820 -460 0 1 {name=p9 sig_type=std_logic lab=Iref3p}
C {lab_pin.sym} 820 -340 0 1 {name=p10 sig_type=std_logic lab=Vrefn}
C {lab_pin.sym} 280 -330 2 1 {name=p13 sig_type=std_logic lab=Vres}
C {iopin.sym} 940 -380 0 0 {name=p14 lab=Iref2n}
C {iopin.sym} 940 -440 0 0 {name=p16 lab=Iref2p}
C {lab_pin.sym} 820 -380 0 1 {name=p17 sig_type=std_logic lab=Iref2n}
C {lab_pin.sym} 820 -440 0 1 {name=p18 sig_type=std_logic lab=Iref2p}
C {libs/error_amplifier_N_input_v4/xschem/error_amplifier_N_input_v4.sym} 410 -480 0 0 {name=x1}
C {libs/current_reference_second_stage_v2/xschem/current_reference_second_stage_v2.sym} 680 -410 0 0 {name=x2}
