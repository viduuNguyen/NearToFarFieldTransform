function displayFarField(obj, viewAngle)
    
    arguments
        obj       OerwgField 
        viewAngle (1,2)      = [0, 90]
    end
    
    f = figure(Name="Normalised electric Far-Field of the open-ended rectangular waveguide");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    surface(obj.fieldX, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Far-Field (dB)");
    title(xAxis, "Co-Polar Far-Field");
    title(yAxis, "Cross-Polar Far-Field");
end