% singlePlot Method
%
% This method creates a plot of the vector quantity on the specified axes.
% The y-values are scaled according to the scale property of the VectorQuantity
% object.
%
% Usage:
%    singlePlot(obj, ax)
%
% Arguments:
%    obj - A VectorQuantity object.
%    ax  - Axes on which to plot the vector quantity.
%
% Description:
%    This method plots the x and y values of the VectorQuantity object on the
%    specified axes. The y-values are scaled based on the scale property:
%       - "linear": y-values are plotted as is.
%       - "10log": y-values are scaled using 10*log10(abs(y)).
%       - "20log": y-values are scaled using 20*log10(abs(y)).
%    If an invalid scale option is provided, an error is raised.
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

function singlePlot(obj, ax)
    arguments
       obj VectorQuantity 
       ax
    end
    
    switch obj.scale
        case "linear"
            y = obj.y;
        case "10log"
            y = 10*log10(abs(obj.y));
        case "20log"
            y = 20*log10(abs(obj.y));
        otherwise
            error("Wrong option for scale");
    end
    plot(ax, obj.x, y);
end
