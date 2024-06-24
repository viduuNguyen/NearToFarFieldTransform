% AutField Class
%
% This class represents the field of an antenna under test (AUT), including
% the near-field and far-field components, as well as the directivity in different
% planes. It also includes methods for computing and displaying these components.
%
% Properties (private):
%    nearFieldGrid    - A PlanarGrid object representing the near-field grid.
%    farFieldGrid     - An AngularGrid object representing the far-field grid.
%    frequency        - The operating frequency of the antenna. Must be positive.
%    antenna          - The antenna object.
%    scanningDistance - The distance between the scanning plane and the antenna.
%                       Must be positive.
%
% Properties (public, get; private, set):
%    nearField    - A MeshgridQuantity object representing the electric near-field
%                   in x and y coordinates.
%    directivityX - A VectorQuantity object representing the directivity in the xz plane.
%    directivityY - A VectorQuantity object representing the directivity in the yz plane.
%
% Methods (public):
%    AutField(antenna, frequency, nearFieldGrid, farFieldGrid, scanningDistance) - 
%        Constructor that initializes the AutField object with specified parameters,
%        computes the directivities in different slicing planes, and computes the
%        electric near-field components.
%
%    generateNearFieldFiles(obj, fileNameX, fileNameY) - Method to export near-field
%        data to text files.
%
%    [f, ax] = displayDirectivity(obj, viewAngle) - Method to display the directivity
%        of the AUT in specified view angles.
%
%    [f, ax] = displayNearField(obj, viewAngle) - Method to display the magnitude
%        of the near-field of the AUT in specified view angles.
%
%    [f, ax] = displayNearFieldPhase(obj, viewAngle) - Method to display the phase
%        of the near-field of the AUT in specified view angles.
%
% Methods (private):
%    computeDirectivity(obj) - Method to compute the directivity in 2D cuts.
%
%    computeNearField(obj) - Method to compute the electric near-field components.
%
% Example:
%    antenna = AntennaObject(); % Replace with actual antenna object designed by MATLAB
%        Antenna Toolbox
%    frequency = 3e9; % 3 GHz
%    nearFieldGrid = PlanarGrid(256, 256, 1.0, 1.0);
%    farFieldGrid = AngularGrid(0.01);
%    scanningDistance = 1.0;
%    autField = AutField(antenna, frequency, nearFieldGrid, farFieldGrid, scanningDistance);
%
%    % Display directivity
%    [f, ax] = autField.displayDirectivity([45, 45]);
%
%    % Display near-field magnitude
%    [f, ax] = autField.displayNearField([0, 90]);
%
%    % Display near-field phase
%    [f, ax] = autField.displayNearFieldPhase([0, 90]);
%
%    % Generate near-field files
%    autField.generateNearFieldFiles('nearFieldX.txt', 'nearFieldY.txt');
%
% This example creates an AutField object with specified parameters, computes
% the directivity and near-field components, and demonstrates how to display
% and export these components.


classdef AutField

    properties(Access=private)
        nearFieldGrid    PlanarGrid                        % near-field grid
        farFieldGrid     AngularGrid                       % far-field grid
        frequency        (1,1) double {mustBePositive} = 1 % operating frequency of the antenna
        antenna                                            % antenna object
        scanningDistance (1,1) double {mustBePositive} = 1 % distance between the scanning plane and the antenna
        
    end
    
    properties(GetAccess=public, SetAccess=private)
        nearField        MeshgridQuantity                  % electric near-field in x and y coordinate
        directivityX     VectorQuantity                    % directivity in xz plane
        directivityY     VectorQuantity                    % directivity in yz plane
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
        [f, ax] = displayDirectivity(obj, viewAngle)
        
        % display the magnitude of Near-Field
        [f, ax] = displayNearField(obj, viewAngle)

        % display the phase of Near-Field
        [f, ax] = displayNearFieldPhase(obj, viewAngle)

    end
    
    methods(Access=private)
        % compute the directivity in 2D cuts    
        obj = computeDirectivity(obj);
        
        % compute the electric Near-Field
        obj = computeNearField(obj);

    end

end