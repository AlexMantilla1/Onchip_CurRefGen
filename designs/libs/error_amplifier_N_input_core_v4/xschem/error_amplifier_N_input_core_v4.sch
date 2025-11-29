v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {FOLDED CASCODE OTA} 320 -710 0 0 0.4 0.4 {}
T {FOLDED CASCODE DUMMYS} 1020 -710 0 0 0.4 0.4 {}
T {5uA} 370 -310 0 0 0.4 0.4 {}
T {5uA} 130 -310 0 0 0.4 0.4 {}
T {1uA} 540 -50 0 0 0.4 0.4 {}
T {1uA} 730 -50 0 0 0.4 0.4 {}
T {6uA} 540 -650 0 0 0.4 0.4 {}
T {6uA} 730 -650 0 0 0.4 0.4 {}
T {10uA} 250 -50 0 0 0.4 0.4 {}
N 570 -490 570 -400 {
lab=Vdm5}
N 750 -460 750 -400 {
lab=Vdm6}
N 570 -230 570 -140 {
lab=#net1}
N 750 -230 750 -140 {
lab=Vcomn}
N 750 -340 750 -290 {
lab=Vout}
N 570 -320 570 -290 {
lab=Val}
N 660 -370 710 -370 {
lab=VbiasP2}
N 660 -540 710 -540 {
lab=Val}
N 570 -320 640 -320 {
lab=Val}
N 640 -540 640 -320 {
lab=Val}
N 660 -260 710 -260 {
lab=VbiasN2}
N 660 -110 710 -110 {
lab=VbiasN1}
N 570 -620 570 -540 {
lab=VDD}
N 660 -620 750 -620 {
lab=VDD}
N 750 -620 750 -540 {
lab=VDD}
N 190 -480 570 -480 {
lab=Vdm5}
N 660 -60 750 -60 {
lab=VSS}
N 660 -410 660 -370 {
lab=VbiasP2}
N 750 -110 750 -60 {
lab=VSS}
N 570 -110 570 -60 {
lab=VSS}
N 560 -260 570 -260 {
lab=VSS}
N 560 -260 560 -60 {
lab=VSS}
N 750 -260 760 -260 {
lab=VSS}
N 760 -260 760 -60 {
lab=VSS}
N 750 -60 760 -60 {
lab=VSS}
N 560 -370 570 -370 {
lab=VDD}
N 560 -620 560 -370 {
lab=VDD}
N 560 -620 570 -620 {
lab=VDD}
N 750 -620 760 -620 {
lab=VDD}
N 760 -620 760 -370 {
lab=VDD}
N 750 -370 760 -370 {
lab=VDD}
N 660 -300 660 -260 {
lab=VbiasN2}
N 660 -150 660 -110 {
lab=VbiasN1}
N 270 -60 560 -60 {
lab=VSS}
N 560 -60 570 -60 {
lab=VSS}
N 570 -340 570 -320 {
lab=Val}
N 610 -540 640 -540 {
lab=Val}
N 570 -510 570 -490 {
lab=Vdm5}
N 750 -510 750 -460 {
lab=Vdm6}
N 610 -370 660 -370 {
lab=VbiasP2}
N 570 -620 660 -620 {
lab=VDD}
N 610 -260 660 -260 {
lab=VbiasN2}
N 610 -110 660 -110 {
lab=VbiasN1}
N 570 -60 660 -60 {
lab=VSS}
N 640 -540 660 -540 {
lab=Val}
N 1050 -630 1050 -590 {lab=VDD}
N 1050 -530 1050 -490 {lab=VDD}
N 1050 -560 1110 -560 {lab=VDD}
N 970 -560 1010 -560 {lab=VDD}
N 1300 -430 1300 -390 {lab=VSS}
N 1300 -330 1300 -290 {lab=VSS}
N 1300 -360 1360 -360 {lab=VSS}
N 1220 -360 1260 -360 {lab=VSS}
N 1050 -430 1050 -390 {lab=VSS}
N 1050 -330 1050 -290 {lab=VSS}
N 1050 -360 1110 -360 {lab=VSS}
N 970 -360 1010 -360 {lab=VSS}
N 120 -240 150 -240 {
lab=V+}
N 390 -240 420 -240 {
lab=V-}
N 190 -210 190 -160 {
lab=#net2}
N 350 -210 350 -160 {
lab=#net2}
N 270 -160 270 -140 {
lab=#net2}
N 200 -110 230 -110 {
lab=VbiasN1}
N 270 -110 270 -60 {
lab=VSS}
N 280 -240 350 -240 {lab=VSS}
N 270 -290 270 -240 {lab=VSS}
N 190 -160 270 -160 {
lab=#net2}
N 190 -240 270 -240 {lab=VSS}
N 270 -160 350 -160 {lab=#net2}
N 270 -240 280 -240 {lab=VSS}
N 350 -450 750 -450 {lab=Vdm6}
N 350 -450 350 -270 {lab=Vdm6}
N 190 -480 190 -270 {lab=Vdm5}
N 120 -60 270 -60 {lab=VSS}
N 120 -620 560 -620 {lab=VDD}
N 750 -310 820 -310 {lab=Vout}
N 750 -200 850 -200 {lab=Vcomn}
C {devices/ipin.sym} 660 -300 2 0 {name=p45 lab=VbiasN2}
C {devices/iopin.sym} 120 -620 2 0 {name=p46 lab=VDD}
C {devices/ipin.sym} 660 -410 2 0 {name=p14 lab=VbiasP2}
C {devices/ipin.sym} 660 -150 0 0 {name=p9 lab=VbiasN1}
C {devices/ipin.sym} 120 -240 0 0 {name=p22 lab=V+}
C {devices/ipin.sym} 420 -240 2 0 {name=p15 lab=V-}
C {devices/iopin.sym} 120 -60 2 0 {name=p2 lab=VSS}
C {devices/lab_wire.sym} 670 -540 0 1 {name=p17 sig_type=std_logic lab=Val}
C {symbols/pfet_03v3.sym} 730 -540 0 0 {name=M4
L=1u
W=2u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 590 -540 0 1 {name=M3
L=1u
W=2u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 590 -370 0 1 {name=M5
L=1u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 730 -370 0 0 {name=M6
L=1u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 590 -110 0 1 {name=M9
L=2u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 730 -260 0 0 {name=M8
L=2u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 590 -260 0 1 {name=M7
L=2u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 730 -110 0 0 {name=M10
L=2u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1030 -560 0 0 {name=M15
L=1u
W=2u
nf=1
m=22
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 1050 -630 0 1 {name=p11 sig_type=std_logic lab=VDD
}
C {devices/lab_wire.sym} 1110 -560 0 1 {name=p31 sig_type=std_logic lab=VDD
}
C {devices/lab_wire.sym} 970 -560 0 0 {name=p32 sig_type=std_logic lab=VDD
}
C {devices/lab_wire.sym} 1050 -490 0 1 {name=p47 sig_type=std_logic lab=VDD
}
C {devices/lab_wire.sym} 1300 -430 0 1 {name=p40 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 1360 -360 0 1 {name=p41 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 1220 -360 0 0 {name=p42 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 1300 -290 0 1 {name=p43 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1280 -360 0 0 {name=M13
L=4u
W=2u
nf=1
m=50
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 1050 -430 0 1 {name=p18 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 1110 -360 0 1 {name=p19 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 970 -360 0 0 {name=p20 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 1050 -290 0 1 {name=p25 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1030 -360 0 0 {name=M12
L=2u
W=2u
nf=1
m=70
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/iopin.sym} 850 -200 0 0 {name=p23 lab=Vcomn}
C {devices/iopin.sym} 820 -310 0 0 {name=p21 lab=Vout}
C {devices/lab_wire.sym} 190 -480 0 0 {name=p30 sig_type=std_logic lab=Vdm5}
C {devices/lab_wire.sym} 270 -290 0 0 {name=p33 sig_type=std_logic lab=VSS
m=1}
C {devices/lab_wire.sym} 200 -110 0 0 {name=p48 sig_type=std_logic lab=VbiasN1}
C {devices/lab_wire.sym} 350 -450 0 0 {name=p49 sig_type=std_logic lab=Vdm6}
C {symbols/nfet_03v3.sym} 370 -240 0 1 {name=M1
L=4u
W=2u
nf=1
m=30
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 170 -240 0 0 {name=M2
L=4u
W=2u
nf=1
m=30
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 250 -110 0 0 {name=M11
L=2u
W=2u
nf=1
m=20
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
