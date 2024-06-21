function [f, ax] =  displayDirectivity(obj)
    arguments
        obj AutField 
    end
    
    f = figure(Name="MATLAB antenna toolbox");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.directivityX, obj.directivityY], ax);
    maxDirectivity = max(obj.directivityX.y, [], "all");
    xlabel(ax, "elevation (degree)");
    ylabel(ax, sprintf("directivity (dBi), max = %2.0f(dBi)", maxDirectivity));
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end