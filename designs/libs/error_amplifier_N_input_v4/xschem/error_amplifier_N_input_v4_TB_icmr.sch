v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {The measurerror_amplifier_N_input_v4ent for this test must be checked. 

For this test we define the ICMR as the range
for Vin where the opamps has enough gain to
keep the output at 0.9V (param Vout_CM).

Here we need to measure the point where the
output is not 0.9V (param Vout_CM) anymore.
We can use the 1% or 2% error criteria for this. 
However, measurerror_amplifier_N_input_v4ent is not okay today.

2025-07-14. -Alex.

Fixed.

2025-07-17. -Julian.} 1230 -840 0 0 0.4 0.4 {}
N 140 -130 140 -110 {
lab=GND}
N 140 -230 140 -190 {
lab=VSS}
N 220 -130 220 -110 {
lab=GND}
N 140 -110 140 -90 {
lab=GND}
N 220 -230 220 -190 {
lab=VDD}
N 220 -110 220 -90 {
lab=GND}
N 300 -130 300 -110 {
lab=GND}
N 300 -230 300 -190 {
lab=Vref}
N 300 -110 300 -90 {
lab=GND}
N 960 -290 1020 -290 {lab=Vout}
N 1170 -160 1170 -80 {
lab=VSS}
N 1170 -290 1170 -230 {
lab=Vout}
N 1020 -290 1170 -290 {
lab=Vout}
N 600 -270 780 -270 {
lab=Vin}
N 1170 -230 1170 -220 {
lab=Vout}
N 670 -320 780 -320 {
lab=#net1}
N 670 -400 670 -320 {
lab=#net1}
N 1140 -400 1140 -290 {
lab=Vout}
N 380 -230 380 -190 {
lab=Vin}
N 380 -130 380 -90 {
lab=GND}
N 1050 -610 1090 -610 {lab=Vout}
N 1050 -570 1090 -570 {lab=GND}
N 1090 -570 1090 -510 {lab=GND}
N 1010 -510 1090 -510 {lab=GND}
N 1010 -560 1010 -510 {lab=GND}
N 1010 -510 1010 -490 {lab=GND}
N 1010 -640 1010 -620 {lab=Vo2}
N 970 -640 1010 -640 {lab=Vo2}
N 1140 -610 1140 -400 {lab=Vout}
N 1090 -610 1140 -610 {lab=Vout}
N 670 -640 670 -400 {lab=#net1}
N 810 -640 910 -640 {lab=#net2}
N 670 -640 750 -640 {lab=#net1}
N 760 -740 760 -680 {lab=Vin}
N 800 -740 800 -680 {lab=GND}
C {simulator_commands.sym} 390 -490 0 0 {name="COMMANDS"
simulator="ngspice"
only_toplevel="false" 
value="
.control
save all

** OP simulation
op

** run dc simulation
 dc V1 0 1.8 0.001

** All OP parameters
setplot op1

let #####_M1_nmos_input_##### = 0 
let id_M1 = @m.x1.x1.xm1.m0[id]
let gm_M1 = @m.x1.x1.xm1.m0[gm]
let ro_M1 = 1/@m.x1.x1.xm1.m0[gds]
let Vgs_M1 = @m.x1.x1.xm1.m0[vgs]
let Vds_M1 = @m.x1.x1.xm1.m0[vds]
let Vsb_M1 = -@m.x1.x1.xm1.m0[vbs]
let Vdsat_M1 = @m.x1.x1.xm1.m0[vdsat]
let Vth_M1 = @m.x1.x1.xm1.m0[vth]
let ao_M1 = gm_M1*ro_M1
let gmid_M1 = gm_M1/id_M1
let fT_M1 = gm_M1/(6.283185*@m.x1.x1.xm1.m0[cgg])
print #####_M1_nmos_input_##### id_M1 gm_M1 ro_M1 Vgs_M1 Vds_M1 Vsb_M1 Vdsat_M1 Vth_M1 ao_M1 gmid_M1 fT_M1

let #####_M2_nmos_input_##### = 0 
let id_M2 = @m.x1.x1.xm2.m0[id]
let gm_M2 = @m.x1.x1.xm2.m0[gm]
let ro_M2 = 1/@m.x1.x1.xm2.m0[gds]
let Vgs_M2 = @m.x1.x1.xm2.m0[vgs]
let Vds_M2 = @m.x1.x1.xm2.m0[vds]
let Vsb_M2 = -@m.x1.x1.xm2.m0[vbs]
let Vdsat_M2 = @m.x1.x1.xm2.m0[vdsat]
let Vth_M2 = @m.x1.x1.xm2.m0[vth]
let ao_M2 = gm_M2*ro_M2
let gmid_M2 = gm_M2/id_M2
let fT_M2 = gm_M2/(6.283185*@m.x1.x1.xm2.m0[cgg])
print #####_M2_nmos_input_##### id_M2 gm_M2 ro_M2 Vgs_M2 Vds_M2 Vsb_M2 Vdsat_M2 Vth_M2 ao_M2 gmid_M2 fT_M2

let #####_M3_pmos_top_##### = 0 
let id_M3 = @m.x1.x1.xm3.m0[id]
let gm_M3 = @m.x1.x1.xm3.m0[gm]
let ro_M3 = 1/@m.x1.x1.xm3.m0[gds]
let Vsg_M3 = @m.x1.x1.xm3.m0[vgs]
let Vsd_M3 = @m.x1.x1.xm3.m0[vds]
let Vbs_M3 = -@m.x1.x1.xm3.m0[vbs]
let Vdsat_M3 = @m.x1.x1.xm3.m0[vdsat]
let Vth_M3 = @m.x1.x1.xm3.m0[vth]
let ao_M3 = gm_M3*ro_M3
let gmid_M3 = gm_M3/id_M3
let fT_M3 = gm_M3/(6.283185*@m.x1.x1.xm3.m0[cgg])
print #####_M3_pmos_top_##### id_M3 gm_M3 ro_M3 Vsg_M3 Vsd_M3 Vbs_M3 Vdsat_M3 Vth_M3 ao_M3 gmid_M3 fT_M3

let #####_M4_pmos_top_##### = 0 
let id_M4 = @m.x1.x1.xm4.m0[id]
let gm_M4 = @m.x1.x1.xm4.m0[gm]
let ro_M4 = 1/@m.x1.x1.xm4.m0[gds]
let Vsg_M4 = @m.x1.x1.xm4.m0[vgs]
let Vsd_M4 = @m.x1.x1.xm4.m0[vds]
let Vbs_M4 = -@m.x1.x1.xm4.m0[vbs]
let Vdsat_M4 = @m.x1.x1.xm4.m0[vdsat]
let Vth_M4 = @m.x1.x1.xm4.m0[vth]
let ao_M4 = gm_M4*ro_M4
let gmid_M4 = gm_M4/id_M4
let fT_M4 = gm_M4/(6.283185*@m.x1.x1.xm4.m0[cgg])
print #####_M4_pmos_top_##### id_M4 gm_M4 ro_M4 Vsg_M4 Vsd_M4 Vbs_M4 Vdsat_M4 Vth_M4 ao_M4 gmid_M4 fT_M4

let #####_M5_pmos_out_##### = 0 
let id_M5 = @m.x1.x1.xm5.m0[id]
let gm_M5 = @m.x1.x1.xm5.m0[gm]
let ro_M5 = 1/@m.x1.x1.xm5.m0[gds]
let Vsg_M5 = @m.x1.x1.xm5.m0[vgs]
let Vsd_M5 = @m.x1.x1.xm5.m0[vds]
let Vbs_M5 = -@m.x1.x1.xm5.m0[vbs]
let Vdsat_M5 = @m.x1.x1.xm5.m0[vdsat]
let Vth_M5 = @m.x1.x1.xm5.m0[vth]
let ao_M5 = gm_M5*ro_M5
let gmid_M5 = gm_M5/id_M5
let fT_M5 = gm_M5/(6.283185*@m.x1.x1.xm5.m0[cgg])
print #####_M5_pmos_out_##### id_M5 gm_M5 ro_M5 Vsg_M5 Vsd_M5 Vbs_M5 Vdsat_M5 Vth_M5 ao_M5 gmid_M5 fT_M5

let #####_M6_pmos_out_##### = 0 
let id_M6 = @m.x1.x1.xm6.m0[id]
let gm_M6 = @m.x1.x1.xm6.m0[gm]
let ro_M6 = 1/@m.x1.x1.xm6.m0[gds]
let Vsg_M6 = @m.x1.x1.xm6.m0[vgs]
let Vsd_M6 = @m.x1.x1.xm6.m0[vds]
let Vbs_M6 = -@m.x1.x1.xm6.m0[vbs]
let Vdsat_M6 = @m.x1.x1.xm6.m0[vdsat]
let Vth_M6 = @m.x1.x1.xm6.m0[vth]
let ao_M6 = gm_M6*ro_M6
let gmid_M6 = gm_M6/id_M6
let fT_M6 = gm_M6/(6.283185*@m.x1.x1.xm6.m0[cgg])
print #####_M6_pmos_out_##### id_M6 gm_M6 ro_M6 Vsg_M6 Vsd_M6 Vbs_M6 Vdsat_M6 Vth_M6 ao_M6 gmid_M6 fT_M6

let #####_M7_nmos_out_##### = 0 
let id_M7 = @m.x1.x1.xm7.m0[id]
let gm_M7 = @m.x1.x1.xm7.m0[gm]
let ro_M7 = 1/@m.x1.x1.xm7.m0[gds]
let Vgs_M7 = @m.x1.x1.xm7.m0[vgs]
let Vds_M7 = @m.x1.x1.xm7.m0[vds]
let Vsb_M7 = -@m.x1.x1.xm7.m0[vbs]
let Vdsat_M7 = @m.x1.x1.xm7.m0[vdsat]
let Vth_M7 = @m.x1.x1.xm7.m0[vth]
let ao_M7 = gm_M7*ro_M7
let gmid_M7 = gm_M7/id_M7
let fT_M7 = gm_M7/(6.283185*@m.x1.x1.xm7.m0[cgg])
print #####_M7_nmos_out_##### id_M7 gm_M7 ro_M7 Vgs_M7 Vds_M7 Vsb_M7 Vdsat_M7 Vth_M7 ao_M7 gmid_M7 fT_M7

let #####_M8_nmos_out_##### = 0 
let id_M8 = @m.x1.x1.xm8.m0[id]
let gm_M8 = @m.x1.x1.xm8.m0[gm]
let ro_M8 = 1/@m.x1.x1.xm8.m0[gds]
let Vgs_M8 = @m.x1.x1.xm8.m0[vgs]
let Vds_M8 = @m.x1.x1.xm8.m0[vds]
let Vsb_M8 = -@m.x1.x1.xm8.m0[vbs]
let Vdsat_M8 = @m.x1.x1.xm8.m0[vdsat]
let Vth_M8 = @m.x1.x1.xm8.m0[vth]
let ao_M8 = gm_M8*ro_M8
let gmid_M8 = gm_M8/id_M8
let fT_M8 = gm_M8/(6.283185*@m.x1.x1.xm8.m0[cgg])
print #####_M8_nmos_out_##### id_M8 gm_M8 ro_M8 Vgs_M8 Vds_M8 Vsb_M8 Vdsat_M8 Vth_M8 ao_M8 gmid_M8 fT_M8

let #####_M9_nmos_bottom_##### = 0 
let id_M9 = @m.x1.x1.xm9.m0[id]
let gm_M9 = @m.x1.x1.xm9.m0[gm]
let ro_M9 = 1/@m.x1.x1.xm9.m0[gds]
let Vgs_M9 = @m.x1.x1.xm9.m0[vgs]
let Vds_M9 = @m.x1.x1.xm9.m0[vds]
let Vsb_M9 = -@m.x1.x1.xm9.m0[vbs]
let Vdsat_M9 = @m.x1.x1.xm9.m0[vdsat]
let Vth_M9 = @m.x1.x1.xm9.m0[vth]
let ao_M9 = gm_M9*ro_M9
let gmid_M9 = gm_M9/id_M9
let fT_M9 = gm_M9/(6.283185*@m.x1.x1.xm9.m0[cgg])
print #####_M9_nmos_bottom_##### id_M9 gm_M9 ro_M9 Vgs_M9 Vds_M9 Vsb_M9 Vdsat_M9 Vth_M9 ao_M9 gmid_M9 fT_M9

let #####_M10_nmos_bottom_##### = 0 
let id_M10 = @m.x1.x1.xm10.m0[id]
let gm_M10 = @m.x1.x1.xm10.m0[gm]
let ro_M10 = 1/@m.x1.x1.xm10.m0[gds]
let Vgs_M10 = @m.x1.x1.xm10.m0[vgs]
let Vds_M10 = @m.x1.x1.xm10.m0[vds]
let Vsb_M10 = @m.x1.x1.xm10.m0[vbs]
let Vdsat_M10 = @m.x1.x1.xm10.m0[vdsat]
let Vth_M10 = @m.x1.x1.xm10.m0[vth]
let ao_M10 = gm_M10*ro_M10
let gmid_M10 = gm_M10/id_M10
let fT_M10 = gm_M10/(6.283185*@m.x1.x1.xm10.m0[cgg])
print #####_M10_nmos_bottom_##### id_M10 gm_M10 ro_M10 Vgs_M10 Vds_M10 Vsb_M10 Vdsat_M10 Vth_M10 ao_M10 gmid_M10 fT_M10

let #####_M11_nmos_mirror_##### = 0 
let id_M11 = @m.x1.x1.xm11.m0[id]
let gm_M11 = @m.x1.x1.xm11.m0[gm]
let ro_M11 = 1/@m.x1.x1.xm11.m0[gds]
let Vgs_M11 = @m.x1.x1.xm11.m0[vgs]
let Vds_M11 = @m.x1.x1.xm11.m0[vds]
let Vsb_M11 = -@m.x1.x1.xm11.m0[vbs]
let Vdsat_M11 = @m.x1.x1.xm11.m0[vdsat]
let Vth_M11 = @m.x1.x1.xm11.m0[vth]
let ao_M11 = gm_M11*ro_M11
let gmid_M11 = gm_M11/id_M11
let fT_M11 = gm_M11/(6.283185*@m.x1.x1.xm11.m0[cgg])
print #####_M11_nmos_mirror_##### id_M11 gm_M11 ro_M11 Vgs_M11 Vds_M11 Vsb_M11 Vdsat_M11 Vth_M11 ao_M11 gmid_M11 fT_M11

** Custom output
let #####_Custom_output_##### = 0

* Power
let power = abs(i(V2))*VDD

* DC_gain
let r1 = ao_M6*ro_M4
let r2 = ao_M8*((ro_M1*ro_M10)/(ro_M1+ro_M10))
let Rout = (r1*r2)/(r1+r2)
let Av = db(gm_M1*Rout)
* Bandwidth 
let BW = 1/(Rout*1e-12*6.283185)

print #####_Custom_output_##### Av BW Rout power gm_M1 ro_M1 gm_M6 ro_M6 ro_M4 gm_M8 ro_M8 ro_M10

write error_amplifier_N_input_v4_TB_icmr.raw

setplot dc1

* measure parameters
let dVout = deriv(v(Vout))    
    
meas dc ICMmin when dVout=-0.05 cross=1
meas dc ICMmax when dVout=0 cross=last
let ICMR = ICMmax - ICMmin
print ICMR
plot Vout dVout

.endc
"}
C {devices/vsource.sym} 140 -160 0 0 {name=V0 value=\{VSS\} savecurrent=false}
C {devices/gnd.sym} 140 -90 0 0 {name=l5 lab=GND}
C {devices/vsource.sym} 220 -160 0 0 {name=V2 value=\{VDD\} savecurrent=false}
C {devices/lab_wire.sym} 140 -230 0 0 {name=p25 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 220 -230 0 0 {name=p26 sig_type=std_logic lab=VDD}
C {devices/gnd.sym} 220 -90 0 0 {name=l6 lab=GND}
C {devices/vsource.sym} 300 -160 0 0 {name=V4 value=\{Vref\} savecurrent=false}
C {devices/lab_wire.sym} 300 -230 0 0 {name=p27 sig_type=std_logic lab=Vref}
C {devices/gnd.sym} 300 -90 0 0 {name=l7 lab=GND}
C {lab_pin.sym} 850 -210 2 1 {name=p7 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 850 -190 2 1 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 850 -170 2 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 600 -270 2 1 {name=p10 sig_type=std_logic lab=Vin}
C {capa.sym} 1170 -190 0 0 {name=C1
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1170 -80 2 1 {name=p1 sig_type=std_logic lab=VSS}
C {noconn.sym} 890 -230 2 0 {name=l1}
C {lab_pin.sym} 1170 -290 0 1 {name=p2 sig_type=std_logic lab=Vout}
C {devices/lab_wire.sym} 380 -230 0 0 {name=p3 sig_type=std_logic lab=Vin}
C {devices/gnd.sym} 380 -90 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} 380 -160 0 0 {name=V1 value=\{Vin\} savecurrent=false}
C {devices/code_shown.sym} 80 -890 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {vcvs.sym} 1010 -590 0 1 {name=E1 value=1}
C {devices/gnd.sym} 1010 -490 0 0 {name=l4 lab=GND}
C {devices/lab_wire.sym} 1010 -640 0 0 {name=p4 sig_type=std_logic lab=Vo2}
C {devices/vsource.sym} 940 -640 1 0 {name=V10 value=\{Vout_CM\}}
C {vcvs.sym} 780 -640 3 1 {name=E2 value=1}
C {devices/gnd.sym} 800 -740 3 0 {name=l3 lab=GND}
C {devices/lab_wire.sym} 760 -740 0 0 {name=p5 sig_type=std_logic lab=Vin}
C {devices/code_shown.sym} 100 -730 0 0 {name=Voltage_sources only_toplevel=true
value="
.param VDD = 3.3
.param VSS = 0
.param Vref = 1.2
.param Vin = 1.2
.param Vout_CM = 1.65
"}
C {gf180/error_amplifier_N_input_v4/xschem/error_amplifier_N_input_v4.sym} 870 -290 0 0 {name=x1}
C {devices/launcher.sym} 180 -430 0 0 {name=h3
descr="Save & Netlist & sim" 
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 180 -370 0 0 {name=h2
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
