classdef PlanarGrid

    properties(SetAccess=private, GetAccess=public)
        x           % meshgrid in x-axis
        y           % meshgrid in y-axis
        spaceX      % space between 2 adjacent grid points in x-axis
        spaceY      % space between 2 adjacent grid points in y-axis
        lengthX     % x dimension of the grid
        lengthY     % y dimension of the grid
        pointX      % number of sampling points in each column (x-axis)
        pointY      % number of sampling points in each row (y-axis) 
    end
    
    methods(Access=public)
        % constructor
        function o = PlanarGrid(pointX, pointY, lengthX, lengthY)
            if (~(isPowerOf2(pointX) && isPowerOf2(pointY)))
                warning("Sampling points should be a power of 2 to apply FFT");
            end

            % calculate corresponding attribtutes
            o.pointX = pointX;
            o.pointY = pointY;
            o.lengthX = lengthX;
            o.lengthY = lengthY;
            o.spaceX = lengthX / pointX;
            o.spaceY = lengthY / pointY;
            
            % create set of coordinate of sampling points in x- and y-axis
            x_ = -lengthX/2 + o.spaceX/2 : o.spaceX : lengthX/2 - o.spaceX/2;
            y_ = -lengthY/2 + o.spaceY/2 : o.spaceY : lengthX/2 - o.spaceY/2;
            % create meshgrid of sampling points in x- and y-axis
            [o.y, o.x] = meshgrid(y_, x_);
        end
    end
    
end

function b = isPowerOf2(number)
    b = bitand(number, number - 1) == 0;
end