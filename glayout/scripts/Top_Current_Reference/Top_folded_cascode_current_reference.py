from glayout import MappedPDK, sky130, gf180
from glayout import  via_stack

#from glayout.spice.netlist import Netlist
from glayout.routing import c_route, L_route, straight_route

from gdsfactory.component import Component
from gdsfactory.components.rectangle import rectangle

from glayout.util.comp_utils import (
    align_comp_to_port,
    evaluate_bbox,
    movex,
    movey,
    prec_ref_center,
)

from glayout.util.port_utils import (
    add_ports_perimeter,
    print_ports,
    rename_ports_by_list,
    rename_ports_by_orientation,
)
from glayout.util.snap_to_grid import component_snap_to_grid
from glayout.placement.common_centroid_ab_ba import common_centroid_ab_ba
from typing import Optional, Union, Literal

# Import custom functions (Matrix generator)
from custom_utils import macro_two_transistor_placement_Onchip
from custom_utils import pin_label_creation
from custom_utils import center_component_with_ports
from custom_utils import filtrar_puertos
from custom_utils import interdigitado_placement_Onchip
from custom_utils import interdigitado_cascode_placement_Onchip
from custom_utils import Boundary_layer
from custom_utils import power_rails_placement
from folded_cascode_bias_180 import generator_bias
from folded_cascode_core import generator_core
from curr_ref_gen_second_stage import generator_current_reference
import gdsfactory as gf


# Numerical functions
from decimal import Decimal
from typing import Literal, Optional, Union


