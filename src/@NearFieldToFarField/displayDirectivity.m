function [f, ax] = displayDirectivity(obj)
    arguments
        obj NearFieldToFarField 
    end
    
    if (obj.mode == "corrected") 
        error("This methos is not applicable for this mode");
    end
    
    f = figure(Name="NF2FFT algorithm");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.directivityX, obj.directivityY], ax);
    xlabel(ax, "elevation (degree)");
    maxDirectivity = 10*log10(max(obj.directivityX.y, [], "all"));
    ylabel(ax, sprintf("directivity (dBi), max = %2.0f (dBi)", maxDirectivity));
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end