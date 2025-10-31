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
import gdsfactory as gf


# Numerical functions
from decimal import Decimal
from typing import Literal, Optional, Union


def OTA_Main(pdk: MappedPDK,
                        width_route: float = 0) -> Component:
    """
    this function connects the biasing and core circuits of the OTA
    """
    # Create the component
    OTA_MAIN = Component()
    Bias_circuit, bias_route_list = generator_bias()
    Core_circuit, core_route_list = generator_core()
    Bias = OTA_MAIN << Bias_circuit
    Core = OTA_MAIN << Core_circuit

    Bias_size =  evaluate_bbox(Bias)
    Core_size =  evaluate_bbox(Core)


    min_separation_nwell = pdk.get_grule('nwell')['min_separation']
    min_separation2 = pdk.get_grule('met2')['min_separation']
    min_separation3 = pdk.get_grule('met3')['min_separation']

    #Movement and Aux vias
    via_23 = via_stack(pdk, 'met2', 'met3')
    size_via23 = evaluate_bbox(via_23)

    Core_HMovement = (Bias_size[0] + Core_size[0])/2 + 2*size_via23[0] + 4*min_separation3
    Core_VMovement = (Core_size[1]/2)-(Bias_size[1]/2)

    Core.movex(pdk.snap_to_2xgrid(Core_HMovement))
    Core.movey(pdk.snap_to_2xgrid(Core_VMovement))

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

    aux_N1 = OTA_MAIN << via_23
    aux_N1.movey(Bias.ports['VBIASN1_E'].center[1])
    aux_N1.movex(Bias.ports['VBIASN1_N'].center[0])

    aux_P2 = OTA_MAIN << via_23
    aux_P2.movey(Bias.ports['VBIASP2_E'].center[1])
    aux_P2.movex(Bias.ports['VBIASP2_N'].center[0] + size_via23[0] + min_separation3)
    OTA_MAIN << straight_route(pdk, Bias.ports['VBIASP2_E'], aux_P2.ports['bottom_met_W'])

    aux_N2 = OTA_MAIN << via_23
    aux_N2.movey(Bias.ports['VBIASN2_E'].center[1])
    aux_N2.movex(Bias.ports['VBIASN2_N'].center[0] + 2*size_via23[0] + 3*min_separation3)
    OTA_MAIN << straight_route(pdk, Bias.ports['VBIASN2_E'], aux_N2.ports['bottom_met_W'])
    

    OTA_MAIN.add_ports(Bias.get_ports_list(),prefix='Bias_')
    OTA_MAIN.add_ports(Core.get_ports_list(),prefix='Core_')

    #Routing

    OTA_MAIN << L_route(pdk, aux_N1.ports['top_met_S'], Core.ports['P_VbiasN1_E'])
    OTA_MAIN << L_route(pdk, aux_N2.ports['top_met_N'], Core.ports['P_VbiasN2_E'])
    OTA_MAIN << L_route(pdk, aux_P2.ports['top_met_N'], Core.ports['P_VbiasP2_E'])
    
    OTA_centered = center_component_with_ports(pdk, OTA_MAIN)
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


    power_rails_placement(pdk = pdk,
                          component = OTA_centered,
                          width = 1.2,
                          alignment = 0,    #0 horizontal
                          route_list = route_list_hor,
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

    pin_label_creation(pdk, 'P_V+','V+','met2',component)
    pin_label_creation(pdk, 'P_V-','V-','met2',component)
    #pin_label_creation(pdk, 'P_VbiasN1','VbiasN1','met2',component)
    pin_label_creation(pdk, 'P_Vout','Vout','met2',component)
    #pin_label_creation(pdk, 'P_VbiasP1','VbiasP1','met2',component, True)
    #pin_label_creation(pdk, 'P_VbiasP2','VbiasP2','met2',component)
    #pin_label_creation(pdk, 'P_VbiasN2','VbiasN2','met2',component)
    pin_label_creation(pdk, 'P_Vcomn', 'Vcomn', 'met2',component)

    #VDD and VSS
    filtrar_puertos(OTA_centered, component, 'VDD_2_', 'VDD_P_')
    filtrar_puertos(OTA_centered, component, 'VSS_1_', 'VSS_P_')
    pin_label_creation(pdk, 'VDD_P', 'VDD', 'met4', component)
    pin_label_creation(pdk, 'VSS_P', 'VSS', 'met4', component)
    
    return component_snap_to_grid(component)


Test = OTA_Main(gf180, 1)
Test.name = "error_amplifier_N_input_v1"
Test.write_gds("error_amplifier_N_input_v1_pcells.gds")
ports = [name for name in Test.ports if 'V' in name]
print(ports)
Test.show()