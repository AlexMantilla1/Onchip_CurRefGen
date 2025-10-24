# Primitives
from gdsfactory import Component
# Standard
from glayout.flow.pdk.mappedpdk import MappedPDK
from glayout.flow.pdk.sky130_mapped import sky130_mapped_pdk as sky130
# Utility
from glayout.flow.pdk.util.comp_utils import evaluate_bbox, prec_center
from glayout.flow.primitives.fet import pmos
from glayout.flow.primitives.guardring import tapring
from glayout.flow.routing.c_route import c_route
# Routing
from glayout.flow.routing.straight_route import straight_route


def currentMirror(pdk: MappedPDK) -> Component:
    # Create a top level Component
    curr_mirror_TOP = Component()
    # Let's define the pfet that takes the reference current and append it to the top circuit.
    M1_pmos = pmos(pdk, width=0.5, length=6, with_tie=False, with_substrate_tap=False, with_dummy=(True, False))
    # Insert M1 to the top view
    M1_pmos_ref = curr_mirror_TOP << M1_pmos 
    print(type(M1_pmos_ref))
    # Now define the pfet that mirrors the reference current and append it to the top circuit.
    M2_pmos = pmos(pdk, width=0.5, length=6, with_tie=False, with_substrate_tap=False, with_dummy=(False, True))
    # Insert M2 to the top view
    M2_pmos_ref = curr_mirror_TOP << M2_pmos 

    # Evaluate width and height of the M1_pmos transistor
    ref_dimentions = evaluate_bbox(M1_pmos)
    # Move the mirror transistor to avoid overlap with ref transistor
    M2_pmos_ref.movex( ref_dimentions[0] + pdk.util_max_metal_seperation() ) 

    # Calculate x coordinate of the center of top cell at the moment
    shift_amount = -prec_center(curr_mirror_TOP.flatten())[0]
    #print(shift_amount)
    
    # Place Tap ring and center
    tap_ring = tapring(pdk, enclosed_rectangle=evaluate_bbox(curr_mirror_TOP.flatten(), padding=pdk.util_max_metal_seperation()))
    # Insert Tap ring to the top view
    tr_ref = curr_mirror_TOP << tap_ring
    # Move the Tap ring in the x axis by shift_amount 
    tr_ref.movex(shift_amount)
 
    # ###########################################   Routing   ###########################################
    # Route M1 and M2 Sources
    curr_mirror_TOP << straight_route(pdk, M1_pmos_ref.ports["multiplier_0_source_E"], M2_pmos_ref.ports["multiplier_0_source_W"])
    # Route M1 and M2 Gates
    curr_mirror_TOP << straight_route(pdk, M1_pmos_ref.ports["multiplier_0_gate_E"], M2_pmos_ref.ports["multiplier_0_gate_W"])
    # Route M1 Drain ang Gate for Diode connection.
    curr_mirror_TOP << c_route(pdk, M1_pmos_ref.ports["multiplier_0_drain_W"], M1_pmos_ref.ports["multiplier_0_gate_W"])
    # Route M1 dummy to body ring
    curr_mirror_TOP << straight_route(pdk, M1_pmos_ref.ports["multiplier_0_dummy_L_gsdcon_top_met_W"], tr_ref.ports["bl_bottom_met_S"])  
    # Route M2 dummy to body ring
    curr_mirror_TOP << straight_route(pdk, M2_pmos_ref.ports["multiplier_0_dummy_R_gsdcon_top_met_E"], tr_ref.ports["br_bottom_met_S"])  

    with open("tmp.txt","w") as file:
        for elem in tr_ref.ports.keys():
            if "_" in elem:
                file.write(elem)
                file.write("\n")

    # Return the top level compenent
    return curr_mirror_TOP


def main():
    # Define the current mirror:
    my_current_mirror = currentMirror(sky130)
    # Display the current mirror layout at Klayout:
    my_current_mirror.show()

if __name__ == "__main__":
    # If called directly call main function
    main()