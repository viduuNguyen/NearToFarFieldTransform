classdef AngularGrid

    properties(GetAccess=public, SetAccess=private)
        theta       % meshgrid in theta-coordinate (radian)
        phi         % meshgrid in phi-coordinate (radian)
    end

    methods(Access=public)
        % constructor
        function o = AngularGrid(spaceTheta, spacePhi)
            if (spaceTheta < 0.002 || spacePhi < 0.002)
                error("Grid space is too small and leads to error");
            end
            % create set of coordinate of sampling points in theta- and
            % phi-axis
            theta_ = -pi/2 + spaceTheta : spaceTheta : pi/2 - spaceTheta;
            phi_ = 0 + spacePhi : spacePhi : pi - spacePhi;
            % create meshgrid of sampling points in theta- and phi- axis
            [o.phi, o.theta] = meshgrid(phi_, theta_);
        end
    end
    
end