"""
This script defines functions to create a CMOS inverter component using the gdsfactory library
and a specified Process Design Kit (PDK).

The main functions are `create_inverter` to generate the layout and `add_inverter_labels`
to add pins and labels. When run directly, this script will generate and display a
sample inverter in KLayout.
"""

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


def remove_port_orientation(port_name: str) -> str:
    """Removes the orientation suffix from a port name.

    For example, 'my_port_N' becomes 'my_port'. If the port name does not
    have an orientation suffix, it is returned unchanged.

    Args:
        port_name: The name of the port.

    Returns:
        The port name without the orientation suffix.
    """
    orientations = ["_N", "_S", "_E", "_W"]
    for orientation in orientations:
        if port_name.endswith(orientation):
            return port_name[: -len(orientation)]
    return port_name


def port_is_on_component(component: Component, port_name: str) -> bool:
    """Checks if a port name containing a given substring exists on a component.

    This function iterates through all ports of a component and checks if any
    port name contains the `port_name` as a substring.

    Args:
        component: The gdsfactory component to inspect.
        port_name: The substring to search for within the port names.

    Returns:
        True if a matching port is found, False otherwise.
    """
    for key, val in component.ports.items():
        if port_name in key:
            return True
    return False


def pin_label_creation(
    pdk: MappedPDK,
    component: Component,
    port_name: str,
    pin_label: str,
    pin_layer: str,
    label_layer: str,
    verbose: bool = False,
) -> None:
    """Creates and places a pin with a label on a specified port of a component.

    This function generates a rectangular pin on a given layer and a text label
    on another layer. It then aligns this pin to an existing port on the
    component. This is useful for defining the I/O pads of a chip.

    The function assumes that the port specified by `port_name` has at least
    a North (`_N`) and a West (`_W`) orientation, as it uses them to
    determine the size of the pin.

    Args:
        pdk: The MappedPDK object, used to retrieve layer information.
        component: The gdsfactory component to which the pin and label will be added.
        port_name: The base name of the port for placing the pin. The function
            will automatically handle orientation suffixes.
        pin_label: The text for the label.
        pin_layer: The name of the layer for the pin's rectangle (e.g., "met1").
        label_layer: The name of the layer for the text label (e.g., "met1_label").
        verbose: If True, prints a confirmation message upon completion.
    """
    # Just check if the port name actually matches a port in the component.
    if not port_is_on_component(component, port_name):
        raise ValueError(f"Port {port_name} is not on component {component}.")

    # If the port comes with orientation, remove it.
    port_name = remove_port_orientation(port_name)

    # Get the width and length of the port from its North and West orientations
    port_width = component.ports[port_name + "_N"].width
    port_length = component.ports[port_name + "_W"].width
    label_glayer = pdk.get_glayer(label_layer)
    pin_glayer = pdk.get_glayer(pin_layer)

    # Create the rectangle for the pin and add the label to it
    pin_rectangle = rectangle(
        size=(port_width, port_length), layer=pin_glayer, centered=True
    ).copy()
    pin_rectangle.add_label(text=pin_label, layer=label_glayer, magnification=4)
    pin_ref = component << pin_rectangle

    # Align the newly created pin to the component's port
    pin_ref = align_comp_to_port(
        pin_ref,
        component.ports[port_name + "_N"],
        alignment=("c", "b"),
    )

    if verbose:
        print(f"Pin and label {pin_label} created on component with metal {pin_layer}.")


