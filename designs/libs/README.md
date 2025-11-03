# Design Characterization with CACE: From Schematic to Post-Layout 

This README outlines the process for verifying circuit designs using **CACE** (Cadence Automated Circuit Evaluation). CACE allows for automated simulations and analysis to validate the characteristics and specifications of electronic designs before physical implementation.

## Prerequisites
It is necessary to clone the repository directly into the /foss/designs directory within the Docker container.

## Project Structure
All directories, schematics, templates, testbenches, etc., of the main project are located in the directory `Onchip_CurRefGen/designs/libs/`. The project has the following hierarchical structure.

```
Current Reference Generator
|---Error Amplifier N_input
|   |---Error Amplifier N_input_core
|   |---Error Amplifier N_input_bias
|---Current Reference Second Stage
Current Reference Load
```




