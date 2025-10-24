v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
P 4 1 1090 -390 {}
N 280 -90 280 -80 {lab=GND}
N 280 -180 280 -150 {lab=Vin}
N 130 -90 130 -80 {lab=GND}
N 130 -180 130 -150 {lab=VDD}
N 210 -90 210 -80 {lab=GND}
N 210 -180 210 -150 {lab=VSS}
N 350 -90 350 -80 {lab=GND}
N 350 -180 350 -150 {lab=Vref}
N 1370 -220 1410 -220 {lab=VDD}
N 1370 -180 1410 -180 {lab=VSS}
N 940 -390 1000 -390 {lab=#net1}
N 940 -390 940 -360 {lab=#net1}
N 870 -360 940 -360 {lab=#net1}
N 980 -420 1000 -420 {lab=Vrefp}
N 980 -490 980 -420 {lab=Vrefp}
N 1060 -510 1060 -470 {lab=VDD}
N 720 -400 760 -400 {
lab=Vout}
N 720 -400 720 -320 {
lab=Vout}
N 580 -450 760 -450 {
lab=Vin}
N 940 -420 980 -420 {lab=Vrefp}
N 1060 -230 1060 -210 {lab=Vout}
N 1060 -210 1060 -190 {lab=Vout}
N 1060 -130 1060 -90 {lab=VSS}
N 1090 -230 1090 -190 {lab=VSS}
N 1260 -280 1300 -280 {lab=#net2}
N 1260 -300 1450 -300 {lab=#net3}
N 1450 -300 1450 -250 {lab=#net3}
N 1260 -320 1490 -320 {lab=#net4}
N 1490 -320 1490 -250 {lab=#net4}
N 1260 -340 1530 -340 {lab=#net5}
N 1530 -340 1530 -250 {lab=#net5}
N 1260 -360 1570 -360 {lab=#net6}
N 1570 -360 1570 -250 {lab=#net6}
N 1260 -380 1610 -380 {lab=#net7}
N 1610 -380 1610 -250 {lab=#net7}
N 1260 -400 1650 -400 {lab=#net8}
N 1650 -400 1650 -250 {lab=#net8}
N 720 -320 720 -210 {lab=Vout}
N 720 -210 1060 -210 {lab=Vout}
C {devices/code_shown.sym} 100 -810 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice statistical
"}
C {devices/vsource.sym} 280 -120 0 0 {name=V6 value="DC = \{Vin\}, AC = 1"}
C {devices/gnd.sym} 280 -80 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 280 -180 0 0 {name=p14 sig_type=std_logic lab=Vin}
C {devices/vsource.sym} 130 -120 0 0 {name=V8 value=\{VDD\}}
C {devices/gnd.sym} 130 -80 0 0 {name=l12 lab=GND}
C {devices/lab_wire.sym} 130 -180 0 0 {name=p19 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 210 -120 0 0 {name=V9 value=\{VSS\}}
C {devices/gnd.sym} 210 -80 0 0 {name=l13 lab=GND}
C {devices/lab_wire.sym} 210 -180 0 0 {name=p20 sig_type=std_logic lab=VSS}
C {devices/launcher.sym} 160 -420 0 0 {name=h1
descr="Save & Netlist & sim" 
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 160 -340 0 0 {name=h2
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {devices/vsource.sym} 350 -120 0 0 {name=V1 value=\{Vref\}}
C {devices/gnd.sym} 350 -80 0 0 {name=l2 lab=GND}
C {devices/lab_wire.sym} 350 -180 0 0 {name=p2 sig_type=std_logic lab=Vref}
C {devices/code_shown.sym} 110 -620 0 0 {name=Voltage_sources only_toplevel=true
value="
.param VDD = 3.3
.param VSS = 0
.param Vref = 1.2
.param Vin = 1.2
"}
C {simulator_commands.sym} 410 -640 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="

*.param TEMPGAUSS = agauss(40, 30, 1)
*.option temp = 'TEMPGAUSS'

.save @m.x3.xm1.m0[id]
.save @m.x3.xm2.m0[id]
.save @m.x3.xm3.m0[id]
.save @m.x3.xm4.m0[id]
.save @m.x3.xm5.m0[id]
.save @m.x3.xm6.m0[id]
.param sw_stat_global = 1
.param sw_stat_mismatch = 1
.option filetype=ascii
*.save all
.control
  let mc_runs = 1000
  let run = 0
  set curplot=new          $ create a new plot
  set scratch=$curplot     $ store its name to 'scratch'
  setplot $scratch         $ make 'scratch' the active plot
  let current_n2=unitvec(mc_runs) $ create a vector in plot 'scratch' to store current_n2 data
  let current_n20=unitvec(mc_runs) $ create a vector in plot 'scratch' to store current_n20 data
  let current_n50=unitvec(mc_runs) $ create a vector in plot 'scratch' to store current_n50 data
  let current_p2=unitvec(mc_runs) $ create a vector in plot 'scratch' to store current_p2 data
  let current_p20=unitvec(mc_runs) $ create a vector in plot 'scratch' to store current_p20 data
  let current_p50=unitvec(mc_runs) $ create a vector in plot 'scratch' to store current_p50 data

  dowhile run < mc_runs

    *MC statistical

    op

    let id_n2 = @m.x3.xm1.m0[id]
    let id_n20 = @m.x3.xm2.m0[id]
    let id_n50 = @m.x3.xm3.m0[id]
    let id_p2 = @m.x3.xm4.m0[id]
    let id_p20 = @m.x3.xm5.m0[id]
    let id_p50 = @m.x3.xm6.m0[id]

    print id_n2 id_n20 id_n50 id_p2 id_p20 id_p50

    set run = $&run             $ create a variable from the vector
    set dt = $curplot           $ store the current plot to dt
    setplot $scratch            $ make 'scratch' the active plot

    let current_n2[run]=\{$dt\}.id_n2       $ store In to vector Current in plot 'scratch'
    let current_n20[run]=\{$dt\}.id_n20       $ store In to vector Current in plot 'scratch'
    let current_n50[run]=\{$dt\}.id_n50       $ store In to vector Current in plot 'scratch'
    let current_p2[run]=\{$dt\}.id_p2       $ store In to vector Current in plot 'scratch'
    let current_p20[run]=\{$dt\}.id_p20       $ store In to vector Current in plot 'scratch'
    let current_p50[run]=\{$dt\}.id_p50       $ store In to vector Current in plot 'scratch'

    setplot $dt                 $ go back to the previous plot

    let run = run + 1
    reset
  end    $ loop ends here

  echo
  *print \{$scratch\}.current_n2 
  *print \{$scratch\}.current_n20 
  *print \{$scratch\}.current_n50 
  *print \{$scratch\}.current_p2 
  *print \{$scratch\}.current_p20 
  *print \{$scratch\}.current_p50

* Compute statistics

let mean_val_n2 = avg(\{$scratch\}.current_n2)          ; Store mean in scalar variable
let mean_n2 = mean_val_n2[mc_runs-1]
let diff_n2 = \{$scratch\}.current_n2 - mean_val_n2
let diff_sq_n2 = diff_n2 * diff_n2
let variance_n2 = avg(diff_sq_n2)
let stddev_val_n2 = sqrt(variance_n2)  ; Store stddev in scalar variable
let stddev_n2 = stddev_val_n2[mc_runs-1]

let mean_val_n20 = avg(\{$scratch\}.current_n20)          ; Store mean in scalar variable
let mean_n20 = mean_val_n20[mc_runs-1]
let diff_n20 = \{$scratch\}.current_n20 - mean_val_n20
let diff_sq_n20 = diff_n20 * diff_n20
let variance_n20 = avg(diff_sq_n20)
let stddev_val_n20 = sqrt(variance_n20)  ; Store stddev in scalar variable
let stddev_n20 = stddev_val_n20[mc_runs-1]

let mean_val_n50 = avg(\{$scratch\}.current_n50)          ; Store mean in scalar variable
let mean_n50 = mean_val_n50[mc_runs-1]
let diff_n50 = \{$scratch\}.current_n50 - mean_val_n50
let diff_sq_n50 = diff_n50 * diff_n50
let variance_n50 = avg(diff_sq_n50)
let stddev_val_n50 = sqrt(variance_n50)  ; Store stddev in scalar variable
let stddev_n50 = stddev_val_n50[mc_runs-1]

let mean_val_p2 = avg(\{$scratch\}.current_p2)          ; Store mean in scalar variable
let mean_p2 = mean_val_p2[mc_runs-1]
let diff_p2 = \{$scratch\}.current_p2 - mean_val_p2
let diff_sq_p2 = diff_p2 * diff_p2
let variance_p2 = avg(diff_sq_p2)
let stddev_val_p2 = sqrt(variance_p2)  ; Store stddev in scalar variable
let stddev_p2 = stddev_val_p2[mc_runs-1]

let mean_val_p20 = avg(\{$scratch\}.current_p20)          ; Store mean in scalar variable
let mean_p20 = mean_val_p20[mc_runs-1]
let diff_p20 = \{$scratch\}.current_p20 - mean_val_p20
let diff_sq_p20 = diff_p20 * diff_p20
let variance_p20 = avg(diff_sq_p20)
let stddev_val_p20 = sqrt(variance_p20)  ; Store stddev in scalar variable
let stddev_p20 = stddev_val_p20[mc_runs-1]

let mean_val_p50 = avg(\{$scratch\}.current_p50)          ; Store mean in scalar variable
let mean_p50 = mean_val_p50[mc_runs-1]
let diff_p50 = \{$scratch\}.current_p50 - mean_val_p50
let diff_sq_p50 = diff_p50 * diff_p50
let variance_p50 = avg(diff_sq_p50)
let stddev_val_p50 = sqrt(variance_p50)  ; Store stddev in scalar variable
let stddev_p50 = stddev_val_p50[mc_runs-1]

write mc_data.raw \{$scratch\}.current_n2 \{$scratch\}.current_n20 \{$scratch\}.current_n50 \{$scratch\}.current_p2 \{$scratch\}.current_p20 \{$scratch\}.current_p50

* Print statistics
echo
echo '----------------------------------------'
echo 'Monte Carlo Results (n = $&mc_runs)'
echo '----------------------------------------'
echo 'Mean Id_n2: $&mean_n2 A'
echo 'Std Dev Id_n2: $&stddev_n2 A'
echo '----------------------------------------'
echo 'Mean Id_n20: $&mean_n20 A'
echo 'Std Dev Id_n20: $&stddev_n20 A'
echo '----------------------------------------'
echo 'Mean Id_n50: $&mean_n50 A'
echo 'Std Dev Id_n50: $&stddev_n50 A'
echo '----------------------------------------'
echo 'Mean Id_p2: $&mean_p2 A'
echo 'Std Dev Id_p2: $&stddev_p2 A'
echo '----------------------------------------'
echo 'Mean Id_p20: $&mean_p20 A'
echo 'Std Dev Id_p20: $&stddev_p20 A'
echo '----------------------------------------'
echo 'Mean Id_p50: $&mean_p50 A'
echo 'Std Dev Id_p50: $&stddev_p50 A'
echo '----------------------------------------'


.endc
"}
C {res.sym} 1060 -160 0 0 {name=R2
value=600k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1060 -90 2 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 1370 -220 2 1 {name=p12 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1370 -180 2 1 {name=p13 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 830 -340 2 1 {name=p15 sig_type=std_logic lab=Vref}
C {lab_pin.sym} 830 -320 2 1 {name=p16 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 830 -300 2 1 {name=p21 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 580 -450 2 1 {name=p22 sig_type=std_logic lab=Vin}
C {lab_pin.sym} 1090 -190 0 1 {name=p23 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 980 -490 0 1 {name=p24 sig_type=std_logic lab=Vrefp}
C {lab_pin.sym} 1060 -510 0 1 {name=p25 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1060 -220 2 1 {name=p26 sig_type=std_logic lab=Vout}
C {noconn.sym} 1300 -280 2 0 {name=l3}
C {gf180/current_reference_load/xschem/current_reference_load.sym} 1550 -200 0 0 {name=x3}
C {gf180/error_amplifier_N_input_v3/xschem/error_amplifier_N_input_v3.sym} 850 -420 0 0 {name=x1}
C {gf180/current_reference_second_stage_v2/xschem/current_reference_second_stage_v2.sym} 1120 -350 0 0 {name=x2}
