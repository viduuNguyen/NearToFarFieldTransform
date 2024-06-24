% NearFieldToFarField Class
%
% This class represents the transformation of near-field data to far-field
% data, including spectral analysis and directivity calculations. It provides
% methods to parse near-field data from files or workspace, set up the
% transformation parameters, compute spectra, compute far-fields, display
% near-field data, display spectra, display far-field data, and display
% directivity.
%
% Properties (private):
%    waveNumber       - Wave number of the electromagnetic wave. Must be positive.
%    spectrum         - MeshgridQuantity object representing spectrum components
%                       in x and y coordinates.
%    interpSpectrum   - Interpolated MeshgridQuantity object representing
%                       spectrum components in x and y coordinates.
%    nearField        - MeshgridQuantity object representing near-field
%                       components in x and y coordinates.
%    farField         - MeshgridQuantity object representing far-field
%                       components in x and y coordinates.
%    corrFarField     - MeshgridQuantity object representing far-field with
%                       probe correction in x and y coordinates.
%    nearFieldGrid    - PlanarGrid object representing the near-field scanning grid.
%    farFieldGrid     - AngularGrid object representing the far-field scanning grid.
%    farFieldDistance - Distance to the far-field measurement plane.
%    fftSizeX         - Size of the FFT in the x coordinate.
%    fftSizeY         - Size of the FFT in the y coordinate.
%    mode             - String indicating the choice for probe correction.
%    probeAntenna     - Antenna object used for probe correction.
%
% Properties (public, get; private, set):
%    directivityX     - VectorQuantity object representing directivity in the xz plane.
%    directivityY     - VectorQuantity object representing directivity in the yz plane.
%    corrDirectivityX - VectorQuantity object representing directivity with probe
%                       correction in the xz plane.
%    corrDirectivityY - VectorQuantity object representing directivity with probe
%                       correction in the yz plane.
%
% Methods (public):
%    parseNearFieldFiles(obj, fileNameX, fileNameY) - Parse near-field data from
%        text files and return a MeshgridQuantity object.
%
%    parseNearFieldWorkspace(obj, xGrid, yGrid, phasorX, phasorY) - Parse
%        near-field data from workspace variables and return a MeshgridQuantity object.
%
%    setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY) -
%        Set up the transformation parameters for near-field to far-field conversion.
%
%    nf2fft(obj, mode, probeAntenna) - Perform near-field to far-field transformation
%        with optional probe correction.
%
%    [f, ax] = displayNearField(obj, viewAngle) - Display the magnitude of the
%        near-field data in specified view angles.
%
%    [f, ax] = displayNearFieldPhase(obj, viewAngle) - Display the phase of the
%        near-field data in specified view angles.
%
%    displaySpectrum(obj, viewAngle) - Display the spectrum components.
%
%    [f, ax] = displayInterpSpectrum(obj, viewAngle) - Display the interpolated
%        spectrum components in specified view angles.
%
%    displayFarField(obj, viewAngle) - Display the normalized electric far-field
%        data in specified view angles.
%
%    displayDirectivity(obj) - Display the directivity of the far-field data.
%
%    displayCorrFarField(obj, viewAngle) - Display the far-field data with probe
%        correction in specified view angles.
%
%    displayCorrDirectivity(obj) - Display the directivity of the far-field data
%        with probe correction.
%
% Methods (private):
%    computeSpectrum(obj) - Compute the spectrum components from the near-field data.
%
%    computeFarField(obj) - Compute the far-field data from the spectrum components.
%
%    computeCorrFarField(obj) - Compute the far-field data with probe correction.
%
%    [directivityX, directivityY] = computeDirectivity(obj, fieldX, fieldY) -
%        Compute the directivity in the xz and yz planes from the far-field data.
%
% Methods (static, private):
%    getNearGrid(dataX, dataY) - Evaluate the data and generate a PlanarGrid object
%                                for near-field scanning.
%
% Example:
%    % Set up parameters
%    guideWidth = 0.2; % 20 cm
%    guideHeight = 0.1; % 10 cm
%    wavelength = 0.03; % 30 mm
%    farFieldDistance = 1.0; % 1 meter
%    farFieldGrid = AngularGrid(100, 50); % Angular grid parameters
%    fftSizeX = 256;
%    fftSizeY = 256;
%
%    % Create NearFieldToFarField object
%    nearFarFieldObj = NearFieldToFarField(guideWidth, guideHeight, wavelength, ...
%                                         farFieldDistance, farFieldGrid);
%
%    % Display near-field data
%    [f, ax] = nearFarFieldObj.displayNearField([0, 90]);
%
%    % Perform near-field to far-field transformation
%    nearFarFieldObj.nf2fft("probe_correction", probeAntenna);
%
%    % Display far-field data with probe correction
%    nearFarFieldObj.displayCorrFarField([0, 90]);
%
%    % Display directivity
%    nearFarFieldObj.displayDirectivity();
%
%    % Display directivity with probe correction
%    nearFarFieldObj.displayCorrDirectivity();
%
%    % Display interpolated spectrum components
%    [f, ax] = nearFarFieldObj.displayInterpSpectrum([0, 90]);
%
% This example demonstrates the usage of the NearFieldToFarField class to
% transform near-field data to far-field, display various components, and
% compute directivity with and without probe correction.
%
% See also: MeshgridQuantity, PlanarGrid, AngularGrid, VectorQuantity.