def OTA_Current_Reference(pdk: MappedPDK,
                        width_route: float = 0) -> Component:
    """
    this function connects the biasing and core circuits of the OTA to current reference circuit
    """
    # Create the component
    OTA_Current_Reference = Component()
    Bias_circuit, bias_route_list = generator_bias()
    Core_circuit, core_route_list = generator_core()
    current_reference, current_route_list = generator_current_reference()
    Bias = OTA_Current_Reference << Bias_circuit
    Core = OTA_Current_Reference << Core_circuit
    Current_Outputs = OTA_Current_Reference << current_reference

    Bias_size =  evaluate_bbox(Bias)
    Core_size =  evaluate_bbox(Core)
    Current_Outputs_size = evaluate_bbox(Current_Outputs)

    min_separation_nwell = pdk.get_grule('nwell')['min_separation']
    min_separation2 = pdk.get_grule('met2')['min_separation']
    min_separation3 = pdk.get_grule('met3')['min_separation']

    #Movement and Aux vias
    via_23 = via_stack(pdk, 'met2', 'met3')
    size_via23 = evaluate_bbox(via_23)

    Core_HMovement = (Bias_size[0] + Core_size[0])/2 + 2*size_via23[0] + 4*min_separation3
    Core_VMovement = (Core_size[1]/2)-(Bias_size[1]/2)
    Current_HMovement = ((Bias_size[0]/2) + Core_size[0] + (Current_Outputs_size[0]/2) + 4*size_via23[0] + 8*min_separation3)
    Current_VMovement = (Current_Outputs_size[1]/2)-(Bias_size[1]/2)

    Core.movex(pdk.snap_to_2xgrid(Core_HMovement))
    Core.movey(pdk.snap_to_2xgrid(Core_VMovement))
    Current_Outputs.movex(pdk.snap_to_2xgrid(Current_HMovement))
    Current_Outputs.movey(pdk.snap_to_2xgrid(Current_VMovement))
    
    #algin movement
    port_biasv1n_core = Core.ports["P_VbiasN1_E"].center[1]
    port_biasv1n_bias = Bias.ports["VBIASN1_E"].center[1]
    port_biasv2n_bias = Bias.ports["VBIASN2_E"].center[1]
    port_biasv1p_bias = Bias.ports["VBIASP1_E"].center[1]
    port_biasv2p_bias = Bias.ports["VBIASP2_E"].center[1]

    extra_move = 0
    unavailable_pos = [port_biasv1n_core-0.25-min_separation2-width_route/2, port_biasv1n_core+0.25+min_separation2+width_route/2]

    ports_check = [port_biasv1n_bias, port_biasv2n_bias, port_biasv1p_bias, port_biasv2p_bias]
    for port in ports_check:
        if unavailable_pos[0] < port < unavailable_pos[1]:
            extra_move -= round(width_route + 1 + 2*min_separation2, 2) 
            print(f'extra move {extra_move}')
            Core.movey(pdk.snap_to_2xgrid(extra_move))

    Core.movex(0.0001)
    Core.movey(0.0001)

    Bias.movex(0.001)
    Bias.movey(0.001)  

    aux_N1 = OTA_Current_Reference << via_23
    aux_N1.movey(Bias.ports['VBIASN1_E'].center[1])
    aux_N1.movex(Bias.ports['VBIASN1_N'].center[0])

    aux_P2 = OTA_Current_Reference << via_23
    aux_P2.movey(Bias.ports['VBIASP2_E'].center[1])
    aux_P2.movex(Bias.ports['VBIASP2_N'].center[0] + size_via23[0] + min_separation3)
    OTA_Current_Reference << straight_route(pdk, Bias.ports['VBIASP2_E'], aux_P2.ports['bottom_met_W'])

    aux_N2 = OTA_Current_Reference << via_23
    aux_N2.movey(Bias.ports['VBIASN2_E'].center[1])
    aux_N2.movex(Bias.ports['VBIASN2_N'].center[0] + 2*size_via23[0] + 3*min_separation3)
    OTA_Current_Reference << straight_route(pdk, Bias.ports['VBIASN2_E'], aux_N2.ports['bottom_met_W'])

    aux_Vref = OTA_Current_Reference << via_23
    aux_Vref.movey(Bias.ports['VREF_E'].center[1])
    aux_Vref.movex(Bias.ports['VREF_N'].center[0])

    aux_Vcom = OTA_Current_Reference << via_23
    aux_Vcom.movey(Current_Outputs.ports['VCOMN_E'].center[1])
    aux_Vcom.movex(Current_Outputs.ports['VCOMN_N'].center[0] - size_via23[0] - min_separation3)
    OTA_Current_Reference << straight_route(pdk, Current_Outputs.ports['VCOMN_E'], aux_Vcom.ports['bottom_met_W'])

    aux_Vrep = OTA_Current_Reference << via_23
    #aux_Vrep.movey(Current_Outputs.ports['Opamp_output_E'].center[1])
    aux_Vrep.movey(Current_Outputs.ports['VCOMN_E'].center[1])
    aux_Vrep.movex(Current_Outputs.ports['Opamp_output_N'].center[0] - size_via23[0] - min_separation2)
    aux_Vrep.movey(-(pdk.snap_to_2xgrid(size_via23[1])))
    aux_Vrep.movex(-(pdk.snap_to_2xgrid(size_via23[0]+pdk.get_grule('met3')['min_separation'])))
    OTA_Current_Reference << L_route(pdk, Current_Outputs.ports['Opamp_output_E'], aux_Vrep.ports['bottom_met_S'], vglayer='met3')

    aux_Vres = OTA_Current_Reference << via_23
    #aux_Vres.movey(Current_Outputs.ports['Resistor_E'].center[1])
    aux_Vres.movey(Current_Outputs.ports['VCOMN_E'].center[1])
    aux_Vres.movex(Current_Outputs.ports['Resistor_N'].center[0])
    aux_Vres.movey(-(pdk.snap_to_2xgrid(2*size_via23[1]+pdk.get_grule('met3')['min_separation'])))
    OTA_Current_Reference << straight_route(pdk, Current_Outputs.ports['Resistor_N'], aux_Vres.ports['bottom_met_S'], glayer1='met3')

    OTA_Current_Reference.add_ports(Bias.get_ports_list(),prefix='Bias_')
    OTA_Current_Reference.add_ports(Core.get_ports_list(),prefix='Core_')
    OTA_Current_Reference.add_ports(Current_Outputs.get_ports_list(),prefix='Current_Outs_')
    port = [name for name in Current_Outputs.ports if 'Nref_A_source_T_Ver' in name]
    print (port)
    #Routing

    OTA_Current_Reference << L_route(pdk, aux_N1.ports['top_met_S'], Core.ports['P_VbiasN1_E'])
    OTA_Current_Reference << L_route(pdk, aux_N2.ports['top_met_N'], Core.ports['P_VbiasN2_E'])
    OTA_Current_Reference << L_route(pdk, aux_P2.ports['top_met_N'], Core.ports['P_VbiasP2_E'])
    OTA_Current_Reference << L_route(pdk, Core.ports['P_Vcomn_W'], aux_Vcom.ports['top_met_S'], vglayer='met3')
    OTA_Current_Reference << L_route(pdk, Core.ports['P_Vout_W'], aux_Vrep.ports['top_met_S'], vglayer='met3')
    OTA_Current_Reference << L_route(pdk, Core.ports['P_V-_E'], Bias.ports['VREF_S'], vglayer='met3')
    OTA_Current_Reference << L_route(pdk, Core.ports['P_V+_N'], aux_Vres.ports['top_met_E'], hglayer='met2')
    
    OTA_centered = center_component_with_ports(pdk, OTA_Current_Reference)
    boundary = Boundary_layer(pdk, OTA_centered)
    
    #Rails
    route_list_hor = list()
    route_list_ver = list()
    #bias
    for route in bias_route_list:
        new_name = 'Bias_' + route[0]
        route[0] = new_name
        route_list_hor.append(route)

    #core
    for route in core_route_list:
        new_name =  'Core_' + route[0]
        route[0] = new_name
        route_list_hor.append(route)

    #current
    for route in current_route_list:
        new_name =  'Current_Outs_' + route[0]
        route[0] = new_name
        route_list_hor.append(route)

    #specific_rail = [['Iref1p', 48], ['Iref2p', 49], ['Iref3p', 50],
    #                 ['Iref1n', 29], ['Iref2n', 30], ['Iref3n', 31]]
    
    port = [name for name in OTA_centered.ports if 'Nref_A_source_T_Ver' in name]
    print (port)
    power_rails_placement(pdk = pdk,
                          component = OTA_centered,
                          width = 1.2,
                          alignment = 0,    #0 horizontal
                          route_list = route_list_hor,
    #                      specific_rail=specific_rail,
                          label = False,
                          ports = True)
    
    ports_VDD = [name for name in OTA_centered.ports if 'VDD' in name and 'W' in name]
    ports_VSS = [name for name in OTA_centered.ports if 'VSS' in name and 'W' in name]

    for i in range(len(ports_VDD)):
        route = []
        route.append(ports_VDD[i][0:-1])
        route.append('VDD')
        route_list_ver.append(route)
    
    for i in range(len(ports_VSS)):
        route = []
        route.append(ports_VSS[i][0:-1])
        route.append('VSS')
        route_list_ver.append(route)
    
    power_rails_placement(pdk = pdk,
                          component = OTA_centered,
                          width = 1.2,
                          alignment = 1,    #1 vertical
                          route_list = route_list_ver,
                          label = False,
                          ports = False)

    component = Component()
    component << OTA_centered

    #Ports and label biasing
    filtrar_puertos(OTA_centered, component, 'Bias_VREF_', 'VREF_', True)
    filtrar_puertos(OTA_centered, component, 'Bias_VBIASN1_', 'VBIASN1_', True)
    filtrar_puertos(OTA_centered, component, 'Bias_VBIASN2_', 'VBIASN2_', True)
    filtrar_puertos(OTA_centered, component, 'Bias_VBIASP1_', 'VBIASP1_', True)
    filtrar_puertos(OTA_centered, component, 'Bias_VBIASP2_', 'VBIASP2_', True)

    #pin_label_creation(pdk, 'VBIASN1', 'VbiasN1', 'met2', component)
    #pin_label_creation(pdk, 'VBIASN2', 'VbiasN2', 'met2', component)
    pin_label_creation(pdk, 'VREF', 'Vref', 'met2', component)    
    #pin_label_creation(pdk, 'VBIASP1', 'VbiasP1', 'met2', component)
    #pin_label_creation(pdk, 'VBIASP2', 'VbiasP2', 'met2', component)

    #Ports and label core
    filtrar_puertos(OTA_centered, component, 'Core_P_V+_', 'P_V+_', True)
    filtrar_puertos(OTA_centered, component, 'Core_P_V-_', 'P_V-_', True)
    filtrar_puertos(OTA_centered, component, 'Core_P_VbiasN1_', 'P_VbiasN1_', True) 
    filtrar_puertos(OTA_centered, component, 'Core_P_Vout_', 'P_Vout_', True)
    #filtrar_puertos(OTA_core_centered, component, 'Core_P_VbiasP1_', 'P_VbiasP1_', True) 
    filtrar_puertos(OTA_centered, component, 'Core_P_VbiasP2_', 'P_VbiasP2_', True) 
    filtrar_puertos(OTA_centered, component, 'Core_P_VbiasN2_', 'P_VbiasN2_', True)  
    filtrar_puertos(OTA_centered, component, 'Core_P_Vcomn_', 'P_Vcomn_', True)

    #pin_label_creation(pdk, 'P_V+','Vres','met2',component)
    #pin_label_creation(pdk, 'P_V-','Vref','met2',component)
    #pin_label_creation(pdk, 'P_VbiasN1','VbiasN1','met2',component)
    pin_label_creation(pdk, 'P_Vout','Vrefp','met2',component)
    #pin_label_creation(pdk, 'P_VbiasP1','VbiasP1','met2',component, True)
    #pin_label_creation(pdk, 'P_VbiasP2','VbiasP2','met2',component)
    #pin_label_creation(pdk, 'P_VbiasN2','VbiasN2','met2',component)
    #pin_label_creation(pdk, 'P_Vcomn', 'Vcomn', 'met2',component)

    #VDD and VSS
    filtrar_puertos(OTA_centered, component, 'VDD_2_', 'VDD_P_')
    filtrar_puertos(OTA_centered, component, 'VSS_1_', 'VSS_P_')
    pin_label_creation(pdk, 'VDD_P', 'VDD', 'met4', component)
    pin_label_creation(pdk, 'VSS_P', 'VSS', 'met4', component)
    
    return component_snap_to_grid(component)


Test = OTA_Current_Reference(gf180, 1)
Test.name = "current_reference_generator_v2"
Test.write_gds("current_reference_generator_v2_pcells.gds")
ports = [name for name in Test.ports if 'V' in name]
print(ports)
Test.show()