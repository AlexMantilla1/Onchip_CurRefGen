# error_amplifier_N_input_v4

- Description: Folded cascode full
- PDK: gf180mcuD

## Authorship

- Designer: Ramon Sarmiento
- Company: OnChip UIS
- Created: July 11th, 2025
- License: Apache 2.0
- Last modified: None

## Pins

- VDD
  + Description: Positive analog power supply
  + Type: power
  + Direction: inout
  + Vmin: 1.7
  + Vmax: 1.9
- VSS
  + Description: Analog ground
  + Type: ground
  + Direction: inout
- Vout
  + Description: Output voltage
  + Type: signal
  + Direction: inout
- Vcomn
  + Description: Compensation pin
  + Type: signal
  + Direction: inout
- V+
  + Description: Non inverting input
  + Type: signal
  + Direction: input
- V-
  + Description: Inverting input
  + Type: signal
  + Direction: input

## Default Conditions

- vdd
  + Description: Analog power supply voltage
  + Display: Vdd
  + Unit: V
  + Typical: 1.8
- vref
  + Description: Voltage reference from BandGAP
  + Display: VrefBG
  + Unit: V
  + Typical: 1.2
- Vy
  + Description: Fix voltage Mode Voltage
  + Display: Vy
  + Unit: V
  + Typical: -0.3
- Vsweep
  + Description: Voltage to run the dc for Output swing
  + Display: Vsweep
  + Unit: V
  + Typical: 0
- corner
  + Description: Process corner
  + Display: Corner
  + Typical: typical
- temperature
  + Description: Ambient temperature
  + Display: Temp
  + Unit: °C
  + Typical: 27

## Symbol

![Symbol of error_amplifier_N_input_v4](error_amplifier_N_input_v4_symbol.svg)

## Schematic

![Schematic of error_amplifier_N_input_v4](error_amplifier_N_input_v4_schematic.svg)

## Layout

![Layout of error_amplifier_N_input_v4 with white background](error_amplifier_N_input_v4_w.png)
![Layout of error_amplifier_N_input_v4 with black background](error_amplifier_N_input_v4_b.png)
