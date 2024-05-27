function displayInterpSpectrum(obj)
    
    arguments
        obj NearFieldToFarField 
    end
    
    f = figure(Name="Interpolated spectrum components in x- and y-coordinate");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    surface(obj.interpSpectrum, xAxis, yAxis, scale="20log");
end