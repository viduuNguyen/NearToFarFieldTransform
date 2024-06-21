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