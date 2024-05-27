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