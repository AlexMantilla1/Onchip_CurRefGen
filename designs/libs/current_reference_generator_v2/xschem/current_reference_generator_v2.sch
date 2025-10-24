v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 320 -250 360 -250 {
lab=Vrefp}
N 230 -190 300 -190 {
lab=#net1}
N 300 -220 300 -190 {
lab=#net1}
N 300 -220 360 -220 {
lab=#net1}
N 80 -230 120 -230 {
lab=Vres}
N 80 -230 80 -60 {
lab=Vres}
N 80 -50 420 -50 {
lab=Vres}
N 420 -340 420 -300 {
lab=VDD}
N 320 -300 320 -250 {
lab=Vrefp}
N 300 -250 320 -250 {
lab=Vrefp}
N 450 -60 450 -30 {lab=VSS}
N 80 -60 80 -50 {lab=Vres}
N 420 -60 420 -50 {lab=Vres}
N -80 -280 120 -280 {lab=Vref}
N -60 -170 190 -170 {lab=Vref}
N -60 -280 -60 -170 {lab=Vref}
N 320 -370 720 -370 {lab=Vrefp}
N 80 -50 80 -0 {lab=Vres}
N -80 100 450 100 {lab=VSS}
N 450 -30 450 100 {lab=VSS}
N 320 -370 320 -300 {lab=Vrefp}
N 420 -440 420 -340 {lab=VDD}
N -80 -440 420 -440 {lab=VDD}
N 620 -230 740 -230 {lab=Iref3p}
N 620 -210 740 -210 {lab=Iref2p}
N 620 -190 740 -190 {lab=Iref1p}
N 620 -170 740 -170 {lab=Iref1n}
N 620 -150 740 -150 {lab=Iref2n}
N 620 -130 740 -130 {lab=Iref3n}
N 620 -110 680 -110 {lab=Vrefn}
N 680 -110 680 -30 {lab=Vrefn}
N 680 -30 720 -30 {lab=Vrefn}
C {ipin.sym} -80 -280 0 0 {name=p22 lab=Vref}
C {iopin.sym} -80 -440 2 0 {name=p23 lab=VDD}
C {iopin.sym} -80 100 2 0 {name=p24 lab=VSS}
C {iopin.sym} 720 -370 0 0 {name=p25 lab=Vrefp}
C {iopin.sym} 720 -30 0 0 {name=p27 lab=Vrefn}
C {iopin.sym} 740 -170 0 0 {name=p15 lab=Iref1n}
C {iopin.sym} 740 -130 0 0 {name=p21 lab=Iref3n}
C {iopin.sym} 740 -190 0 0 {name=p26 lab=Iref1p}
C {iopin.sym} 740 -230 0 0 {name=p28 lab=Iref3p}
C {iopin.sym} 80 0 1 0 {name=p29 lab=Vres}
C {lab_pin.sym} 190 -150 2 1 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 190 -130 2 1 {name=p2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 620 -130 0 1 {name=p6 sig_type=std_logic lab=Iref3n}
C {lab_pin.sym} 620 -170 0 1 {name=p7 sig_type=std_logic lab=Iref1n}
C {lab_pin.sym} 620 -190 0 1 {name=p8 sig_type=std_logic lab=Iref1p}
C {lab_pin.sym} 620 -230 0 1 {name=p9 sig_type=std_logic lab=Iref3p}
C {lab_pin.sym} 620 -110 0 1 {name=p10 sig_type=std_logic lab=Vrefn}
C {lab_pin.sym} 80 -20 2 1 {name=p13 sig_type=std_logic lab=Vres}
C {iopin.sym} 740 -150 0 0 {name=p14 lab=Iref2n}
C {iopin.sym} 740 -210 0 0 {name=p16 lab=Iref2p}
C {lab_pin.sym} 620 -150 0 1 {name=p17 sig_type=std_logic lab=Iref2n}
C {lab_pin.sym} 620 -210 0 1 {name=p18 sig_type=std_logic lab=Iref2p}
C {gf180/current_reference_second_stage_v2/xschem/current_reference_second_stage_v2.sym} 480 -180 0 0 {name=x2}
C {gf180/error_amplifier_N_input_v3/xschem/error_amplifier_N_input_v3.sym} 210 -250 0 0 {name=x1}
