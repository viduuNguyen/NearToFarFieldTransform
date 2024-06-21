function displayNearField(obj)
    
    arguments
        obj ImperfectParabolicReflector 
    end
    
    f = figure(Name="Normalised electric Near-Field of the Imperfect Parabolic Reflector at the scanning plane");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    
    surface(obj.nearField, xAxis, yAxis, scale="20log");
end