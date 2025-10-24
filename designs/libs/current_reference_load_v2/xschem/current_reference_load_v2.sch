v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {Loads} 310 -70 0 0 0.4 0.4 {}
N 150 -230 150 -200 {lab=Iref2p}
N 70 -170 110 -170 {lab=Iref2p}
N 70 -230 70 -170 {lab=Iref2p}
N 70 -230 150 -230 {lab=Iref2p}
N 150 -550 150 -450 {lab=VDD}
N 150 -390 150 -350 {lab=Iref2n}
N 70 -450 110 -450 {lab=Iref2n}
N 70 -450 70 -390 {lab=Iref2n}
N 70 -390 150 -390 {lab=Iref2n}
N 560 -550 560 -450 {lab=VDD}
N 560 -390 560 -350 {lab=Iref50n}
N 480 -450 480 -390 {lab=Iref50n}
N 480 -450 520 -450 {lab=Iref50n}
N 480 -390 560 -390 {lab=Iref50n}
N 150 -170 150 -90 {lab=VSS}
N 560 -230 560 -200 {lab=Iref50p}
N 480 -170 520 -170 {lab=Iref50p}
N 480 -230 480 -170 {lab=Iref50p}
N 480 -230 560 -230 {lab=Iref50p}
N 560 -170 560 -90 {lab=VSS}
N 150 -270 150 -230 {lab=Iref2p}
N 150 -420 150 -390 {lab=Iref2n}
N 560 -420 560 -390 {lab=Iref50n}
N 560 -270 560 -230 {lab=Iref50p}
N 360 -550 360 -450 {lab=VDD}
N 360 -390 360 -350 {lab=Iref20n}
N 280 -450 280 -390 {lab=Iref20n}
N 280 -450 320 -450 {lab=Iref20n}
N 280 -390 360 -390 {lab=Iref20n}
N 360 -230 360 -200 {lab=Iref20p}
N 280 -170 320 -170 {lab=Iref20p}
N 280 -230 280 -170 {lab=Iref20p}
N 280 -230 360 -230 {lab=Iref20p}
N 360 -170 360 -90 {lab=VSS}
N 360 -420 360 -390 {lab=Iref20n}
N 360 -270 360 -230 {lab=Iref20p}
C {lab_pin.sym} 150 -90 2 1 {name=p40 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 150 -270 2 1 {name=p41 sig_type=std_logic lab=Iref2p}
C {lab_pin.sym} 150 -550 2 1 {name=p15 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 150 -350 2 1 {name=p31 sig_type=std_logic lab=Iref2n}
C {lab_pin.sym} 560 -550 2 1 {name=p44 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 560 -350 2 1 {name=p45 sig_type=std_logic lab=Iref50n}
C {lab_pin.sym} 560 -90 2 1 {name=p21 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 560 -270 2 1 {name=p32 sig_type=std_logic lab=Iref50p}
C {ipin.sym} 780 -560 0 0 {name=p1 lab=Iref2n}
C {iopin.sym} 760 -380 0 0 {name=p23 lab=VDD}
C {iopin.sym} 760 -350 0 0 {name=p24 lab=VSS}
C {ipin.sym} 780 -500 0 0 {name=p8 lab=Iref50n}
C {ipin.sym} 780 -470 0 0 {name=p9 lab=Iref2p}
C {ipin.sym} 780 -410 0 0 {name=p10 lab=Iref50p}
C {symbols/pfet_03v3.sym} 130 -450 0 0 {name=M1
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
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 130 -170 0 0 {name=M4
L=2u
W=4u
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
C {symbols/pfet_03v3.sym} 540 -450 0 0 {name=M3
L=2u
W=2u
nf=1
m=50
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 540 -170 0 0 {name=M6
L=2u
W=4u
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
C {ipin.sym} 780 -440 0 0 {name=p2 lab=Iref20p}
C {ipin.sym} 780 -530 0 0 {name=p3 lab=Iref20n}
C {lab_pin.sym} 360 -550 2 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 360 -350 2 1 {name=p5 sig_type=std_logic lab=Iref20n}
C {lab_pin.sym} 360 -90 2 1 {name=p6 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 360 -270 2 1 {name=p7 sig_type=std_logic lab=Iref20p}
C {symbols/pfet_03v3.sym} 340 -450 0 0 {name=M2
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
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 340 -170 0 0 {name=M5
L=2u
W=4u
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
