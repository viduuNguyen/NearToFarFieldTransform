classdef OerwgField
   
    properties(Access=private)
        width      (1,1) double {mustBeNumeric}
        height     (1,1) double {mustBeNumeric}
        waveNumber (1,1) double {mustBeNumeric}
        distance   (1,1) double {mustBeNumeric}
        grid       AngularGrid
        farField   MeshgridQuantity
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
                                  
            obj.width = guideWidth;
            obj.height = guideHeight;
            obj.waveNumber = 2*pi/wavelength;
            obj.distance = farFieldDistance;
            obj.grid = farFieldGrid;
        end
        
        farField = computeFarField(obj);
        displayFarField(obj);
    end
    
end