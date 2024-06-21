function [f, ax] = displayNearField(obj, viewAngle)

    arguments
        obj       NearFieldToFarField
        viewAngle (1,2) = [0, 90]
    end
    
    if isempty(obj.nearField)  
        error("The Near-Field data must be imported first by using method setUp");
    end

    f = figure(Name="Magnitude of the Near-Field data");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    surface(obj.nearField, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "x (m)");
    ylabel([xAxis, yAxis], "y (m)");
    zlabel([xAxis, yAxis], "Near-Field (dB)");
    title(xAxis, "Co-Polar Near-Field");
    title(yAxis, "Cross-Polar Near-Field");

end