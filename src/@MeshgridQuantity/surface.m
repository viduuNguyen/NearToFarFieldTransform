% surface Method
%
% This method creates a surface plot of the MeshgridQuantity object on specified
% x and y axes. The x and y components of the quantity are displayed according to
% the specified scale and view angle.
%
% Usage:
%    surface(obj, xAxis, yAxis, viewAngle)
%
% Arguments:
%    obj       - A MeshgridQuantity object.
%    xAxis     - Axes on which to plot the x component of the quantity.
%    yAxis     - Axes on which to plot the y component of the quantity.
%    viewAngle - A 1x2 array specifying the azimuth and elevation of the
%                observation view. Default is [0, 90].
%
% Description:
%    This method plots the x and y components of the MeshgridQuantity object on
%    the specified axes. The components are scaled based on the scale property:
%       - "20log": Components are scaled using 20*log10(abs(X or Y)).
%       - "10log": Components are scaled using 10*log10(abs(X or Y)).
%       - "linear": Components are scaled using abs(X or Y).
%       - "signed": Components are plotted as is.
%    If an invalid scale option is provided, an error is raised.
%
%    The method also sets the shading to 'flat', adjusts the aspect ratio, sets
%    the view angle, and adds a color bar to each plot.
%
% Example:
%    [xGrid, yGrid] = meshgrid(linspace(-5, 5, 100), linspace(-5, 5, 100));
%    X = sin(xGrid) .* cos(yGrid);
%    Y = cos(xGrid) .* sin(yGrid);
%    scale = "linear";
%    mgq = MeshgridQuantity(xGrid, yGrid, X, Y, scale);
%    figure;
%    ax1 = subplot(1, 2, 1);
%    ax2 = subplot(1, 2, 2);
%    mgq.surface(ax1, ax2, [45, 45]);
%
% This example creates a MeshgridQuantity object with specified meshgrid data
% points, x and y components of the quantity, and a scale of "linear". It then
% creates a surface plot of the quantity on the specified axes with a view angle
% of [45, 45].


function surface(obj, xAxis, yAxis, viewAngle)
    arguments
        obj       MeshgridQuantity  
        xAxis
        yAxis
        viewAngle (1,2) = [0, 90] % azimuth and elevation of observation view
    end
    
    switch obj.scale
        case "20log"
            X = 20*log10(abs(obj.X));
            Y = 20*log10(abs(obj.Y));
        case "10log"
            X = 10*log10(abs(obj.X));
            Y = 10*log10(abs(obj.Y));
        case "linear"
            X = abs(obj.X);
            Y = abs(obj.Y);
        case "signed"
            X = obj.X;
            Y = obj.Y;
        otherwise
            error("Wrong option for scale");
    end

    surf(xAxis, obj.xGrid, obj.yGrid, X);
    shading(xAxis, "flat");
    pbaspect(xAxis,[1,1,1]);
    view(xAxis, viewAngle);
    colorbar(xAxis);
    
    surf(yAxis, obj.xGrid, obj.yGrid, Y);
    shading(yAxis, "flat");
    pbaspect(yAxis,[1,1,1]);
    view(yAxis, viewAngle);
    colorbar(yAxis);
end