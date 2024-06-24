% getNearField - Compute and store the near-field of the imperfect parabolic reflector.
%
%   obj = getNearField(obj)
%
%   Inputs:
%       obj - ImperfectParabolicReflector object.
%
%   Outputs:
%       obj - Updated ImperfectParabolicReflector object with computed near-field stored in obj.nearField.
%
%   This method computes the near-field of the imperfect parabolic reflector
%   based on its parameters and stores it in obj.nearField as a MeshgridQuantity object.
%   It initializes a uniform field magnitude across the reflector's aperture,
%   adds phase variations based on a randomly generated rough surface obtained
%   from getRandomRoughSurface, and suppresses field values outside the reflector's aperture.
%
%   Dependencies:
%       getRandomRoughSurface - Private method to generate a random rough surface for reflector imperfections.
%       MeshgridQuantity       - Custom class representing meshgrid quantities (included in this code).
%
%   See also: ImperfectParabolicReflector, getRandomRoughSurface, MeshgridQuantity.

function obj = getNearField(obj)
    arguments
        obj ImperfectParabolicReflector 
    end
    
    % define constants
    MATRIX_DIMENSION = size(obj.nearFieldGrid.x);
    % field's magnitude of the beam
    HIGH_LEVEL = 1;
    LOW_LEVEL = 0;
    
    % define field's magnitude and phase distribution
    fieldMagnitude = HIGH_LEVEL * ones(MATRIX_DIMENSION);
    
    errorSurface = getRandomRoughSurface(obj);
    fieldPhase = 4 * pi * errorSurface ./ obj.wavelength;
    
    % phasor distribution
    fieldX = fieldMagnitude .* exp(1j * fieldPhase);
    
    condition = (obj.radius^2 < (obj.nearFieldGrid.x.^2 + obj.nearFieldGrid.y.^2));
    % suppress the magnitude outside of the beam
    fieldX(condition) = LOW_LEVEL;
    fieldY = LOW_LEVEL * ones(MATRIX_DIMENSION);
    
    obj.nearField = MeshgridQuantity(obj.nearFieldGrid.x, ...
                                     obj.nearFieldGrid.y, ...
                                     fieldX,              ...
                                     fieldY);
    
end
