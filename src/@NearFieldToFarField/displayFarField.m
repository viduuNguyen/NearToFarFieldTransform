function [f, ax] = displayFarField(obj, viewAngle)
    
    arguments
        obj       NearFieldToFarField 
        viewAngle (1,2)               = [0, 90]
    end
    
    if (obj.mode == "corrected") 
        error("This methos is not applicable for this mode");
    end

    f = figure(Name="Normalised electric Far-Field");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    surface(obj.farField, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Far-Field (dB)");
    title(xAxis, "Phi-component of Far-Field");
    title(yAxis, "Theta-component of Far-Field");
end