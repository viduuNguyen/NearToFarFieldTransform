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
