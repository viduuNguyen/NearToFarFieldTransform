% AngularGrid Class
%
% This class represents a grid in spherical coordinates, specifically
% defining a meshgrid in theta and phi coordinates. The grid is used
% to sample points in a spherical coordinate system.
%
% Properties:
%    theta - A matrix of theta values (in radians) for the meshgrid.
%            The theta values range from -pi/2 to pi/2, excluding the boundaries.
%    phi   - A matrix of phi values (in radians) for the meshgrid.
%            The phi values range

classdef AngularGrid

    properties(GetAccess=public, SetAccess=private)
        theta (:,:) double {mustBeReal} % meshgrid in theta-coordinate (radian)
        phi   (:,:) double {mustBeReal} % meshgrid in phi-coordinate (radian)         
    end

    methods(Access=public)
        
        % constructor
        function obj = AngularGrid(gridSpace)
            arguments
                gridSpace double {mustBePositive} 
            end
            
            if (gridSpace < 0.002)
                warning("Grid space is small and leads to long computing time");
            end
            
            % create set of coordinate of sampling points in theta- and phi-axis
            theta_ = -pi/2 + gridSpace/2 : gridSpace : pi/2 - gridSpace/2;
            phi_ = 0 + gridSpace/2 : gridSpace : pi - gridSpace/2;
            % create meshgrid of sampling points in theta- and phi- axis
            [obj.phi, obj.theta] = meshgrid(phi_, theta_);
        end
    end    
end