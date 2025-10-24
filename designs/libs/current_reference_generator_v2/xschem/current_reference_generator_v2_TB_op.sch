v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 590 -360 630 -360 {lab=Vref}
N 750 -440 750 -400 {lab=VDD}
N 1040 -120 1080 -120 {lab=VDD}
N 1040 -80 1080 -80 {lab=VSS}
N 750 -60 750 -20 {lab=VSS}
N 750 -160 750 -120 {lab=Vout}
N 780 -160 780 -120 {lab=VSS}
N 950 -210 990 -210 {lab=#net1}
N 950 -350 990 -350 {lab=#net2}
N 170 -140 170 -130 {lab=GND}
N 170 -230 170 -200 {lab=VDD}
N 250 -140 250 -130 {lab=GND}
N 250 -230 250 -200 {lab=VSS}
N 330 -140 330 -130 {lab=GND}
N 330 -230 330 -200 {lab=Vref}
N 950 -230 1120 -230 {lab=#net3}
N 1120 -230 1120 -150 {lab=#net3}
N 950 -250 1160 -250 {lab=#net4}
N 1160 -250 1160 -150 {lab=#net4}
N 950 -270 1200 -270 {lab=#net5}
N 1200 -270 1200 -150 {lab=#net5}
N 950 -290 1240 -290 {lab=#net6}
N 1240 -290 1240 -150 {lab=#net6}
N 950 -310 1280 -310 {lab=#net7}
N 1280 -310 1280 -150 {lab=#net7}
N 950 -330 1320 -330 {lab=#net8}
N 1320 -330 1320 -150 {lab=#net8}
C {devices/lab_wire.sym} 780 -120 2 0 {name=p1 sig_type=std_logic lab=VSS}
C {res.sym} 750 -90 0 0 {name=R1
value=600k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 750 -20 2 1 {name=p5 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 590 -360 2 1 {name=p4 sig_type=std_logic lab=Vref}
C {devices/lab_wire.sym} 750 -440 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1040 -120 2 1 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1040 -80 2 1 {name=p6 sig_type=std_logic lab=VSS}
C {noconn.sym} 990 -210 2 0 {name=l8}
C {noconn.sym} 990 -350 2 0 {name=l9}
C {gf180/current_reference_load/xschem/current_reference_load.sym} 1220 -100 0 0 {name=x3}
C {devices/code_shown.sym} 80 -590 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/vsource.sym} 170 -170 0 0 {name=V8 value=\{VDD\}}
C {devices/gnd.sym} 170 -130 0 0 {name=l12 lab=GND}
C {devices/lab_wire.sym} 170 -230 0 0 {name=p19 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 250 -170 0 0 {name=V9 value=\{VSS\}}
C {devices/gnd.sym} 250 -130 0 0 {name=l13 lab=GND}
C {devices/lab_wire.sym} 250 -230 0 0 {name=p20 sig_type=std_logic lab=VSS}
C {devices/launcher.sym} 180 -440 0 0 {name=h1
descr="Save & Netlist & sim" 
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 180 -370 0 0 {name=h2
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {devices/vsource.sym} 330 -170 0 0 {name=V1 value=\{Vref\}}
C {devices/gnd.sym} 330 -130 0 0 {name=l2 lab=GND}
C {devices/lab_wire.sym} 330 -230 0 0 {name=p7 sig_type=std_logic lab=Vref}
C {devices/code_shown.sym} 690 -590 0 0 {name=Voltage_sources only_toplevel=true
value="
.param VDD = 3.3
.param VSS = 0
.param Vref = 1.2
"}
C {simulator_commands.sym} 940 -600 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.control
save all

** OP simulation
op

** All OP parameters

** Error amplifier core
let ##########_Error_amplifier_op_########## = 1
print ##########_Error_amplifier_op_##########

let #####_M1_nmos_input_##### = 0 
let id_M1 = @m.x1.x1.x1.xm1.m0[id]
let gm_M1 = @m.x1.x1.x1.xm1.m0[gm]
let ro_M1 = 1/@m.x1.x1.x1.xm1.m0[gds]
let Vgs_M1 = @m.x1.x1.x1.xm1.m0[vgs]
let Vds_M1 = @m.x1.x1.x1.xm1.m0[vds]
let Vsb_M1 = -@m.x1.x1.x1.xm1.m0[vbs]
let Vdsat_M1 = @m.x1.x1.x1.xm1.m0[vdsat]
let Vth_M1 = @m.x1.x1.x1.xm1.m0[vth]
let ao_M1 = gm_M1*ro_M1
let gmid_M1 = gm_M1/id_M1
let fT_M1 = gm_M1/(6.283185*@m.x1.x1.x1.xm1.m0[cgg])
print #####_M1_nmos_input_##### id_M1 gm_M1 ro_M1 Vgs_M1 Vds_M1 Vsb_M1 Vdsat_M1 Vth_M1 ao_M1 gmid_M1 fT_M1

let #####_M2_nmos_input_##### = 0 
let id_M2 = @m.x1.x1.x1.xm2.m0[id]
let gm_M2 = @m.x1.x1.x1.xm2.m0[gm]
let ro_M2 = 1/@m.x1.x1.x1.xm2.m0[gds]
let Vgs_M2 = @m.x1.x1.x1.xm2.m0[vgs]
let Vds_M2 = @m.x1.x1.x1.xm2.m0[vds]
let Vsb_M2 = -@m.x1.x1.x1.xm2.m0[vbs]
let Vdsat_M2 = @m.x1.x1.x1.xm2.m0[vdsat]
let Vth_M2 = @m.x1.x1.x1.xm2.m0[vth]
let ao_M2 = gm_M2*ro_M2
let gmid_M2 = gm_M2/id_M2
let fT_M2 = gm_M2/(6.283185*@m.x1.x1.x1.xm2.m0[cgg])
print #####_M2_nmos_input_##### id_M2 gm_M2 ro_M2 Vgs_M2 Vds_M2 Vsb_M2 Vdsat_M2 Vth_M2 ao_M2 gmid_M2 fT_M2

let #####_M3_pmos_top_##### = 0 
let id_M3 = @m.x1.x1.x1.xm3.m0[id]
let gm_M3 = @m.x1.x1.x1.xm3.m0[gm]
let ro_M3 = 1/@m.x1.x1.x1.xm3.m0[gds]
let Vsg_M3 = @m.x1.x1.x1.xm3.m0[vgs]
let Vsd_M3 = @m.x1.x1.x1.xm3.m0[vds]
let Vbs_M3 = -@m.x1.x1.x1.xm3.m0[vbs]
let Vdsat_M3 = @m.x1.x1.x1.xm3.m0[vdsat]
let Vth_M3 = @m.x1.x1.x1.xm3.m0[vth]
let ao_M3 = gm_M3*ro_M3
let gmid_M3 = gm_M3/id_M3
let fT_M3 = gm_M3/(6.283185*@m.x1.x1.x1.xm3.m0[cgg])
print #####_M3_pmos_top_##### id_M3 gm_M3 ro_M3 Vsg_M3 Vsd_M3 Vbs_M3 Vdsat_M3 Vth_M3 ao_M3 gmid_M3 fT_M3

let #####_M4_pmos_top_##### = 0 
let id_M4 = @m.x1.x1.x1.xm4.m0[id]
let gm_M4 = @m.x1.x1.x1.xm4.m0[gm]
let ro_M4 = 1/@m.x1.x1.x1.xm4.m0[gds]
let Vsg_M4 = @m.x1.x1.x1.xm4.m0[vgs]
let Vsd_M4 = @m.x1.x1.x1.xm4.m0[vds]
let Vbs_M4 = -@m.x1.x1.x1.xm4.m0[vbs]
let Vdsat_M4 = @m.x1.x1.x1.xm4.m0[vdsat]
let Vth_M4 = @m.x1.x1.x1.xm4.m0[vth]
let ao_M4 = gm_M4*ro_M4
let gmid_M4 = gm_M4/id_M4
let fT_M4 = gm_M4/(6.283185*@m.x1.x1.x1.xm4.m0[cgg])
print #####_M4_pmos_top_##### id_M4 gm_M4 ro_M4 Vsg_M4 Vsd_M4 Vbs_M4 Vdsat_M4 Vth_M4 ao_M4 gmid_M4 fT_M4

let #####_M5_pmos_out_##### = 0 
let id_M5 = @m.x1.x1.x1.xm5.m0[id]
let gm_M5 = @m.x1.x1.x1.xm5.m0[gm]
let ro_M5 = 1/@m.x1.x1.x1.xm5.m0[gds]
let Vsg_M5 = @m.x1.x1.x1.xm5.m0[vgs]
let Vsd_M5 = @m.x1.x1.x1.xm5.m0[vds]
let Vbs_M5 = -@m.x1.x1.x1.xm5.m0[vbs]
let Vdsat_M5 = @m.x1.x1.x1.xm5.m0[vdsat]
let Vth_M5 = @m.x1.x1.x1.xm5.m0[vth]
let ao_M5 = gm_M5*ro_M5
let gmid_M5 = gm_M5/id_M5
let fT_M5 = gm_M5/(6.283185*@m.x1.x1.x1.xm5.m0[cgg])
print #####_M5_pmos_out_##### id_M5 gm_M5 ro_M5 Vsg_M5 Vsd_M5 Vbs_M5 Vdsat_M5 Vth_M5 ao_M5 gmid_M5 fT_M5

let #####_M6_pmos_out_##### = 0 
let id_M6 = @m.x1.x1.x1.xm6.m0[id]
let gm_M6 = @m.x1.x1.x1.xm6.m0[gm]
let ro_M6 = 1/@m.x1.x1.x1.xm6.m0[gds]
let Vsg_M6 = @m.x1.x1.x1.xm6.m0[vgs]
let Vsd_M6 = @m.x1.x1.x1.xm6.m0[vds]
let Vbs_M6 = -@m.x1.x1.x1.xm6.m0[vbs]
let Vdsat_M6 = @m.x1.x1.x1.xm6.m0[vdsat]
let Vth_M6 = @m.x1.x1.x1.xm6.m0[vth]
let ao_M6 = gm_M6*ro_M6
let gmid_M6 = gm_M6/id_M6
let fT_M6 = gm_M6/(6.283185*@m.x1.x1.x1.xm6.m0[cgg])
print #####_M6_pmos_out_##### id_M6 gm_M6 ro_M6 Vsg_M6 Vsd_M6 Vbs_M6 Vdsat_M6 Vth_M6 ao_M6 gmid_M6 fT_M6

let #####_M7_nmos_out_##### = 0 
let id_M7 = @m.x1.x1.x1.xm7.m0[id]
let gm_M7 = @m.x1.x1.x1.xm7.m0[gm]
let ro_M7 = 1/@m.x1.x1.x1.xm7.m0[gds]
let Vgs_M7 = @m.x1.x1.x1.xm7.m0[vgs]
let Vds_M7 = @m.x1.x1.x1.xm7.m0[vds]
let Vsb_M7 = -@m.x1.x1.x1.xm7.m0[vbs]
let Vdsat_M7 = @m.x1.x1.x1.xm7.m0[vdsat]
let Vth_M7 = @m.x1.x1.x1.xm7.m0[vth]
let ao_M7 = gm_M7*ro_M7
let gmid_M7 = gm_M7/id_M7
let fT_M7 = gm_M7/(6.283185*@m.x1.x1.x1.xm7.m0[cgg])
print #####_M7_nmos_out_##### id_M7 gm_M7 ro_M7 Vgs_M7 Vds_M7 Vsb_M7 Vdsat_M7 Vth_M7 ao_M7 gmid_M7 fT_M7

let #####_M8_nmos_out_##### = 0 
let id_M8 = @m.x1.x1.x1.xm8.m0[id]
let gm_M8 = @m.x1.x1.x1.xm8.m0[gm]
let ro_M8 = 1/@m.x1.x1.x1.xm8.m0[gds]
let Vgs_M8 = @m.x1.x1.x1.xm8.m0[vgs]
let Vds_M8 = @m.x1.x1.x1.xm8.m0[vds]
let Vsb_M8 = -@m.x1.x1.x1.xm8.m0[vbs]
let Vdsat_M8 = @m.x1.x1.x1.xm8.m0[vdsat]
let Vth_M8 = @m.x1.x1.x1.xm8.m0[vth]
let ao_M8 = gm_M8*ro_M8
let gmid_M8 = gm_M8/id_M8
let fT_M8 = gm_M8/(6.283185*@m.x1.x1.x1.xm8.m0[cgg])
print #####_M8_nmos_out_##### id_M8 gm_M8 ro_M8 Vgs_M8 Vds_M8 Vsb_M8 Vdsat_M8 Vth_M8 ao_M8 gmid_M8 fT_M8

let #####_M9_nmos_bottom_##### = 0 
let id_M9 = @m.x1.x1.x1.xm9.m0[id]
let gm_M9 = @m.x1.x1.x1.xm9.m0[gm]
let ro_M9 = 1/@m.x1.x1.x1.xm9.m0[gds]
let Vgs_M9 = @m.x1.x1.x1.xm9.m0[vgs]
let Vds_M9 = @m.x1.x1.x1.xm9.m0[vds]
let Vsb_M9 = -@m.x1.x1.x1.xm9.m0[vbs]
let Vdsat_M9 = @m.x1.x1.x1.xm9.m0[vdsat]
let Vth_M9 = @m.x1.x1.x1.xm9.m0[vth]
let ao_M9 = gm_M9*ro_M9
let gmid_M9 = gm_M9/id_M9
let fT_M9 = gm_M9/(6.283185*@m.x1.x1.x1.xm9.m0[cgg])
print #####_M9_nmos_bottom_##### id_M9 gm_M9 ro_M9 Vgs_M9 Vds_M9 Vsb_M9 Vdsat_M9 Vth_M9 ao_M9 gmid_M9 fT_M9

let #####_M10_nmos_bottom_##### = 0 
let id_M10 = @m.x1.x1.x1.xm10.m0[id]
let gm_M10 = @m.x1.x1.x1.xm10.m0[gm]
let ro_M10 = 1/@m.x1.x1.x1.xm10.m0[gds]
let Vgs_M10 = @m.x1.x1.x1.xm10.m0[vgs]
let Vds_M10 = @m.x1.x1.x1.xm10.m0[vds]
let Vsb_M10 = @m.x1.x1.x1.xm10.m0[vbs]
let Vdsat_M10 = @m.x1.x1.x1.xm10.m0[vdsat]
let Vth_M10 = @m.x1.x1.x1.xm10.m0[vth]
let ao_M10 = gm_M10*ro_M10
let gmid_M10 = gm_M10/id_M10
let fT_M10 = gm_M10/(6.283185*@m.x1.x1.x1.xm10.m0[cgg])
print #####_M10_nmos_bottom_##### id_M10 gm_M10 ro_M10 Vgs_M10 Vds_M10 Vsb_M10 Vdsat_M10 Vth_M10 ao_M10 gmid_M10 fT_M10

let #####_M11_nmos_mirror_##### = 0 
let id_M11 = @m.x1.x1.x1.xm11.m0[id]
let gm_M11 = @m.x1.x1.x1.xm11.m0[gm]
let ro_M11 = 1/@m.x1.x1.x1.xm11.m0[gds]
let Vgs_M11 = @m.x1.x1.x1.xm11.m0[vgs]
let Vds_M11 = @m.x1.x1.x1.xm11.m0[vds]
let Vsb_M11 = -@m.x1.x1.x1.xm11.m0[vbs]
let Vdsat_M11 = @m.x1.x1.x1.xm11.m0[vdsat]
let Vth_M11 = @m.x1.x1.x1.xm11.m0[vth]
let ao_M11 = gm_M11*ro_M11
let gmid_M11 = gm_M11/id_M11
let fT_M11 = gm_M11/(6.283185*@m.x1.x1.x1.xm11.m0[cgg])
print #####_M11_nmos_mirror_##### id_M11 gm_M11 ro_M11 Vgs_M11 Vds_M11 Vsb_M11 Vdsat_M11 Vth_M11 ao_M11 gmid_M11 fT_M11

** Second stage
let ##########_Second_stage_op_########## = 1
print ##########_Second_stage_op_##########

let #####_M1_pmos_##### = 0 
let id_M1 = @m.x1.x2.xm1.m0[id]
let gm_M1 = @m.x1.x2.xm1.m0[gm]
let ro_M1 = 1/@m.x1.x2.xm1.m0[gds]
let Vsg_M1 = @m.x1.x2.xm1.m0[vgs]
let Vsd_M1 = @m.x1.x2.xm1.m0[vds]
let Vbs_M1 = -@m.x1.x2.xm1.m0[vbs]
let Vdsat_M1 = @m.x1.x2.xm1.m0[vdsat]
let Vth_M1 = @m.x1.x2.xm1.m0[vth]
let ao_M1 = gm_M1*ro_M1
let gmid_M1 = gm_M1/id_M1
let fT_M1 = gm_M1/(6.283185*@m.x1.x2.xm1.m0[cgg])
print #####_M1_pmos_##### id_M1 gm_M1 ro_M1 Vsg_M1 Vsd_M1 Vbs_M1 Vdsat_M1 Vth_M1 ao_M1 gmid_M1 fT_M1

let #####_M2_pmos_##### = 0 
let id_M2 = @m.x1.x2.xm2.m0[id]
let gm_M2 = @m.x1.x2.xm2.m0[gm]
let ro_M2 = 1/@m.x1.x2.xm2.m0[gds]
let Vsg_M2 = @m.x1.x2.xm2.m0[vgs]
let Vsd_M2 = @m.x1.x2.xm2.m0[vds]
let Vbs_M2 = -@m.x1.x2.xm2.m0[vbs]
let Vdsat_M2 = @m.x1.x2.xm2.m0[vdsat]
let Vth_M2 = @m.x1.x2.xm2.m0[vth]
let ao_M2 = gm_M2*ro_M2
let gmid_M2 = gm_M2/id_M2
let fT_M2 = gm_M2/(6.283185*@m.x1.x2.xm2.m0[cgg])
print #####_M2_pmos_##### id_M2 gm_M2 ro_M2 Vsg_M2 Vsd_M2 Vbs_M2 Vdsat_M2 Vth_M2 ao_M2 gmid_M2 fT_M2

let #####_M3_pmos_##### = 0 
let id_M3 = @m.x1.x2.xm3.m0[id]
let gm_M3 = @m.x1.x2.xm3.m0[gm]
let ro_M3 = 1/@m.x1.x2.xm3.m0[gds]
let Vsg_M3 = @m.x1.x2.xm3.m0[vgs]
let Vsd_M3 = @m.x1.x2.xm3.m0[vds]
let Vbs_M3 = -@m.x1.x2.xm3.m0[vbs]
let Vdsat_M3 = @m.x1.x2.xm3.m0[vdsat]
let Vth_M3 = @m.x1.x2.xm3.m0[vth]
let ao_M3 = gm_M3*ro_M3
let gmid_M3 = gm_M3/id_M3
let fT_M3 = gm_M3/(6.283185*@m.x1.x2.xm3.m0[cgg])
print #####_M3_pmos_##### id_M3 gm_M3 ro_M3 Vsg_M3 Vsd_M3 Vbs_M3 Vdsat_M3 Vth_M3 ao_M3 gmid_M3 fT_M3

let #####_M4_pmos_##### = 0 
let id_M4 = @m.x1.x2.xm4.m0[id]
let gm_M4 = @m.x1.x2.xm4.m0[gm]
let ro_M4 = 1/@m.x1.x2.xm4.m0[gds]
let Vsg_M4 = @m.x1.x2.xm4.m0[vgs]
let Vsd_M4 = @m.x1.x2.xm4.m0[vds]
let Vbs_M4 = -@m.x1.x2.xm4.m0[vbs]
let Vdsat_M4 = @m.x1.x2.xm4.m0[vdsat]
let Vth_M4 = @m.x1.x2.xm4.m0[vth]
let ao_M4 = gm_M4*ro_M4
let gmid_M4 = gm_M4/id_M4
let fT_M4 = gm_M4/(6.283185*@m.x1.x2.xm4.m0[cgg])
print #####_M4_pmos_##### id_M4 gm_M4 ro_M4 Vsg_M4 Vsd_M4 Vbs_M4 Vdsat_M4 Vth_M4 ao_M4 gmid_M4 fT_M4

let #####_M5_pmos_##### = 0 
let id_M5 = @m.x1.x2.xm5.m0[id]
let gm_M5 = @m.x1.x2.xm5.m0[gm]
let ro_M5 = 1/@m.x1.x2.xm5.m0[gds]
let Vsg_M5 = @m.x1.x2.xm5.m0[vgs]
let Vsd_M5 = @m.x1.x2.xm5.m0[vds]
let Vbs_M5 = -@m.x1.x2.xm5.m0[vbs]
let Vdsat_M5 = @m.x1.x2.xm5.m0[vdsat]
let Vth_M5 = @m.x1.x2.xm5.m0[vth]
let ao_M5 = gm_M5*ro_M5
print #####_M5_pmos_##### id_M5 gm_M5 ro_M5 Vsg_M5 Vsd_M5 Vbs_M5 Vdsat_M5 Vth_M5 ao_M5 gmid_M5

let #####_M6_nmos_##### = 0 
let id_M6 = @m.x1.x2.xm6.m0[id]
let gm_M6 = @m.x1.x2.xm6.m0[gm]
let ro_M6 = 1/@m.x1.x2.xm6.m0[gds]
let Vgs_M6 = @m.x1.x2.xm6.m0[vgs]
let Vds_M6 = @m.x1.x2.xm6.m0[vds]
let Vsb_M6 = -@m.x1.x2.xm6.m0[vbs]
let Vdsat_M6 = @m.x1.x2.xm6.m0[vdsat]
let Vth_M6 = @m.x1.x2.xm6.m0[vth]
let ao_M6 = gm_M6*ro_M6
let gmid_M6 = gm_M6/id_M6
let fT_M6 = gm_M6/(6.283185*@m.x1.x2.xm6.m0[cgg])
print #####_M6_nmos_##### id_M6 gm_M6 ro_M6 Vgs_M6 Vds_M6 Vsb_M6 Vdsat_M6 Vth_M6 ao_M6 gmid_M6 fT_M6

let #####_M7_nmos_##### = 0 
let id_M7 = @m.x1.x2.xm7.m0[id]
let gm_M7 = @m.x1.x2.xm7.m0[gm]
let ro_M7 = 1/@m.x1.x2.xm7.m0[gds]
let Vgs_M7 = @m.x1.x2.xm7.m0[vgs]
let Vds_M7 = @m.x1.x2.xm7.m0[vds]
let Vsb_M7 = -@m.x1.x2.xm7.m0[vbs]
let Vdsat_M7 = @m.x1.x2.xm7.m0[vdsat]
let Vth_M7 = @m.x1.x2.xm7.m0[vth]
let ao_M7 = gm_M7*ro_M7
let gmid_M7 = gm_M7/id_M7
let fT_M7 = gm_M7/(6.283185*@m.x1.x2.xm7.m0[cgg])
print #####_M7_nmos_##### id_M7 gm_M7 ro_M7 Vgs_M7 Vds_M7 Vsb_M7 Vdsat_M7 Vth_M7 ao_M7 gmid_M7 fT_M7

let #####_M8_nmos_##### = 0 
let id_M8 = @m.x1.x2.xm8.m0[id]
let gm_M8 = @m.x1.x2.xm8.m0[gm]
let ro_M8 = 1/@m.x1.x2.xm8.m0[gds]
let Vgs_M8 = @m.x1.x2.xm8.m0[vgs]
let Vds_M8 = @m.x1.x2.xm8.m0[vds]
let Vsb_M8 = -@m.x1.x2.xm8.m0[vbs]
let Vdsat_M8 = @m.x1.x2.xm8.m0[vdsat]
let Vth_M8 = @m.x1.x2.xm8.m0[vth]
let ao_M8 = gm_M8*ro_M8
let gmid_M8 = gm_M8/id_M8
let fT_M8 = gm_M8/(6.283185*@m.x1.x2.xm8.m0[cgg])
print #####_M8_nmos_##### id_M8 gm_M8 ro_M8 Vgs_M8 Vds_M8 Vsb_M8 Vdsat_M8 Vth_M8 ao_M8 gmid_M8 fT_M8

** Load
let ##########_Load_op_########## = 1
print ##########_Load_op_##########

let #####_M1_pmos_##### = 0 
let id_M1 = @m.x3.xm1.m0[id]
let gm_M1 = @m.x3.xm1.m0[gm]
let ro_M1 = 1/@m.x3.xm1.m0[gds]
let Vsg_M1 = @m.x3.xm1.m0[vgs]
let Vsd_M1 = @m.x3.xm1.m0[vds]
let Vbs_M1 = -@m.x3.xm1.m0[vbs]
let Vdsat_M1 = @m.x3.xm1.m0[vdsat]
let Vth_M1 = @m.x3.xm1.m0[vth]
let ao_M1 = gm_M1*ro_M1
let gmid_M1 = gm_M1/id_M1
let fT_M1 = gm_M1/(6.283185*@m.x3.xm1.m0[cgg])
print #####_M1_pmos_##### id_M1 gm_M1 ro_M1 Vsg_M1 Vsd_M1 Vbs_M1 Vdsat_M1 Vth_M1 ao_M1 gmid_M1 fT_M1

let #####_M2_pmos_##### = 0 
let id_M2 = @m.x3.xm2.m0[id]
let gm_M2 = @m.x3.xm2.m0[gm]
let ro_M2 = 1/@m.x3.xm2.m0[gds]
let Vsg_M2 = @m.x3.xm2.m0[vgs]
let Vsd_M2 = @m.x3.xm2.m0[vds]
let Vbs_M2 = -@m.x3.xm2.m0[vbs]
let Vdsat_M2 = @m.x3.xm2.m0[vdsat]
let Vth_M2 = @m.x3.xm2.m0[vth]
let ao_M2 = gm_M2*ro_M2
let gmid_M2 = gm_M2/id_M2
let fT_M2 = gm_M2/(6.283185*@m.x3.xm2.m0[cgg])
print #####_M2_pmos_##### id_M2 gm_M2 ro_M2 Vsg_M2 Vsd_M2 Vbs_M2 Vdsat_M2 Vth_M2 ao_M2 gmid_M2 fT_M2

let #####_M3_nmos_##### = 0 
let id_M3 = @m.x3.xm3.m0[id]
let gm_M3 = @m.x3.xm3.m0[gm]
let ro_M3 = 1/@m.x3.xm3.m0[gds]
let Vgs_M3 = @m.x3.xm3.m0[vgs]
let Vds_M3 = @m.x3.xm3.m0[vds]
let Vsb_M3 = -@m.x3.xm3.m0[vbs]
let Vdsat_M3 = @m.x3.xm3.m0[vdsat]
let Vth_M3 = @m.x3.xm3.m0[vth]
let ao_M3 = gm_M3*ro_M3
let gmid_M3 = gm_M3/id_M3
let fT_M3 = gm_M3/(6.283185*@m.x3.xm3.m0[cgg])
print #####_M3_nmos_##### id_M3 gm_M3 ro_M3 Vgs_M3 Vds_M3 Vsb_M3 Vdsat_M3 Vth_M3 ao_M3 gmid_M3 fT_M3

let #####_M4_nmos_##### = 0 
let id_M4 = @m.x3.xm4.m0[id]
let gm_M4 = @m.x3.xm4.m0[gm]
let ro_M4 = 1/@m.x3.xm4.m0[gds]
let Vgs_M4 = @m.x3.xm4.m0[vgs]
let Vds_M4 = @m.x3.xm4.m0[vds]
let Vsb_M4 = -@m.x3.xm4.m0[vbs]
let Vdsat_M4 = @m.x3.xm4.m0[vdsat]
let Vth_M4 = @m.x3.xm4.m0[vth]
let ao_M4 = gm_M4*ro_M4
let gmid_M4 = gm_M4/id_M4
let fT_M4 = gm_M4/(6.283185*@m.x3.xm4.m0[cgg])
print #####_M4_nmos_##### id_M4 gm_M4 ro_M4 Vgs_M4 Vds_M4 Vsb_M4 Vdsat_M4 Vth_M4 ao_M4 gmid_M4 fT_M4

** Custom output
let #####_Custom_output_##### = 0

* Power
let power = abs(i(V8))*VDD

* DC_gain
let r1 = ao_M6*ro_M4
let r2 = ao_M8*((ro_M1*ro_M10)/(ro_M1+ro_M10))
let Rout = (r1*r2)/(r1+r2)
let Av = db(gm_M1*Rout)
* Bandwidth 
let BW = 1/(Rout*1e-12*6.283185)

print #####_Custom_output_##### Av BW Rout power gm_M1 ro_M1 gm_M6 ro_M6 ro_M4 gm_M8 ro_M8 ro_M10

write current_reference_generator_v2_TB_op.raw

.endc
"}
C {gf180/current_reference_generator_v2/xschem/current_reference_generator_v2.sym} 780 -280 0 0 {name=x1}
C {devices/lab_wire.sym} 750 -130 0 0 {name=p8 sig_type=std_logic lab=Vout}
