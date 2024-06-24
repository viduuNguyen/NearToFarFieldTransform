% ImperfectParabolicReflector - Class representing an imperfect parabolic reflector antenna.
%
%   This class models an imperfect parabolic reflector antenna with properties
%   such as wavelength, radius of the circular aperture, RMS error of height variation,
%   correlation length of the Gaussian hat function, and a near-field grid.
%
% Properties (private):
%   wavelength         - Operating wavelength of the antenna.
%   radius             - Radius of the circular aperture.
%   rmsError           - RMS error of height variation across the reflector.
%   correlationLength  - Correlation length of the Gaussian distribution for height errors.
%   nearFieldGrid      - PlanarGrid object representing the near-field grid.
%
% Properties (public, get):
%   nearField          - MeshgridQuantity object representing the electric near-field.
%
% Methods (public):
%   ImperfectParabolicReflector(wavelength, radius, rmsError, correlationLength, nearFieldGrid) -
%       Constructor method that initializes an ImperfectParabolicReflector object
%       with specified parameters.
%
%   obj = getNearField(obj) -
%       Method to compute and return the near-field of the reflector.
%
% Methods (private):
%   getRandomRoughSurface(obj) -
%       Method to generate a random rough surface for the reflector's imperfections.
%
% Example:
%   wavelength = 0.03; % 30 mm (replace with actual wavelength in meters)
%   radius = 0.2; % 20 cm (replace with actual radius in meters)
%   rmsError = 0.01; % 1 cm (replace with actual RMS error in meters)
%   correlationLength = 0.05; % 5 cm (replace with actual correlation length in meters)
%   nearFieldGrid = PlanarGrid(256, 256, 1.0, 1.0); % Replace with actual grid parameters
%
%   reflector = ImperfectParabolicReflector(wavelength, radius, rmsError, correlationLength, nearFieldGrid);
%
%   % Compute and retrieve the near-field
%   nearField = reflector.getNearField();
%
%   % Display or analyze the near-field as needed
%
% See also: PlanarGrid, MeshgridQuantity.


classdef ImperfectParabolicReflector
    properties (Access=private)
        wavelength
        radius                      % radius of the circular aperture  
        rmsError                    % rms error of the height variation
        correlationLength           % correlation length of the gaussian hat
        nearFieldGrid PlanarGrid  
    end
    
    properties (GetAccess=public)
        nearField MeshgridQuantity
    end

    methods (Access=public)
        
        function obj =  ImperfectParabolicReflector(wavelength, radius, rmsError, correlationLength, nearFieldGrid)
            % set the instance's attributes
            obj.wavelength = wavelength;
            obj.radius = radius;
            obj.rmsError = rmsError;
            obj.correlationLength = correlationLength;
            obj.nearFieldGrid = nearFieldGrid;
        end
        
        obj = getNearField(obj)
        
    end

    methods (Access=private)
        errorSurface = getRandomRoughSurface(obj)

    end

end
