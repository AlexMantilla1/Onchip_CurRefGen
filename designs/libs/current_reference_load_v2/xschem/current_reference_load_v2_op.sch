v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 420 -140 480 -140 {lab=VDD}
N 420 -100 480 -100 {lab=VSS}
N 520 -440 520 -340 {lab=VSS}
N 520 -280 520 -170 {lab=Iref10n}
N 600 -280 600 -170 {lab=Iref1p}
N 560 -360 560 -170 {lab=Iref1n}
N 640 -360 640 -170 {lab=Iref10p}
N 640 -440 640 -420 {lab=VDD}
N 600 -440 600 -340 {lab=VDD}
N 560 -440 560 -420 {lab=VSS}
N 340 -340 340 -300 {lab=GND}
N 420 -340 420 -300 {lab=GND}
N 420 -440 420 -400 {lab=VSS}
N 340 -440 340 -400 {lab=VDD}
N 520 -440 560 -440 {lab=VSS}
N 600 -440 640 -440 {lab=VDD}
C {isource.sym} 560 -390 2 0 {name=I4 value=1u}
C {sky130_fd_pr/corner.sym} 50 -200 0 0 {name=CORNER only_toplevel=true corner=tt}
C {simulator_commands.sym} 190 -200 0 0 {name="COMMANDS"
simulator="ngspice"
only_toplevel="false" 
value="
.param VDD=1.8
.save

* Operation point of the loads given ideal current outputs from the CR

*nfet

+ v(@m.x1.xm3.msky130_fd_pr__nfet_01v8[vds])
+ v(@m.x1.xm3.msky130_fd_pr__nfet_01v8[vth])
+ @m.x1.xm3.msky130_fd_pr__nfet_01v8[id]

+ v(@m.x1.xm4.msky130_fd_pr__nfet_01v8[vds])
+ v(@m.x1.xm4.msky130_fd_pr__nfet_01v8[vth])
+ @m.x1.xm4.msky130_fd_pr__nfet_01v8[gds]

*pfet

+ v(@m.x1.xm1.msky130_fd_pr__pfet_01v8_lvt[vds])
+ v(@m.x1.xm1.msky130_fd_pr__pfet_01v8_lvt[vth])
+ @m.x1.xm1.msky130_fd_pr__pfet_01v8_lvt[id]

+ v(@m.x1.xm2.msky130_fd_pr__pfet_01v8_lvt[vds])
+ v(@m.x1.xm2.msky130_fd_pr__pfet_01v8_lvt[vth])
+ @m.x1.xm2.msky130_fd_pr__pfet_01v8_lvt[gds]

+ abstol=1e-14 savecurrents
.control
    save all
    op
    write CR_loads_jangarita.raw

    print v(Iref10n) v(Iref1n) v(Iref1p) v(Iref10p)
.endc
"}
C {devices/launcher.sym} 120 -380 0 0 {name=h15
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/launcher.sym} 120 -450 0 0 {name=h3
descr="Netlist & sim" 
tclcommand="xschem netlist; xschem simulate"}
C {devices/vsource.sym} 420 -370 0 0 {name=VSN value=0 savecurrent=false}
C {devices/gnd.sym} 420 -300 0 0 {name=l5 lab=GND}
C {devices/vsource.sym} 340 -370 0 0 {name=VSP value=\{VDD\} savecurrent=false}
C {devices/gnd.sym} 340 -300 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 340 -440 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {isource.sym} 600 -310 0 0 {name=I1 value=1u}
C {isource.sym} 640 -390 0 0 {name=I2 value=10u}
C {isource.sym} 520 -310 2 0 {name=I3 value=10u}
C {devices/lab_wire.sym} 640 -440 0 1 {name=p3 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 420 -140 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 420 -100 0 0 {name=p5 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 520 -200 1 0 {name=p8 sig_type=std_logic lab=Iref10n}
C {devices/lab_wire.sym} 560 -200 1 0 {name=p9 sig_type=std_logic lab=Iref1n}
C {devices/lab_wire.sym} 640 -200 1 0 {name=p10 sig_type=std_logic lab=Iref10p}
C {devices/lab_wire.sym} 600 -200 1 0 {name=p11 sig_type=std_logic lab=Iref1p}
C {devices/lab_wire.sym} 520 -440 0 0 {name=p6 sig_type=std_logic lab=VSS
}
C {devices/lab_wire.sym} 420 -440 0 0 {name=p7 sig_type=std_logic lab=VSS}
C {/foss/designs/chipathon_2025/designs/sky130/current_reference_load_v2/xschem/current_reference_load_v2.sym} 580 -120 0 0 {name=x1}
