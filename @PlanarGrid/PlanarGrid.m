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