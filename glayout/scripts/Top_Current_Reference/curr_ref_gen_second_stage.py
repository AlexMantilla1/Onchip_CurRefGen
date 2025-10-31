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
from folded_cascode_core_blocks import (diode, transistor, moscap)
from custom_utils import filtrar_puertos, pin_label_creation, interdigitado_placement_Onchip, macro_two_transistor_placement_Onchip 
from custom_utils import center_component_with_ports
from custom_utils import Boundary_layer, power_rails_placement

#### Current reference circuit ###

def current_reference(pdk, devices_info, matriz_ref, matriz_p, matriz_n, p_mirrors, n_mirrors, MC_array, moscaps) -> Component:
    
    current_reference = Component()
    #T1 = transistor(pdk, devices_info[0], matriz_ref, with_b_effect=1)
    T1 = macro_two_transistor_placement_Onchip(pdk=pdk, deviceA_and_B=devices_info[0]['type'], with_substrate_tap=devices_info[0]['with_substrate_tap'],
                                                              with_tie=devices_info[0]['with_tie'], width1=devices_info[0]['width'], length1=devices_info[0]['length'],
                                                              fingers1=devices_info[0]['fingers'], matriz=matriz_ref, with_dummy=devices_info[0]['with_dummy'],
                                                              width_route_mult=devices_info[0]['width_route_mult'], with_lvt_layer=devices_info[0]['lvt'], full_output_size = True)

    #T2 = transistor(pdk, devices_info[1], matriz_p, with_b_effect=1)
    T2 = macro_two_transistor_placement_Onchip(pdk=pdk, deviceA_and_B=devices_info[1]['type'], with_substrate_tap=devices_info[1]['with_substrate_tap'],
                                                              with_tie=devices_info[1]['with_tie'], width1=devices_info[1]['width'], length1=devices_info[1]['length'],
                                                              fingers1=devices_info[1]['fingers'], matriz=matriz_p, with_dummy=devices_info[1]['with_dummy'],
                                                              width_route_mult=devices_info[1]['width_route_mult'], with_lvt_layer=devices_info[1]['lvt'], full_output_size = True)

    #T5 = transistor(pdk, devices_info[2], matriz_n, with_b_effect=1)
    T5 = macro_two_transistor_placement_Onchip(pdk=pdk, deviceA_and_B=devices_info[2]['type'], with_substrate_tap=devices_info[2]['with_substrate_tap'],
                                                              with_tie=devices_info[2]['with_tie'], width1=devices_info[2]['width'], length1=devices_info[2]['length'],
                                                              fingers1=devices_info[2]['fingers'], matriz=matriz_n, with_dummy=devices_info[2]['with_dummy'],
                                                              width_route_mult=devices_info[2]['width_route_mult'], with_lvt_layer=devices_info[2]['lvt'], full_output_size = True)
    
    MC = moscap(gf180, devices_info[3], MC_array)

    print('Transistores de referencia creados')

    Tref = current_reference << T1
    Pref = current_reference << T2
    Nref = current_reference << T5
    Tmoscap = current_reference << MC
    
    size_Tref = evaluate_bbox(Tref)
    size_Pref = evaluate_bbox(Pref)
    size_Nref = evaluate_bbox(Nref)
    size_Tmoscap = evaluate_bbox(Tmoscap)

    # Width configuration
    width_route = devices_info[0]['width_route_mult']
    if width_route == None or width_route == 0:
        separation_interdigitado = 0
        width_horizontal = evaluate_bbox(via_stack(pdk,'met2','met3'))[1]
    else:
        separation_interdigitado = width_route
        width_horizontal = width_route

    size_via = evaluate_bbox(via_stack(pdk, 'met3', 'met4'))
    

    pmove_x = pdk.snap_to_2xgrid(pdk.get_grule('met4')['min_separation'] + (size_Tref[0] + size_Pref[0])/2)
    nmove_x = pdk.snap_to_2xgrid((size_Nref[0] - size_Tref[0])/2)
    moscapmovex = pdk.snap_to_2xgrid((size_Tmoscap[0]-size_Tref[0])/2)

    #pmove_y = pdk.snap_to_2xgrid(pdk.get_grule('met4')['min_separation']/2 + size_Pref[1]/2)
    if size_Tref[1]>= size_Pref[1]:
        nmove_y = pdk.snap_to_2xgrid(3*pdk.get_grule('met4')['min_separation'] + 2*evaluate_bbox(via_stack(pdk,'met2','met3'))[1] + (size_Tref[1] + size_Nref[1])/2)
        moscapmovey = pdk.snap_to_2xgrid(4*pdk.get_grule('met4')['min_separation'] + + 2*evaluate_bbox(via_stack(pdk,'met2','met3'))[1] + size_Tref[1]/2 + size_Nref[1] + size_Tmoscap[1]/2)
    else:
        nmove_y = pdk.snap_to_2xgrid(3*pdk.get_grule('met4')['min_separation'] + 2*evaluate_bbox(via_stack(pdk,'met2','met3'))[1] + (size_Pref[1] + size_Nref[1])/2)
        moscapmovey = pdk.snap_to_2xgrid(4*pdk.get_grule('met4')['min_separation'] + 2*evaluate_bbox(via_stack(pdk,'met2','met3'))[1] + size_Pref[1]/2 + size_Nref[1] + size_Tmoscap[1]/2)

    type_transistor_p = 0
    for transistor in matriz_p[0]:
        if transistor==1:
            type_transistor_p+=1
    
    Pref.movex(pmove_x)
    Nref.mirror((1,0))
    Nref.movex(nmove_x).movey(-nmove_y)
    Tmoscap.movex(moscapmovex).movey(-moscapmovey)

    '''type_transistor_n = 0
    for transistor in matriz_n[0]:
        if transistor==1:
            type_transistor_n+=1'''

    #Conexiones del transistor Tref consigo mismo
    extensionTref = abs(Tref.ports['B_source_S'].center[1]-Tref.ports['A_gate_S'].center[1]) + pdk.get_grule('met2')['min_separation']
    rutagrefAgrefB = current_reference << c_route(pdk, Tref.ports['A_gate_S'], Tref.ports['B_gate_S'] ,extension=extensionTref, cglayer='met2')
    rutadrefAsrefB = current_reference << L_route(pdk, Tref.ports['A_drain_W'], Tref.ports['B_source_S'])
    rutabrefsref = current_reference << straight_route(pdk, Tref.ports['bulk_down_N'], Tref.ports['A_source_S'])

    #Conexiones del transistor Pref consigo mismo
    extensionPref = abs(Pref.ports['B_source_S'].center[1]-Pref.ports['A_gate_S'].center[1]) + pdk.get_grule('met2')['min_separation']
    rutagpAgpB = current_reference << c_route(pdk, Pref.ports['A_gate_S'], Pref.ports['B_gate_S'], extension=extensionPref, cglayer='met2')
    rutadpAspB = current_reference << L_route(pdk, Pref.ports['A_drain_W'], Pref.ports['B_source_S'])
    rutaprefsref = current_reference << straight_route(pdk, Pref.ports['bulk_down_N'], Pref.ports['A_source_S'])

    #Conexiones del transistor Nref consigo mismo
    extensionNref = abs(Nref.ports['B_source_S'].center[1]-Nref.ports['A_gate_S'].center[1]) + pdk.get_grule('met2')['min_separation']
    rutagnAgnB = current_reference << c_route(pdk, Nref.ports['A_gate_S'], Nref.ports['B_gate_S'], extension=extensionNref, cglayer='met2')
    rutasnBdnA = current_reference << L_route(pdk, Nref.ports['B_source_N'], Nref.ports['A_drain_W'])
    rutadnBgnB = current_reference << L_route(pdk, Nref.ports['B_drain_W'], Nref.ports['A_gate_N'])
    rutanrefsref = current_reference << straight_route(pdk, Nref.ports['bulk_down_N'], Nref.ports['A_source_S'])

    #Ports para conexión dp_gn
    #input port
    via_dp = via_stack(pdk, 'met2', 'met3')
    V_dp = current_reference << via_dp
    align_comp_to_port(V_dp, Pref.ports['B_drain_N'])
    size_via = evaluate_bbox(via_stack(pdk, 'met2', 'met3'))
    if size_Tref[1]<=size_Pref[1]:
        min_separation = pdk.get_grule('met3')['min_separation']
    else:
        min_separation = pdk.get_grule('met3')['min_separation'] + (size_Tref[1]-size_Pref[1])/2
    V_dp.movey(pdk.snap_to_2xgrid(min_separation))

    via_gn = via_stack(pdk, 'met2', 'met3')
    V_gn = current_reference << via_gn
    align_comp_to_port(V_gn, Nref.ports['A_gate_W'])
    size_via = evaluate_bbox(via_stack(pdk, 'met2', 'met3'))
    min_separation = pdk.get_grule('met3')['min_separation']
    V_gn.movex(pdk.snap_to_2xgrid(-min_separation))
    
    #Conexiones de los transistores referencia
    if size_Tref==size_Pref:
        ruta_gref_gp = current_reference << straight_route(pdk, Tref.ports['B_gate_W'], Pref.ports['A_gate_E'])
    else:
        ruta_gref_gp = current_reference << c_route(pdk, Tref.ports['B_gate_N'], Pref.ports['A_gate_N'], cglayer='met2')
    #ruta_sref_sp = current_reference << straight_route(pdk, Tref.ports['A_source_W'], Pref.ports['A_source_E'])
    ruta_viadp_dp = current_reference << straight_route(pdk, V_dp.ports['bottom_met_N'], Pref.ports['B_drain_S'])
    ruta_viagn_gn = current_reference << straight_route(pdk, V_gn.ports['top_met_W'], Nref.ports['A_gate_E'])
    ruta_dp_gn = current_reference << L_route(pdk, V_dp.ports['bottom_met_E'], V_gn.ports['bottom_met_N'], vglayer='met3')
    ruta_moscap_Tref = current_reference << c_route(pdk, Tref.ports['B_drain_W'], Tmoscap.ports['VG_W'], extension=pdk.snap_to_2xgrid(0.7))

    current_reference.add_ports(V_dp.ports, prefix = 'Vdp_')
    current_reference.add_ports(V_gn.ports, prefix = 'Vgn_')
    current_reference.add_ports(Tref.ports, prefix = 'Tref_')
    current_reference.add_ports(Pref.ports, prefix = 'Pref_')
    current_reference.add_ports(Nref.ports, prefix = 'Nref_')
    current_reference.add_ports(Tmoscap.ports, prefix = 'Tmoscap_')
    
    matrizn_currents_out = list()
    matrizp_currents_out = list()
    multipliers_total_n = len(matriz_n[0])
    multipliers_total_p = len(matriz_p[0])*2
    
    for multiplier in p_mirrors:
        result = []
        for row in matriz_p:
            new_row = row * multiplier  # repite la fila n veces
            result.append(new_row)
        matrizp_currents_out.append(result)
        print(result)
    for multiplier in n_mirrors:
        result = []
        for row in matriz_n:
            new_row = row * multiplier
            result.append(new_row)
        matrizn_currents_out.append(result)
        print(result)

    p_outs = list()
    n_outs = list()
    
    compensacion = list()
    
    if devices_info[0]['with_dummy']:
        multipliers_total_p += 4+2*len(p_mirrors)
        multipliers_total_n += 2+2*len(n_mirrors)
        row_compensacion_n = len(matriz_n)+2
        row_compensacion_p = len(matriz_p)+2
    else:
        row_compensacion_n = len(matriz_n)
        row_compensacion_p = len(matriz_p)
    
    for multiplier in p_mirrors:
        multipliers_total_p += len(matriz_p[0])*multiplier
    for multiplier in n_mirrors:
        multipliers_total_n += len(matriz_n[0])*multiplier
    
    print('Multiplicadores P:', multipliers_total_p)
    print('Multiplicadores N:', multipliers_total_n)
    
    if moscaps:
        if multipliers_total_p != multipliers_total_n:
            diferencia = multipliers_total_p - multipliers_total_n
            mag_diferencia =  abs(diferencia)
            exp = [1] * (mag_diferencia) 
            if diferencia > 0 and mag_diferencia != 0:
                if len(p_mirrors)>len(n_mirrors):
                    exp = [1] * (mag_diferencia+(len(p_mirrors)-len(n_mirrors)))
                for i in range(row_compensacion_n):
                    compensacion.append(exp)
                down = True
                up = False
                print('Se agregaran moscap N')
            elif diferencia < 0 and mag_diferencia != 0:
                if len(n_mirrors)>len(p_mirrors)+2:
                    exp = [1] * (mag_diferencia+((len(n_mirrors)-2)-len(p_mirrors)))  
                for i in range(row_compensacion_p):
                    compensacion.append(exp)
                down = False
                up = True
                print('Se agregaran moscap P')
            else:
                down = False
                up = False
                print('No se agregaran moscap')
        else:
            down = False
            up = False
            print('No se agregaran moscap')
    else:
        down = False
        up = False 
    
    placement_pouts = list()
    placement_nouts = list()
    Current_out_nums=0
    for matrix in matrizp_currents_out:
        #Transistor P
        p_outs.append(macro_two_transistor_placement_Onchip(pdk=pdk, deviceA_and_B=devices_info[1]['type'], with_substrate_tap=devices_info[1]['with_substrate_tap'],
                                                              with_tie=devices_info[1]['with_tie'], width1=devices_info[1]['width'], length1=devices_info[1]['length'],
                                                              fingers1=devices_info[1]['fingers'], matriz=matrix, with_dummy=devices_info[1]['with_dummy'],
                                                              width_route_mult=devices_info[1]['width_route_mult'], with_lvt_layer=devices_info[1]['lvt'], full_output_size = True))
        placement_pouts.append(current_reference << p_outs[-1])
        #Calcular movex segun tamaño
        size_last_pout = evaluate_bbox(placement_pouts[-1])
        #Mover los componentes
        if len(placement_pouts) == 1:
            pmove_x += pdk.get_grule('met4')['min_separation'] + (size_Pref[0] + size_last_pout[0])/2
        else:
            size_pre_last_pout = evaluate_bbox(placement_pouts[-2])
            pmove_x += pdk.get_grule('met4')['min_separation'] + (size_pre_last_pout[0] + size_last_pout[0])/2
    
        if type_transistor_p==len(matriz_p[0]) or type_transistor_p==0:
            placement_pouts[-1].movey(-(pdk.snap_to_2xgrid(0.72)))
        placement_pouts[-1].movex(pmove_x)
        #guardar puertos
        current_reference.add_ports(placement_pouts[-1].get_ports_list(), prefix='pout_'+str(len(placement_pouts)))
        #Rutear drain-source
        ruta_ds_pouts = current_reference << L_route(pdk, placement_pouts[-1].ports['A_drain_E'], placement_pouts[-1].ports['B_source_N'])
        #Rutear bulk-VDD
        ruta_bvs = current_reference << straight_route(pdk, placement_pouts[-1].ports['bulk_down_N'], placement_pouts[-1].ports['A_source_S'])
        #Rutear gates
        if Current_out_nums==0:
            ruta_gates_pouts = current_reference << straight_route(pdk, Pref.ports['B_gate_W'], placement_pouts[-1].ports['A_gate_E'])
        else:
            pass
            ruta_gates_pouts = current_reference << straight_route(pdk, placement_pouts[-1].ports['A_gate_E'], placement_pouts[-2].ports['B_gate_W'])
        
        extensionPout = abs(placement_pouts[-1].ports['B_source_S'].center[1]-placement_pouts[-1].ports['A_gate_S'].center[1]) + pdk.get_grule('met2')['min_separation']
        ruta_gate_common = current_reference << c_route(pdk, placement_pouts[-1].ports['A_gate_S'], placement_pouts[-1].ports['B_gate_S'], extension=extensionPout, cglayer='met2') 
        Current_out_nums +=1
    Current_out_nums = 0
    print('Se realizo el placement de las salidas de corriente P')
    #Rutear sources
    ruta_sources_pouts = current_reference << straight_route(pdk, Pref.ports['A_source_W'], placement_pouts[-1].ports['A_source_E'])
    #rutear bulks
    ruta_bulks_pouts = current_reference << straight_route(pdk, Pref.ports['bulk_up_W'], placement_pouts[-1].ports['bulk_up_E'])

    #Quiero reflejar en x los espejos n para facilitar conectarlos
    for matrix in matrizn_currents_out:
        #Transistor N
        n_outs.append(macro_two_transistor_placement_Onchip(pdk=pdk, deviceA_and_B=devices_info[2]['type'], with_substrate_tap=devices_info[2]['with_substrate_tap'],
                                                              with_tie=devices_info[2]['with_tie'], width1=devices_info[2]['width'], length1=devices_info[2]['length'],
                                                              fingers1=devices_info[2]['fingers'], matriz=matrix, with_dummy=devices_info[2]['with_dummy'],
                                                              width_route_mult=devices_info[2]['width_route_mult'], with_lvt_layer=devices_info[2]['lvt'], full_output_size = True))
        placement_nouts.append(current_reference << n_outs[-1])
        #Calcular movex segun tamaño
        size_last_nout = evaluate_bbox(placement_nouts[-1])
        #Reflejar en x
        placement_nouts[-1].mirror((1,0))
        #Mover los componentes
        if len(placement_nouts) == 1:
            nmove_x += pdk.get_grule('met4')['min_separation'] + (size_Nref[0] + size_last_nout[0])/2
        else:
            size_pre_last_nout = evaluate_bbox(placement_nouts[-2])
            nmove_x += pdk.get_grule('met4')['min_separation'] + (size_pre_last_nout[0] + size_last_nout[0])/2
        placement_nouts[-1].movex(nmove_x)
        placement_nouts[-1].movey(-nmove_y)
        #guardar puertos
        current_reference.add_ports(placement_nouts[-1].get_ports_list(), prefix='nout_'+str(len(placement_nouts)))
        #Rutear drain-source
        ruta_ds_nouts = current_reference << L_route(pdk, placement_nouts[-1].ports['B_source_N'], placement_nouts[-1].ports['A_drain_W'])
        #Rutear bulk-VSS
        ruta_bvs = current_reference << straight_route(pdk, placement_nouts[-1].ports['bulk_down_N'], placement_nouts[-1].ports['A_source_S'])
        #Rutear gates
        if Current_out_nums==0:
            ruta_gates_nouts = current_reference << straight_route(pdk, Nref.ports['B_gate_W'], placement_nouts[-1].ports['A_gate_E'])
        else:
            pass
            ruta_gates_nouts = current_reference << straight_route(pdk, placement_nouts[-1].ports['A_gate_E'], placement_nouts[-2].ports['B_gate_W'])
        
        extensionNout = abs(placement_nouts[-1].ports['B_source_S'].center[1]-placement_nouts[-1].ports['A_gate_S'].center[1]) + pdk.get_grule('met2')['min_separation']
        ruta_gate_common = current_reference << c_route(pdk, placement_nouts[-1].ports['A_gate_S'], placement_nouts[-1].ports['B_gate_S'], extension=extensionNout, cglayer='met2') 

        Current_out_nums +=1
    Current_out_nums=0
    print('Se realizo el placement de las salidas de corriente N')
    #Rutear sources
    ruta_sources_nouts = current_reference << straight_route(pdk, Nref.ports['A_source_W'], placement_nouts[-1].ports['A_source_E'])
    #ruta bulks
    ruta_bulks_nouts = current_reference << straight_route(pdk, Nref.ports['bulk_up_W'], placement_nouts[-1].ports['bulk_up_E'])
    #Placement compensacion
    devices_info[1]['with_dummy'] = False
    devices_info[2]['with_dummy'] = False
    
    if up:
        compensacion_p = moscap(gf180, devices_info[1], compensacion)
        
        placement_compensacion = current_reference << compensacion_p
        size_compensacion_p = evaluate_bbox(compensacion_p)
        #Reflejar en y
        placement_compensacion.mirror((0,1))
        #Calcular movex segun tamaño
        pmove_x += pdk.snap_to_2xgrid(3*pdk.get_grule('met4')['min_separation'] + (size_last_pout[0] + size_compensacion_p[0])/2)
        #Mover los componentes
        #pmove_y = pdk.snap_to_2xgrid(pdk.get_grule('met4')['min_separation']/2 + size_compensacion_p[1]/2)
        placement_compensacion.movex(pmove_x)#.movey(pmove_y)
        '''
        #Ruteo para moscap
        #ruta_d_s_cap = current_reference << straight_route(pdk, placement_compensacion.ports['A_drain_N'], placement_compensacion.ports['A_source_S'])
        #Ruteo bulk
        #ruta_bulk_cap = current_reference << straight_route(pdk, placement_compensacion.ports['bulk_up_S'], placement_compensacion.ports['A_drain_N'], width=0.5)
        #Ruteo VDD
        ruta_vddp = current_reference << L_route(pdk, placement_compensacion.ports['VS_S'], placement_pouts[-1].ports['A_source_W'])
        #Ruteo VSS
        ruta_vssp = current_reference << c_route(pdk, placement_compensacion.ports['VG_W'], placement_nouts[-1].ports['A_source_E'], cglayer='met1')'''
        print('Se realizo el placement de los moscap P')

    if down:
        compensacion_n = moscap(gf180, devices_info[2], compensacion)
        
        placement_compensacion = current_reference << compensacion_n
        size_compensacion_n = evaluate_bbox(compensacion_n)
        #Reflejar en x,y
        placement_compensacion.mirror((1,0))
        placement_compensacion.mirror((0,1))
        #Calcular movex segun tamaño
        nmove_x += pdk.snap_to_2xgrid(3*pdk.get_grule('met4')['min_separation'] + (size_last_nout[0] + size_compensacion_n[0])/2)
        #Mover los componentes
        if size_Tref[1]>= size_Pref[1]:
            nmove_y = pdk.snap_to_2xgrid(3*pdk.get_grule('met4')['min_separation'] + 2*evaluate_bbox(via_stack(pdk,'met2','met3'))[1] + (size_Tref[1] + size_Nref[1])/2)
        else:
            nmove_y = pdk.snap_to_2xgrid(3*pdk.get_grule('met4')['min_separation'] + 2*evaluate_bbox(via_stack(pdk,'met2','met3'))[1] + (size_Pref[1] + size_Nref[1])/2)
        
        placement_compensacion.movex(nmove_x).movey(-nmove_y)
        #Ruteo VSS
        ruta_vssn = current_reference << L_route(pdk, placement_compensacion.ports['VS_S'], placement_nouts[-1].ports['A_source_W'])
        #Ruteo VDD
        ruta_vddn = current_reference << c_route(pdk, placement_compensacion.ports['VG_W'], placement_pouts[-1].ports['A_source_E'], cglayer='met1', extension=1.5)
        print('Se realizo el placement de los moscap N')
    
    #Guardar ports
    #component = Component()
    #component << current_reference
    
    current_reference_centered = center_component_with_ports(pdk, current_reference)
    component = Component()
    component << current_reference_centered

    #boundary = Boundary_layer(component)
    boundary_dim = evaluate_bbox(component)
    #Temporal save port name
    rectangle_ref = rectangle((0.5,0.5), layer=pdk.get_glayer('met2'), centered=True)
    temp = Component()
    #Input port
    V_refp = current_reference_centered << rectangle_ref
    V_refp.movey(pdk.snap_to_2xgrid(current_reference_centered.ports['Tref_A_gate_W'].center[1]))
    V_refp.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    current_reference_centered << straight_route(pdk, current_reference_centered.ports['Tref_A_gate_E'], V_refp.ports['e1'])
    temp.add_ports(V_refp.get_ports_list(), prefix='V_refp_')
    temp = rename_ports_by_orientation(temp)
    current_reference_centered.add_ports(temp.get_ports_list())

    temp = Component()
    V_refn = current_reference_centered << rectangle_ref
    V_refn.movey(pdk.snap_to_2xgrid(current_reference_centered.ports['Vdp_bottom_met_W'].center[1]))
    V_refn.movex((pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    current_reference_centered << straight_route(pdk, current_reference_centered.ports['Vdp_bottom_met_W'], V_refn.ports['e3'])
    temp.add_ports(V_refn.get_ports_list(), prefix='V_refn_')
    temp = rename_ports_by_orientation(temp)
    current_reference_centered.add_ports(temp.get_ports_list())

    temp = Component()
    V_comn = current_reference_centered << rectangle_ref
    V_comn.movey(pdk.snap_to_2xgrid(current_reference_centered.ports['Tmoscap_VS_W'].center[1]))
    V_comn.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    current_reference_centered << straight_route(pdk, current_reference_centered.ports['Tmoscap_VS_E'], V_comn.ports['e1'])
    temp.add_ports(V_comn.get_ports_list(), prefix='V_comn_')
    temp = rename_ports_by_orientation(temp)
    current_reference_centered.add_ports(temp.get_ports_list())

    temp = Component()
    V_res = current_reference_centered << rectangle_ref
    V_res.movey(pdk.snap_to_2xgrid(current_reference_centered.ports['Tmoscap_VG_W'].center[1]))
    #V_res.movey(-(pdk.snap_to_2xgrid(boundary_dim[1]/2-evaluate_bbox(rectangle_ref)[1]/2)))
    V_res.movex(-(pdk.snap_to_2xgrid(boundary_dim[0]/2-evaluate_bbox(rectangle_ref)[0]/2)))
    current_reference_centered << straight_route(pdk, current_reference_centered.ports['Tmoscap_VG_E'], V_comn.ports['e1'])
    temp.add_ports(V_res.get_ports_list(), prefix='V_res_')
    temp = rename_ports_by_orientation(temp)
    current_reference_centered.add_ports(temp.get_ports_list())

    route_list = [['Tref_A_source_T_Ver_R_','VDD'], ['Tref_A_source_T_Ver_L_','VDD'],['Pref_A_source_T_Ver_R_','VDD'], ['Pref_A_source_T_Ver_L_','VDD'],
                  ['Nref_A_source_T_Ver_R_','VSS'], ['Nref_A_source_T_Ver_L_','VSS']]
    
    for i in range(len(placement_pouts)):
        route = []
        route.append('pout_'+str(i+1)+'A_source_T_Ver_R_')
        route.append('VDD')
        route_list.append(route)
        route = []
        route.append('pout_'+str(i+1)+'A_source_T_Ver_L_')
        route.append('VDD')
        route_list.append(route)

    for i in range(len(placement_nouts)):
        route = []
        route.append('nout_'+str(i+1)+'A_source_T_Ver_R_')
        route.append('VSS')
        route_list.append(route)
        route = []
        route.append('nout_'+str(i+1)+'A_source_T_Ver_L_')
        route.append('VSS')
        route_list.append(route)
    
    
    for i in range(len(placement_pouts)):
        #route = []
        #route.append('pout_'+str(i+1)+'B_drain_T_Ver_L_')
        #route.append('Iref'+str(i+1)+'p')
        #route_list.append(route)
        #route = []
        #route.append('pout_'+str(i+1)+'B_drain_T_Ver_R_')
        #route.append('Iref'+str(i+1)+'p')
        #route_list.append(route)
        filtrar_puertos(current_reference_centered, component, 'pout_'+str(i+1)+'B_drain_', 'IREF'+str(i+1)+'p_')

    for i in range(len(placement_nouts)):
        #route = []
        #route.append('nout_'+str(i+1)+'B_drain_T_Ver_L_')
        #route.append('Iref'+str(i+1)+'n')
        #route_list.append(route)
        #route = []
        #route.append('nout_'+str(i+1)+'B_drain_T_Ver_R_')
        #route.append('Iref'+str(i+1)+'n')
        #route_list.append(route)
        filtrar_puertos(current_reference_centered, component, 'nout_'+str(i+1)+'B_drain_', 'IREF'+str(i+1)+'n_')
    
    filtrar_puertos(current_reference_centered, component, 'V_refp_', 'Opamp_output_')
    filtrar_puertos(current_reference_centered, component, 'V_refn_', 'VreferenceN_')
    filtrar_puertos(current_reference_centered, component, 'V_res_', 'Resistor_')
    filtrar_puertos(current_reference_centered, component, 'V_comn_', 'VCOMN_')
    #filtrar_puertos(current_reference_centered, component, 'Tref_A_source_', 'VDD_')
    #filtrar_puertos(Nref, component, 'A_source_', 'VSS_')

    for route in route_list:
        filtrar_puertos(current_reference_centered, component, route[0], signal=True)

    # add the pin and label
    for i in range(len(placement_pouts)):
        pin_label_creation(pdk, 'IREF'+str(i+1)+'p', 'Iref'+str(i+1)+'p', 'met3', component)
    for i in range(len(placement_nouts)):
        pin_label_creation(pdk, 'IREF'+str(i+1)+'n', 'Iref'+str(i+1)+'n', 'met3', component)
    #pin_label_creation(pdk, 'Opamp_output', 'Vrefp', 'met3', component)
    pin_label_creation(pdk, 'VreferenceN', 'Vrefn', 'met2', component)
    pin_label_creation(pdk, 'Resistor', 'Vres', 'met3', component)
    #pin_label_creation(pdk, 'VCOMN', 'Vcomn', 'met3', component)
    #pin_label_creation('VBIASN2', 'VbiasN2', 'met3', component)'''
    return component, route_list

def generator_current_reference():
    # Information of the transistors

    m1 = {'type':'pfet', 'name':'M1', 'width':2, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':True}
    m2 = {'type':'pfet', 'name':'M2', 'width':2, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':True}
    m5 = {'type':'nfet', 'name':'M5', 'width':4, 'length':2, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':True, 'lvt':False}
    MC = {'type':'pfet', 'name':'MC', 'width':5, 'length':5, 'width_route_mult':1, 'fingers':1, 'with_substrate_tap':False, 'with_tie':True, 'with_dummy':False, 'lvt':False}
    devices_info = [m1, m2, m5, MC]
    matriz1 = [[1,2],[2,1]]
    matriz2_p = [[1,2],[2,1]]
    #Por conveniencia de diseño matriz1=matriz2_p para mejorar la distribución de layout
    matriz3_n = [[1,2],[2,1]]
    pmirror = [1,10,25]
    nmirror = [1,10,25]
    MC_array = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]    

    current_outs, rails_route_list = current_reference(gf180, devices_info, matriz1, matriz2_p, matriz3_n, pmirror, nmirror, MC_array, moscaps=True)
    # Display the current mirror layout at Klayout:
    #current_reference.name = "current_reference"
    #current_reference.write_gds("current_reference_pcells.gds")
    current_outs.show()
    #puertos_salidas_pout = [name for name in Test.ports if 'Iref' in name and 'p_']
    #puertos_salidas_nout = [name for name in Test.ports if 'Iref' in name and 'n_']
    #puertos_faltantes = [name for name in Test.ports if 'Opamp' in name or 'Resistor' in name or 'VDD' in name or 'VSS' in name]
    #print('Puertos de salida P:', puertos_salidas_pout)
    #print('Puertos de salida N:', puertos_salidas_nout)
    #print('Puertos faltantes:', puertos_faltantes)
    return current_outs, rails_route_list

if __name__ == "__main__":
    # If called directly call main function
    generator_current_reference()
