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
