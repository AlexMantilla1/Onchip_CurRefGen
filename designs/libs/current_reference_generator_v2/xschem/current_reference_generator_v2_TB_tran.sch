v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 560 -360 600 -360 {lab=Vin}
N 140 -140 140 -130 {lab=GND}
N 140 -230 140 -200 {lab=VDD}
N 220 -140 220 -130 {lab=GND}
N 220 -230 220 -200 {lab=VSS}
N 300 -140 300 -130 {lab=GND}
N 300 -230 300 -200 {lab=Vref}
N 420 -280 420 -240 {lab=Vref}
N 420 -360 420 -340 {lab=Vin}
N 420 -360 560 -360 {lab=Vin}
N 720 -440 720 -400 {lab=VDD}
N 1010 -120 1050 -120 {lab=VDD}
N 1010 -80 1050 -80 {lab=VSS}
N 720 -60 720 -20 {lab=VSS}
N 720 -160 720 -120 {lab=Vout}
N 750 -160 750 -120 {lab=VSS}
N 920 -210 960 -210 {lab=#net1}
N 920 -350 960 -350 {lab=#net2}
N 920 -230 1090 -230 {lab=#net3}
N 1090 -230 1090 -150 {lab=#net3}
N 920 -250 1130 -250 {lab=#net4}
N 1130 -250 1130 -150 {lab=#net4}
N 920 -270 1170 -270 {lab=#net5}
N 1170 -270 1170 -150 {lab=#net5}
N 920 -290 1210 -290 {lab=#net6}
N 1210 -290 1210 -150 {lab=#net6}
N 920 -310 1250 -310 {lab=#net7}
N 1250 -310 1250 -150 {lab=#net7}
N 920 -330 1290 -330 {lab=#net8}
N 1290 -330 1290 -150 {lab=#net8}
C {simulator_commands.sym} 970 -560 0 0 {name=COMMANDS3
simulator="ngspice"
only_toplevel="false" 
value="
.param VDD=1.8
.param Vref=1.2
.save


.control

    op

    * run tran simulation
    tran 1n 1.5u

    *let current_refp1 = v(Iref1p)/450e3
    
    plot v(Vout) v(Vin) 

    write current_reference_generator_v2_TB_tran.raw
.endc
"}
C {devices/vsource.sym} 420 -310 0 0 {name=V1 value="pwl 0 0 10u 0 0.501u 0.01"}
C {lab_pin.sym} 420 -240 2 1 {name=p7 sig_type=std_logic lab=Vref}
C {devices/code_shown.sym} 50 -590 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/vsource.sym} 140 -170 0 0 {name=V8 value=\{VDD\}}
C {devices/gnd.sym} 140 -130 0 0 {name=l12 lab=GND}
C {devices/lab_wire.sym} 140 -230 0 0 {name=p19 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 220 -170 0 0 {name=V9 value=\{VSS\}}
C {devices/gnd.sym} 220 -130 0 0 {name=l13 lab=GND}
C {devices/lab_wire.sym} 220 -230 0 0 {name=p20 sig_type=std_logic lab=VSS}
C {devices/launcher.sym} 150 -440 0 0 {name=h1
descr="Save & Netlist & sim" 
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 150 -370 0 0 {name=h2
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {devices/vsource.sym} 300 -170 0 0 {name=V3 value=\{Vref\}}
C {devices/gnd.sym} 300 -130 0 0 {name=l3 lab=GND}
C {devices/lab_wire.sym} 300 -230 0 0 {name=p11 sig_type=std_logic lab=Vref}
C {devices/code_shown.sym} 660 -590 0 0 {name=Voltage_sources only_toplevel=true
value="
.param VDD = 3.3
.param VSS = 0
.param Vref = 1.2
"}
C {lab_pin.sym} 420 -360 2 1 {name=p1 sig_type=std_logic lab=Vin}
C {res.sym} 720 -90 0 0 {name=R3
value="600k tc1=200e-6"
footprint=1206
device=resistor
m=1}
C {devices/lab_wire.sym} 750 -120 2 0 {name=p8 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 720 -20 2 1 {name=p9 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 720 -440 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1010 -120 2 1 {name=p12 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1010 -80 2 1 {name=p13 sig_type=std_logic lab=VSS}
C {noconn.sym} 960 -210 2 0 {name=l1}
C {noconn.sym} 960 -350 2 0 {name=l2}
C {gf180/current_reference_load/xschem/current_reference_load.sym} 1190 -100 0 0 {name=x2}
C {gf180/current_reference_generator_v2/xschem/current_reference_generator_v2.sym} 750 -280 0 0 {name=x1}
C {lab_pin.sym} 720 -140 2 1 {name=p3 sig_type=std_logic lab=Vout}
