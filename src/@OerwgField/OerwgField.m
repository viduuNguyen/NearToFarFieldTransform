% OerwgField - Class representing the electromagnetic far-field of an OE-RWG structure.
%
%   This class models the far-field of an Open-Ended Rectangular Waveguide (OE-RWG)
%   structure for vertical and horizontal polarizations based on specified parameters.
%
% Properties (private):
%   width         - Width of the waveguide aperture.
%   height        - Height of the waveguide aperture.
%   waveNumber    - Wave number calculated as 2*pi divided by the wavelength.
%   distance      - Distance from the waveguide aperture to the far-field measurement plane.
%   grid          - AngularGrid object representing the angular grid for far-field measurements.
%
% Properties (public):
%   fieldX        - MeshgridQuantity object representing the far-field in vertical polarization.
%   fieldY        - MeshgridQuantity object representing the far-field in horizontal polarization.
%
% Methods (public):
%   OerwgField(guideWidth, guideHeight, wavelength, farFieldDistance, farFieldGrid) -
%       Constructor method that initializes an OerwgField object with specified parameters,
%       computes the far-field for vertical and horizontal polarizations, and stores
%       the results in fieldX and fieldY, respectively.
%
%   displayFarField(obj, viewAngle) -
%       Method to display the far-field of the OE-RWG structure in specified view angles.
%
% Methods (private, Static):
%   computeFarField(waveNumber, width, height, distance, thetaGrid, phiGrid) -
%       Static method to compute the far-field of the OE-RWG structure based on
%       waveguide parameters and angular grid specifications.
%
%   This method computes the far-field for both vertical and horizontal polarizations
%   by calling computeFarField twice with appropriate angle adjustments for each polarization.
%   It initializes properties such as width, height, waveNumber, distance, and grid based on
%   the provided input parameters. The resulting far-field data is stored in fieldX and fieldY
%   as MeshgridQuantity objects.
%
% Example:
%   guideWidth = 0.2; % 20 cm (replace with actual guide width in meters)
%   guideHeight = 0.1; % 10 cm (replace with actual guide height in meters)
%   wavelength = 0.03; % 30 mm (replace with actual wavelength in meters)
%   farFieldDistance = 1.0; % 1 meter (replace with actual distance in meters)
%   farFieldGrid = AngularGrid(100, 50); % Replace with actual grid parameters
%
%   oerwg = OerwgField(guideWidth, guideHeight, wavelength, farFieldDistance, farFieldGrid);
%
%   % Display the far-field in specific view angles
%   oerwg.displayFarField([0, 90]);
%
% See also: AngularGrid, MeshgridQuantity.


classdef OerwgField
   
    properties(Access=private)
        width      (1,1) double {mustBeNumeric}
        height     (1,1) double {mustBeNumeric}
        waveNumber (1,1) double {mustBeNumeric}
        distance   (1,1) double {mustBeNumeric}
        grid       AngularGrid        
    end
    properties(Access=public)
        fieldX     MeshgridQuantity % far-field in the vertical polarisation
        fieldY     MeshgridQuantity % far-field in the horizontal polarisation
    end
    
    methods(Access=public)
        function obj = OerwgField(guideWidth,       ...
                                  guideHeight,      ...
                                  wavelength,       ...
                                  farFieldDistance, ...
                                  farFieldGrid)
            arguments
                guideWidth       (1,1) double {mustBePositive}
                guideHeight      (1,1) double {mustBePositive}
                wavelength       (1,1) double {mustBePositive}
                farFieldDistance (1,1) double {mustBePositive}
                farFieldGrid     AngularGrid
            end
                                  
            width = guideWidth;
            height = guideHeight;
            waveNumber = 2*pi/wavelength;
            distance = farFieldDistance;
            grid = farFieldGrid;
            
            % compute far-field for different polarisation measurements
            thetaVerticalGrid = pi - grid.theta;
            phiVerticalGrid   = pi/2 - grid.phi;
            obj.fieldX = OerwgField.computeFarField(waveNumber,        ...
                                                    width,             ...
                                                    height,            ...
                                                    distance,          ...
                                                    thetaVerticalGrid, ...
                                                    phiVerticalGrid);
            
            thetaHorizontalGrid = pi - grid.theta;
            phiHorizontalGrid   = -grid.phi;
            obj.fieldY = OerwgField.computeFarField(waveNumber,          ...
                                                    width,               ...
                                                    height,              ...
                                                    distance,            ...
                                                    thetaHorizontalGrid, ...
                                                    phiHorizontalGrid);
        end        
        
        displayFarField(obj, viewAngle);
    end
    
    methods(Access=private, Static)
        farField = computeFarField(waveNumber, width, height, distance, thetaGrid, phiGrid)
    end
    
end