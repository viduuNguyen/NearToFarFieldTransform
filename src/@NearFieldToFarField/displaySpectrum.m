function displaySpectrum(obj)
    
    arguments
        obj NearFieldToFarField 
    end
    
    f = figure(Name="Spectrum components in x- and y-coordinate");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    size(obj.spectrum.X)
    
    surface(obj.spectrum, xAxis, yAxis, scale="20log");
end