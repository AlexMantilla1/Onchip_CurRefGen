v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -260 -140 {}
N 0 80 50 80 {
lab=VbiasP2}
N 0 100 50 100 {
lab=VbiasN2}
N 0 120 50 120 {
lab=VbiasN1}
N 50 120 100 120 {lab=VbiasN1}
N 50 100 100 100 {lab=VbiasN2}
N 50 80 100 80 {lab=VbiasP2}
N -110 60 -90 60 {lab=#net1}
N 250 -70 280 -70 {lab=Vout}
N -20 -100 50 -100 {lab=V-}
N -20 -40 50 -40 {lab=V+}
N -430 70 -350 70 {lab=Vref}
N -390 90 -350 90 {lab=VDD}
N -390 110 -350 110 {lab=VSS}
N 40 20 100 20 {lab=VDD}
N 40 40 100 40 {lab=VSS}
N 40 60 100 60 {lab=Vcomn}
N -110 80 -0 80 {lab=VbiasP2}
N -110 100 0 100 {lab=VbiasN2}
N -110 120 0 120 {lab=VbiasN1}
N 0 60 40 60 {lab=Vcomn}
N 0 20 0 60 {lab=Vcomn}
N -40 20 0 20 {lab=Vcomn}
N 280 -70 380 -70 {lab=Vout}
C {devices/lab_wire.sym} -390 90 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} -390 110 0 0 {name=p5 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 40 20 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 40 40 0 0 {name=p1 sig_type=std_logic lab=VSS}
C {devices/ipin.sym} -20 -40 0 0 {name=p14 lab=V+}
C {devices/iopin.sym} 380 -70 0 0 {name=p18 lab=Vout}
C {devices/ipin.sym} -20 -100 0 0 {name=p19 lab=V-}
C {devices/ipin.sym} -430 70 0 0 {name=p9 lab=Vref}
C {devices/iopin.sym} -160 -70 2 0 {name=p15 lab=VDD}
C {devices/iopin.sym} -160 -100 2 0 {name=p10 lab=VSS}
C {devices/iopin.sym} -40 20 2 0 {name=p11 lab=Vcomn}
C {noconn.sym} -90 60 2 0 {name=l1}
C {devices/lab_wire.sym} 0 80 0 0 {name=p13 sig_type=std_logic lab=VbiasP2}
C {devices/lab_wire.sym} 0 100 0 0 {name=p16 sig_type=std_logic lab=VbiasN2}
C {devices/lab_wire.sym} 0 120 0 0 {name=p17 sig_type=std_logic lab=VbiasN1}
C {libs/error_amplifier_N_input_core_v4/xschem/error_amplifier_N_input_core_v4.sym} 150 -70 0 0 {name=x1}
C {libs/error_amplifier_N_input_bias_v4/xschem/error_amplifier_N_input_bias_v4.sym} -230 90 0 0 {name=x2}
