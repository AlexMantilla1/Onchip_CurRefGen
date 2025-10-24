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
N 300 -340 300 -300 {lab=GND}
N 420 -340 420 -300 {lab=GND}
N 420 -440 420 -400 {lab=VSS}
N 300 -440 300 -400 {lab=VDD}
N 520 -440 560 -440 {lab=VSS}
N 600 -440 640 -440 {lab=VDD}
C {/foss/designs/chipathon_2025/designs/current_reference_load_v2/xschem/current_reference_load_v2.sym} 580 -120 0 0 {name=x1}
C {isource.sym} 560 -390 2 0 {name=I4 value=1u}
C {simulator_commands.sym} 80 -410 0 0 {name="COMMANDS"
simulator="ngspice"
only_toplevel="false" 
value="
* .param VDD=1.8
.save

.control
	save all
	op
	* write CR_loads_jangarita.raw
	* print v(Iref10n) v(Iref1n) v(Iref1p) v(Iref10p)

	let VIref10n=v(Iref10n)
	let VIref1n=v(Iref1n)
	let VIref10p=v(Iref10p)	
	let VIref1p=v(Iref1p)

	set wr_singlescale
	echo $&VIref10n $&VIref1n $&VIref10p $&VIref1p > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
	.endc
"}
C {devices/vsource.sym} 420 -370 0 0 {name=VSN value=0 savecurrent=false}
C {devices/gnd.sym} 420 -300 0 0 {name=l5 lab=GND}
C {devices/vsource.sym} 300 -370 0 0 {name=VSP value=CACE\{VDD\} savecurrent=false}
C {devices/gnd.sym} 300 -300 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 300 -440 0 0 {name=p2 sig_type=std_logic lab=VDD}
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
C {devices/code_shown.sym} 20 -690 0 0 {name=SETUP
simulator=ngspice
only_toplevel=false
value="
.lib CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/combined/sky130.lib.spice CACE\{corner\}

.include CACE\{DUT_path\}

.temp CACE\{temperature\}

.option SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]

* Flag unsafe operating conditions (exceeds models' specified limits)
.option warn=1
"}
