function [f, ax] = displayCorrDirectivity(obj)
    arguments
        obj NearFieldToFarField 
    end
    
    if (obj.mode == "normal") 
        error("Incorrect option for mode");
    end
    
    f = figure(Name="NF2FFT algorithm");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.corrDirectivityX, obj.corrDirectivityY], ax);
    xlabel(ax, "elevation (degree)");
    maxDirectivity = 10*log10(max(obj.corrDirectivityX.y, [], "all"));
    ylabel(ax, sprintf("directivity (dBi), max = %2.0f (dBi)", maxDirectivity));
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end