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

# Import custom functions (Matrix generator)
from folded_cascode_core_blocks import (mirror, Cascode, current_source, transistor, diode, differential_pair, Bi_current_source, Pair_bias)
from custom_utils import filtrar_puertos, pin_label_creation, interdigitado_placement_Onchip, macro_two_transistor_placement_Onchip 
from custom_utils import center_component_with_ports
from custom_utils import Boundary_layer, power_rails_placement


def place_cascode(pdk: MappedPDK, true_size: int = 0) -> Component:
    place_cascode = Component()

    # Use of second order primitive
    # We define the parameters of our primitive

    m1 = {'type':'pfet', 'name':'M3_M4', 'width':2.00, 'length':1.00, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'width_route_mult':1, 'lvt':True}
    m2 = {'type':'pfet', 'name':'M5_M6', 'width':2.00, 'length':1.00, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'width_route_mult':1, 'lvt':True}

    array = [[[2,1],[1,2]], [[1,2]]]
    
    casc_dum_down = (len(array[0][0])+2) * 2 + 2*len(array[0])
    casc_dum_up = (len(array[1][0])+2) * 2 + 2*len(array[1])

    print(f'Casc dum up = {casc_dum_up}')
    print(f'Casc dum down = {casc_dum_down}')

    devices_info = [m1,m2]

    # We call the cascode primitive 
    Cascode_call = Cascode(pdk,devices_info,array, 0, true_size) #No pin, yes true size

    
    Cascode_component = place_cascode << Cascode_call

    place_cascode.add_ports(Cascode_component.get_ports_list(),prefix='CASC_')

    #component = Component()
    #component << place_cascode

    place_cascode_centered = center_component_with_ports(pdk, place_cascode)
    component = Component()
    component << place_cascode_centered

    filtrar_puertos(place_cascode_centered, component, 'CASC_VREF_', 'VREF_') #Source voltage from current mirror P 
    filtrar_puertos(place_cascode_centered, component, 'CASC_VIP_', 'VIP_') #Drain voltage from current mirror P (Left Transistor)
    filtrar_puertos(place_cascode_centered, component, 'CASC_VIN_', 'VIN_') #Drain voltage from current mirror P (Right Transistor)
    filtrar_puertos(place_cascode_centered, component, 'CASC_VB1_', 'VB1_') #Gate voltage from active load P
    filtrar_puertos(place_cascode_centered, component, 'CASC_VB2_', 'VB2_') #Gate voltage from current mirror P 
    filtrar_puertos(place_cascode_centered, component, 'CASC_VD1_', 'VD1_') #Drain voltage from active load P (Left Transistor)
    filtrar_puertos(place_cascode_centered, component, 'CASC_VOUT_', 'VOUT_') #Drain voltage from active load P (Right Transistor)
    if true_size == 1:
        filtrar_puertos(place_cascode_centered, component, 'CASC_VS1_T_Hor_', 'VS1_T_Hor_')     #Source voltage from current mirror (Left Transistor)
        filtrar_puertos(place_cascode_centered, component, 'CASC_VS2_T_Hor_', 'VS2_T_Hor_')     #Source voltage from current mirror (Right Transistor)
        #vertical
        filtrar_puertos(place_cascode_centered, component, 'CASC_VS1_T_Ver_R_', 'VS1_T_Ver_R_')     #Source voltage from current mirror (Left Transistor)
        filtrar_puertos(place_cascode_centered, component, 'CASC_VS1_T_Ver_L_', 'VS1_T_Ver_L_')     #Source voltage from current mirror (Left Transistor)
        filtrar_puertos(place_cascode_centered, component, 'CASC_VS2_T_Ver_R_', 'VS2_T_Ver_R_')     #Source voltage from current mirror (Right Transistor)
        filtrar_puertos(place_cascode_centered, component, 'CASC_VS2_T_Ver_L_', 'VS2_T_Ver_L_')     #Source voltage from current mirror (Right Transistor)
    return component

