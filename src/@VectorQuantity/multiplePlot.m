function multiplePlot(objArray, ax, scale)
    % Static method to plot multiple instances on the same Axis
    
    arguments
        objArray (:,1)
        ax
        scale (1,1) string = "linear"
    end
    
    hold(ax, 'on');
    for i = 1:numel(objArray)
        instance = objArray(i);
        if isa(instance, "VectorQuantity")
            instance.singlePlot(ax, scale);
        else
            error("Input must contain only VectorQuantity objects.");
        end
    end
    
    hold(ax, 'off');
    legend(ax, 'show');
end
