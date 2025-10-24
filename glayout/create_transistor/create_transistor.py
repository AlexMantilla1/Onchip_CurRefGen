from glayout import MappedPDK, gf180
from glayout import (
    nmos,
    pmos,
    multiplier,
    tapring,
    via_stack,
    via_array,
)
from gdsfactory.cell import cell
from glayout.placement.two_transistor_interdigitized import (
    two_nfet_interdigitized,
    two_pfet_interdigitized,
)

# from gdsfactory.pdk import get_layer
# from gdsfactory.grid import grid
from gdsfactory.cell import cell
from gdsfactory.component import Component, copy
from gdsfactory.components.rectangle import rectangle
from glayout.pdk.mappedpdk import MappedPDK

# from typing import Optional, Union
from glayout.primitives.via_gen import via_array, via_stack
from glayout.primitives.guardring import tapring
from pydantic import validate_arguments
from glayout.util.comp_utils import (
    evaluate_bbox,
    to_float,
    to_decimal,
    prec_array,
    prec_center,
    prec_ref_center,
    movey,
    align_comp_to_port,
)
from glayout.util.port_utils import (
    rename_ports_by_orientation,
    rename_ports_by_list,
    add_ports_perimeter,
)
from glayout.routing.c_route import c_route
from glayout.routing.L_route import L_route
from glayout.util.snap_to_grid import component_snap_to_grid
from decimal import Decimal
from glayout.routing.straight_route import straight_route
from glayout.spice import Netlist

from glayout.util.comp_utils import (
    align_comp_to_port,
    evaluate_bbox,
    movex,
    movey,
    prec_ref_center,
    prec_array,
)

from gdsfactory.component import Component


def print_ports(component, filter: str = "", name_only: bool = True) -> list:
    """Prints the ports of a component and returns a list of their names.

    This function is useful for debugging and inspecting the available ports on a gdsfactory component.

    Args:
        component: The gdsfactory component to inspect.
        filter: A string to filter the port names. Only ports containing this string will be printed.
        name_only: If True, only the port names are printed. If False, the full port object is printed.

    Returns:
        A list of the names of the filtered ports.
    """
    names = list()
    for key, val in component.ports.items():
        if filter in key:
            print(key)
            names.append(key)
            if not name_only:
                print(val)
    return names


@cell
def create_mosfet(
    pdk: MappedPDK,
    width: float,
    length: float,
    type: str = "nmos",
    fingers: int = 1,
    inter_finger_topmet: str = "met2",
) -> Component:
    """Creates a single MOSFET component.

    This function is a wrapper around the `glayout.primitives.multiplier`
    and is used to instantiate a single NMOS or PMOS transistor.

    Args:
        pdk: The MappedPDK object to use.
        width: The width of the transistor gate.
        length: The length of the transistor gate.
        type: The type of the transistor, either "nmos" or "pmos".
        fingers: The number of gate fingers.
        inter_finger_topmet: The top metal layer for inter-finger routing
            of source/drain connections. Can be 'met1', 'met2', or 'met3'.

    Returns:
        A gdsfactory Component representing the MOSFET. For a PMOS, this
        includes an nwell enclosure.
    """
    if type.lower() == "nmos":
        sdlayer = "n+s/d"
    elif type.lower() == "pmos":
        sdlayer = "p+s/d"
    else:
        raise ValueError("Type must be either 'nmos' or 'pmos'.")

    if inter_finger_topmet.lower() not in ["met1", "met2", "met3"]:
        raise ValueError(
            "Invalid inter_finger_topmet. Choose from 'met1', 'met2', or 'met3'."
        )

    # Create top component
    mosfet = Component()

    # Define the desired mosfet device
    kwargs = {
        "pdk": pdk,
        "width": width,
        "length": length,
        "fingers": fingers,
        "sdlayer": sdlayer,
        "dummy": (False, False),
        "routing": False,
        "sd_route_topmet": inter_finger_topmet,
        # "gate_route_topmet": "met1",
        "inter_finger_topmet": inter_finger_topmet,
    }
    fet = multiplier(**kwargs)
    fet_ref = mosfet << fet

    # Add the nwell if pmos
    if sdlayer == "p+s/d":
        mosfet.add_padding(
            layers=(pdk.get_glayer("nwell"),),
            default=pdk.get_grule("active_diff", "nwell")["min_enclosure"],
        )
        mosfet = add_ports_perimeter(
            mosfet, layer=pdk.get_glayer("nwell"), prefix="well_"
        )

    # Add ports
    mosfet.add_ports(fet_ref.ports)

    return component_snap_to_grid(rename_ports_by_orientation(mosfet))


def main(pdk: MappedPDK):
    pdk.activate()
    """Main function to create and display a MOSFET component."""
    width = 1.0  # Example width in micrometers
    length = 0.18  # Example length in micrometers
    fingers = 4  # Example number of fingers
    inter_finger_topmet = "met2"  # Example top metal layer for inter-finger routing

    nmos_component = create_mosfet(
        pdk=pdk,
        width=width,
        length=length,
        type="pmos",
        fingers=fingers,
        inter_finger_topmet=inter_finger_topmet,
    )

    nmos_component.show()


if __name__ == "__main__":
    print("Running create_transistor.py as a script.")
    main(gf180)