def create_tap_trace(
    pdk: MappedPDK,
    met1_size: tuple[float, float] = (4.0, 0.5),
    add_nwell: bool = True,
) -> Component:
    """Creates a component for a substrate or well tap connection.

    This function generates a rectangular tap structure consisting of a metal 1
    trace, an active diffusion trace of the same size, and a via array
    connecting them. It can optionally be enclosed in an nwell, which is
    necessary for PMOS body connections. This component is typically used to
    provide VDD or VSS connections to the substrate or well.

    Args:
        pdk: The MappedPDK object to use for layer and rule information.
        met1_size: A tuple (width, height) defining the size of the metal 1
            and active diffusion trace.
        add_nwell: If True, an nwell layer is added around the component,
            and `well_` ports are created.

    Returns:
        A gdsfactory Component representing the tap trace, with ports for
        metal, diffusion, vias, and optionally the well.
    """
    # Check if the provided size is greater than pdk drc
    if met1_size[0] < pdk.get_grule("met1", "met1")["min_width"]:
        raise ValueError("met1 width is smaller than DRC minimum")
    if met1_size[1] < pdk.get_grule("met1", "met1")["min_width"]:
        raise ValueError("met1 height is smaller than DRC minimum")

    tap_trace = Component()
    # Create a rectangle for the met1 trace
    met1_trace = rectangle(
        layer=pdk.get_glayer("met1"),
        size=met1_size,
        centered=True,
    ).copy()
    met1_trace_ref = tap_trace << met1_trace

    # Create a rectangle for the diffusion trace
    diff_trace = rectangle(
        layer=pdk.get_glayer("active_tap"),
        size=met1_size,
        centered=True,
    ).copy()
    diff_trace_ref = tap_trace << diff_trace

    # Create the via for the tap
    via_array_horizontal = via_array(
        pdk,
        "active_tap",
        "met1",
        (met1_size[0], met1_size[1]),
        minus1=True,
        lay_every_layer=True,
    )
    via_array_horizontal_ref = tap_trace << via_array_horizontal

    # Add the Nwell if required
    if add_nwell:
        tap_trace.add_padding(
            layers=(pdk.get_glayer("nwell"),),
            default=pdk.get_grule("active_tap", "nwell")["min_enclosure"],
        )
        tap_trace = add_ports_perimeter(
            tap_trace, layer=pdk.get_glayer("nwell"), prefix="well_"
        )

    # Clone ports
    tap_trace.add_ports(met1_trace_ref.ports, prefix="met1_")
    tap_trace.add_ports(diff_trace_ref.ports, prefix="diff_")
    tap_trace.add_ports(via_array_horizontal_ref.ports, prefix="via_")

    return component_snap_to_grid(rename_ports_by_orientation(tap_trace))


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
            default=pdk.get_grule("active_tap", "nwell")["min_enclosure"],
        )
        mosfet = add_ports_perimeter(
            mosfet, layer=pdk.get_glayer("nwell"), prefix="well_"
        )

    # Add ports
    mosfet.add_ports(fet_ref.ports)

    return component_snap_to_grid(rename_ports_by_orientation(mosfet))


def add_inverter_labels(pdk: MappedPDK, inverter: Component):
    """Adds pin labels to the inverter component and flattens it.

    This function is a final processing step for the inverter. It adds
    rectangular pins and text labels for the VDD, VSS, IN, and OUT ports.
    It assumes that the inverter component has ports with specific names
    (e.g., 'VDD_met1', 'VSS_met1', 'IN_route', 'OUT_route').

    Args:
        pdk: The MappedPDK object, used for layer information.
        inverter: The inverter component to which labels will be added.

    Returns:
        A flattened version of the inverter component with pins and labels.
    """
    inverter.unlock()
    # Create label for VDD
    pin_label_creation(
        pdk=pdk,
        component=inverter,
        port_name="VDD_met1",
        pin_label="VDD",
        pin_layer="met1",
        label_layer="met1_label",
    )

    # Create label for VSS
    pin_label_creation(
        pdk=pdk,
        component=inverter,
        port_name="VSS_met1",
        pin_label="VSS",
        pin_layer="met1",
        label_layer="met1_label",
    )

    # Create label for Input
    pin_label_creation(
        pdk=pdk,
        component=inverter,
        port_name="IN_route",
        pin_label="IN",
        pin_layer="met1",
        label_layer="met1_label",
    )

    # Create label for Output
    pin_label_creation(
        pdk=pdk,
        component=inverter,
        port_name="OUT_route",
        pin_label="OUT",
        pin_layer="met1",
        label_layer="met1_label",
    )

    return inverter.flatten()


