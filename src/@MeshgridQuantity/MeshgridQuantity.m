% MeshgridQuantity Class
%
% This class represents a quantity defined over a meshgrid in Cartesian
% coordinates, specifically with x and y components and an optional scale
% property to define how the data should be displayed.
%
% Properties:
%    xGrid - A matrix representing the meshgrid of x data points.
%    yGrid - A matrix representing the meshgrid of y data points.
%    X     - The x component of the quantity. Must match the dimensions of xGrid.
%    Y     - The y component of the quantity. Must match the dimensions of yGrid.
%    scale - A string specifying the scale to display the data. Default is "linear".
%
% Methods:
%    MeshgridQuantity(xGrid, yGrid, X, Y, scale) - Constructor that initializes
%        the MeshgridQuantity object with specified meshgrid data points, x and y
%        components of the quantity, and an optional scale. If the scale is not
%        provided, it defaults to "linear".
%
%    surface(obj, xAxis, yAxis) - Method to create a surface plot of the quantity
%        on specified x and y axes.
%
% Example:
%    [xGrid, yGrid] = meshgrid(linspace(-5, 5, 100), linspace(-5, 5, 100));
%    X = sin(xGrid) .* cos(yGrid);
%    Y = cos(xGrid) .* sin(yGrid);
%    scale = "linear";
%    mgq = MeshgridQuantity(xGrid, yGrid, X, Y, scale);
%    figure;
%    ax = gca;
%    mgq.surface(ax, ax);
%
% This example creates a MeshgridQuantity object with specified meshgrid data
% points, x and y components of the quantity, and a scale of "linear". It then
% creates a surface plot of the quantity on the specified axes.


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

