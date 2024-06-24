% multiplePlot Static Method
%
% This static method creates plots of multiple VectorQuantity objects on the
% same axes.
%
% Usage:
%    multiplePlot(objArray, ax)
%
% Arguments:
%    objArray - A column vector array of VectorQuantity objects.
%    ax       - Axes on which to plot the vector quantities.
%
% Description:
%    This method iterates through an array of VectorQuantity objects and
%    plots each one on the specified axes. It ensures that all plots are
%    displayed on the same axes by using the 'hold on' and 'hold off'
%    commands. If the objArray contains any elements that are not
%    VectorQuantity objects, an error is raised.
%
% Example:
%    x1 = [1; 2; 3];
%    y1 = [2; 4; 6];
%    vq1 = VectorQuantity(x1, y1, "linear");
%    
%    x2 = [1; 2; 3];
%    y2 = [1; 2; 3];
%    vq2 = VectorQuantity(x2, y2, "20log");
%    
%    objArray = [vq1; vq2];
%    figure;
%    ax = gca;
%    VectorQuantity.multiplePlot(objArray, ax);
%
% This example creates two VectorQuantity objects with different scales and
% plots both of them on the same axes.

function multiplePlot(objArray, ax)
    % Static method to plot multiple instances on the same Axis
    
    arguments
        objArray (:,1)
        ax
    end
    
    hold(ax, 'on');
    for i = 1:numel(objArray)
        instance = objArray(i);
        if isa(instance, "VectorQuantity")
            instance.singlePlot(ax);
        else
            error("Input must contain only VectorQuantity objects.");
        end
    end
    
    hold(ax, 'off');
    legend(ax, 'show');
end
