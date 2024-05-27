classdef VectorQuantity
    properties(SetAccess=private, GetAccess=public)
        x (:,1) double    
        y (:,1) double
    end
    
    methods(Access=public)
        % constructor
        function obj = VectorQuantity(x, y)
            obj.x = x;
            obj.y = y;
        end
        
        % create the curve
        singlePlot(obj, ax, scale)
        
    end
    
    methods(Static)
        multiplePlot(objArray, ax, scale)
    end
    
end
