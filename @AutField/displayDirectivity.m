function displayDirectivity(obj)
    arguments
        obj AutField 
    end
    
    f = figure(Name="MATLAB antenna toolbox");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.directivityX, obj.directivityY], ax);
    xlabel(ax, "elevation (degree)");
    ylabel(ax, "directivity (dBi)");
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end