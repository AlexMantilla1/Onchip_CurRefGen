v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
L 4 1120 -495 1540 -495 {}
L 4 1120 -445 1540 -445 {}
L 4 1250 -495 1250 -135 {}
L 4 1340 -495 1340 -135 {}
L 4 1430 -495 1430 -135 {}
L 4 1540 -495 1540 -135 {}
L 4 1120 -495 1120 -135 {}
L 4 1120 -135 1540 -135 {}
T {Expected values for inputs:} 1200 -545 0 0 0.4 0.4 {}
T {Input} 1160 -485 0 0 0.4 0.4 {}
T {Min} 1280 -485 0 0 0.4 0.4 {}
T {Typ} 1370 -485 0 0 0.4 0.4 {}
T {Max} 1470 -485 0 0 0.4 0.4 {}
T {VDD} 1160 -435 0 0 0.4 0.4 {}
T {3.3} 1370 -435 0 0 0.4 0.4 {}
T {VIN_CM} 1140 -385 0 0 0.4 0.4 {}
T {0.8} 1470 -385 0 0 0.4 0.4 {}
T {VbiasP1} 1140 -335 0 0 0.4 0.4 {}
T {VbiasP2} 1140 -285 0 0 0.4 0.4 {}
T {VbiasN1} 1140 -235 0 0 0.4 0.4 {}
T {VbiasN2} 1140 -185 0 0 0.4 0.4 {}
T {0.95} 1365 -335 0 0 0.4 0.4 {}
T {0.81} 1365 -235 0 0 0.4 0.4 {}
T {1.2} 1370 -185 0 0 0.4 0.4 {}
T {0.5} 1370 -285 0 0 0.4 0.4 {}
N 790 -620 850 -620 {lab=Vout}
N 510 -330 590 -330 {
lab=Vx}
N 510 -380 510 -330 {
lab=Vx}
N 370 -330 410 -330 {
lab=Vin}
N 470 -330 510 -330 {
lab=Vx}
N 330 -330 370 -330 {
lab=Vin}
N 920 -620 920 -410 {
lab=Vout}
N 1000 -490 1000 -410 {
lab=GND}
N 1000 -620 1000 -560 {
lab=Vout}
N 850 -620 1000 -620 {
lab=Vout}
N 510 -480 510 -440 {
lab=Vn}
N 1000 -560 1000 -550 {
lab=Vout}
N 370 -410 370 -330 {lab=Vin}
N 920 -410 920 -330 {lab=Vout}
N 370 -590 590 -590 {lab=Vin}
N 370 -590 370 -410 {lab=Vin}
N 510 -650 590 -650 {lab=Vn}
N 510 -570 510 -480 {lab=Vn}
N 490 -570 510 -570 {lab=Vn}
N 490 -610 490 -570 {lab=Vn}
N 490 -610 510 -610 {lab=Vn}
N 510 -650 510 -610 {lab=Vn}
N 550 -70 550 -60 {lab=GND}
N 550 -160 550 -130 {lab=VbiasP2}
N 630 -70 630 -60 {lab=GND}
N 630 -160 630 -130 {lab=VbiasN2}
N 710 -70 710 -60 {lab=GND}
N 710 -160 710 -130 {lab=VbiasN1}
N 390 -70 390 -60 {lab=GND}
N 390 -160 390 -130 {lab=VDD}
N 470 -70 470 -60 {lab=GND}
N 470 -160 470 -130 {lab=VSS}
N 330 -240 330 -230 {lab=GND}
N 330 -330 330 -300 {lab=Vin}
N 1000 -410 1000 -390 {lab=GND}
N 590 -490 640 -490 {lab=Vcom}
N 590 -330 610 -330 {lab=Vx}
N 870 -300 920 -300 {lab=Vout}
N 920 -330 920 -300 {lab=Vout}
N 830 -250 830 -220 {lab=GND}
N 870 -260 910 -260 {lab=GND}
N 910 -260 910 -230 {lab=GND}
N 830 -230 910 -230 {lab=GND}
N 830 -330 830 -310 {lab=Vz}
N 780 -330 830 -330 {lab=Vz}
N 670 -330 720 -330 {lab=Vy}
C {simulator_commands.sym} 140 -460 0 0 {name="COMMANDS"
simulator="ngspice"
only_toplevel="false" 
value="
.option temp = 125

* --- Include PDK and Model Files ---
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice ff


* --- Simulation Commands and Analysis ---
 

*+ abstol=1e-14 savecurrents
.control
    save all 
    
** OP simulation
op
** run ac simulation
ac dec 20 0.1 100e6

** All OP parameters
setplot op1

let #####_M1_pmos_input_##### = 0 
let id_M1 = @m.x1.xm1.m0[id]
let gm_M1 = @m.x1.xm1.m0[gm]
let ro_M1 = 1/@m.x1.xm1.m0[gds]
let Vsg_M1 = @m.x1.xm1.m0[vgs]
let Vsd_M1 = @m.x1.xm1.m0[vds]
let Vbs_M1 = -@m.x1.xm1.m0[vbs]
let Vdsat_M1 = @m.x1.xm1.m0[vdsat]
let Vth_M1 = @m.x1.xm1.m0[vth]
let ao_M1 = gm_M1*ro_M1
let gmid_M1 = gm_M1/id_M1
let fT_M1 = gm_M1/(6.283185*@m.x1.xm1.m0[cgg])
print #####_M1_pmos_input_##### id_M1 gm_M1 ro_M1 Vsg_M1 Vsd_M1 Vbs_M1 Vdsat_M1 Vth_M1 ao_M1 gmid_M1 fT_M1 

let #####_M2_pmos_input_##### = 0 
let id_M2 = @m.x1.xm2.m0[id]
let gm_M2 = @m.x1.xm2.m0[gm]
let ro_M2 = 1/@m.x1.xm2.m0[gds]
let Vsg_M2 = @m.x1.xm2.m0[vgs]
let Vsd_M2 = @m.x1.xm2.m0[vds]
let Vbs_M2 = -@m.x1.xm2.m0[vbs]
let Vdsat_M2 = @m.x1.xm2.m0[vdsat]
let Vth_M2 = @m.x1.xm2.m0[vth]
let ao_M2 = gm_M2*ro_M2
let gmid_M2 = gm_M2/id_M2
let fT_M2 = gm_M2/(6.283185*@m.x1.xm2.m0[cgg])
print #####_M2_pmos_input_##### id_M2 gm_M2 ro_M2 Vsg_M2 Vsd_M2 Vbs_M2 Vdsat_M2 Vth_M2 ao_M2 gmid_M2 fT_M2 

let #####_M3_pmos_top_##### = 0 
let id_M3 = @m.x1.xm3.m0[id]
let gm_M3 = @m.x1.xm3.m0[gm]
let ro_M3 = 1/@m.x1.xm3.m0[gds]
let Vsg_M3 = @m.x1.xm3.m0[vgs]
let Vsd_M3 = @m.x1.xm3.m0[vds]
let Vbs_M3 = -@m.x1.xm3.m0[vbs]
let Vdsat_M3 = @m.x1.xm3.m0[vdsat]
let Vth_M3 = @m.x1.xm3.m0[vth]
let ao_M3 = gm_M3*ro_M3
let gmid_M3 = gm_M3/id_M3
let fT_M3 = gm_M3/(6.283185*@m.x1.xm3.m0[cgg])
print #####_M3_pmos_top_##### id_M3 gm_M3 ro_M3 Vsg_M3 Vsd_M3 Vbs_M3 Vdsat_M3 Vth_M3 ao_M3 gmid_M3 fT_M3

let #####_M4_pmos_top_##### = 0 
let id_M4 = @m.x1.xm4.m0[id]
let gm_M4 = @m.x1.xm4.m0[gm]
let ro_M4 = 1/@m.x1.xm4.m0[gds]
let Vsg_M4 = @m.x1.xm4.m0[vgs]
let Vsd_M4 = @m.x1.xm4.m0[vds]
let Vbs_M4 = -@m.x1.xm4.m0[vbs]
let Vdsat_M4 = @m.x1.xm4.m0[vdsat]
let Vth_M4 = @m.x1.xm4.m0[vth]
let ao_M4 = gm_M4*ro_M4
let gmid_M4 = gm_M4/id_M4
let fT_M4 = gm_M4/(6.283185*@m.x1.xm4.m0[cgg])
print #####_M4_pmos_top_##### id_M4 gm_M4 ro_M4 Vsg_M4 Vsd_M4 Vbs_M4 Vdsat_M4 Vth_M4 ao_M4 gmid_M4 fT_M4

let #####_M5_pmos_out_##### = 0 
let id_M5 = @m.x1.xm5.m0[id]
let gm_M5 = @m.x1.xm5.m0[gm]
let ro_M5 = 1/@m.x1.xm5.m0[gds]
let Vsg_M5 = @m.x1.xm5.m0[vgs]
let Vsd_M5 = @m.x1.xm5.m0[vds]
let Vbs_M5 = -@m.x1.xm5.m0[vbs]
let Vdsat_M5 = @m.x1.xm5.m0[vdsat]
let Vth_M5 = @m.x1.xm5.m0[vth]
let ao_M5 = gm_M5*ro_M5
let gmid_M5 = gm_M5/id_M5
let fT_M5 = gm_M5/(6.283185*@m.x1.xm5.m0[cgg])
print #####_M5_pmos_out_##### id_M5 gm_M5 ro_M5 Vsg_M5 Vsd_M5 Vbs_M5 Vdsat_M5 Vth_M5 ao_M5 gmid_M5 fT_M5

let #####_M6_pmos_out_##### = 0 
let id_M6 = @m.x1.xm6.m0[id]
let gm_M6 = @m.x1.xm6.m0[gm]
let ro_M6 = 1/@m.x1.xm6.m0[gds]
let Vsg_M6 = @m.x1.xm6.m0[vgs]
let Vsd_M6 = @m.x1.xm6.m0[vds]
let Vbs_M6 = -@m.x1.xm6.m0[vbs]
let Vdsat_M6 = @m.x1.xm6.m0[vdsat]
let Vth_M6 = @m.x1.xm6.m0[vth]
let ao_M6 = gm_M6*ro_M6
let gmid_M6 = gm_M6/id_M6
let fT_M6 = gm_M6/(6.283185*@m.x1.xm6.m0[cgg])
print #####_M6_pmos_out_##### id_M6 gm_M6 ro_M6 Vsg_M6 Vsd_M6 Vbs_M6 Vdsat_M6 Vth_M6 ao_M6 gmid_M6 fT_M6

let #####_M7_nmos_out_##### = 0 
let id_M7 = @m.x1.xm7.m0[id]
let gm_M7 = @m.x1.xm7.m0[gm]
let ro_M7 = 1/@m.x1.xm7.m0[gds]
let Vgs_M7 = @m.x1.xm7.m0[vgs]
let Vds_M7 = @m.x1.xm7.m0[vds]
let Vsb_M7 = -@m.x1.xm7.m0[vbs]
let Vdsat_M7 = @m.x1.xm7.m0[vdsat]
let Vth_M7 = @m.x1.xm7.m0[vth]
let ao_M7 = gm_M7*ro_M7
let gmid_M7 = gm_M7/id_M7
let fT_M7 = gm_M7/(6.283185*@m.x1.xm7.m0[cgg])
print #####_M7_nmos_out_##### id_M7 gm_M7 ro_M7 Vgs_M7 Vds_M7 Vsb_M7 Vdsat_M7 Vth_M7 ao_M7 gmid_M7 fT_M7

let #####_M8_nmos_out_##### = 0 
let id_M8 = @m.x1.xm8.m0[id]
let gm_M8 = @m.x1.xm8.m0[gm]
let ro_M8 = 1/@m.x1.xm8.m0[gds]
let Vgs_M8 = @m.x1.xm8.m0[vgs]
let Vds_M8 = @m.x1.xm8.m0[vds]
let Vsb_M8 = -@m.x1.xm8.m0[vbs]
let Vdsat_M8 = @m.x1.xm8.m0[vdsat]
let Vth_M8 = @m.x1.xm8.m0[vth]
let ao_M8 = gm_M8*ro_M8
let gmid_M8 = gm_M8/id_M8
let fT_M8 = gm_M8/(6.283185*@m.x1.xm8.m0[cgg])
print #####_M8_nmos_out_##### id_M8 gm_M8 ro_M8 Vgs_M8 Vds_M8 Vsb_M8 Vdsat_M8 Vth_M8 ao_M8 gmid_M8 fT_M8
let #####_M9_nmos_bottom_##### = 0 
let id_M9 = @m.x1.xm9.m0[id]
let gm_M9 = @m.x1.xm9.m0[gm]
let ro_M9 = 1/@m.x1.xm9.m0[gds]
let Vgs_M9 = @m.x1.xm9.m0[vgs]
let Vds_M9 = @m.x1.xm9.m0[vds]
let Vsb_M9 = -@m.x1.xm9.m0[vbs]
let Vdsat_M9 = @m.x1.xm9.m0[vdsat]
let Vth_M9 = @m.x1.xm9.m0[vth]
let ao_M9 = gm_M9*ro_M9
let gmid_M9 = gm_M9/id_M9
let fT_M9 = gm_M9/(6.283185*@m.x1.xm9.m0[cgg])
print #####_M9_nmos_bottom_##### id_M9 gm_M9 ro_M9 Vgs_M9 Vds_M9 Vsb_M9 Vdsat_M9 Vth_M9 ao_M9 gmid_M9 fT_M9

let #####_M10_nmos_bottom_##### = 0 
let id_M10 = @m.x1.xm10.m0[id]
let gm_M10 = @m.x1.xm10.m0[gm]
let ro_M10 = 1/@m.x1.xm10.m0[gds]
let Vgs_M10 = @m.x1.xm10.m0[vgs]
let Vds_M10 = @m.x1.xm10.m0[vds]
let Vsb_M10 = @m.x1.xm10.m0[vbs]
let Vdsat_M10 = @m.x1.xm10.m0[vdsat]
let Vth_M10 = @m.x1.xm10.m0[vth]
let ao_M10 = gm_M10*ro_M10
let gmid_M10 = gm_M10/id_M10
let fT_M10 = gm_M10/(6.283185*@m.x1.xm10.m0[cgg])
print #####_M10_nmos_bottom_##### id_M10 gm_M10 ro_M10 Vgs_M10 Vds_M10 Vsb_M10 Vdsat_M10 Vth_M10 ao_M10 gmid_M10 fT_M10

let #####_M11_pmos_mirror_##### = 0 
let id_M11 = @m.x1.xm11.m0[id]
let gm_M11 = @m.x1.xm11.m0[gm]
let ro_M11 = 1/@m.x1.xm11.m0[gds]
let Vsg_M11 = @m.x1.xm11.m0[vgs]
let Vsd_M11 = @m.x1.xm11.m0[vds]
let Vbs_M11 = -@m.x1.xm11.m0[vbs]
let Vdsat_M11 = @m.x1.xm11.m0[vdsat]
let Vth_M11 = @m.x1.xm11.m0[vth]
let ao_M11 = gm_M11*ro_M11
let gmid_M11 = gm_M11/id_M11
let fT_M11 = gm_M11/(6.283185*@m.x1.xm11.m0[cgg])
print #####_M11_pmos_mirror_##### id_M11 gm_M11 ro_M11 Vsg_M11 Vsd_M11 Vbs_M11 Vdsat_M11 Vth_M11 ao_M11 gmid_M11 fT_M11

** Custom output
let #####_Custom_output_##### = 0

* DC_gain
let power = i(v4)*VDD*(-1)
let r1 = ao_M6*ro_M4
let r2 = ao_M8*((ro_M1*ro_M10)/(ro_M1+ro_M10))
let Rout = (r1*r2)/(r1+r2)
let Av = db(gm_M1*Rout)
* Bandwidth 
let BW = 1/(Rout*1e-12*6.283185)
let BW_2 = 1/(Rout*5p*6.283185)


print #####_Custom_output_##### power Av BW BW_2 Rout gm_M1 ro_M1 gm_M6 ro_M6 ro_M4 gm_M8 ro_M8 ro_M10


    remzerovec
    write error_amplifier_N_input_TB_ac_v2.raw
    set appendwrite
    setplot ac1

    * measure parameters
    let vout_mag_VV = abs(v(Vout))
    let vout_mag = db(abs(v(Vout)))
    let vout_phase = cph(v(Vout)) * 180/pi
    let gm = (-1)*db(abs(v(Vout)))

    meas ac A0 find vout_mag at=0.1
    meas ac UGB when vout_mag=0 fall=1
    meas ac PM find vout_phase when vout_mag=0
    meas ac GM find gm when vout_phase=0

    let A0_p1 = A0 - 3
    meas ac BW when vout_mag=A0_p1
    
    plot vout_mag
    *plot vout_phase
.endc
"}
C {devices/launcher.sym} 160 -620 0 0 {name=h15
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/launcher.sym} 160 -690 0 0 {name=h3
descr="Netlist & sim" 
tclcommand="xschem netlist; xschem simulate"}
C {vsource.sym} 510 -410 0 0 {name=V5 value="AC 1" savecurrent=false}
C {capa.sym} 440 -330 1 0 {name=C2
m=1
value=10G
footprint=1206
device="ceramic capacitor"}
C {ind.sym} 640 -330 1 0 {name=L4
m=1
value=10G
footprint=1206
device=inductor}
C {lab_pin.sym} 640 -530 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 640 -510 2 1 {name=p9 sig_type=std_logic lab=VSS}
C {capa.sym} 1000 -520 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {noconn.sym} 590 -490 2 1 {name=l1}
C {lab_pin.sym} 1000 -620 0 1 {name=p2 sig_type=std_logic lab=Vout}
C {lab_pin.sym} 640 -470 2 1 {name=p6 sig_type=std_logic lab=VbiasP2}
C {lab_pin.sym} 640 -450 2 1 {name=p7 sig_type=std_logic lab=VbiasN2}
C {lab_pin.sym} 640 -430 2 1 {name=p11 sig_type=std_logic lab=VbiasN1}
C {devices/vsource.sym} 550 -100 0 0 {name=V1 value=\{VbiasP2\}}
C {devices/gnd.sym} 550 -60 0 0 {name=l2 lab=GND}
C {devices/lab_wire.sym} 550 -160 0 0 {name=p3 sig_type=std_logic lab=VbiasP2}
C {devices/vsource.sym} 630 -100 0 0 {name=V2 value=\{VbiasN2\}}
C {devices/gnd.sym} 630 -60 0 0 {name=l3 lab=GND}
C {devices/lab_wire.sym} 630 -160 0 0 {name=p4 sig_type=std_logic lab=VbiasN2}
C {devices/vsource.sym} 710 -100 0 0 {name=V3 value=\{VbiasN1\}}
C {devices/gnd.sym} 710 -60 0 0 {name=l5 lab=GND}
C {devices/lab_wire.sym} 710 -160 0 0 {name=p12 sig_type=std_logic lab=VbiasN1}
C {devices/vsource.sym} 390 -100 0 0 {name=V4 value=\{VDD\}}
C {devices/gnd.sym} 390 -60 0 0 {name=l6 lab=GND}
C {devices/lab_wire.sym} 390 -160 0 0 {name=p13 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 470 -100 0 0 {name=V6 value=\{VSS\}}
C {devices/gnd.sym} 470 -60 0 0 {name=l7 lab=GND}
C {devices/lab_wire.sym} 470 -160 0 0 {name=p14 sig_type=std_logic lab=VSS}
C {devices/vsource.sym} 330 -270 0 0 {name=V7 value=\{Vin_CM\}}
C {devices/gnd.sym} 330 -230 0 0 {name=l8 lab=GND}
C {devices/lab_wire.sym} 330 -330 0 0 {name=p10 sig_type=std_logic lab=Vin}
C {devices/gnd.sym} 1000 -390 0 0 {name=l9 lab=GND}
C {devices/lab_wire.sym} 550 -330 0 0 {name=p1 sig_type=std_logic lab=Vx}
C {devices/lab_wire.sym} 620 -490 0 0 {name=p16 sig_type=std_logic lab=Vcom}
C {devices/lab_wire.sym} 530 -650 0 0 {name=p17 sig_type=std_logic lab=Vn}
C {devices/vsource.sym} 750 -330 1 0 {name=V9 value=\{Vy\}}
C {vcvs.sym} 830 -280 0 1 {name=E1 value=1}
C {devices/gnd.sym} 830 -220 0 0 {name=l11 lab=GND}
C {devices/lab_wire.sym} 690 -330 0 0 {name=p18 sig_type=std_logic lab=Vy}
C {devices/lab_wire.sym} 830 -330 0 0 {name=p19 sig_type=std_logic lab=Vz}
C {devices/code_shown.sym} 1100 -790 0 0 {name=Voltage_sources only_toplevel=true
value="
.param VDD = 1.62
.param VSS = 0
.param VbiasN1 = 0.6
.param VbiasN2 = 1.21
.param VbiasP2 = 0.57
.param Vin_CM = 1.2
.param Vout_CM = 0.9
.param Vy = (Vout_CM - Vin_CM)
.param load_cap = 1*1e-12 
"}
C {gf180/error_amplifier_N_input_core_v4/xschem/error_amplifier_N_input_core_v4.sym} 690 -620 0 0 {name=x1}