def place_bi_current(pdk: MappedPDK, true_size: int = 0) -> Component:
    place_bi_current = Component()

    # Use of second order primitive
    
    m1 = {'type':'nfet', 'name':'M9_M10', 'width':2.00, 'length':2.00, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'width_route_mult':1, 'lvt':False}
    m2 = {'type':'nfet', 'name':'M7_M8', 'width':2.00, 'length':2.00, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'width_route_mult':1, 'lvt':False}
    #m1 son los que van a vss
    array = array = [[[1,2],[2,1]],
                     [[1,2],[2,1]]
                      ]

    bi_cur_dum_down = (len(array[0][0])+2) * 2 + 2*len(array[0])
    bi_cur_dum_up = (len(array[1][0])+2) * 2 + 2*len(array[1])

    print(f'bi_cur_dum_up = {bi_cur_dum_up}')
    print(f'bi_cur_dum_down = {bi_cur_dum_down}')


    devices_info = [m1,m2]

    # We call the Bi_current primitive 
    Bi_current_call, size_cs1, size_cs2 = Bi_current_source(pdk,devices_info,array, 0, 1)

    Bi_current_component = place_bi_current << Bi_current_call

    place_bi_current.add_ports(Bi_current_component.get_ports_list(),prefix='BIC_')

    #component = Component()
    #component << place_bi_current

    place_bi_current_centered = center_component_with_ports(pdk, place_bi_current)
    component = Component()
    component << place_bi_current_centered

    filtrar_puertos(place_bi_current_centered, component, 'BIC_VOUT_', 'VOUT_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VD1_', 'VD1_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VB2_', 'VB2_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VB2R_', 'VB2R_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VCS1_D1_', 'CS1_VD1_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VB3_', 'VB3_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VREF_', 'VREF_')
    filtrar_puertos(place_bi_current_centered, component, 'BIC_VCOMM_', 'VCOMM_')
    if true_size == 1:
        filtrar_puertos(place_bi_current_centered, component, 'BIC_VS1_T_Hor_', 'VS1_T_Hor_')
        filtrar_puertos(place_bi_current_centered, component, 'BIC_VS2_T_Hor_', 'VS2_T_Hor_')
        #vertical
        filtrar_puertos(place_bi_current_centered, component, 'BIC_VS1_T_Ver_R_', 'VS1_T_Ver_R_')
        filtrar_puertos(place_bi_current_centered, component, 'BIC_VS1_T_Ver_L_', 'VS1_T_Ver_L_')
        filtrar_puertos(place_bi_current_centered, component, 'BIC_VS2_T_Ver_R_', 'VS2_T_Ver_R_')
        filtrar_puertos(place_bi_current_centered, component, 'BIC_VS2_T_Ver_L_', 'VS2_T_Ver_L_')
    return component, size_cs1, size_cs2