classdef NearFieldToFarField
    
    properties (Access=private)
        waveNumber       {mustBePositive} = 1  % wave number
        spectrum         MeshgridQuantity      % spectrum components in x- and y-coordinates
        interpSpectrum   MeshgridQuantity      % interpolated spectrum components in x- and y-coordinates
        
        nearField        MeshgridQuantity      % near-field components in x- and y-coordinates
        farField         MeshgridQuantity      % far-field components in x- and y-coordinates
        corrFarField     MeshgridQuantity      % far-field with probe correction
        
        
        
        nearFieldGrid    PlanarGrid            % near-field scanning grid
        farFieldGrid     AngularGrid           % far-field scanning grid
        farFieldDistance                       % far-field distance
        fftSizeX                               % size of the fft in x coordinate
        fftSizeY                               % size of the fft in y coordinate
        
        mode             string           = "" % choice for probe correction
        probeAntenna                    
    end
    
    properties(Access=public)
        directivityX     VectorQuantity        % directivity in xz plane
        directivityY     VectorQuantity        % directivity in yz plane
        
        corrDirectivityX VectorQuantity        % directivity with probe correction
        corrDirectivityY VectorQuantity
    end

    methods(Access=public)
        
        nearField = parseNearFieldFiles(obj, fileNameX, fileNameY)
        
        nearField = parseNearFieldWorkspace(obj, xGrid, yGrid, phasorX, phasorY)
        
        obj = setUp(obj, nearField, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
        
        obj = nf2fft(obj, mode, probeAntenna)

        [f, ax] = displayNearField(obj, viewAngle)
        
        [f, ax] = displayNearFieldPhase(obj, viewAngle)
        
        displaySpectrum(obj, viewAngle)
        
        [f, ax] = displayInterpSpectrum(obj, viewAngle)
        
        displayFarField(obj, viewAngle)
        
        displayDirectivity(obj)
        
        displayCorrFarField(obj, viewAngle)
        
        displayCorrDirectivity(obj)
        
    end

    methods(Access=private)
        
        obj = computeSpectrum(obj)
        
        obj = computeFarField(obj)
        
        obj = computeCorrFarField(obj)
        
        [directivityX, directivityY] = computeDirectivity(obj, fieldX, fieldY)
        
    end
    
    methods(Static, Access=private)
        % valuating the data and generate a PlanarGrid
        grid = getNearGrid(dataX, dataY)
    end

end