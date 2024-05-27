function displayDirectivity(obj)
    arguments
        obj NearFieldToFarField 
    end
    
    f = figure(Name="NF2FFT algorithm");
    ax = subplot(1,1,1);
    VectorQuantity.multiplePlot([obj.directivityX, obj.directivityY], ax, "10log");
    xlabel(ax, "elevation (degree)");
    ylabel(ax, "directivity (dBi)");
    legend(ax, "phi = 0^{\circ}", "phi = 90^{\circ}");
    
end