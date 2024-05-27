classdef AutField

    properties(Access=private)
        nearFieldGrid    PlanarGrid                        % near-field grid
        farFieldGrid     AngularGrid                       % far-field grid
        frequency        (1,1) double {mustBePositive} = 1 % operating frequency of the antenna
        antenna                                            % antenna object
        scanningDistance (1,1) double {mustBePositive} = 1 % distance between the scanning plane and the antenna
        
        directivityX     VectorQuantity                    % directivity in xz plane
        directivityY     VectorQuantity                    % directivity in yz plane
        
        
    end
    
    properties(Access=public)
        nearField        MeshgridQuantity                  % electric near-field in x and y coordinate
    end

    methods (Access=public)

        function obj = AutField(antenna, frequency, nearFieldGrid, farFieldGrid, scanningDistance)
            
            arguments
                antenna
                frequency        {mustBePositive}
                nearFieldGrid    PlanarGrid
                farFieldGrid     AngularGrid
                scanningDistance {mustBePositive} 
            end

            % attributes assignment
            obj.antenna = antenna;
            obj.frequency = frequency;
            obj.nearFieldGrid = nearFieldGrid;
            obj.farFieldGrid = farFieldGrid;
            obj.scanningDistance = scanningDistance;
            
            % compute the directivities in 2 different slicing planes
            obj = computeDirectivity(obj);
            
            % compute the electric near-field components
            obj = computeNearField(obj);
        end       
        
        % export text data files
        generateNearFieldFiles(obj, fileNameX, fileNameY)
        
        % display directivity
        displayDirectivity(obj)
        
        % display the Near-Field
        displayNearField(obj)

    end
    
    methods(Access=private)
        % compute the directivity in 2D cuts    
        obj = computeDirectivity(obj);
        
        % compute the electric Near-Field
        obj = computeNearField(obj);

    end

end