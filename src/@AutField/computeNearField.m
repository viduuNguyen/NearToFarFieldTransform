% computeNearField - Compute the electric near-field components for the antenna under test (AUT).
%
%   obj = computeNearField(obj)
%
%   Inputs:
%       obj - AutField object.
%
%   Outputs:
%       obj - Updated AutField object with electric near-field computed and stored in obj.nearField.
%
%   This method constructs a scanning surface based on the near-field grid
%   coordinates, generates the electric field at these points using the antenna's
%   EHfields function, reshapes the field data to match the grid dimensions, and
%   stores the computed near-field as a MeshgridQuantity object.
%
%   Dependencies:
%       EHfields        - Antenna Toolbox function used to compute electric and
%                         magnetic fields of the antenna.
%       MeshgridQuantity - Custom class representing meshgrid quantities (included in this code).
%
%   See also: EHfields, MeshgridQuantity.


function obj = computeNearField(obj)
    % compute the Near-Field and store in attribute obj.nearField
    
    arguments
        obj AutField 
    end
    
    % construct the scanning surface
    % the matrix must have 3 rows (each row is the data series for each coordinate)
    xGrid = obj.nearFieldGrid.x;
    yGrid = obj.nearFieldGrid.y;
    zGrid = ones(size(obj.nearFieldGrid.x)) * obj.scanningDistance;
    scanningSurface = [xGrid(:)';yGrid(:)';zGrid(:)'];
    
    % generate electric field at the scanning points
    [field, ~] = EHfields(obj.antenna, obj.frequency, scanningSurface);
    
    % reshape the field dimension to match the grid dimension
    dimension = size(obj.nearFieldGrid.x);
    fieldX = reshape(field(1,:), dimension);
    fieldY = reshape(field(2,:), dimension);
    
    obj.nearField = MeshgridQuantity(xGrid, yGrid, fieldX, fieldY, "20log");
end