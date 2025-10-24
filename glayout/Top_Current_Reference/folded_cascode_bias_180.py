from glayout import MappedPDK, sky130, gf180
from glayout import nmos, pmos, multiplier, tapring, via_stack, via_array

from glayout.spice.netlist import Netlist
from glayout.routing import c_route, L_route, straight_route

from gdsfactory.cell import cell
from gdsfactory.component import Component, copy
from gdsfactory.components.rectangle import rectangle
from gdsfactory.routing.route_quad import route_quad
from gdsfactory.routing.route_sharp import route_sharp

from glayout.util.comp_utils import (
    align_comp_to_port,
    evaluate_bbox,
    movex,
    movey,
    prec_ref_center,
    prec_array,
)
from glayout.util.port_utils import (
    add_ports_perimeter,
    get_orientation,
    print_ports,
    rename_ports_by_list,
    rename_ports_by_orientation,
    set_port_orientation,
)
from glayout.util.snap_to_grid import component_snap_to_grid
from glayout.placement.common_centroid_ab_ba import common_centroid_ab_ba

from gdsfactory.functions import transformed
from gdsfactory.components import text_freetype
from gdsfactory.components.rectangular_ring import rectangular_ring
from typing import Optional, Union, Literal
import time
import copy

# Import custom functions
from custom_utils import (
    pin_label_creation,
    center_component_with_ports,
    filtrar_puertos,
    interdigitado_placement_Onchip,
    interdigitado_cascode_placement_Onchip,
    layer_pin_and_label,
    Boundary_layer,
    power_rails_placement
)

import gdsfactory as gf