def place_par_bias(pdk: MappedPDK, true_size: int = 0) -> Component:
    place_par_bias = Component()

    # Use of second order primitive

    m1 = {'type':'nfet', 'name':'M1_M2', 'width':2.00, 'length':4.00, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'width_route_mult':1, 'lvt':False}
    m2 = {'type':'nfet', 'name':'M11', 'width':2.00, 'length':2.00, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'width_route_mult':1, 'lvt':False}

    #Par bias
    array = [[
   	         [1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1],
             [2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2],
             [1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2,1]
             ]
            ,[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
              ]] #

    par = (len(array[0][0])+2) * 2 + 2*len(array[0])
    bias = (len(array[1][0])+2) * 2 + 2*len(array[1])

    print(f'Par = {par}')
    print(f'Bias = {bias}')

    devices_info = [m1,m2]

    # We call the Bi_current primitive 
    Par_bias_call, size_P1, size_T1 = Pair_bias(pdk,devices_info,array, 0, true_size)

    Par_bias_component = place_par_bias << Par_bias_call

    place_par_bias.add_ports(Par_bias_component.get_ports_list(),prefix='PBI_')

    #routing bulks
    if size_P1[0]<=size_T1[0]:
        pos_der = (place_par_bias.ports['PBI_P_VBC_D_N'].center[0]-place_par_bias.ports['PBI_P_VBC_D_W'].center[0])/2
        pos_iz = (place_par_bias.ports['PBI_P_VBC_D_N'].center[0]-place_par_bias.ports['PBI_P_VBC_D_E'].center[0])/2
    else:
        pos_der = (place_par_bias.ports['PBI_T_VBC_D_N'].center[0]-place_par_bias.ports['PBI_T_VBC_D_W'].center[0])/2
        pos_iz = (place_par_bias.ports['PBI_T_VBC_D_N'].center[0]-place_par_bias.ports['PBI_T_VBC_D_E'].center[0])/2
    via_ref = via_array(pdk, 'met2', 'met3', (pos_der/2, 0.5))

    bulk_par_1 = place_par_bias << via_ref
    bulk_par_1.movex(pos_der).movey(place_par_bias.ports['PBI_P_VBC_D_E'].center[1])

    bulk_par_2 = place_par_bias << via_ref
    bulk_par_2.movex(pos_iz).movey(place_par_bias.ports['PBI_P_VBC_D_E'].center[1])

    bulk_tail_1 = place_par_bias << via_ref
    bulk_tail_1.movex(pos_der).movey(place_par_bias.ports['PBI_T_VBC_U_E'].center[1])

    bulk_tail_2 = place_par_bias << via_ref
    bulk_tail_2.movex(pos_iz).movey(place_par_bias.ports['PBI_T_VBC_U_E'].center[1])

    place_par_bias << straight_route(pdk, bulk_par_1.ports['top_met_N'], bulk_tail_1.ports['top_met_S'])
    place_par_bias << straight_route(pdk, bulk_par_2.ports['top_met_N'], bulk_tail_2.ports['top_met_S'])

    #component = Component()
    #component << place_par_bias

    place_par_bias_centered = center_component_with_ports(pdk, place_par_bias)
    component = Component()
    component << place_par_bias_centered

    filtrar_puertos(place_par_bias_centered, component, 'PBI_VGP_', 'VGP_')
    filtrar_puertos(place_par_bias_centered, component, 'PBI_VGN_', 'VGN_')
    filtrar_puertos(place_par_bias_centered, component, 'PBI_VDP_', 'VDP_')
    filtrar_puertos(place_par_bias_centered, component, 'PBI_VDN_', 'VDN_')
    filtrar_puertos(place_par_bias_centered, component, 'PBI_VBIAS_', 'VBIAS_')
    filtrar_puertos(place_par_bias_centered, component, 'PBI_VREF_', 'VREF_')
    if true_size:
        filtrar_puertos(place_par_bias_centered, component, 'PBI_T_VS_T_Ver_L_', 'T_VS_T_Ver_L_')
        filtrar_puertos(place_par_bias_centered, component, 'PBI_T_VS_T_Ver_R_', 'T_VS_T_Ver_R_')

    return component, devices_info

