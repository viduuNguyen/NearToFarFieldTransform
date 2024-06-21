function [f, ax] = displayNearField(obj, viewAngle)
    
    arguments
        obj       AutField 
        viewAngle (1,2)    = [0, 90]
    end
    
    f = figure(Name="Magnitude of the Near-Field");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    surface(obj.nearField, xAxis, yAxis, viewAngle);
end