function displayFarField(obj)
    
    arguments
        obj NearFieldToFarField 
    end
    
    f = figure(Name="Normalised electric Far-Field");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    surface(obj.farField, xAxis, yAxis, scale="20log");
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
end