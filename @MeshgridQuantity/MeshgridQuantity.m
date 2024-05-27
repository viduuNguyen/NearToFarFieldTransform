classdef MeshgridQuantity
    properties(SetAccess=private, GetAccess=public)
        x    % meshgrid of x data points        
        y    % meshgrid of y data points
        X    % X component of the quantity    
        Y    % Y component of the quantity
    end
    
    methods(Access=public)
        
        % constructor
        function obj = MeshgridQuantity(xGrid, yGrid, X, Y)
            obj.x = xGrid;
            obj.y = yGrid;
            obj.X = X;
            obj.Y = Y;
        end
        
        % create surface graph
        surface(obj, xAxis, yAxis, options)
    end
    
end

