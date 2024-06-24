# Near-Field to Far-Field Transformation Software

This software package simulates the transformation of Near-Field data into Far-Field data using MATLAB. 
It includes classes and functions designed to handle Near-Field measurements, perform FFT-based transformations, and visualize results.

## Overview

The software consists of several MATLAB classes and functions:

- **Main Class (`Main.m`)**: 
  - Handles input parameters related to Near-Field data, Far-Field grid settings, and frequency.
  - Computes the Near-Field to Far-Field transformation using the NF2FFT algorithm.
  - Provides methods to display Near-Field data, Far-Field data, directivity patterns, and interpolated spectra.

- **NearFieldToFarField Class (`NearFieldToFarField.m`)**:
  - Manages the transformation process:
    - `nf2fft`: Performs Near-Field to Far-Field transformation with or without probe correction.
    - `setUp`: Sets up parameters for the transformation, including grid settings and FFT size.
    - `computeSpectrum`: Computes the spectrum components from Near-Field data.
    - `computeFarField` and `computeCorrFarField`: Compute Far-Field data with and without probe correction.
    - `computeDirectivity`: Computes directivity patterns from Far-Field data.

- **PlanarGrid Class (`PlanarGrid.m`)**:
  - Defines a grid structure for Near-Field and Far-Field data.

- **AngularGrid Class (`AngularGrid.m`)**:
  - Defines an angular grid structure for Far-Field data.

- **MeshgridQuantity Class (`MeshgridQuantity.m`)**:
  - Represents quantities defined on a meshgrid, such as Near-Field, Far-Field, phase data, etc.
  - Handles visualization and manipulation of grid-based quantities.

- **Functions**:
  - `parseNearFieldFiles`: Parses Near-Field data from files into a structured format.
  - `parseNearFieldWorkspace`: Parses Near-Field data from workspace variables into a structured format.
  - Visualization functions (`displayNearField`, `displayNearFieldPhase`, `displaySpectrum`, `displayInterpSpectrum`, etc.): Display various aspects of the transformed data.

## Usage

1. **Setup**:
   - Define the Near-Field sampling grids (`xGrid`, `yGrid`) and corresponding phasor data (`phasorX`, `phasorY`).
   - Specify the frequency of the signal.

2. **Transformation**:
   - Initialize a `Main` object and call its `Transform` method.
   - This method sets up the transformation parameters, computes the Far-Field, directivity, and spectrum, and visualizes the results.

3. **Visualization**:
   - Various visualization methods are available (`displayNearField`, `displayNearFieldPhase`, `displaySpectrum`, `displayInterpSpectrum`, etc.) to display different aspects of the transformed data.
   - Directivity patterns and interpolated spectra can be compared with and without probe correction.

## Requirements

- MATLAB R2019a or later.

## Example

```matlab
% Example usage of the Main class for Near-Field to Far-Field transformation

% Create Main instance and initialize with Near-Field data
mainObj = Main();
mainObj.xGrid = xGrid;
mainObj.yGrid = yGrid;
mainObj.phasorX = phasorX;
mainObj.phasorY = phasorY;
mainObj.frequency = 5e9; % Specify frequency in Hz

% Perform transformation
mainObj.Transform();
```

# Reference
[1] https://uk.mathworks.com/matlabcentral/fileexchange/23385-nf2ff

[2] https://uk.mathworks.com/matlabcentral/fileexchange/27876-near-field-to-far-field-transformation?s_tid=FX_rc2_behav

[3] http://www.mysimlabs.com/matlab/surfgen/rsgeng2D.m