def Component_Biasing(pdk: MappedPDK,
                        devices_info, 
                        arrays_info,
                        width_route: float = None,
                        offset_drc: float = 0) -> Component:
    
    # Width configuration
    if width_route == None or width_route == 0:
        separation_interdigitado = 0
        width_horizontal = evaluate_bbox(via_stack(pdk,'met2','met3'))[1]
    else:
        separation_interdigitado = width_route
        width_horizontal = width_route
    # min separations
    min_separation_met4 = pdk.get_grule('met4')['min_separation']
    min_separation_met3 = pdk.get_grule('met3')['min_separation']
    min_separation_met2 = pdk.get_grule('met2')['min_separation']
    min_separation_nwell = pdk.get_grule('nwell')['min_separation']
    # diff size offset
    offsetM1M2 = round((abs((devices_info[0]['width'] - devices_info[1]['width']))* 3/2 )/2, 2)
    offsetM1 = offsetM1M2 if devices_info[1]['width'] - 0.02 > devices_info[0]['width'] else 0

    offsetM2M3 = round((abs((devices_info[2]['width'] - devices_info[1]['width']))* 3/2 + 0.12)/2, 2)
    offsetM2 = offsetM2M3 if devices_info[2]['width'] - 0.02 > devices_info[1]['width'] else 0
    offsetM3 = offsetM2M3 if devices_info[1]['width'] - 0.02 > devices_info[2]['width'] else 0

    offsetM4M6 = round((abs((devices_info[3]['width'] - devices_info[5]['width']))* 3/2 + 0.12)/2, 2)
    offsetM4 = offsetM4M6 if devices_info[5]['width'] - 0.02 > devices_info[3]['width'] else 0
    offsetM6 = offsetM4M6 if devices_info[3]['width'] - 0.02 > devices_info[5]['width'] else 0
    # Create the component
    biasing = Component()

    M1_ref = interdigitado_placement_Onchip(pdk, output='via', common_route=(False, False), deviceA_and_B=devices_info[0]['type'],
                                             width=devices_info[0]['width'], length=devices_info[0]['length'], fingers=devices_info[0]['fingers'], 
                                             with_dummy=True, array=arrays_info[0], with_tie=True, with_lvt_layer=devices_info[0]['lvt'], 
                                             output_separation=(separation_interdigitado + offsetM1, separation_interdigitado), routed = True)
    
    M2_ref = interdigitado_placement_Onchip(pdk, output='via', common_route=(False, False), deviceA_and_B=devices_info[1]['type'],
                                             width=devices_info[1]['width'], length=devices_info[1]['length'], fingers=devices_info[1]['fingers'], 
                                             with_dummy=True, array=arrays_info[1], with_tie=True, with_lvt_layer=devices_info[1]['lvt'], 
                                             output_separation=(separation_interdigitado + offsetM2, separation_interdigitado), routed = True)

    M3_ref = interdigitado_placement_Onchip(pdk, output='via', common_route=(False, True), deviceA_and_B=devices_info[2]['type'],
                                             width=devices_info[2]['width'], length=devices_info[2]['length'], fingers=devices_info[2]['fingers'], 
                                             with_dummy=True, array=arrays_info[2], with_tie=True, with_lvt_layer=devices_info[2]['lvt'], 
                                             output_separation=(separation_interdigitado + offsetM3, separation_interdigitado), routed = True)
    M4_ref = interdigitado_placement_Onchip(pdk, output='via', common_route=(False, False), deviceA_and_B=devices_info[3]['type'],
                                             width=devices_info[3]['width'], length=devices_info[3]['length'], fingers=devices_info[3]['fingers'], 
                                             with_dummy=True, array=arrays_info[3], with_tie=True, with_lvt_layer=devices_info[3]['lvt'], 
                                             output_separation=(separation_interdigitado + offsetM4, separation_interdigitado), routed = True)

    M5_ref = interdigitado_placement_Onchip(pdk, output='via', common_route=(False, False), deviceA_and_B=devices_info[4]['type'],
                                             width=devices_info[4]['width'], length=devices_info[4]['length'], fingers=devices_info[4]['fingers'], 
                                             with_dummy=True, array=arrays_info[4], with_tie=True, with_lvt_layer=devices_info[4]['lvt'], 
                                             output_separation=(separation_interdigitado, separation_interdigitado), gate_common=False, routed = False)
    
    M6_ref = interdigitado_placement_Onchip(pdk, output='via', common_route=(False, False), deviceA_and_B=devices_info[5]['type'],
                                             width=devices_info[5]['width'], length=devices_info[5]['length'], fingers=devices_info[5]['fingers'], 
                                             with_dummy=True, array=arrays_info[5], with_tie=True, with_lvt_layer=devices_info[5]['lvt'], 
                                             output_separation=(separation_interdigitado + offsetM6, separation_interdigitado), routed = True)
    
    # Sizes referencias
    size_M1 = evaluate_bbox(M1_ref)
    size_M2 = evaluate_bbox(M2_ref)
    size_M3 = evaluate_bbox(M3_ref)
    size_M4 = evaluate_bbox(M4_ref)
    size_M5 = evaluate_bbox(M5_ref)
    size_M6 = evaluate_bbox(M6_ref)

    # Movement
    # M1 -> M2 -> M3 -> M6 -> M4 -> M5 
    direccion = 0   #0 x, 1 y
    M2_x = pdk.snap_to_2xgrid((size_M1[direccion]+size_M2[direccion])/2 + min_separation_nwell + 0.1)    
    M3_x = pdk.snap_to_2xgrid(M2_x + (size_M2[direccion]+size_M3[direccion])/2 + min_separation_nwell + 0.1)
    M6_x = pdk.snap_to_2xgrid(M3_x + (size_M3[direccion]+size_M6[direccion])/2 + min_separation_nwell + 0.1)
    M4_x = pdk.snap_to_2xgrid(M6_x + (size_M6[direccion]+size_M4[direccion])/2 + min_separation_nwell + 0.1)
    M5_x = pdk.snap_to_2xgrid(M4_x + (size_M4[direccion]+size_M5[direccion])/2 + min_separation_nwell + 0.1)

    # Add components
    M1 = biasing << M1_ref
    M2 = biasing << M2_ref
    M3 = biasing << M3_ref
    M4 = biasing << M4_ref
    M5 = biasing << M5_ref
    M6 = biasing << M6_ref

    # Move components
    M2.movex(M2_x).movey(offset_drc)
    M3.movex(M3_x).movey(offset_drc)
    M4.movex(M4_x).movey(offset_drc)
    M5.movex(M5_x).movey(-min_separation_met2 + offset_drc)
    M6.movex(M6_x).movey(offset_drc)

    M2.movex(offset_drc)
    M3.movex(offset_drc)
    M4.movex(offset_drc)
    M5.movex(offset_drc)
    M6.movex(offset_drc)

    #Auxiliar vias
    via_3_4 = via_stack(pdk, 'met3', 'met4')
    #Reference ports
    index_list = []
    for array in arrays_info:
        indices = {}
        for i, val in enumerate(array[0]):
            if val not in indices:  # primera vez que aparece
                indices[val] = [i, i]
            else:  # actualizar última aparición
                indices[val][1] = i
        index_list.append(indices)

    # Routing
    # Common nodes
    # M1 doesn't have
    # M2 doesn't have
    # M3
    biasing << straight_route(pdk, M3.ports['source_1_'+str(arrays_info[2][0][0])+'_0_W'], M3.ports['source_'+str(len(arrays_info[2][0]))+'_'+str(arrays_info[2][0][-1])+'_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met2', width = width_horizontal)
    # M4 doesn't have
    # M5
    biasing << straight_route(pdk, M5.ports['drain_'+str(index_list[4][1][0]+1)+'_1_0_W'], M5.ports['drain_'+str(index_list[4][1][1]+1)+'_1_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met2', width = width_horizontal)
    biasing << straight_route(pdk, M5.ports['source_'+str(index_list[4][1][0]+1)+'_1_0_W'], M5.ports['source_'+str(index_list[4][1][1]+1)+'_1_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met2', width = width_horizontal)
    biasing << straight_route(pdk, M5.ports['source_'+str(index_list[4][2][0]+1)+'_2_0_W'], M5.ports['source_'+str(index_list[4][2][1]+1)+'_2_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met2', width = width_horizontal)

    #gates
    biasing << straight_route(pdk, M5.ports[str(index_list[4][1][0]+1)+'_1_gate_W'], M5.ports[str(index_list[4][1][1]+1)+'_1_gate_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met3')
    biasing << straight_route(pdk, M5.ports[str(index_list[4][2][0]+1)+'_2_gate_W'], M5.ports[str(index_list[4][2][1]+1)+'_2_gate_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met3')
    
    #Internal routing
    
    #M1
    #bulk
    for i in range(len(arrays_info[0][0])):
        if arrays_info[0][0][i] == 2:
            biasing << straight_route(pdk, M1.ports['source_'+str(i+1)+'_'+str(arrays_info[0][0][i])+'_0_N'], M1.ports['bulk_down_S'], via2_alignment_layer='met2')  
    ##
    biasing << L_route(pdk, M1.ports['source_'+str(index_list[0][1][0]+1)+'_1_0_N'], M1.ports['drain_'+str(index_list[0][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)

    #M2
    #bulk
    for i in range(len(arrays_info[1][0])):
        if arrays_info[1][0][i] == 1:
            biasing << straight_route(pdk, M2.ports['source_'+str(i+1)+'_'+str(arrays_info[1][0][i])+'_0_N'], M2.ports['bulk_down_S'], via2_alignment_layer='met2') 
    #
    biasing << L_route(pdk, M2.ports['source_'+str(index_list[1][2][0]+1)+'_2_0_N'], M2.ports['drain_'+str(index_list[0][1][0]+1)+'_1_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing << L_route(pdk, M2.ports['gate1_N'], M2.ports['drain_'+str(index_list[1][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing << L_route(pdk, M2.ports['gate2_N'], M2.ports['drain_'+str(index_list[1][2][0]+1)+'_2_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)

    #M3
    #bulk
    for i in range(len(arrays_info[2][0])):
        biasing << straight_route(pdk, M3.ports['source_'+str(i+1)+'_'+str(arrays_info[2][0][i])+'_0_N'], M3.ports['bulk_down_S'], via2_alignment_layer='met2') 
    #
    biasing << L_route(pdk, M3.ports['gate1_N'], M3.ports['drain_'+str(index_list[2][1][0]+1)+'_1_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing << L_route(pdk, M3.ports['gate2_N'], M3.ports['drain_'+str(index_list[2][1][0]+1)+'_1_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)    

    #M4
    for i in range(len(arrays_info[3][0])):
        if arrays_info[3][0][i] == 1:
            #bulk
            biasing << straight_route(pdk, M4.ports['source_'+str(i+1)+'_'+str(arrays_info[3][0][i])+'_0_N'], M4.ports['bulk_down_S'], via2_alignment_layer='met2')
            #
            biasing << L_route(pdk, M4.ports['drain_'+str(i+1)+'_'+str(arrays_info[3][0][i])+'_0_S'], M4.ports['source_'+str(index_list[3][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    
    biasing << L_route(pdk, M4.ports['gate1_N'], M4.ports['drain_'+str(index_list[3][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing << L_route(pdk, M4.ports['gate2_N'], M4.ports['drain_'+str(index_list[3][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)

    #M5
    #bulk
    for i in range(len(arrays_info[4][0])):
        if arrays_info[4][0][i] == 1:
            biasing << straight_route(pdk, M5.ports['source_'+str(i+1)+'_'+str(arrays_info[4][0][i])+'_0_N'], M5.ports['bulk_down_S'], via2_alignment_layer='met2') 
            biasing << L_route(pdk, M5.ports['drain_'+str(i+1)+'_'+str(arrays_info[4][0][i])+'_0_S'], M5.ports['source_'+str(index_list[4][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
        if arrays_info[4][0][i] == 2:
            biasing << L_route(pdk, M5.ports['drain_'+str(i+1)+'_'+str(arrays_info[4][0][i])+'_0_S'], M5.ports[str(index_list[4][1][0]+1)+'_1_gate_E'], hglayer='met2', vglayer='met3')
    
    #M6 doesn't have
    
    #External conections
    #M1 - M2
    #VSS_M1M2 = straight_route(pdk, M1.ports['source_2_'+str(index_list[0][2][1]+1)+'_0_W'], M2.ports['source_1_'+str(index_list[1][1][0]+1)+'_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met2', width = width_horizontal)
    biasing << L_route(pdk, M1.ports['source_'+str(index_list[0][2][1]+1)+'_2_0_W'], M2.ports['source_'+str(index_list[1][1][0]+1)+'_1_0_N'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    
    #M1 - M3
    extension_m1m3 = M1.ports['drain_'+str(index_list[0][2][0]+1)+'_2_0_N'].center[1] - M1.ports['drain_'+str(index_list[0][1][0]+1)+'_1_0_N'].center[1] + width_horizontal
    biasing << c_route(pdk, M1.ports['drain_'+str(index_list[0][1][0]+1)+'_1_0_N'], M3.ports['drain_'+str(index_list[2][1][0]+1)+'_1_0_N'], cglayer='met2', cwidth=width_horizontal, extension=extension_m1m3)
    
    #M2 - M3
    biasing << straight_route(pdk, M2.ports['drain_'+str(index_list[1][2][0]+1)+'_2_0_W'], M3.ports['drain_'+str(index_list[2][1][0]+1)+'_1_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met3', width = width_horizontal)

    #M2 - M6
    biasing << L_route(pdk, M6.ports['gate1_N'], M2.ports['drain_'+str(index_list[1][2][0]+1)+'_2_0_E'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    
    #M3 - M6
    biasing << L_route(pdk, M6.ports['drain_'+str(index_list[5][1][0]+1)+'_1_0_N'], M3.ports['drain_'+str(index_list[2][3][0]+1)+'_3_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)

    #M4 - M5
    biasing << L_route(pdk, M5.ports[str(index_list[4][2][0]+1)+'_2_gate_E'], M4.ports['gate2_N'], hglayer='met2', vglayer='met3')
    #biasing << L_route(pdk, M5.ports['source_'+str(index_list[4][1][0]+1)+'_1_0_E'], M4.ports['source_'+str(index_list[3][1][1]+1)+'_1_0_N'], hglayer='met2', vglayer='met3', vwidth = width_horizontal-2*min_separation_met2)
    #VDD_M4M5 = biasing << straight_route(pdk, M5.ports['source_1_1_0_E'], M4.ports['source_6_1_0_N'], width=width_horizontal)
    #biasing.add_ports(VDD_M4M5.ports, prefix='VDD_M4M5_')

    #M4 - M6
    biasing << straight_route(pdk, M6.ports['drain_'+str(index_list[5][2][0]+1)+'_2_0_W'], M4.ports['gate1_E'], glayer1='met2', glayer2='met2' ,width = width_horizontal)

    #M5 - M6
    for i in range(len(arrays_info[4][0])):
        if arrays_info[4][0][i] == 2:
            biasing << c_route(pdk, M6.ports['drain_'+str(index_list[5][3][0]+1)+'_3_0_N'], M5.ports['drain_'+str(i+1)+'_'+str(arrays_info[4][0][i])+'_0_N'], cglayer='met2', cwidth=width_horizontal, extension=2*min_separation_met2)

    #saving ports
    biasing.add_ports(M1.ports, prefix='M1_')
    biasing.add_ports(M2.ports, prefix='M2_')
    biasing.add_ports(M3.ports, prefix='M3_')
    biasing.add_ports(M4.ports, prefix='M4_')
    biasing.add_ports(M5.ports, prefix='M5_')
    biasing.add_ports(M6.ports, prefix='M6_')

    # Centered and boundary
    biasing_centered = center_component_with_ports(pdk, biasing)

    boundary_dim = evaluate_bbox(biasing_centered)
    
    #Input/Output rectangle
    rectangle_ref = rectangle((0.5,0.5), layer=pdk.get_glayer('met2'), centered=True)

    #Inputs
    Vref = biasing_centered << rectangle_ref
    Vref.movey(pdk.snap_to_2xgrid(biasing_centered.ports['M1_gate1_W'].center[1]))
    Vref.movex(pdk.snap_to_2xgrid(-boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]-min_separation_met3))
    biasing_centered << straight_route(pdk, Vref.ports['e1'], biasing_centered.ports['M1_gate1_E'], glayer1='met2', glayer2='met2')
    biasing_centered.add_ports(Vref.get_ports_list(), prefix='V_REF_P_')

    #Outputs
    VbiasP1 = biasing_centered << rectangle_ref
    VbiasP1.movey(pdk.snap_to_2xgrid(-boundary_dim[1]/2-evaluate_bbox(rectangle_ref)[1]-min_separation_met2))
    VbiasP1.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << L_route(pdk, VbiasP1.ports['e3'], biasing_centered.ports['M3_gate1_S'], hglayer='met2', vglayer='met3')
    biasing_centered << L_route(pdk, VbiasP1.ports['e3'], biasing_centered.ports['M3_gate2_S'], hglayer='met2', vglayer='met3')
    biasing_centered.add_ports(VbiasP1.ports, prefix='V_BIASP1_P_')

    VbiasP2 = biasing_centered << rectangle_ref
    VbiasP2.movey(pdk.snap_to_2xgrid(biasing_centered.ports['M5_'+str(index_list[4][2][0]+1)+'_2_gate_W'].center[1]))
    VbiasP2.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << straight_route(pdk, VbiasP2.ports['e1'], biasing_centered.ports['M5_'+str(index_list[4][2][1]+1)+'_2_gate_W'], glayer1='met2', glayer2='met2')
    biasing_centered.add_ports(VbiasP2.ports, prefix='V_BIASP2_P_')

    VbiasN2 = biasing_centered << rectangle_ref
    VbiasN2.movey(pdk.snap_to_2xgrid(-boundary_dim[1]/2-2*evaluate_bbox(rectangle_ref)[1]-2*min_separation_met2))
    VbiasN2.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << L_route(pdk, VbiasN2.ports['e3'], biasing_centered.ports['M6_gate1_S'], hglayer='met2', vglayer='met3')
    biasing_centered << L_route(pdk, VbiasN2.ports['e3'], biasing_centered.ports['M6_gate2_S'], hglayer='met2', vglayer='met3')
    biasing_centered.add_ports(VbiasN2.ports, prefix='V_BIASN2_P_')

    rename_ports_by_orientation(biasing_centered)
    
    component = center_component_with_ports(pdk, biasing_centered)
   
    return component

def Biasing_generator(pdk, 
                      devices_info, 
                      arrays_info, 
                      width_route: float = None,
                      offset_drc: float = 0.0) -> Component:

    # Width configuration
    if width_route == None or width_route == 0:
        separation_interdigitado = 0
        width_horizontal = evaluate_bbox(via_stack(pdk,'met2','met3'))[1]
    else:
        separation_interdigitado = width_route
        width_horizontal = width_route
    # min separations
    min_separation_met4 = pdk.get_grule('met4')['min_separation']
    min_separation_met3 = pdk.get_grule('met3')['min_separation']
    min_separation_met2 = pdk.get_grule('met2')['min_separation']
    # Create the component
    biasing = Component()

    #Reference ports
    index_list = []
    for array in arrays_info:
        indices = {}
        for i, val in enumerate(array[0]):
            if val not in indices:  # primera vez que aparece
                indices[val] = [i, i]
            else:  # actualizar última aparición
                indices[val][1] = i
        index_list.append(indices)

    top_components_ref = Component_Biasing(pdk, devices_info, arrays_info, width_route, offset_drc)
    M7_ref = interdigitado_cascode_placement_Onchip(pdk, output='via', common_route=(False, True), output_separation=(separation_interdigitado, width_route),
                                                    deviceA_and_B=devices_info[6]['type'], width=devices_info[6]['width'], length=devices_info[6]['length'], 
                                                    fingers=devices_info[6]['fingers'], with_dummy=devices_info[6]['with_dummy'], array=arrays_info[6], 
                                                    with_tie=devices_info[6]['with_tie'], with_lvt_layer=devices_info[6]['lvt'], routed=True)
    # Sizes referencias
    size_top = evaluate_bbox(top_components_ref)
    size_M7 = evaluate_bbox(M7_ref)

    # Add components
    top = biasing << top_components_ref
    M7 = biasing << M7_ref
    
    # Movement
    M7_y = pdk.snap_to_2xgrid((size_top[1]+size_M7[1])/2 + min_separation_met4 + separation_interdigitado)
    # Horizontal alignement
    port1_x = top.ports['M6_source_'+str(index_list[5][1][0]+1)+'_1_0_S'].center[0]
    port2_x = top.ports['M6_source_'+str(index_list[5][2][0]+1)+'_2_0_S'].center[0]
    port3_x = top.ports['M6_source_'+str(index_list[5][3][0]+1)+'_3_0_S'].center[0]
    top_ports_x = [port1_x, port2_x, port3_x]
        #conection port
    ports1 = list()
    ports2 = list()
    ports3 = list()
    for i in range(len(arrays_info[6][0])):
        if arrays_info[6][0][i] == 1:
            ports1.append(M7.ports['drain_'+str(i+1)+'_1_0_N'].center[0])
        elif arrays_info[6][0][i] == 2:
            ports2.append(M7.ports['drain_'+str(i+1)+'_2_0_N'].center[0])
        elif arrays_info[6][0][i] == 3:
            ports3.append(M7.ports['drain_'+str(i+1)+'_3_0_N'].center[0])
    m7_ports_x = [ports1, ports2, ports3]
    x_offset = 0
    moved = False
    for i in range(3):
        if moved:
            break
        range_av = [top_ports_x[i]-0.25-min_separation_met3, top_ports_x[i]+0.25+min_separation_met3]
        for port_list in range(len(m7_ports_x)):
            if moved:
                break
            elif i <= port_list:
                for j in range(len(m7_ports_x[port_list])):
                    if range_av[0] < m7_ports_x[port_list][j] < range_av[1]:
                        x_offset += 0.5 + min_separation_met3
                        moved = True
                        break
        
    
    print(x_offset)
                
    #Move components
    M7.movey(-M7_y)
    M7.movey(offset_drc)
    M7.movex(x_offset + offset_drc)

    #Auxiliar vias
    via_3_4 = via_stack(pdk, 'met3', 'met4')    

    #Routing
    #Internal routing
    #M7
    for i in range(len(arrays_info[6][0])):
        #bulk
        biasing << straight_route(pdk, M7.ports['source_'+str(i+1)+'_'+str(arrays_info[6][0][i])+'_0_N'], M7.ports['bulk_down_S'], via2_alignment_layer='met2') 
        #
    #VSS_M7 = biasing << straight_route(pdk, M7.ports['source_'+str(index_list[6][3][0]+1)+'_3_0_W'], M7.ports['source_'+str(index_list[6][3][1]+1)+'_3_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met2', width = width_horizontal)
    biasing << straight_route(pdk, M7.ports['gate_1_l_S'], M7.ports['gate_2_l_N'], glayer1 = 'met3', glayer2 = 'met3')
    biasing << straight_route(pdk, M7.ports['gate_1_r_S'], M7.ports['gate_2_r_N'], glayer1 = 'met3', glayer2 = 'met3')
    #biasing << straight_route(pdk, M7.ports['drain_1_3_0_W'], M7.ports['drain_39_3_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met3', width = width_horizontal)
    #biasing << straight_route(pdk, M7.ports['drain_4_2_0_W'], M7.ports['drain_36_2_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met3', width = width_horizontal)
    #biasing << straight_route(pdk, M7.ports['drain_14_1_0_W'], M7.ports['drain_26_1_0_E'], glayer1='met2', glayer2='met2', via1_alignment_layer='met3', width = width_horizontal)

    #External routing
    #M6 - M7
    #bulk
    top.ports['M6_bulk_down_N'].layer =  pdk.get_glayer('met1')
    biasing << straight_route(pdk, top.ports['M6_bulk_down_N'], M7.ports['bulk_up_E'], width=1, glayer1 = 'met1', glayer2='met1')
    #
    biasing << L_route(pdk, top.ports['M6_source_'+str(index_list[5][1][0]+1)+'_1_0_N'], M7.ports['drain_'+str(index_list[6][1][0]+1)+'_1_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing << L_route(pdk, top.ports['M6_source_'+str(index_list[5][2][0]+1)+'_2_0_N'], M7.ports['drain_'+str(index_list[6][2][0]+1)+'_2_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing << L_route(pdk, top.ports['M6_source_'+str(index_list[5][3][0]+1)+'_3_0_N'], M7.ports['drain_'+str(index_list[6][3][0]+1)+'_3_0_W'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)

    #M3 - M7
    #auxiliar via
    via_2_3_ref = via_stack(pdk, 'met2', 'met3')
    position_top_component = top.bbox[1][1] + width_horizontal
    position_left_component = round(-evaluate_bbox(biasing)[0]/2 - evaluate_bbox(via_2_3_ref)[0]/2 - width_horizontal/2, 2)
    position_right_component = round(evaluate_bbox(biasing)[0]/2 + evaluate_bbox(via_2_3_ref)[0]/2 + width_horizontal/2, 2)
    via_M3M7_left = biasing << via_2_3_ref
    via_M3M7_left.movex(position_left_component-min_separation_met3)
    via_M3M7_left.movey(position_top_component + min_separation_met2)
    biasing << L_route(pdk, top.ports['M3_drain_'+str(index_list[2][3][0]+1)+'_3_0_S'], via_M3M7_left.ports['bottom_met_W'], vwidth = width_horizontal)
    biasing << L_route(pdk, via_M3M7_left.ports['top_met_N'], M7.ports['gate_1_l_E'], hglayer = 'met2', vglayer='met3', hwidth = width_horizontal, vwidth=width_horizontal)
    biasing << L_route(pdk, via_M3M7_left.ports['top_met_N'], M7.ports['gate_2_l_E'], hglayer = 'met2', vglayer='met3', hwidth = width_horizontal, vwidth=width_horizontal)

    via_M3M7_right = biasing << via_2_3_ref
    via_M3M7_right.movex(position_right_component+min_separation_met3)
    via_M3M7_right.movey(position_top_component + min_separation_met2)
    biasing << L_route(pdk, top.ports['M3_drain_'+str(index_list[2][3][0]+1)+'_3_0_S'], via_M3M7_right.ports['bottom_met_E'], vwidth = width_horizontal)
    biasing << L_route(pdk, via_M3M7_right.ports['top_met_N'], M7.ports['gate_1_r_W'], hglayer = 'met2', vglayer='met3', hwidth = width_horizontal, vwidth=width_horizontal)
    biasing << L_route(pdk, via_M3M7_right.ports['top_met_N'], M7.ports['gate_2_r_W'], hglayer = 'met2', vglayer='met3', hwidth = width_horizontal, vwidth=width_horizontal)
    #biasing << c_route(pdk, top.ports['M3_drain_3_3_0_N'], M7.ports['gate_1_l_N'], cglayer='met2', cwidth=width_horizontal, extension=width_horizontal+3*min_separation_met2)
    #biasing << c_route(pdk, top.ports['M3_drain_3_3_0_N'], M7.ports['gate_1_r_N'], cglayer='met2', cwidth=width_horizontal, extension=width_horizontal+3*min_separation_met2)
    
    #Add ports to component
    biasing.add_ports(top.ports)
    biasing.add_ports(M7.ports, prefix='M7_')

    # Centered
    biasing_centered = center_component_with_ports(pdk, biasing)

    boundary_dim = evaluate_bbox(biasing_centered)

    #Input/Output rectangle
    rectangle_ref = rectangle((0.5,0.5), layer=pdk.get_glayer('met2'), centered=True)

    #Inputs
    Vref = biasing_centered << rectangle_ref
    Vref.movey(pdk.snap_to_2xgrid(biasing_centered.ports['V_REF_P_W'].center[1]))
    Vref.movex(pdk.snap_to_2xgrid(-boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]-min_separation_met3))
    biasing_centered << straight_route(pdk, Vref.ports['e1'], biasing_centered.ports['V_REF_P_E'], glayer1='met2', glayer2='met2')
    biasing_centered.add_ports(Vref.get_ports_list(), prefix='V_REF_')

    #Outputs
    VbiasP1 = biasing_centered << rectangle_ref
    VbiasP1.movey(pdk.snap_to_2xgrid(biasing_centered.ports['V_BIASP1_P_W'].center[1]))
    VbiasP1.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << straight_route(pdk, VbiasP1.ports['e1'], biasing_centered.ports['V_BIASP1_P_W'], glayer1='met2', glayer2='met2')
    biasing_centered.add_ports(VbiasP1.ports, prefix='V_BIASP1_')

    VbiasP2 = biasing_centered << rectangle_ref
    VbiasP2.movey(pdk.snap_to_2xgrid(biasing_centered.ports['V_BIASP2_P_W'].center[1]))
    VbiasP2.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << straight_route(pdk, VbiasP2.ports['e1'], biasing_centered.ports['V_BIASP2_P_W'], glayer1='met2', glayer2='met2')
    biasing_centered.add_ports(VbiasP2.ports, prefix='V_BIASP2_')

    VbiasN1 = biasing_centered << rectangle_ref
    VbiasN1.movey(pdk.snap_to_2xgrid((biasing_centered.ports['M7_gate_2_r_W'].center[1]+biasing_centered.ports['M7_gate_1_r_W'].center[1])/2))
    VbiasN1.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << L_route(pdk, VbiasN1.ports['e3'], biasing_centered.ports['M7_gate_2_r_S'], hglayer='met2', vglayer='met3', vwidth = width_horizontal)
    biasing_centered.add_ports(VbiasN1.ports, prefix='V_BIASN1_')

    VbiasN2 = biasing_centered << rectangle_ref
    VbiasN2.movey(pdk.snap_to_2xgrid(biasing_centered.ports['V_BIASN2_P_W'].center[1]))
    VbiasN2.movex(pdk.snap_to_2xgrid(boundary_dim[0]/2+evaluate_bbox(rectangle_ref)[0]+min_separation_met3))
    biasing_centered << straight_route(pdk, VbiasN2.ports['e1'], biasing_centered.ports['V_BIASN2_P_W'], glayer1='met2', glayer2='met2')
    biasing_centered.add_ports(VbiasN2.ports, prefix='V_BIASN2_')

    #Centered and boundary
    biasing_centered = center_component_with_ports(pdk, biasing_centered)
    rename_ports_by_orientation(biasing_centered)

    #boundary = Boundary_layer(pdk, biasing_centered)

    #Rails
    route_list_hor = [['M1_source_'+str(index_list[0][2][0]+1)+'_2_0_route_','VSS'], ['M2_source_'+str(index_list[1][1][0]+1)+'_1_0_route_', 'VSS']]
    #VDD
    for i in range(len(arrays_info[2][0])):
        route = []
        route.append('M3_source_'+str(i+1)+'_'+str(arrays_info[2][0][i])+'_0_route_')
        route.append('VDD')
        route_list_hor.append(route)
    for i in range(len(arrays_info[3][0])):
        route = []
        if arrays_info[3][0][i] == 1:
            route.append('M4_source_'+str(i+1)+'_'+str(arrays_info[3][0][i])+'_0_route_')
            route.append('VDD')
            route_list_hor.append(route)
    for i in range(len(arrays_info[4][0])):
        route = []
        if arrays_info[4][0][i] == 1:
            route.append('M5_source_'+str(i+1)+'_'+str(arrays_info[4][0][i])+'_0_route_')
            route.append('VDD')
            route_list_hor.append(route)
    #VSS        
    for i in range(len(arrays_info[6][0])):
        route = []
        route.append('M7_source_'+str(i+1)+'_'+str(arrays_info[6][0][i])+'_0_route_')
        route.append('VSS')
        route_list_hor.append(route)
    #route_spec = [['Test', 5], ['Test2',10]]
    #power_rails_placement(pdk = pdk,
    #                      component = biasing_centered,
    #                      width = 1.2,
    #                      alignment = 0,    #0 horizontal
    #                      route_list = route_list_hor,
    #                      specific_rail=route_spec,
    #                      label = True,
    #                      ports = True)
    
    route_list_ver = []
    #ports_VDD = [name for name in biasing_centered.ports if 'VDD' in name and 'W' in name]
    #ports_VSS = [name for name in biasing_centered.ports if 'VSS' in name and 'W' in name]
    #for i in range(len(ports_VDD)):
    #    route = []
    #    route.append(ports_VDD[i][0:-1])
    #    route.append('VDD')
    #    route_list_ver.append(route)
    
    #for i in range(len(ports_VSS)):
    #    route = []
    #    route.append(ports_VSS[i][0:-1])
    #    route.append('VSS')
    #    route_list_ver.append(route)
    #rails_route_list = [route_list_hor, route_list_ver]
    
    #power_rails_placement(pdk = pdk,
    #                      component = biasing_centered,
    #                      width = 1.2,
    #                      alignment = 1,    #0 vertical
    #                      route_list = route_list_ver,
    #                      label = False,
    #                      ports = False)
    
    #Save ports

    component = Component()
    component << biasing_centered

    filtrar_puertos(biasing_centered, component, 'V_REF_', 'VREF_', True)
    filtrar_puertos(biasing_centered, component, 'V_BIASN1_', 'VBIASN1_', True)
    filtrar_puertos(biasing_centered, component, 'V_BIASN2_', 'VBIASN2_', True)
    filtrar_puertos(biasing_centered, component, 'V_BIASP1_', 'VBIASP1_', True)
    filtrar_puertos(biasing_centered, component, 'V_BIASP2_', 'VBIASP2_', True)
    for route in route_list_hor:
        filtrar_puertos(biasing_centered, component, route[0])
    #filtrar_puertos(biasing_centered, component, 'VDD_2_', 'VDD_P_')
    #filtrar_puertos(biasing_centered, component, 'VSS_1_', 'VSS_P_')

    # add the pin and label
    #pin_label_creation(pdk, 'VBIASN1', 'VbiasN1', 'met2', component)
    #pin_label_creation(pdk, 'VBIASN2', 'VbiasN2', 'met2', component)
    #pin_label_creation(pdk, 'VREF', 'Vref', 'met2', component)    
    #pin_label_creation(pdk, 'VBIASP1', 'VbiasP1', 'met2', component)
    #pin_label_creation(pdk, 'VBIASP2', 'VbiasP2', 'met2', component)
    #pin_label_creation(pdk, 'VDD_P', 'VDD', 'met4', component)
    #pin_label_creation(pdk, 'VSS_P', 'VSS', 'met4', component)

    return component_snap_to_grid(component), route_list_hor

def generator_bias():
    # Information of the transistors
    array_m1 = [[1,2]]
    array_m2 = [[1,2]]
    array_m3 = [[2,1,3]]
    array_m4 = [[1,2]]
    array_m5 = [[2,1]]
    array_m6 = [[1,2,3]]
    array_m7 = [[3,3,2,2,1,1,1,1,2,2,3,3,3,3,2,2,1,1,1,1,2,2,3,3,3,3,2,2,1,1,1,1,2,2,3,3,3,3,2,2,1,1,1,1,2,2,3,3]]

    dum_m1 = (len(array_m1[0])+2)*2 + 2
    dum_m2 = (len(array_m2[0])+2)*2 + 2
    dum_m3 = (len(array_m3[0])+2)*2 + 2
    dum_m4 = (len(array_m4[0])+2)*2 + 2
    dum_m5 = (len(array_m5[0])+2)*2 + 2
    dum_m6 = (len(array_m6[0])+2)*2 + 2
    dum_m7 = (len(array_m7[0])+2)*2 + 4
    
    print(f'dummys M1 = {dum_m1}')
    print(f'dummys M2 = {dum_m2}')
    print(f'dummys M3 = {dum_m3}')
    print(f'dummys M4 = {dum_m4}')
    print(f'dummys M5 = {dum_m5}')
    print(f'dummys M6 = {dum_m6}')
    print(f'dummys M7 = {dum_m7}')

    devices_info_m1 = {'type':'nfet', 'name':'M1', 'width':1.00, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    devices_info_m2 = {'type':'nfet', 'name':'M1', 'width':0.50, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    devices_info_m3 = {'type':'pfet', 'name':'M1', 'width':1.00, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    devices_info_m4 = {'type':'pfet', 'name':'M1', 'width':1.00, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    devices_info_m5 = {'type':'pfet', 'name':'M1', 'width':1.00, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    devices_info_m6 = {'type':'nfet', 'name':'M1', 'width':0.50, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    devices_info_m7 = {'type':'nfet', 'name':'M1', 'width':2.00, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}

    devices_info = [devices_info_m1, devices_info_m2, devices_info_m3, devices_info_m4, devices_info_m5, devices_info_m6, devices_info_m7]
    arrays_info = [array_m1, array_m2, array_m3, array_m4, array_m5, array_m6, array_m7]

    bias_core, rails_route_list = Biasing_generator(gf180, devices_info, arrays_info, width_route=1, offset_drc = 0.00)
    # Display the current mirror layout at Klayout:
    #bias_core.name = "error_amplifier_N_input_bias"
    #bias_core.write_gds("error_amplifier_N_input_bias_pcells.gds")
    #bias_core.show()
    #ports = [name for name in bias_core.ports if 'V' in name]
    #print(ports)
    return bias_core, rails_route_list

if __name__ == "__main__":
    # If called directly call main function
    generator_bias()