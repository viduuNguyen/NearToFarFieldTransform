% PlanarGrid Class
%
% This class represents a grid in Cartesian coordinates, specifically
% defining a meshgrid in x and y coordinates. The grid is used to sample
% points in a planar coordinate system.
%
% Properties:
%    x - A matrix of x values for the meshgrid.
%        The x values range symmetrically around zero, with a spacing
%        determined by the grid length and number of points.
%    y - A matrix of y values for the meshgrid.
%        The y values range symmetrically around zero, with a spacing
%        determined by the grid length and number of points.
%
% Methods:
%    PlanarGrid(pointX, pointY, lengthX, lengthY) - Constructor that
%        initializes the PlanarGrid object with a specified number of
%        sampling points and lengths in the x and y directions. The
%        number of points should be integers, and the lengths should
%        be positive real numbers. A warning is issued if the number
%        of points in either direction is not a power of 2, as this
%        is required for efficient FFT computation.
%
% Example:
%    pointX = 256;
%    pointY = 256;
%    lengthX = 1.0;
%    lengthY = 1.0;
%    pg = PlanarGrid(pointX, pointY, lengthX, lengthY);
%    xValues = pg.x;
%    yValues = pg.y;
%
% This example creates a PlanarGrid object with 256 sampling points in
% both the x and y directions, and grid lengths of 1.0 in both directions.
% It then retrieves the x and y values of the meshgrid.

classdef PlanarGrid

    properties(SetAccess=private, GetAccess=public)
        x (:,:) double {mustBeNumeric} % meshgrid in x-coordinate           
        y (:,:) double {mustBeNumeric} % meshgrid in y-coordinate
    end
    
    methods(Access=public)
        % constructor
        function obj = PlanarGrid(pointX, pointY, lengthX, lengthY)
            
            arguments
                pointX          {mustBeInteger}
                pointY          {mustBeInteger}
                lengthX  double {mustBePositive}
                lengthY  double {mustBePositive}
            end
            
            if (~(isPowerOf2(pointX) && isPowerOf2(pointY)))
                warning("Sampling points should be a power of 2 to apply FFT");
            end

            % calculate grid space between adjacent points
            spaceX = lengthX / pointX;
            spaceY = lengthY / pointY;
            
            % create set of coordinate of sampling points in x- and y-coordinate
            x_ = -lengthX/2 + spaceX/2 : spaceX : lengthX/2 - spaceX/2;
            y_ = -lengthY/2 + spaceY/2 : spaceY : lengthY/2 - spaceY/2;
            % create meshgrid of sampling points in x- and y-coordinate
            [obj.y, obj.x] = meshgrid(y_, x_);
        end
    end
    
end

function b = isPowerOf2(number)
    b = bitand(number, number - 1) == 0;
end