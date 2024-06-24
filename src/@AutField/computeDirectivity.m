% computeDirectivity - Compute the directivity in 2D cuts for the antenna under test (AUT).
%
%   obj = computeDirectivity(obj)
%
%   Inputs:
%       obj - AutField object.
%
%   Outputs:
%       obj - Updated AutField object with directivity computed for xz and yz planes.
%
%   This method computes the directivity of the AUT in two slicing planes (xz and yz) 
%   based on the antenna pattern at different elevation angles calculated from 
%   the far-field grid.
%
%   Dependencies:
%       patternElevation - Antenna Toolbox function used to compute antenna pattern
%                          at specific elevation angles.
%       VectorQuantity    - Custom class representing vector quantities (included in this code).
%
%   See also: patternElevation, VectorQuantity.

function obj = computeDirectivity(obj)
    
    arguments
        obj AutField 
    end
    elevation_degree = 90 - 180/pi * obj.farFieldGrid.theta(:,1);
    directivityX = patternElevation(obj.antenna, obj.frequency,  0, "Elevation", elevation_degree);
    directivityY = patternElevation(obj.antenna, obj.frequency, 90, "Elevation", elevation_degree);
    
    obj.directivityX = VectorQuantity(elevation_degree, directivityX);
    obj.directivityY = VectorQuantity(elevation_degree, directivityY);
end