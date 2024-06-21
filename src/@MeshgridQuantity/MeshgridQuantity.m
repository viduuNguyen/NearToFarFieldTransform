classdef MeshgridQuantity
    properties(SetAccess=private, GetAccess=public)
        xGrid         % meshgrid of x data points        
        yGrid         % meshgrid of y data points
        X             % x component of the quantity    
        Y             % y component of the quantity
        scale string  % scale to display the data
    end
    
    methods(Access=public)
        
        % constructor
        function obj = MeshgridQuantity(xGrid, yGrid, X, Y, scale)
            arguments
                xGrid
                yGrid
                X
                Y
                scale string = "linear"
            end

            obj.xGrid = xGrid;
            obj.yGrid = yGrid;
            obj.X     = X;
            obj.Y     = Y;
            obj.scale = scale;
        end
        
        % create surface graph
        surface(obj, xAxis, yAxis)
    end
    
end

