classdef VectorQuantity
    properties(SetAccess=private, GetAccess=public)
        x     (:,1) double    
        y     (:,1) double
        scale string      
    end
    
    methods(Access=public)
        % constructor
        function obj = VectorQuantity(x, y, scale)
            arguments
                x
                y
                scale string = "linear"
            end
            obj.x = x;
            obj.y = y;
            obj.scale = scale;
            
        end
        
        % create the curve
        singlePlot(obj, ax)
        
    end
    
    methods(Static)
        multiplePlot(objArray, ax)
    end
    
end
