% VectorQuantity Class
%
% This class represents a vector quantity with x and y components, and a
% scale property that defines the scale of the quantity (default is "linear").
%
% Properties:
%    x - A column vector of x values. Must be a double-precision array.
%    y - A column vector of y values. Must be a double-precision array.
%    scale - A string specifying the scale of the quantity. Default is "linear".
%
% Methods:
%    VectorQuantity(x, y, scale) - Constructor that initializes the 
%        VectorQuantity object with specified x and y values and an optional
%        scale. If the scale is not provided, it defaults to "linear".
%
%    singlePlot(obj, ax) - Method to create a plot of the vector quantity
%        on the specified axes.
%
% Static Methods:
%    multiplePlot(objArray, ax) - Static method to create plots of multiple
%        VectorQuantity objects on the specified axes.
%
% Example:
%    x = [1; 2; 3];
%    y = [2; 4; 6];
%    scale = "linear";
%    vq = VectorQuantity(x, y, scale);
%    figure;
%    ax = gca;
%    vq.singlePlot(ax);
%
% This example creates a VectorQuantity object with x values [1, 2, 3], y
% values [2, 4, 6], and a scale of "linear". It then plots the vector
% quantity on the current axes.


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
