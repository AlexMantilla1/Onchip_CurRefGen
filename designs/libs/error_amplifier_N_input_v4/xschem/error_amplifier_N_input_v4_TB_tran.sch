v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 1220 -240 1220 -180 {
lab=GND}
N 1130 -350 1220 -350 {
lab=Vout}
N 1220 -350 1220 -300 {
lab=Vout}
N 850 -380 950 -380 {
lab=Vout}
N 290 -100 290 -90 {lab=GND}
N 290 -190 290 -160 {lab=Vin}
N 850 -330 950 -330 {
lab=Vin}
N 140 -100 140 -90 {lab=GND}
N 140 -190 140 -160 {lab=VDD}
N 220 -100 220 -90 {lab=GND}
N 220 -190 220 -160 {lab=VSS}
N 1170 -350 1170 -100 {lab=Vout}
N 360 -100 360 -90 {lab=GND}
N 360 -190 360 -160 {lab=Vref}
N 770 -380 850 -380 {lab=Vout}
N 770 -380 770 -100 {lab=Vout}
N 770 -100 1170 -100 {lab=Vout}
C {devices/code_shown.sym} 80 -590 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/noconn.sym} 1060 -290 2 0 {name=l3}
C {devices/lab_wire.sym} 1020 -230 0 0 {name=p12 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 1020 -250 0 0 {name=p13 sig_type=std_logic lab=VDD}
C {devices/capa.sym} 1220 -270 0 0 {name=C4
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 290 -90 0 0 {name=l5 lab=GND}
C {devices/lab_wire.sym} 290 -190 0 0 {name=p14 sig_type=std_logic lab=Vin}
C {devices/lab_wire.sym} 1220 -350 0 0 {name=p15 sig_type=std_logic lab=Vout}
C {devices/gnd.sym} 1220 -180 0 0 {name=l8 lab=GND}
C {devices/code_shown.sym} 690 -550 0 0 {name=Voltage_sources only_toplevel=true
value="
.param VDD = 3.3
.param VSS = 0
.param Vref = 1.2
.param Vin = 1.2
"}
C {devices/vsource.sym} 140 -130 0 0 {name=V8 value=\{VDD\}}
C {devices/gnd.sym} 140 -90 0 0 {name=l12 lab=GND}
C {devices/lab_wire.sym} 140 -190 0 0 {name=p19 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 220 -130 0 0 {name=V9 value=\{VSS\}}
C {devices/gnd.sym} 220 -90 0 0 {name=l13 lab=GND}
C {devices/lab_wire.sym} 220 -190 0 0 {name=p20 sig_type=std_logic lab=VSS}
C {launcher.sym} 170 -350 0 0 {name=h2
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xscherror_amplifier_N_input_v4 annotate_op"}
C {devices/lab_wire.sym} 850 -330 0 0 {name=p23 sig_type=std_logic lab=Vin}
C {devices/lab_wire.sym} 1020 -270 0 0 {name=p5 sig_type=std_logic lab=Vref}
C {simulator_commands.sym} 1000 -580 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.control
save all

** tran simulation

    op

    * run tran simulation
    tran 1n 10u
    
    plot v(Vout) v(Vin) 

write error_amplifier_N_input_v4_TB_tran.raw

.endc
"}
C {devices/vsource.sym} 360 -130 0 0 {name=V2 value=\{Vref\}}
C {devices/gnd.sym} 360 -90 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 360 -190 0 0 {name=p1 sig_type=std_logic lab=Vref}
C {devices/vsource.sym} 290 -130 0 0 {name=V1 value="pwl 0 0 10u 0 0.501u 1.8"}
C {gf180/error_amplifier_N_input_v4/xschem/error_amplifier_N_input_v4.sym} 1040 -350 0 0 {name=x1}
C {devices/launcher.sym} 170 -400 0 0 {name=h3
descr="Save & Netlist & sim" 
tclcommand="xschem save; xschem netlist; xschem simulate"}