def OTA_Core(pdk: MappedPDK) -> Component:
    OTA_core = Component()

    BI1, size_c1, size_c2 = place_bi_current(pdk, 1)
    CAS1= place_cascode(pdk, 1)
    PB1, type_par = place_par_bias(pdk, 1)

    TOP_BI1 = OTA_core << BI1
    TOP_CAS1 = OTA_core << CAS1
    TOP_PB1 = OTA_core << PB1
    
    size_BI1 = evaluate_bbox(TOP_BI1)
    size_CAS1 = evaluate_bbox(TOP_CAS1)
    size_PB1 = evaluate_bbox(TOP_PB1)

    print(size_BI1)
    print(size_CAS1)

    max_size_y = pdk.snap_to_2xgrid((size_BI1[1] + size_CAS1[1])/2)
    if size_CAS1[0]>size_BI1[0]:
        max_size_x = pdk.snap_to_2xgrid((size_CAS1[0] + size_PB1[0])/2)
    else:
        max_size_x = pdk.snap_to_2xgrid((size_BI1[0] + size_PB1[0])/2)
    mov_par_tail = pdk.snap_to_2xgrid(((size_PB1[1] - size_BI1[1])/2)-0.01)

    if type_par[0]['type']=='nfet':
    
        TOP_CAS1.movey(max_size_y +pdk.get_grule('met3')['min_separation'])
        TOP_PB1.movey(mov_par_tail)
        TOP_PB1.movex(-(max_size_x+2*pdk.get_grule('met3')['min_separation']))

        OTA_core.add_ports(TOP_BI1.get_ports_list(),prefix='BI_')
        OTA_core.add_ports(TOP_CAS1.get_ports_list(),prefix='CAS_')
        OTA_core.add_ports(TOP_PB1.get_ports_list(),prefix='PB_')
        
        #Routing
        Route_VDS1 = OTA_core << c_route(pdk, TOP_BI1.ports['VD1_W'], TOP_CAS1.ports['VD1_W'])
        Route_VDS2 = OTA_core << c_route(pdk, TOP_BI1.ports['VOUT_E'], TOP_CAS1.ports['VOUT_E'])

        Route_CN = OTA_core << L_route(pdk, TOP_PB1.ports['VDN_S'], TOP_CAS1.ports['VIN_W'])
        Route_CP = OTA_core << L_route(pdk, TOP_PB1.ports['VDP_S'], TOP_CAS1.ports['VIP_W'])
        lower_position = max(
                            abs(TOP_PB1.ports['VBIAS_S'].center[1]),
                            abs(TOP_BI1.ports['VB2_S'].center[1])
                            )
        size_component = -1*OTA_core.bbox[0][1]
        extension_bias = pdk.get_grule('met2')['min_separation'] + (size_component - lower_position)
        Route_Bias = OTA_core << c_route(pdk, TOP_PB1.ports['VBIAS_S'],TOP_BI1.ports['VB2_S'], cglayer='met2', extension=extension_bias)
        Route_VSS = OTA_core << c_route(pdk, TOP_PB1.ports['VREF_S'], TOP_BI1.ports['VREF_S'], cglayer='met2', extension=0.5 + 2*pdk.get_grule('met2')['min_separation'])
        #OTA_core.add_ports(Route_VSS.get_ports_list(), prefix='Ruta_')

    else:
        TOP_PB1.mirror((1,0))
        TOP_CAS1.movey(max_size_y +pdk.get_grule('met3')['min_separation'])
        TOP_PB1.movey((max_size_y +pdk.get_grule('met3')['min_separation'])-(pdk.snap_to_2xgrid((size_PB1[1] - size_CAS1[1])/2))+0.01)
        TOP_PB1.movex(-(max_size_x+2*pdk.get_grule('met3')['min_separation']))

        OTA_core.add_ports(TOP_BI1.get_ports_list(),prefix='BI_')
        OTA_core.add_ports(TOP_CAS1.get_ports_list(),prefix='CAS_')
        OTA_core.add_ports(TOP_PB1.get_ports_list(),prefix='PB_')

        #Routing
        Route_VDS1 = OTA_core << c_route(pdk, TOP_BI1.ports['VD1_W'], TOP_CAS1.ports['VD1_W'])
        Route_VDS2 = OTA_core << c_route(pdk, TOP_BI1.ports['VOUT_E'], TOP_CAS1.ports['VOUT_E'])

        Route_D1Par_D1M9 = OTA_core << L_route(pdk, TOP_PB1.ports['VDN_N'], TOP_BI1.ports['CS1_VD1__E'])
        Route_D2Par_D2M10 = OTA_core << L_route(pdk, TOP_PB1.ports['VDP_N'], TOP_BI1.ports['VCOMM_E'])
        #Route_Bias = OTA_core << c_route(pdk, TOP_PB1.ports['VBIAS_S'],TOP_BI1.ports['VB2_S'], extension=2*pdk.get_grule('met4')['min_separation'])
        Route_VDD = OTA_core << c_route(pdk, TOP_PB1.ports['VREF_S'], TOP_CAS1.ports['VREF_S'], extension=3*pdk.get_grule('met3')['min_separation'])
        OTA_core.add_ports(Route_VDD.get_ports_list(), prefix='Ruta_')
    #component = Component()
    #component << OTA_core

    # Centered
    OTA_core_centered = center_component_with_ports(pdk, OTA_core)

    boundary_dim = evaluate_bbox(OTA_core_centered)

    save_ports_component =  Component()

    #Input/Output port 
    min_separation_met3 = pdk.get_grule('met3')['min_separation']
    rectangle_ref = rectangle((0.5,0.5), layer=pdk.get_glayer('met2'), centered=True)
    aux_via_ref = via_stack(pdk, 'met2', 'met3')

    size_output = evaluate_bbox(rectangle_ref)
    size_aux = evaluate_bbox(aux_via_ref)
    if size_c1[0] + min_separation_met3 > size_c2[0]:
        size_aux1 = (size_c1[0]-size_c2[0])/2
    else:
        size_aux1 = 0
    if size_BI1[0] + min_separation_met3 > size_CAS1[0]:
        size_axu2 = (size_BI1[0]-size_CAS1[0])/2
    else:
        size_axu2 = 0
    
    VbiasP2 = OTA_core_centered << rectangle_ref
    pos_movey = -boundary_dim[1]/2 - 3*pdk.get_grule('met2')['min_separation'] - 5*evaluate_bbox(rectangle_ref)[0]/2
    VbiasP2.movey(pdk.snap_to_2xgrid(pos_movey))
    VbiasP2.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    ##aux rect
    via_axu_biasP2 = OTA_core_centered << aux_via_ref
    via_axu_biasP2.movey(OTA_core_centered.ports['CAS_VB1_E'].center[1])
    via_axu_biasP2.movex(evaluate_bbox(OTA_core_centered)[0]/2 + size_aux[0]*3/2 + 2*min_separation_met3)
    OTA_core_centered << straight_route(pdk, OTA_core_centered.ports['CAS_VB1_E'], via_axu_biasP2.ports['bottom_met_E'])
    OTA_core_centered << L_route(pdk, via_axu_biasP2.ports['top_met_N'], VbiasP2.ports['e3'])
    #OTA_core_centered << c_route(pdk, OTA_core_centered.ports['CAS_VB1_E'], VbiasP2.ports['e3'], extension=size_axu2+3*size_aux[0]+2*pdk.get_grule('met3')['min_separation'])
    save_ports_component.add_ports(VbiasP2.get_ports_list(), prefix='VbiasP2_')

    VbiasN2 = OTA_core_centered << rectangle_ref
    pos_movey = -boundary_dim[1]/2 - 2*pdk.get_grule('met2')['min_separation'] - 3*evaluate_bbox(rectangle_ref)[0]/2
    VbiasN2.movey(pdk.snap_to_2xgrid(pos_movey))
    VbiasN2.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    OTA_core_centered << c_route(pdk, OTA_core_centered.ports['BI_VB3_E'], VbiasN2.ports['e3'], extension=size_aux1+pdk.get_grule('met3')['min_separation'])
    save_ports_component.add_ports(VbiasN2.get_ports_list(), prefix='VbiasN2_')

    VbiasN1 = OTA_core_centered << rectangle_ref
    VbiasN1.movey(pdk.snap_to_2xgrid(OTA_core_centered.ports['PB_VBIAS_W'].center[1]))
    VbiasN1.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    OTA_core_centered << straight_route(pdk, OTA_core_centered.ports['PB_VBIAS_E'], VbiasN1.ports['e1'])
    save_ports_component.add_ports(VbiasN1.get_ports_list(), prefix='VbiasN1_')

    V_neg = OTA_core_centered << rectangle_ref
    pos_movey = OTA_core_centered.ports['PB_VDN_E'].center[1] + pdk.get_grule('met2')['min_separation'] + size_output[1]
    V_neg.movey(pdk.snap_to_2xgrid(pos_movey))
    V_neg.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    OTA_core_centered << L_route(pdk, OTA_core_centered.ports['PB_VGN_S'], V_neg.ports['e1'])
    save_ports_component.add_ports(V_neg.get_ports_list(), prefix='V_neg_')

    V_comn = OTA_core_centered << rectangle_ref
    V_comn.movey(pdk.snap_to_2xgrid(OTA_core_centered.ports['BI_VCOMM_W'].center[1]))
    V_comn.movex((pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    OTA_core_centered << straight_route(pdk, OTA_core_centered.ports['BI_VCOMM_W'], V_comn.ports['e3'])
    save_ports_component.add_ports(V_comn.get_ports_list(), prefix='V_comn_')

    V_out = OTA_core_centered << rectangle_ref
    V_out.movey(pdk.snap_to_2xgrid(OTA_core_centered.ports['CAS_VOUT_W'].center[1]))
    V_out.movex((pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    OTA_core_centered << straight_route(pdk, OTA_core_centered.ports['CAS_VOUT_W'], V_out.ports['e3'])
    save_ports_component.add_ports(V_out.get_ports_list(), prefix='V_out_')

    rename_ports_by_orientation(save_ports_component)
    OTA_core_centered.add_ports(save_ports_component.ports)
    #Centered and boundary
    OTA_core_centered = center_component_with_ports(pdk, OTA_core_centered)

    boundary = Boundary_layer(pdk, OTA_core_centered)
    
    #Rails

    route_list=[['PB_T_VS_T_Ver_L_', 'VSS'], ['PB_T_VS_T_Ver_R_', 'VSS'], ['BI_VS1_T_Ver_L_', 'VSS'], ['BI_VS1_T_Ver_R_', 'VSS'],  ['BI_VS2_T_Ver_L_', 'VSS'], ['BI_VS2_T_Ver_R_', 'VSS'],
                 ['CAS_VS1_T_Ver_L_', 'VDD'], ['CAS_VS1_T_Ver_R_', 'VDD'], ['CAS_VS2_T_Ver_L_', 'VDD'], ['CAS_VS2_T_Ver_R_', 'VDD']]
    
    power_rails_placement(pdk=pdk, 
                          component=OTA_core_centered, 
                          width=1, 
                         alignment=0, 
                          route_list=route_list)
    
    route_list = []
    ports_VDD = [name for name in OTA_core_centered.ports if 'VDD' in name and 'W' in name]
    ports_VSS = [name for name in OTA_core_centered.ports if 'VSS' in name and 'W' in name]
    for i in range(len(ports_VDD)):
        route = []
        route.append(ports_VDD[i][0:-1])
        route.append('VDD')
        route_list.append(route)
    
    for i in range(len(ports_VSS)):
        route = []
        route.append(ports_VSS[i][0:-1])
        route.append('VSS')
        route_list.append(route)
    
    power_rails_placement(pdk = pdk,
                          component = OTA_core_centered,
                          width = 1,
                          alignment = 1,    #0 vertical
                          route_list = route_list,
                          label = False,
                          ports = False)

    #Save ports
    component = Component()
    component << OTA_core_centered

    filtrar_puertos(OTA_core_centered, component, 'PB_VGP_', 'P_V+_', True)
    filtrar_puertos(OTA_core_centered, component, 'V_neg_', 'P_V-_', True)
    filtrar_puertos(OTA_core_centered, component, 'VbiasN1_', 'P_VbiasN1_', True) #
    filtrar_puertos(OTA_core_centered, component, 'V_out_', 'P_Vout_', True)
    #filtrar_puertos(OTA_core_centered, component, 'CAS_VB2_', 'P_VbiasP1_', True) #
    filtrar_puertos(OTA_core_centered, component, 'VbiasP2_', 'P_VbiasP2_', True) #
    filtrar_puertos(OTA_core_centered, component, 'VbiasN2_', 'P_VbiasN2_', True)  # 
    filtrar_puertos(OTA_core_centered, component, 'V_comn_', 'P_Vcomn_', True)
    for route in route_list:
        filtrar_puertos(OTA_core_centered, component, route[0])

    pin_label_creation(pdk, 'P_V+','V+','met2',component)
    pin_label_creation(pdk, 'P_V-','V-','met2',component)
    pin_label_creation(pdk, 'P_VbiasN1','VbiasN1','met2',component)
    pin_label_creation(pdk, 'P_Vout','Vout','met2',component)
    #pin_label_creation(pdk, 'P_VbiasP1','VbiasP1','met2',component, True)
    pin_label_creation(pdk, 'P_VbiasP2','VbiasP2','met2',component)
    pin_label_creation(pdk, 'P_VbiasN2','VbiasN2','met2',component)
    pin_label_creation(pdk, 'P_Vcomn', 'Vcomn', 'met2',component)

    return component_snap_to_grid(component), route_list

def generator_core():
    Test, route_list = OTA_Core(gf180)
    Test.name = "error_amplifier_N_input_core"
    Test.write_gds("error_amplifier_N_input_core_pcells.gds")
    Test.show()
    #ports_name = [name for name in Test.ports if '_' not in name]
    #print(ports_name)
    return Test, route_list

if __name__ == "__main__":
    # If called directly call main function
    generator_core()
