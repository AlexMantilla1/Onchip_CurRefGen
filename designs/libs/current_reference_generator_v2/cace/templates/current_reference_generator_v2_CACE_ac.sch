v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 1230 -260 1270 -260 {lab=VDD}
N 1230 -220 1270 -220 {lab=VSS}
N 980 -220 980 -180 {lab=VSS}
N 980 -290 980 -280 {lab=Vout}
N 860 -510 920 -510 {lab=#net1}
N 860 -510 860 -480 {lab=#net1}
N 790 -480 860 -480 {lab=#net1}
N 900 -540 920 -540 {lab=Vrefp}
N 1010 -350 1010 -300 {lab=VSS}
N 980 -350 980 -290 {lab=Vout}
N 900 -610 900 -540 {lab=Vrefp}
N 980 -630 980 -590 {lab=VDD}
N 1310 -380 1310 -290 {lab=#net2}
N 1350 -400 1350 -290 {lab=#net3}
N 1390 -420 1390 -290 {lab=#net4}
N 1430 -440 1430 -290 {lab=#net5}
N 780 -290 980 -290 {lab=Vout}
N 640 -520 680 -520 {
lab=#net6}
N 640 -290 720 -290 {
lab=#net7}
N 640 -380 640 -330 {
lab=#net7}
N 640 -520 640 -440 {
lab=#net6}
N 500 -290 540 -290 {
lab=Vref}
N 600 -290 640 -290 {
lab=#net7}
N 460 -290 500 -290 {
lab=Vref}
N 500 -570 500 -330 {
lab=Vref}
N 500 -570 680 -570 {
lab=Vref}
N 1180 -400 1190 -400 {lab=#net8}
N 860 -540 900 -540 {lab=Vrefp}
N 210 -480 210 -440 {
lab=GND}
N 300 -480 300 -440 {
lab=GND}
N 390 -480 390 -440 {
lab=GND}
N 300 -550 300 -540 {lab=VDD}
N 300 -570 300 -550 {lab=VDD}
N 210 -570 210 -540 {lab=VSS}
N 390 -570 390 -540 {lab=Vref}
N 640 -330 640 -290 {lab=#net7}
N 500 -330 500 -290 {lab=Vref}
N 1310 -420 1310 -380 {lab=#net2}
N 1180 -420 1310 -420 {lab=#net2}
N 1350 -440 1350 -400 {lab=#net3}
N 1180 -440 1350 -440 {lab=#net3}
N 1390 -460 1390 -420 {lab=#net4}
N 1180 -460 1390 -460 {lab=#net4}
N 1430 -480 1430 -440 {lab=#net5}
N 1180 -480 1430 -480 {lab=#net5}
N 1180 -500 1460 -500 {lab=#net9}
N 1460 -500 1470 -500 {lab=#net9}
N 1470 -500 1470 -290 {lab=#net9}
N 1510 -520 1510 -290 {lab=#net10}
N 1180 -520 1510 -520 {lab=#net10}
C {lab_pin.sym} 980 -180 2 1 {name=p5 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 1230 -260 2 1 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1230 -220 2 1 {name=p6 sig_type=std_logic lab=VSS}
C {vsource.sym} 640 -410 0 0 {name=V5 value="AC 1" savecurrent=false}
C {capa.sym} 570 -290 1 0 {name=C2
m=1
value=10G
footprint=1206
device="ceramic capacitor"}
C {ind.sym} 750 -290 1 0 {name=L4
m=1
value=10G
footprint=1206
device=inductor}
C {lab_pin.sym} 750 -460 2 1 {name=p7 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 750 -440 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 750 -420 2 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 460 -290 2 1 {name=p10 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 1010 -300 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 900 -610 0 1 {name=p17 sig_type=std_logic lab=Vrefp}
C {lab_pin.sym} 980 -630 0 1 {name=p18 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 980 -320 2 1 {name=p1 sig_type=std_logic lab=Vout}
C {res.sym} 980 -250 0 0 {name=R1
value="600k tc1=200e-6"
footprint=1206
device=resistor
m=1}
C {code.sym} 50 -550 0 0 {name=AC only_toplevel=true value="
.save all
.control
save all

*AC simulation
ac dec 10 1 10e9

* measure parameters
    let vout_mag = db(abs(v(Vout)))
    let vout_phase = cph(v(Vout)) * 180/pi
    let gm = (-1)*db(abs(v(Vout)))

    meas ac A0 find vout_mag at=10
    meas ac UGB when vout_mag=0 fall=1
    meas ac PM find vout_phase when vout_mag=0
    meas ac GM find gm when vout_phase=0

set wr_singlescale
*set wr_vecnames
echo $&A0 $&UGB $&PM $&GM > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"


    

    }
C {noconn.sym} 1190 -400 2 0 {name=l1}
C {devices/vsource.sym} 210 -510 0 0 {name=V1 value=0 savecurrent=false}
C {devices/gnd.sym} 210 -440 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} 300 -510 0 0 {name=V3 value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 300 -440 0 0 {name=l8 lab=GND}
C {devices/vsource.sym} 390 -510 0 0 {name=V6 value=CACE\{Vref\} savecurrent=false}
C {devices/gnd.sym} 390 -440 0 0 {name=l9 lab=GND}
C {lab_pin.sym} 390 -570 2 1 {name=p4 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 300 -570 2 1 {name=p12 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 210 -570 2 1 {name=p13 sig_type=std_logic lab=VSS}
C {devices/code_shown.sym} 40 -850 0 0 {name=SETUP
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
C {/foss/designs/Onchip_CurRefGen/designs/libs/current_reference_second_stage_v2/xschem/current_reference_second_stage_v2.sym} 1040 -470 0 0 {name=x2}
C {/foss/designs/Onchip_CurRefGen/designs/libs/current_reference_load_v2/xschem/current_reference_load_v2.sym} 1410 -240 0 0 {name=x3}
C {/foss/designs/Onchip_CurRefGen/designs/libs/error_amplifier_N_input_v4/xschem/error_amplifier_N_input_v4.sym} 770 -540 0 0 {name=x1}