def create_inverter(
    pdk: MappedPDK, strength: int, width: float = 2, length: float = 0.3
) -> Component:
    """Creates a CMOS inverter component.

    This function generates a standard CMOS inverter by placing and routing a
    PMOS and an NMOS transistor. The transistors are placed vertically, with
    the PMOS on top. VDD and VSS taps are added and connected to the
    respective source terminals. The gates are connected together to form the
    inverter's input, and the drains are connected together to form the output.

    Args:
        pdk: The MappedPDK object to use for layers and DRC rules.
        strength: The number of fingers for both the PMOS and NMOS transistors.
            This value scales the drive strength of the inverter.
        width: The gate width of the transistors.
        length: The gate length of the transistors.

    Returns:
        A gdsfactory Component representing the inverter, with ports for
        VDD, VSS, IN, and OUT. This component is not yet flattened and does
        not contain pin labels.
    """

    # Input checks
    if not isinstance(strength, int):
        raise ValueError("Argument 'strength' must be an integer.")

    if strength <= 0:
        raise ValueError("Strength must be greater than 0.")

    if not 0.5 <= width <= 3:
        raise ValueError("Width must be between 0.5 and 3.")

    if not 0.28 <= length <= 2.5:
        raise ValueError("Length must be between 0.28 and 2.5.")

    # Initial setup for the inverter component
    # Create the gate via
    gate_via = via_stack(pdk, "poly", "met1")

    gate_via_dims = evaluate_bbox(gate_via)
    # Create the S/D via
    sd_via = via_stack(pdk, "met1", "met2")
    sd_via_dims = evaluate_bbox(sd_via)

    # Define the trace width based on the gate via dimensions
    m1_trace_width = max(gate_via_dims[1], sd_via_dims[1])
    # Define the minimum spacing for M1 traces with min DRC rules
    m1_min_spacing = pdk.get_grule("met1", "met1")["min_separation"]

    pdk.activate()
    the_inverter = Component()

    #### ------------ Placing Pmos and Nmos for the inverter ------------ ####

    # Create the Pmos for the inverter
    pmos = create_mosfet(
        pdk=pdk, type="pmos", width=width, length=length, fingers=strength
    )
    # append the pmos to the inverter
    pmos_ref = the_inverter << pmos
    # Create the Nmos for the inverter
    nmos = create_mosfet(
        pdk=pdk, type="nmos", width=width, length=length, fingers=strength
    )
    # evaluate the size of the device (expected nmos equal pmos)
    transistor_size = evaluate_bbox(pmos_ref)

    nmos_ref = the_inverter << nmos
    # This movement aims to leave space fot 2 M1 traces between the PMOS and NMOS.
    nmos_ref.movey(
        pdk.snap_to_2xgrid(
            -transistor_size[1]
            - 3 * m1_min_spacing
            - 2 * m1_trace_width
            + 2 * pdk.get_grule("poly", "active_diff")["overhang"]
        )
    )  # Move the NMOS below the PMOS

    # Create the VDD tap
    vdd_tap = create_tap_trace(
        pdk=pdk,
        met1_size=(transistor_size[0] - 2 * 0.12, m1_trace_width),
        add_nwell=True,
    )
    vdd_tap_ref = the_inverter << vdd_tap
    vdd_tap_ref = align_comp_to_port(
        vdd_tap_ref,
        pmos_ref.ports[f"well_N"],
        alignment=("c", "t"),
    )

    # Create the VSS tap
    vss_tap = create_tap_trace(
        pdk=pdk,
        met1_size=(transistor_size[0] - 2 * 0.12, m1_trace_width),
        add_nwell=False,
    )
    vss_tap_ref = the_inverter << vss_tap
    vss_tap_ref = align_comp_to_port(
        vss_tap_ref,
        nmos_ref.ports[f"plusdoped_S"],
        alignment=("c", "b"),
    )
    vss_tap_ref.movey(-0.15)

    #### ------------ Routing Pmos and Nmos for the inverter ------------ ####
    # Route left source of the PMOS
    the_inverter << straight_route(
        pdk,
        pmos_ref.ports[f"leftsd_top_met_S"],
        vdd_tap_ref.ports[f"met1_N"],
    )

    # Route left source of the NMOS
    the_inverter << straight_route(
        pdk,
        nmos_ref.ports[f"leftsd_top_met_N"],
        vss_tap_ref.ports[f"met1_S"],
    )

    # Lets route for each finger
    for finger in range(strength):

        # Route the poly of the PMOS and the NMOS
        the_inverter << straight_route(
            pdk,
            pmos_ref.ports[f"row0_col{finger}_gate_S"],
            nmos_ref.ports[f"row0_col{finger}_gate_N"],
        )

        # Place the via for horizontal routing
        gate_via_ref = the_inverter << gate_via
        gate_via_ref = align_comp_to_port(
            gate_via_ref,
            pmos_ref.ports[f"row0_col{finger}_gate_S"],
            alignment=("c", "b"),
        )
        gate_via_ref.movey(
            -pdk.get_grule("met1", "met1")["min_separation"]
            + pdk.get_grule("poly", "active_diff")["overhang"]
        )
        gate_route_end_port = gate_via_ref.ports["top_met_W"]

        # Route the drains
        if not finger % 2:

            # create the routing for drains with a rectangle (as the top metal port is on m1)
            path_length = (
                pmos_ref.ports[f"row0_col{finger}_rightsd_top_met_N"].to_dict()[
                    "center"
                ][1]
                - nmos_ref.ports[f"row0_col{finger}_rightsd_top_met_S"].to_dict()[
                    "center"
                ][1]
            )
            path = rectangle(
                layer=pdk.get_glayer("met2"),
                size=(
                    pdk.get_grule("via1", "via1")["width"]
                    + 2 * pdk.get_grule("via1", "met2")["min_enclosure"],
                    path_length,
                ),
                centered=True,
            ).copy()
            # add the path to the inverter
            path_ref = the_inverter << path
            # align the path to the drains
            path_ref = align_comp_to_port(
                path_ref,
                pmos_ref.ports[f"row0_col{finger}_rightsd_top_met_N"],
                alignment=("c", "b"),
            )
            # Place the via for horizontal routing
            drain_via_ref = the_inverter << sd_via
            drain_via_ref = align_comp_to_port(
                drain_via_ref,
                nmos_ref.ports[f"row0_col{finger}_rightsd_top_met_N"],
                alignment=("c", "t"),
            )
            drain_via_ref.movey(pdk.get_grule("met1", "met1")["min_separation"])
            drain_route_end_port = drain_via_ref.ports["bottom_layer_W"]

        else:  # Route the sources
            the_inverter << straight_route(
                pdk,
                pmos_ref.ports[f"row0_col{finger}_rightsd_top_met_S"],
                vdd_tap_ref.ports[f"met1_N"],
            )
            the_inverter << straight_route(
                pdk,
                nmos_ref.ports[f"row0_col{finger}_rightsd_top_met_N"],
                vss_tap_ref.ports[f"met1_S"],
            )

        if finger == 0:
            # Save the ports to route the gates
            gate_route_start_port = gate_via_ref.ports["top_met_E"]
            drain_route_start_port = drain_via_ref.ports["bottom_layer_E"]

    # Horizontally route the poly-met1 vias for the gates, using met1.
    input_path = straight_route(
        pdk,
        gate_route_start_port,
        gate_route_end_port,
    )
    input_path_ref = the_inverter << input_path

    # Horizontally route the met1-met2 vias for the drains, using met1.
    output_path = straight_route(
        pdk,
        drain_route_start_port,
        drain_route_end_port,
    )
    output_path_ref = the_inverter << output_path

    # Finally, add the ports for the elements.
    the_inverter.add_ports(vdd_tap_ref.ports, prefix="VDD_")
    the_inverter.add_ports(vss_tap_ref.ports, prefix="VSS_")
    the_inverter.add_ports(pmos_ref.ports, prefix="PMOS_")
    the_inverter.add_ports(nmos_ref.ports, prefix="NMOS_")
    the_inverter.add_ports(input_path_ref.ports, prefix="IN_")
    the_inverter.add_ports(output_path_ref.ports, prefix="OUT_")

    return the_inverter


def main(pdk: MappedPDK):
    """Creates and displays a sample inverter.

    This function serves as an example of how to use the `create_inverter`
    and `add_inverter_labels` functions. It instantiates an inverter with
    pre-defined parameters and opens it in KLayout for visualization.

    Args:
        pdk: The MappedPDK to use for creating the inverter.
    """
    # Create the inverter
    my_inverter = create_inverter(pdk=pdk, strength=4, width=2, length=0.3)
    # Add pin labels to the inverter
    my_inverter = add_inverter_labels(pdk, my_inverter)
    # Set the name for the gds
    my_inverter.name = "Inverter"
    print(my_inverter)
    # Show gds on klayout
    my_inverter.show()


if __name__ == "__main__":
    # This block is the main entry point of the script. It calls the `main` function
    # to generate and display an inverter using the gf180 PDK.
    main(gf180)
